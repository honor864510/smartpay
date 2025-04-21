import 'package:pocketbase_sdk/pocketbase_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template pocketbase_sdk_initializer}
/// A class that is responsible for running the application.
/// {@endtemplate}
final class PocketbaseSdkInitializer {
  /// {@macro app_runner}
  const PocketbaseSdkInitializer._();

  /// Initializes Pocketbase sdk.
  static Future<PocketBase> init({
    required String serverUrl,
    required SharedPreferences prefs,
    required String lang,
  }) async {
    final asyncAuthStore = AsyncAuthStore(
      save: (data) async => prefs.setString('pb_auth', data),
      initial: prefs.getString('pb_auth'),
    );

    final pb = PocketBase(serverUrl, authStore: asyncAuthStore, lang: lang);

    pb.collection('users').authRefresh().ignore();

    return pb;
  }
}
