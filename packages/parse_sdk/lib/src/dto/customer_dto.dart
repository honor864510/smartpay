import 'package:parse_server_sdk/parse_server_sdk.dart';

final class CustomerDto extends ParseObject {
  // Constructors -------------------------------------------------------------
  CustomerDto() : super(className);

  @override
  CustomerDto clone(Map<String, dynamic> map) => CustomerDto()..fromJson(map);

  // Getters ------------------------------------------------------------------
  String get name => get<String>(keyName) ?? '';

  // Setters ------------------------------------------------------------------
  set name(String value) => set<String>(keyName, value);

  // Key names ----------------------------------------------------------------
  static const className = 'Customer';

  static const String keyName = 'name';
}
