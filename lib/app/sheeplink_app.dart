import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../data/services/notification_service.dart';
import '../ui/core/theme/app_theme.dart';
import '../ui/features/auth/views/login_view.dart';
import '../ui/features/community/view_models/community_view_model.dart';
import '../ui/features/community/views/community_shell.dart';

class SheeplinkApp extends StatelessWidget {
  const SheeplinkApp({
    super.key,
    required this.model,
    required this.notifications,
  });
  final CommunityViewModel model;
  final NotificationService notifications;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'SheepLink',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    locale: const Locale('es'),
    supportedLocales: const [Locale('es')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    home: ListenableBuilder(
      listenable: model,
      builder: (context, _) => model.restoring
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : model.session == null
          ? LoginView(model: model)
          : CommunityShell(model: model, notifications: notifications),
    ),
  );
}
