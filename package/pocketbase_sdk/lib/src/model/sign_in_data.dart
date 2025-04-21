/// {@template sign_in_data}
/// Sign in data.
/// {@endtemplate}
final class SignInData {
  /// {@macro sign_in_data}
  const SignInData(this.email, {this.otp, this.otpId, this.userType, this.partnerId});

  /// Phone number of the user.
  final String email;

  /// OTP id.
  final String? otpId;

  /// OTP code.
  final String? otp;

  /// UserType
  final String? userType;

  /// Partner id
  final String? partnerId;
}
