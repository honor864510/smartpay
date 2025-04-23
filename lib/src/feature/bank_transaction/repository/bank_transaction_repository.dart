import 'dart:async';

import 'package:l/l.dart';
import 'package:pocketbase_sdk/pocketbase_sdk.dart';
import 'package:smartpay/src/feature/bank_transaction/entity/bank_transaction_entity.dart';
import 'package:smartpay/src/feature/bank_transaction/repository/bank_transaction_local_data_source.dart';

abstract interface class IBankTransactionRepository {
  Future<List<BankTransactionEntity>> fetchTransactions();
  Stream<BankTransactionEntity> listen(String id);
  Future<void> create(BankTransactionEntity transaction);
  Future<void> update(BankTransactionEntity transaction);
}

final class BankTransactionRepository implements IBankTransactionRepository {
  BankTransactionRepository({
    required P2pTransactionSdk p2pTransactionSdk,
    required IBankTransactionLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource,
       _p2pTransactionSdk = p2pTransactionSdk;

  final P2pTransactionSdk _p2pTransactionSdk;
  final IBankTransactionLocalDataSource _localDataSource;

  @override
  Future<void> create(BankTransactionEntity transaction) async {
    try {
      // Convert entity to DTO
      final dto = P2PTransactionDto(
        id: transaction.id,
        amount: transaction.amount,
        status: transaction.status.name,
        bankIdentifier: transaction.bankIdentifier,
      );

      // Create transaction in remote database
      await _p2pTransactionSdk.create(dto);

      // Update local cache
      final transactions = await _localDataSource.readTransactions();
      transactions.add(transaction);
      await _localDataSource.saveTransactions(transactions);
    } catch (e) {
      // Handle errors or rethrow
      rethrow;
    }
  }

  @override
  Future<List<BankTransactionEntity>> fetchTransactions() async {
    try {
      // Try to fetch from remote first
      final remoteDtos = await _p2pTransactionSdk.fetchList();

      // Convert DTOs to entities
      final transactions = remoteDtos.map(BankTransactionEntity.fromP2PTransactionDto).toList();

      // Update local cache
      await _localDataSource.saveTransactions(transactions);

      return transactions;
    } on Object catch (error, stackTrace) {
      l.e(error, stackTrace);

      // If remote fetch fails, try to get from local cache
      return _localDataSource.readTransactions();
    }
  }

  @override
  Stream<BankTransactionEntity> listen(String id) {
    // Create a stream controller to manage the output stream
    final controller = StreamController<BankTransactionEntity>.broadcast();

    // Subscribe to remote updates
    _p2pTransactionSdk.subscribe(id);

    // Listen to the SDK stream and transform DTOs to entities
    _p2pTransactionSdk.p2pTransactionStream.listen((dto) {
      if (dto.id == id) {
        final entity = BankTransactionEntity.fromP2PTransactionDto(dto);
        controller.add(entity);

        // Update local cache with the latest data
        _updateLocalCache(entity);
      }
    }, onError: controller.addError);

    // Handle stream closing
    controller.onCancel = () {
      _p2pTransactionSdk.unsubscribe(id);
      controller.close();
    };

    return controller.stream;
  }

  @override
  Future<void> update(BankTransactionEntity transaction) async {
    try {
      // Convert entity to DTO
      final dto = P2PTransactionDto(
        id: transaction.id,
        amount: transaction.amount,
        status: transaction.status.name,
        bankIdentifier: transaction.bankIdentifier,
      );

      // Update in remote database
      await _p2pTransactionSdk.update(transaction.id, dto);

      // Update local cache
      await _updateLocalCache(transaction);
    } catch (e) {
      // Handle errors or rethrow
      rethrow;
    }
  }

  // Helper method to update a single transaction in the local cache
  Future<void> _updateLocalCache(BankTransactionEntity transaction) async {
    final transactions = await _localDataSource.readTransactions();
    final index = transactions.indexWhere((t) => t.id == transaction.id);

    if (index >= 0) {
      transactions[index] = transaction;
    } else {
      transactions.add(transaction);
    }

    await _localDataSource.saveTransactions(transactions);
  }
}
