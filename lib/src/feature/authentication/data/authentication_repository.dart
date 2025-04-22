import 'dart:async';

import 'package:pocketbase_sdk/pocketbase_sdk.dart';
import 'package:smartpay/src/feature/authentication/model/user.dart';

/// Result type for requesting OTP, indicating next step.
enum RequestOtpResult {
  /// OTP sent successfully, user exists (sign-in) or was created (sign-up)
  otpSent,

  /// User not found, proceed to registration details screen (client only)
  needsRegistration,

  /// An error occurred
  error;

  bool get isSignInStep => this != RequestOtpResult.otpSent;

  String get description {
    switch (this) {
      case RequestOtpResult.otpSent:
        return 'OTP sent successfully';
      case RequestOtpResult.needsRegistration:
        return 'User not found, proceed to registration details screen';
      case RequestOtpResult.error:
        return 'An error occurred';
    }
  }
}

/// Result type for verifying OTP
class VerifyOtpResponse {
  VerifyOtpResponse.failure(this.errorMessage) : success = false, user = const User.unauthenticated();

  VerifyOtpResponse.success(this.user) : success = true, errorMessage = null;

  final bool success;

  // Return the authenticated user on success
  final User user;

  final String? errorMessage;
}

abstract interface class IAuthenticationRepository {
  Stream<User> userChanges();
  Future<OTPResponse> requestOtp(SignInData data);
  Future<User> signIn(SignInData data);
  Future<User?> restore();
  Future<void> signOut();
}

final class AuthenticationRepository implements IAuthenticationRepository {
  AuthenticationRepository({required UserSdk userSdk}) : _userSdk = userSdk;

  final UserSdk _userSdk;

  @override
  Future<OTPResponse> requestOtp(SignInData data) => _userSdk.requestOtp(data);

  @override
  Future<User> signIn(SignInData data) async {
    final userDto = await _userSdk.signIn(data);

    return userDto.toUser();
  }

  @override
  Future<void> signOut() => _userSdk.signOut();

  @override
  Stream<User> userChanges() => _userSdk.onChange().map((event) => event?.toUser() ?? const User.unauthenticated());

  @override
  Future<User?> restore() async {
    final user = await _userSdk.restore();

    return user?.toUser();
  }
}

extension UserDtoExtensions on UserDto {
  User toUser() => User.authenticated(id: id, type: UserType.fromString(type), customerId: '', email: email);
}
