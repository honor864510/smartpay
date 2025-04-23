import 'package:meta/meta.dart';
import 'package:pocketbase_sdk/pocketbase_sdk.dart';
import 'package:smartpay/src/feature/authentication/model/user.dart';

/// User type enum
enum P2PTransactionStatus {
  created('created'),
  completed('completed'),
  failed('failed'),
  canceled('canceled'),
  processing('processing');

  const P2PTransactionStatus(this.name);

  factory P2PTransactionStatus.fromString(String? value) => switch (value) {
    'created' => P2PTransactionStatus.created,
    'completed' => P2PTransactionStatus.completed,
    'failed' => P2PTransactionStatus.failed,
    'canceled' => P2PTransactionStatus.canceled,
    'processing' => P2PTransactionStatus.processing,
    _ => P2PTransactionStatus.created,
  };

  final String name;

  bool get isCompleted => this == P2PTransactionStatus.completed;
  bool get isFailed => this == P2PTransactionStatus.failed;
  bool get isCanceled => this == P2PTransactionStatus.canceled;
  bool get isProcessing => this == P2PTransactionStatus.processing;
  bool get isCreated => this == P2PTransactionStatus.created;

  bool get isEditable => isCreated || isProcessing;

  @override
  String toString() => name;
}

@immutable
final class BankTransactionEntity {
  const BankTransactionEntity({
    required this.id,
    required this.amount,
    required this.status,
    this.sender,
    this.receiver,
    this.bankIdentifier = '',
    this.created,
    this.updated,
  });

  factory BankTransactionEntity.fromP2PTransactionDto(P2PTransactionDto dto) => BankTransactionEntity(
    id: dto.id,
    amount: dto.amount.toDouble(),
    sender:
        dto.sender != null
            ? AuthenticatedUser(
              id: dto.sender!.id,
              type: UserType.fromString(dto.sender!.type),
              customerId: '',
              email: dto.sender!.email,
            )
            : null,
    receiver:
        dto.receiver != null
            ? AuthenticatedUser(
              id: dto.receiver!.id,
              type: UserType.fromString(dto.receiver!.type),
              customerId: '',
              email: dto.receiver!.email,
            )
            : null,
    status: P2PTransactionStatus.fromString(dto.status),
    bankIdentifier: dto.bankIdentifier,
    created: dto.created ?? DateTime(0),
    updated: dto.updated ?? DateTime(0),
  );

  /// Creates a [BankTransactionEntity] from a JSON map
  factory BankTransactionEntity.fromJson(Map<String, dynamic> json) => BankTransactionEntity(
    id: json['id'] as String,
    amount: (json['amount'] as num).toDouble(),
    status: P2PTransactionStatus.fromString(json['status'] as String?),
    sender: json['sender'] != null ? User.fromJson(json['sender'] as Map<String, dynamic>) as AuthenticatedUser : null,
    receiver:
        json['receiver'] != null ? User.fromJson(json['receiver'] as Map<String, dynamic>) as AuthenticatedUser : null,
    bankIdentifier: json['bank_identifier'] as String? ?? '',
    created: json['created'] != null ? DateTime.parse(json['created'] as String) : null,
    updated: json['updated'] != null ? DateTime.parse(json['updated'] as String) : null,
  );

  final String id;
  final double amount;
  final AuthenticatedUser? sender;
  final AuthenticatedUser? receiver;
  final P2PTransactionStatus status;
  final String bankIdentifier;
  final DateTime? created;
  final DateTime? updated;

  static const prefsKey = 'bank_transactions';

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'sender': sender?.toJson(),
    'receiver': receiver?.toJson(),
    'status': status.name,
    'bank_identifier': bankIdentifier,
    'created': created?.toIso8601String(),
    'updated': updated?.toIso8601String(),
  };

  BankTransactionEntity copyWith({
    String? id,
    double? amount,
    AuthenticatedUser? sender,
    AuthenticatedUser? receiver,
    P2PTransactionStatus? status,
    String? bankIdentifier,
    DateTime? created,
    DateTime? updated,
  }) => BankTransactionEntity(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    sender: sender ?? this.sender,
    receiver: receiver ?? this.receiver,
    status: status ?? this.status,
    bankIdentifier: bankIdentifier ?? this.bankIdentifier,
    created: created ?? this.created,
    updated: updated ?? this.updated,
  );

  @override
  int get hashCode => Object.hashAll([id, amount, sender, receiver, status, bankIdentifier, created, updated]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankTransactionEntity &&
          id == other.id &&
          amount == other.amount &&
          sender == other.sender &&
          receiver == other.receiver &&
          status == other.status &&
          bankIdentifier == other.bankIdentifier &&
          created == other.created &&
          updated == other.updated;
}
