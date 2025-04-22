import 'package:control/control.dart';
import 'package:pinput/pinput.dart';
import 'package:smartpay/src/common/constant/app_constants.dart';
import 'package:smartpay/src/common/localization/localization.dart';
import 'package:smartpay/src/common/model/dependencies.dart';
import 'package:smartpay/src/common/util/extension/extension.dart';
import 'package:smartpay/src/feature/authentication/controller/authentication_controller.dart';
import 'package:smartpay/src/feature/authentication/controller/authentication_state.dart';
import 'package:smartpay/src/feature/authentication/screen/sign_in/controller/sign_in_screen_controller.dart';
import 'package:ui/ui.dart';

/// {@template sign_in_screen}
/// SignInScreen widget.
/// {@endtemplate}
class SignInScreen extends StatelessWidget {
  /// {@macro sign_in_screen}
  const SignInScreen({required this.isPartner, super.key});

  final bool isPartner;

  @override
  Widget build(BuildContext context) =>
      ControllerScope(() => SignInScreenController(isPartner: isPartner), child: _Screen());
}

class _Screen extends StatelessWidget {
  void _onRequestOtp(BuildContext context) {
    final controller = ControllerScope.of<SignInScreenController>(context);
    if (!controller.isValidEmail) {
      final l10n = Localization.of(context);
      Toast.showError(context, message: l10n.enterEmailCorrectly);
      return;
    }

    Dependencies.of(context).authenticationController.requestOtp(controller.signInData);
  }

  void _onSignIn(BuildContext context) {
    final controller = ControllerScope.of<SignInScreenController>(context);
    final otp = controller.otp;
    if (otp.isNotEmpty && otp.length == 4) {
      Dependencies.of(context).authenticationController.signIn(controller.signInData);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: StateConsumer<AuthenticationController, AuthenticationState>(
      controller: Dependencies.of(context).authenticationController,
      buildWhen: (previous, current) => previous != current,
      listener: (context, controller, previous, current) {
        if (current != previous) {
          if (current.error?.isNotEmpty ?? false) {
            // ControllerScope.of<SignInScreenController>(context).clearNameSurnameLastname();
            Toast.showError(context, message: current.error!);
          }
        }
      },
      builder:
          (context, state, _) => ListView(
            padding: const EdgeInsets.all(AppConstants.padding),
            children: [
              ...[
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.16),
                Text('Авторизация', style: context.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
                if (state.requestOtpResult?.isSignInStep ?? true) ...[
                  _EmailInput(enabled: !state.isProcessing),
                  if (ControllerScope.of<SignInScreenController>(context).isPartner)
                    Card(
                      elevation: 4,
                      margin: EdgeInsets.zero,
                      child: TextFormField(
                        enabled: !state.isProcessing,
                        onChanged: (value) => ControllerScope.of<SignInScreenController>(context).partnerId = value,
                        initialValue: ControllerScope.of<SignInScreenController>(context).partnerId,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: 'ID Партнера',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: context.textTheme.labelLarge,
                      ),
                    ),
                ] else
                  Pinput(
                    length: 4,
                    onChanged: (value) => ControllerScope.of<SignInScreenController>(context).otp = value,
                    enabled: !state.isProcessing,
                    defaultPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      textStyle: context.textTheme.labelLarge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                        border: Border.all(color: context.colorScheme.primary),
                      ),
                    ),
                    onCompleted: (pin) => _onSignIn(context),
                  ),

                if (state.requestOtpResult?.isSignInStep ?? true)
                  Center(
                    child: AnimatedSwitcher(
                      duration: Durations.medium2,
                      child:
                          state.isProcessing
                              ? const CircularProgressIndicator()
                              : FilledButton(
                                style: FilledButton.styleFrom(elevation: 4),
                                onPressed: () => _onRequestOtp(context),
                                child: const Text('Дальше'),
                              ),
                    ),
                  ),
              ].expand((e) => [e, Space.v20]),
            ],
          ),
    ),
  );
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({this.enabled = true});

  final bool enabled;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 42,
    child: Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      child: TextFormField(
        enabled: enabled,
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) => ControllerScope.of<SignInScreenController>(context).email = value,
        textInputAction:
            ControllerScope.of<SignInScreenController>(context).isPartner ? TextInputAction.next : TextInputAction.done,
        decoration: InputDecoration(
          hintText: 'user@example.com',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            borderSide: BorderSide.none,
          ),
          suffixIcon: const Icon(Icons.email),
        ),
        style: context.textTheme.labelLarge,
      ),
    ),
  );
}
