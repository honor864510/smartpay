import 'package:meta/meta.dart';

@immutable
final class BankCardEntity implements Comparable<BankCardEntity> {
  const BankCardEntity({
    required this.id,
    required this.createdAt,
    required this.bankId,
    this.cardHolderName = '',
    this.cardNumber = '',
    this.expirationDate = '',
  });

  factory BankCardEntity.fromJson(Map<String, dynamic> json) => BankCardEntity(
    id: json['id'] as String,
    bankId: json['bankId'] as String,
    cardHolderName: json['cardHolderName'] as String? ?? '',
    cardNumber: json['cardNumber'] as String? ?? '',
    expirationDate: json['expirationDate'] as String? ?? '',
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  final String id;
  final String bankId;
  final String cardHolderName;
  final String cardNumber;
  final String expirationDate;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'bankId': bankId,
    'cardHolderName': cardHolderName,
    'cardNumber': cardNumber,
    'expirationDate': expirationDate,
    'createdAt': createdAt.toIso8601String(),
  };

  @override
  int compareTo(BankCardEntity other) => other.createdAt.compareTo(createdAt);

  @override
  int get hashCode => Object.hashAll([id, bankId, cardHolderName, cardNumber, expirationDate, createdAt]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankCardEntity &&
          id == other.id &&
          bankId == other.bankId &&
          cardHolderName == other.cardHolderName &&
          cardNumber == other.cardNumber &&
          expirationDate == other.expirationDate &&
          createdAt == other.createdAt;
}
