import 'dart:async';

import 'package:pocketbase_sdk/pocketbase_sdk.dart';

final class UserSdk {
  UserSdk({required this.pb});

  final PocketBase pb;

  Future<UserDto?> restore() async {
    final response = await pb.collection(UserDto.collectionName).authRefresh();

    return UserDto.fromJson(response.record.data);
  }

  Future<OTPResponse> requestOtp(SignInData signInData) async {
    final response = await pb.collection(UserDto.collectionName).requestOTP(signInData.email);

    return response;
  }

  Future<UserDto> signIn(SignInData signInData) async {
    final response = await pb.collection(UserDto.collectionName).authWithOTP(signInData.otpId!, signInData.otp!);

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
