import 'dart:async';

import 'package:control/control.dart';
import 'package:flutter/foundation.dart';
import 'package:pocketbase_sdk/pocketbase_sdk.dart';
import 'package:smartpay/src/feature/authentication/controller/authentication_state.dart';
import 'package:smartpay/src/feature/authentication/data/authentication_repository.dart';
import 'package:smartpay/src/feature/authentication/model/user.dart';

final class AuthenticationController extends StateController<AuthenticationState> with DroppableControllerHandler {
  AuthenticationController({
    required IAuthenticationRepository repository,
    super.initialState = const AuthenticationState.idle(user: User.unauthenticated()),
  }) : _repository = repository {
    _userSubscription = repository
        .userChanges()
        .where((user) => !identical(user, state.user))
        .map<AuthenticationState>((u) => AuthenticationState.idle(user: u))
        .listen(setState, cancelOnError: false);
  }

  final IAuthenticationRepository _repository;
  StreamSubscription<AuthenticationState>? _userSubscription;

  /// Restore the session from the cache.
  void restore() => handle(
    () async {
      setState(AuthenticationState.processing(user: state.user, message: 'Restoring session...'));
      final user = await _repository.restore();
      setState(AuthenticationState.idle(user: user ?? const User.unauthenticated()));
    },
    error: (error, _) async {
      setState(
        AuthenticationState.idle(
          user: state.user,
          // ErrorUtil.formatMessage(error)
          error: kDebugMode ? 'Restore Error: $error' : 'Restore Error',
        ),
      );
    },
  );

  /// Sign in with the given [data].
  void signIn(SignInData data) => handle(
    () async {
      if (state.user.isAuthenticated) {
        AuthenticationState.processing(
          user: state.user,
          message: 'Logging out...',
          otpId: state.otpId,
          requestOtpResult: state.requestOtpResult,
        );
        await _repository.signOut().onError((_, __) {
          /* Ignore */
        });
        AuthenticationState.processing(
          user: const User.unauthenticated(),
          otpId: state.otpId,
          message: 'Successfully logged out.',
          requestOtpResult: state.requestOtpResult,
        );
      }

      setState(
        AuthenticationState.processing(
          user: state.user,
          message: 'Confirm otp in progress...',
          otpId: state.otpId,
          requestOtpResult: state.requestOtpResult,
        ),
      );

      final user = await _repository.signIn(data.copyWith(otpId: state.otpId));

      setState(
        AuthenticationState.idle(user: user, message: 'Successfully logged in.', otpId: null, requestOtpResult: null),
      );
    },
    error: (error, _) async {
      setState(
        AuthenticationState.idle(
          user: state.user,
          // ErrorUtil.formatMessage(error)
          error: kDebugMode ? 'Sign In Error: $error' : 'Sign In Error',
          otpId: state.otpId,
          requestOtpResult: state.requestOtpResult,
        ),
      );
    },
  );

  /// Request OTP for the given [SignInData].
  void requestOtp(SignInData signInData) => handle(
    () async {
      setState(
        AuthenticationState.processing(
          user: state.user,
          requestOtpResult: state.requestOtpResult,
          otpId: '',
          message: 'Requesting OTP...',
        ),
      );

      final response = await _repository.requestOtp(signInData);

      setState(
        AuthenticationState.idle(
          user: state.user.copyWith(email: signInData.email),
          otpId: response.otpId,
          requestOtpResult: RequestOtpResult.otpSent,
          message: 'Requested otp successfully...',
        ),
      );
    },
    error:
        (error, _) async => setState(
          AuthenticationState.idle(
            user: state.user,
            // ErrorUtil.formatMessage(error)
            error: kDebugMode ? 'Request OTP Error: $error' : 'Request OTP Error',
            requestOtpResult: state.requestOtpResult,
          ),
        ),
  );

  /// Sign out.
  void signOut() {
    handle(
      () async {
        //if (state.user.isNotAuthenticated) return; // Already signed out.
        setState(AuthenticationState.processing(user: state.user, message: 'Logging out...'));
        await _repository.signOut();
        setState(const AuthenticationState.idle(user: User.unauthenticated()));
      },
      error: (error, _) async {
        setState(
          AuthenticationState.idle(
            user: const User.unauthenticated(),
            // ErrorUtil.formatMessage(error)
            error: kDebugMode ? 'Log Out Error: $error' : 'Log Out Error',
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }
}
