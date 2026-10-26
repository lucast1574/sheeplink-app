import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/sheeplink_app.dart';
import 'data/repositories/community_repository.dart';
import 'data/services/api_client.dart';
import 'data/services/google_identity.dart';
import 'data/services/notification_service.dart';
import 'ui/features/community/view_models/community_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es');
  final repository = ApiCommunityRepository(ApiClient());
  final model = CommunityViewModel(
    repository,
    googleIdentity: FirebaseGoogleIdentity(),
  );
  final notifications = NotificationService(repository);
  try {
    await notifications.initialize();
  } catch (_) {
    notifications.status =
        'No pudimos preparar los avisos. Puedes reintentarlo desde Perfil.';
  }
  runApp(SheeplinkApp(model: model, notifications: notifications));
  await model.restore();
}
