import 'package:flutter/foundation.dart';
import 'package:parse_sdk/parse_sdk.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

/// {@template parse_server_initializer}
/// A class that is responsible for running the application.
/// {@endtemplate}
sealed class ParseServerInitializer {
  /// {@macro app_runner}
  const ParseServerInitializer._();

  /// Initializes Parse server.
  Future<void> init({
    required String applicationId,
    required String parseServerUrl,
    required String parseClientKey,
    String? liveQueryUrl,
  }) async {
    await Parse().initialize(
      applicationId,
      parseServerUrl,
      clientKey: parseClientKey,
      debug: kDebugMode,
      liveQueryUrl: liveQueryUrl,
      parseUserConstructor:
          (username, password, emailAddress, {client, debug, sessionToken}) => ParseUserDto(
            username: username,
            password: password,
            emailAddress: emailAddress,
            client: client,
            debug: debug,
            sessionToken: sessionToken,
          ),
      registeredSubClassMap: <String, ParseObjectConstructor>{
        CustomerDto.className: CustomerDto.new,
      },
    );
  }
}
