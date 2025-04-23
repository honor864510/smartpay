import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:pocketbase_sdk/pocketbase_sdk.dart';

@immutable
final class P2PTransactionDto {
  const P2PTransactionDto({
    required this.id,
    required this.amount,
    this.sender,
    this.receiver,
    this.bankIdentifier = '',
    this.status = 'created',
    this.created,
    this.updated,
  });

  factory P2PTransactionDto.fromJson(Map<String, dynamic> json) => P2PTransactionDto(
    id: json['id'] as String? ?? '',
    sender: UserDto.fromJson(jsonDecode(json['sender'] as String? ?? '') as Map<String, dynamic>),
    receiver: UserDto.fromJson(jsonDecode(json['receiver'] as String? ?? '') as Map<String, dynamic>),
    amount: json['amount'] as num,
    bankIdentifier: json['bank_identifier'] as String? ?? '',
    status: json['status'] as String? ?? 'created',
    created: json['created'] != null ? DateTime.parse(json['created'] as String) : null,
    updated: json['updated'] != null ? DateTime.parse(json['updated'] as String) : null,
  );

  final String id;
  final UserDto? sender;
  final UserDto? receiver;
  final num amount;
  final String bankIdentifier;
  final String status;
  final DateTime? created;
  final DateTime? updated;

  static const String collectionName = 'p2p_transactions';

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'sender': sender?.toJson(),
    'receiver': receiver?.toJson(),
    'amount': amount,
    'bank_identifier': bankIdentifier,
    'status': status,
    'created': created?.toIso8601String() ?? '',
    'updated': updated?.toIso8601String() ?? '',
  };

  P2PTransactionDto copyWith({
    String? id,
    UserDto? sender,
    UserDto? receiver,
    num? amount,
    String? bankIdentifier,
    String? status,
    DateTime? created,
    DateTime? updated,
  }) => P2PTransactionDto(
    id: id ?? this.id,
    sender: sender ?? this.sender,
    receiver: receiver ?? this.receiver,
    amount: amount ?? this.amount,
    bankIdentifier: bankIdentifier ?? this.bankIdentifier,
    status: status ?? this.status,
    created: created ?? this.created,
    updated: updated ?? this.updated,
  );

  @override
  int get hashCode => Object.hashAll([id, sender, receiver, amount, bankIdentifier, status, created, updated]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is P2PTransactionDto &&
          id == other.id &&
          sender == other.sender &&
          receiver == other.receiver &&
          amount == other.amount &&
          bankIdentifier == other.bankIdentifier &&
          status == other.status &&
          created != other.created &&
          updated != other.updated;
}
