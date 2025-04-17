import 'package:meta/meta.dart';
import 'package:smartpay/src/feature/bank_card/entity/bank_entity.dart';

/// {@template bank_list_state}
/// BankListState.
/// {@endtemplate}
@immutable
sealed class BankListState extends _$BankListStateBase {
  const BankListState({required super.banks, required super.message});

  /// Idling state
  /// {@macro bank_list_state}
  const factory BankListState.idle({required List<BankEntity> banks, String message, String? error}) =
      BankListState$Idle;

  /// Processing
  /// {@macro bank_list_state}
  const factory BankListState.processing({required List<BankEntity> banks, String message}) = BankListState$Processing;
}

/// Idling state
final class BankListState$Idle extends BankListState with _$BankListState {
  const BankListState$Idle({required super.banks, super.message = 'Idling', this.error});

  @override
  final String? error;
}

/// Processing
final class BankListState$Processing extends BankListState with _$BankListState {
  const BankListState$Processing({required super.banks, super.message = 'Processing'});

  @override
  String? get error => null;
}

/// Pattern matching for [BankListState].
typedef BankListStateMatch<R, S extends BankListState> = R Function(S state);

base mixin _$BankListState on BankListState {}

@immutable
abstract base class _$BankListStateBase {
  const _$BankListStateBase({required this.banks, required this.message});

  /// Data entity payload.
  @nonVirtual
  final List<BankEntity> banks;

  /// Message or state description.
  @nonVirtual
  final String message;

  /// Error message.
  abstract final String? error;

  /// If an error has occurred?
  bool get hasError => error != null;

  /// Is in progress state?
  bool get isProcessing => maybeMap<bool>(orElse: () => false, processing: (_) => true);

  /// Is in idle state?
  bool get isIdling => !isProcessing;

  /// Pattern matching for [BankListState].
  R map<R>({
    required BankListStateMatch<R, BankListState$Idle> idle,
    required BankListStateMatch<R, BankListState$Processing> processing,
  }) => switch (this) {
    BankListState$Idle s => idle(s),
    BankListState$Processing s => processing(s),
    _ => throw AssertionError(),
  };

  /// Pattern matching for [BankListState].
  R maybeMap<R>({
    required R Function() orElse,
    BankListStateMatch<R, BankListState$Idle>? idle,
    BankListStateMatch<R, BankListState$Processing>? processing,
  }) => map<R>(idle: idle ?? (_) => orElse(), processing: processing ?? (_) => orElse());

  /// Pattern matching for [BankListState].
  R? mapOrNull<R>({
    BankListStateMatch<R, BankListState$Idle>? idle,
    BankListStateMatch<R, BankListState$Processing>? processing,
  }) => map<R?>(idle: idle ?? (_) => null, processing: processing ?? (_) => null);

  @override
  int get hashCode => banks.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) && other is BankListState && banks == other.banks;

  @override
  String toString() {
    final buffer =
        StringBuffer()
          ..write('BankListState{')
          ..write('banks: $banks, ');
    if (error != null) buffer.write('error: $error, ');
    buffer
      ..write('message: $message')
      ..write('}');
    return buffer.toString();
  }
}
