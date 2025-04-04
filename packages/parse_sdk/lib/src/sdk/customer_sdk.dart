import 'package:parse_sdk/parse_sdk.dart';

final class CustomerSdk extends ParseSdkBase<CustomerDto> {
  const CustomerSdk() : super(parseObjectConstructor: CustomerDto.new);
}
