import 'package:meta/meta.dart';
import 'package:smartpay/src/feature/authentication/data/authentication_repository.dart';
import 'package:smartpay/src/feature/authentication/model/user.dart';

/// {@template authentication_state}
/// AuthenticationState.
/// {@endtemplate}
sealed class AuthenticationState extends _$AuthenticationStateBase {
  /// {@macro authentication_state}
  const AuthenticationState({required super.user, required super.message});

  /// Idling state
  /// {@macro authentication_state}
  const factory AuthenticationState.idle({
    required User user,
    String message,
    String? error,
    RequestOtpResult? requestOtpResult,
    String? otpId,
  }) = AuthenticationState$Idle;

  /// Processing
  /// {@macro authentication_state}
  const factory AuthenticationState.processing({
    required User user,
    String message,
    RequestOtpResult? requestOtpResult,
    String? otpId,
  }) = AuthenticationState$Processing;
}

/// Idling state
final class AuthenticationState$Idle extends AuthenticationState with _$AuthenticationState {
  const AuthenticationState$Idle({
    required super.user,
    super.message = 'Idling',
    this.error,
    this.requestOtpResult,
    this.otpId,
  });

  @override
  final RequestOtpResult? requestOtpResult;

  @override
  final String? error;

  @override
  final String? otpId;
}

/// Processing
final class AuthenticationState$Processing extends AuthenticationState with _$AuthenticationState {
  const AuthenticationState$Processing({
    required super.user,
    super.message = 'Processing',
    this.requestOtpResult,
    this.otpId,
  });

  @override
  final RequestOtpResult? requestOtpResult;

  @override
  String? get error => null;

  @override
  final String? otpId;
}

base mixin _$AuthenticationState on AuthenticationState {}

/// Pattern matching for [AuthenticationState].
typedef AuthenticationStateMatch<R, S extends AuthenticationState> = R Function(S state);

@immutable
abstract base class _$AuthenticationStateBase {
  const _$AuthenticationStateBase({required this.user, required this.message});

  /// Data entity payload.
  @nonVirtual
  final User user;

  /// Message or state description.
  @nonVirtual
  final String message;

  /// Error message.
  abstract final String? error;

  /// Error message.
  abstract final String? otpId;

  /// Request OTP result.
  abstract final RequestOtpResult? requestOtpResult;

  /// Is register step
  bool get isRegisterStep => requestOtpResult != null && requestOtpResult == RequestOtpResult.needsRegistration;

  /// If an error has occurred?
  bool get hasError => error != null;

  /// Is in progress state?
  bool get isProcessing => maybeMap<bool>(orElse: () => false, processing: (_) => true);

  /// Is in idle state?
  bool get isIdling => !isProcessing;

  /// Pattern matching for [AuthenticationState].
  R map<R>({
    required AuthenticationStateMatch<R, AuthenticationState$Idle> idle,
    required AuthenticationStateMatch<R, AuthenticationState$Processing> processing,
  }) => switch (this) {
    AuthenticationState$Idle s => idle(s),
    AuthenticationState$Processing s => processing(s),
    _ => throw AssertionError(),
  };

  /// Pattern matching for [AuthenticationState].
  R maybeMap<R>({
    required R Function() orElse,
    AuthenticationStateMatch<R, AuthenticationState$Idle>? idle,
    AuthenticationStateMatch<R, AuthenticationState$Processing>? processing,
  }) => map<R>(idle: idle ?? (_) => orElse(), processing: processing ?? (_) => orElse());

  /// Pattern matching for [AuthenticationState].
  R? mapOrNull<R>({
    AuthenticationStateMatch<R, AuthenticationState$Idle>? idle,
    AuthenticationStateMatch<R, AuthenticationState$Processing>? processing,
  }) => map<R?>(idle: idle ?? (_) => null, processing: processing ?? (_) => null);

  @override
  int get hashCode => user.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) && other is _$AuthenticationStateBase && requestOtpResult == other.requestOtpResult;

  @override
  String toString() {
    final buffer =
        StringBuffer()
          ..write('AuthenticationState{')
          ..write('user: $user, ');
    if (error != null) buffer.write('error: $error, ');
    buffer
      ..write('message: $message')
      ..write('}');
    return buffer.toString();
  }
}
