import 'package:meta/meta.dart';
import 'package:smartpay/src/feature/bank_card/entity/bank_card_entity.dart';

/// {@template bank_card_state}
/// BankCardState.
/// {@endtemplate}
@immutable
sealed class BankCardState extends _$BankCardStateBase {
  const BankCardState({required super.bankCards, required super.message});

  /// Idling state
  /// {@macro bank_card_state}
  const factory BankCardState.idle({required List<BankCardEntity> bankCards, String message, String? error}) =
      BankCardState$Idle;

  /// Processing
  /// {@macro bank_card_state}
  const factory BankCardState.processing({required List<BankCardEntity> bankCards, String message}) =
      BankCardState$Processing;
}

/// Idling state
final class BankCardState$Idle extends BankCardState with _$BankCardState {
  const BankCardState$Idle({required super.bankCards, super.message = 'Idling', this.error});

  @override
  final String? error;
}

/// Processing
final class BankCardState$Processing extends BankCardState with _$BankCardState {
  const BankCardState$Processing({required super.bankCards, super.message = 'Processing'});

  @override
  String? get error => null;
}

/// Pattern matching for [BankCardState].
typedef BankCardStateMatch<R, S extends BankCardState> = R Function(S state);

base mixin _$BankCardState on BankCardState {}

@immutable
abstract base class _$BankCardStateBase {
  const _$BankCardStateBase({required this.bankCards, required this.message});

  /// Data entity payload.
  @nonVirtual
  final List<BankCardEntity> bankCards;

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

  /// Pattern matching for [BankCardState].
  R map<R>({
    required BankCardStateMatch<R, BankCardState$Idle> idle,
    required BankCardStateMatch<R, BankCardState$Processing> processing,
  }) => switch (this) {
    BankCardState$Idle s => idle(s),
    BankCardState$Processing s => processing(s),
    _ => throw AssertionError(),
  };

  /// Pattern matching for [BankCardState].
  R maybeMap<R>({
    required R Function() orElse,
    BankCardStateMatch<R, BankCardState$Idle>? idle,
    BankCardStateMatch<R, BankCardState$Processing>? processing,
  }) => map<R>(idle: idle ?? (_) => orElse(), processing: processing ?? (_) => orElse());

  /// Pattern matching for [BankCardState].
  R? mapOrNull<R>({
    BankCardStateMatch<R, BankCardState$Idle>? idle,
    BankCardStateMatch<R, BankCardState$Processing>? processing,
  }) => map<R?>(idle: idle ?? (_) => null, processing: processing ?? (_) => null);

  @override
  int get hashCode => bankCards.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) && other is BankCardState && bankCards == other.bankCards;

  @override
  String toString() {
    final buffer =
        StringBuffer()
          ..write('BankCardState{')
          ..write('bankCards: $bankCards, ');
    if (error != null) buffer.write('error: $error, ');
    buffer
      ..write('message: $message')
      ..write('}');
    return buffer.toString();
  }
}
