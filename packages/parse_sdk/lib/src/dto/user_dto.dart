import 'package:parse_server_sdk/parse_server_sdk.dart';

final class ParseUserDto extends ParseUser {
  ParseUserDto({
    String? username,
    String? password,
    String? emailAddress,
    ParseClient? client,
    bool? debug,
    String? sessionToken,
  }) : super(
         username,
         password,
         emailAddress,
         client: client,
         debug: debug,
         sessionToken: sessionToken,
       );
}
