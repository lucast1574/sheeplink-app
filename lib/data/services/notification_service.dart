import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import '../../domain/models/community.dart';
import '../../domain/models/personal_profile.dart';
import '../../domain/models/reminder_plan.dart';
import '../repositories/community_repository.dart';

@pragma('vm:entry-point')
Future<void> firebaseBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class NotificationService extends ChangeNotifier {
  NotificationService(this.repository);
  final CommunityRepository repository;
  final _plugin = FlutterLocalNotificationsPlugin();
  final _storage = const FlutterSecureStorage();
  static const channel = AndroidNotificationChannel(
    'sheeplink_care',
    'Mi comunidad',
    description: 'Cumpleaños y avisos de tu comunidad',
    importance: Importance.high,
  );
  bool available = false, enabled = false;
  bool birthdaysEnabled = true, serviceEnabled = true;
  String? status;
  String? _token;
  int _syncGeneration = 0;
  Future<void> _pendingSync = Future.value();
  StreamSubscription<String>? _refresh;
  StreamSubscription<RemoteMessage>? _foreground, _opened;
  final ValueNotifier<String?> destination = ValueNotifier(null);
  Future<void> initialize() async {
    if (kIsWeb) return;
    tzdata.initializeTimeZones();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_notification'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (response) =>
          destination.value = response.payload,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
    final launch = await _plugin.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp ?? false) {
      destination.value = launch?.notificationResponse?.payload;
    }
    try {
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessage);
      available = true;
      _foreground = FirebaseMessaging.onMessage.listen((message) async {
        final notification = message.notification;
        if (!enabled || notification == null) return;
        await _plugin.show(
          id: message.messageId.hashCode & 0x7fffffff,
          title: notification.title,
          body: notification.body,
          notificationDetails: _details,
          payload: 'today',
        );
      });
      _opened = FirebaseMessaging.onMessageOpenedApp.listen(
        (_) => destination.value = 'today',
      );
      if (await FirebaseMessaging.instance.getInitialMessage() != null) {
        destination.value = 'today';
      }
    } catch (_) {
      status = 'Los avisos push no están disponibles en este dispositivo.';
    }
    enabled = await _storage.read(key: 'sheeplink.notifications') == 'true';
    birthdaysEnabled =
        await _storage.read(key: 'sheeplink.reminders.birthdays') != 'false';
    serviceEnabled =
        await _storage.read(key: 'sheeplink.reminders.service') != 'false';
    notifyListeners();
  }

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'sheeplink_care',
      'Mi comunidad',
      channelDescription: 'Cumpleaños y avisos de tu comunidad',
      importance: Importance.high,
      priority: Priority.high,
      icon: 'ic_notification',
      visibility: NotificationVisibility.private,
    ),
    iOS: DarwinNotificationDetails(presentAlert: true, presentSound: true),
  );
  Future<void> enable(
    List<Member> members,
    String timezone, {
    List<ServiceAssignment> assignments = const [],
  }) async {
    try {
      if (available) {
        final settings = await FirebaseMessaging.instance.requestPermission();
        if (settings.authorizationStatus == AuthorizationStatus.denied) {
          status =
              'Permiso denegado. Puedes habilitarlo en los ajustes del teléfono.';
          notifyListeners();
          return;
        }
      } else {
        final granted = await _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission();
        if (granted == false) {
          status = 'Permite las notificaciones en los ajustes del teléfono.';
          notifyListeners();
          return;
        }
      }
      enabled = true;
      await _storage.write(key: 'sheeplink.notifications', value: 'true');
      await synchronize(members, timezone, assignments: assignments);
    } catch (_) {
      status = 'No pudimos activar todos los avisos. Inténtalo de nuevo.';
    }
    notifyListeners();
  }

  Future<void> synchronize(
    List<Member> members,
    String timezone, {
    List<ServiceAssignment> assignments = const [],
  }) {
    final generation = ++_syncGeneration;
    final task = _pendingSync.then((_) async {
      if (!enabled || generation != _syncGeneration) return;
      await _synchronize(members, timezone, assignments);
    });
    _pendingSync = task;
    return task;
  }

  Future<void> _synchronize(
    List<Member> members,
    String timezone,
    List<ServiceAssignment> assignments,
  ) async {
    if (!enabled) return;
    try {
      await scheduleReminders(members, timezone, assignments);
      if (available) {
        await _refresh?.cancel();
        final registered = Completer<String>();
        _refresh = FirebaseMessaging.instance.onRegistered.listen(
          (installationId) async {
            _token = installationId;
            if (!registered.isCompleted) {
              registered.complete(installationId);
            } else if (enabled) {
              try {
                await repository.registerDevice(installationId);
              } catch (_) {
                status = 'Abre Perfil para sincronizar los avisos.';
                notifyListeners();
              }
            }
          },
          onError: (Object error) {
            if (!registered.isCompleted) registered.completeError(error);
          },
        );
        await FirebaseMessaging.instance.setAutoInitEnabled(true);
        await FirebaseMessaging.instance.register();
        final installationId = await registered.future.timeout(
          const Duration(seconds: 25),
        );
        await repository.registerDevice(installationId);
      }
      status =
          'Recordatorios actualizados. El teléfono puede demorarlos por ahorro de batería.';
    } catch (_) {
      status =
          'No pudimos completar la sincronización de los avisos. Reintenta desde Perfil.';
    }
    notifyListeners();
  }

  Future<bool> shouldOffer() async =>
      !enabled &&
      await _storage.read(key: 'sheeplink.notifications.prompted') != 'true';
  Future<void> markPromptSeen() =>
      _storage.write(key: 'sheeplink.notifications.prompted', value: 'true');
  Future<void> preferences({
    bool? birthdays,
    bool? service,
    required List<Member> members,
    required String timezone,
    required List<ServiceAssignment> assignments,
  }) async {
    if (birthdays != null) {
      birthdaysEnabled = birthdays;
      await _storage.write(
        key: 'sheeplink.reminders.birthdays',
        value: '$birthdays',
      );
    }
    if (service != null) {
      serviceEnabled = service;
      await _storage.write(
        key: 'sheeplink.reminders.service',
        value: '$service',
      );
    }
    await synchronize(members, timezone, assignments: assignments);
    notifyListeners();
  }

  Future<void> scheduleReminders(
    List<Member> members,
    String timezone,
    List<ServiceAssignment> assignments,
  ) async {
    final planned = reminderPlan(
      members: members,
      assignments: assignments,
      birthdayTimezone: timezone,
      now: DateTime.now(),
      birthdays: birthdaysEnabled,
      service: serviceEnabled,
    );
    await _plugin.cancelAll();
    for (var index = 0; index < planned.length; index++) {
      final reminder = planned[index];
      await _plugin.zonedSchedule(
        id: 1000 + index,
        title: reminder.title,
        body: reminder.body,
        scheduledDate: reminder.when,
        notificationDetails: _details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: reminder.destination,
      );
    }
  }

  Future<void> disable() async {
    enabled = false;
    ++_syncGeneration;
    await _storage.delete(key: 'sheeplink.notifications');
    await _plugin.cancelAll();
    await _refresh?.cancel();
    _refresh = null;
    final token = _token;
    _token = null;
    await Future.wait([
      if (token != null)
        repository
            .revokeDevice(token)
            .timeout(const Duration(seconds: 2))
            .catchError((Object _) {}),
      if (available)
        (() async {
          await FirebaseMessaging.instance.setAutoInitEnabled(false);
          await FirebaseMessaging.instance.unregister();
        })().timeout(const Duration(seconds: 2)).catchError((Object _) {}),
    ]);
    status = 'Avisos desactivados.';
    notifyListeners();
  }

  @override
  void dispose() {
    _refresh?.cancel();
    _foreground?.cancel();
    _opened?.cancel();
    destination.dispose();
    super.dispose();
  }
}
