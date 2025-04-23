import 'dart:async';

import 'package:pocketbase_sdk/pocketbase_sdk.dart';

/// SDK for interacting with P2P transactions in PocketBase
final class P2pTransactionSdk {
  P2pTransactionSdk({required this.pb});

  final PocketBase pb;

  StreamController<P2PTransactionDto>? _p2pTransactionStreamController;

  /// Stream of transaction updates
  Stream<P2PTransactionDto> get p2pTransactionStream {
    _p2pTransactionStreamController ??= StreamController<P2PTransactionDto>.broadcast();
    return _p2pTransactionStreamController!.stream;
  }

  /// Fetches a list of transactions with pagination
  Future<List<P2PTransactionDto>> fetchList({int page = 1, int perPage = 30, String? filter, String? sort}) async {
    final response = await pb
        .collection(P2PTransactionDto.collectionName)
        .getList(
          page: page,
          perPage: perPage,
          filter: filter,
          sort: sort,
          expand: '${P2PTransactionDto.collectionName}.sender,${P2PTransactionDto.collectionName}.receiver',
        );

    return response.items.map((e) => P2PTransactionDto.fromJson(e.data)).toList();
  }

  /// Fetches a single transaction by ID
  Future<P2PTransactionDto> fetchOne(String id) async {
    final record = await pb
        .collection(P2PTransactionDto.collectionName)
        .getOne(id, expand: '${P2PTransactionDto.collectionName}.sender,${P2PTransactionDto.collectionName}.receiver');

    return P2PTransactionDto.fromJson(record.data);
  }

  /// Creates a new transaction
  Future<P2PTransactionDto> create(P2PTransactionDto dto) async {
    final record = await pb
        .collection(P2PTransactionDto.collectionName)
        .create(
          body: dto.toJson(),
          expand: '${P2PTransactionDto.collectionName}.sender,${P2PTransactionDto.collectionName}.receiver',
        );

    return P2PTransactionDto.fromJson(record.data);
  }

  /// Updates an existing transaction
  Future<P2PTransactionDto> update(String id, P2PTransactionDto dto) async {
    final record = await pb
        .collection(P2PTransactionDto.collectionName)
        .update(
          id,
          body: dto.toJson(),
          expand: '${P2PTransactionDto.collectionName}.sender,${P2PTransactionDto.collectionName}.receiver',
        );

    return P2PTransactionDto.fromJson(record.data);
  }

  /// Subscribes to updates for a specific transaction
  Future<void> subscribe(String id) async {
    if (_p2pTransactionStreamController != null) {
      await _dispose();
    }

    _p2pTransactionStreamController = StreamController<P2PTransactionDto>.broadcast();

    await pb.collection(P2PTransactionDto.collectionName).subscribe(id, (e) {
      if (e.record != null) {
        _p2pTransactionStreamController?.add(P2PTransactionDto.fromJson(e.record!.data));
      }
    }, expand: '${P2PTransactionDto.collectionName}.sender,${P2PTransactionDto.collectionName}.receiver');
  }

  /// Unsubscribes from updates for a specific transaction
  Future<void> unsubscribe(String id) async {
    await pb.collection(P2PTransactionDto.collectionName).unsubscribe(id);
    await _dispose();
  }

  /// Disposes resources used by this SDK
  Future<void> _dispose() async {
    await _p2pTransactionStreamController?.close();
    _p2pTransactionStreamController = null;
  }
}
