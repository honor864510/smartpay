import 'package:pocketbase_sdk/pocketbase_sdk.dart';

/// {@template parse_server_initializer}
/// A class that is responsible for running the application.
/// {@endtemplate}
final class PocketbaseSdkInitializer {
  /// {@macro app_runner}
  const PocketbaseSdkInitializer._();

  /// Initializes Pocketbase sdk.
  static Future<PocketBase> init({required String serverUrl}) async {
    final pb = PocketBase(serverUrl);

    return pb;
  }
}
