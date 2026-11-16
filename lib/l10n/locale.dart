import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'generated/app_localizations.dart';
import 'messages.dart';
import 'system_templates.dart';

/// Follow the device's ordered language preferences; Spanish is the fallback.
Locale resolveLocale(List<Locale>? preferences) {
  for (final preference in preferences ?? <Locale>[]) {
    if (const ['es', 'en', 'pt'].contains(preference.languageCode)) {
      return Locale(preference.languageCode);
    }
  }
  return const Locale('es');
}

Locale get deviceLocale =>
    resolveLocale(WidgetsBinding.instance.platformDispatcher.locales);
String get appLocale =>
    deviceLocale.languageCode == 'pt' ? 'pt_BR' : deviceLocale.languageCode;

String tr(String source, [Map<String, Object?> values = const {}]) =>
    message(lookupAppLocalizations(deviceLocale), source, values);

String serverMessage(String source) {
  final exact = tr(source);
  if (exact != source) return exact;
  for (final template in systemTemplates) {
    final parts = template.split(RegExp(r'\{\{p\d+\}\}'));
    final pattern = RegExp(
      '^${parts.map(RegExp.escape).join(r'([\s\S]*?)')}\$',
    );
    final match = pattern.firstMatch(source);
    if (match != null) {
      return tr(template, {
        for (var i = 1; i <= match.groupCount; i++) 'p${i - 1}': match.group(i),
      });
    }
  }
  return exact;
}

/// Calendar values sent to the API retain their ISO format.
String displayDate(DateTime date, {bool weekday = false, bool short = false}) {
  if (weekday) return DateFormat.MMMMEEEEd(appLocale).format(date);
  return (short ? DateFormat.MMMd(appLocale) : DateFormat.MMMMd(appLocale))
      .format(date);
}
