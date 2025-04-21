import 'package:pocketbase_sdk/pocketbase_sdk.dart';
import 'package:smartpay/src/feature/authentication/model/user.dart';
import 'package:ui/ui.dart';

class SignInScreenController extends ChangeNotifier {
  SignInScreenController({required this.isPartner});

  final bool isPartner;

  String email = '';
  String otp = '';
  String partnerId = '';

  bool get isValidEmail {
    if (email.isEmpty) return false;

    // Regular expression for email validation
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    return emailRegex.hasMatch(email);
  }

  SignInData get signInData => SignInData(
    email,
    otp: otp,
    userType: isPartner ? UserType.partner.toString() : UserType.client.toString(),
    partnerId: partnerId,
  );
}
