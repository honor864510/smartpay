import 'dart:async';

import 'package:pocketbase_sdk/pocketbase_sdk.dart';

final class UserSdk {
  UserSdk({required this.pb});

  final PocketBase pb;

  Future<OTPResponse> requestOtp({required String email}) async {
    final response = await pb.collection('users').requestOTP(email);

    return response;
  }

  Future<UserDto> confirmOtp({required String otpId, required String code}) async {
    final response = await pb.collection('users').authWithOTP(otpId, code);

    return UserDto.fromJson(response.record.data);
  }

  Future<void> signOut() async {
    pb.authStore.clear();
  }

  Stream<UserDto?> onChange() async* {
    yield* pb.authStore.onChange.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          if (data.record?.data != null) {
            sink.add(UserDto.fromJson(data.record!.data));
          } else {
            sink.add(null);
          }
        },
      ),
    );
  }
}
