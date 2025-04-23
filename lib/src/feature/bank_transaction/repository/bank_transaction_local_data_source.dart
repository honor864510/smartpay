import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartpay/src/feature/bank_transaction/entity/bank_transaction_entity.dart';

abstract interface class IBankTransactionLocalDataSource {
  Future<List<BankTransactionEntity>> readTransactions();
  Future<void> saveTransactions(List<BankTransactionEntity> transactions);
}

final class BankTransactionLocalDataSource implements IBankTransactionLocalDataSource {
  BankTransactionLocalDataSource({required SharedPreferences preferences}) : _preferences = preferences;

  final SharedPreferences _preferences;

  @override
  Future<List<BankTransactionEntity>> readTransactions() async {
    final transactionsMap = _preferences.getStringList(BankTransactionEntity.prefsKey);

    if (transactionsMap == null) return [];

    final transactions = <BankTransactionEntity>[];

    for (final json in transactionsMap) {
      final transaction = BankTransactionEntity.fromJson(jsonDecode(json) as Map<String, dynamic>);

      transactions.add(transaction);
    }

    return transactions;
  }

  @override
  Future<void> saveTransactions(List<BankTransactionEntity> transactions) async {
    final jsonList = transactions.map((e) => jsonEncode(e.toJson())).toList();

    await _preferences.setStringList(BankTransactionEntity.prefsKey, jsonList);
  }
}
