import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sheeplink/data/services/notification_service.dart';
import 'package:sheeplink/domain/models/community.dart';
import '../test/fake_repository.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('native Firebase, birthday scheduling and foreground push', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: Text('SheepLink · prueba técnica'))),
      ),
    );
    await tester.runAsync(() async {
      final repository = FakeRepository();
      final notices = NotificationService(repository);
      await notices.initialize();
      debugPrint("Native notifications: initialized");
      expect(notices.available, isTrue);
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      await notices.enable([
        Member(
          id: 'test',
          name: 'Integrante de prueba',
          birthday: DateTime(2000, tomorrow.month, tomorrow.day),
        ),
      ], 'America/Lima');
      debugPrint("Native notifications: activation completed");
      expect(notices.enabled, isTrue);
      final pending = await FlutterLocalNotificationsPlugin()
          .pendingNotificationRequests();
      expect(pending.length, 1);
      final incoming = FirebaseMessaging.onMessage.first.timeout(
        const Duration(seconds: 120),
      );
      final token = repository.registeredId;
      expect(token, isNotEmpty);
      final file = File(
        '${Directory.systemTemp.path}/sheeplink-fcm-smoke.token',
      );
      await file.writeAsString(token!);
      debugPrint("Native notifications: awaiting test push; file ${file.path}");
      final message = await incoming;
      expect(message.notification?.title, 'SheepLink · prueba técnica');
      await file.delete();
      await notices.disable();
      notices.dispose();
    });
  });
}
