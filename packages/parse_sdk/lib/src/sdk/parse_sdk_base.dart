import 'package:parse_sdk/parse_sdk.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

typedef CustomParseObjectConstructor<T extends ParseObject> = T Function();

abstract interface class IParseSdkBase<T extends ParseObject> {
  Future<T> create(T object);
  Future<List<T>> createAll(List<T> objects);

  Future<T> read(String id, {List<String>? include});
  Future<List<T>> readAll(QueryBuilder query);

  Future<T> update(T object);
  Future<List<T>> updateAll(List<T> objects);

  Future<T> delete(T object);
  Future<List<T>> deleteAll(List<T> objects);
}

base class ParseSdkBase<T extends ParseObject> implements IParseSdkBase<T> {
  const ParseSdkBase({required CustomParseObjectConstructor<T> parseObjectConstructor})
    : _parseObjectConstructor = parseObjectConstructor;

  final CustomParseObjectConstructor<T> _parseObjectConstructor;

  Future<T> _handleSingleResponse(Future<ParseResponse> query) async {
    final response = await query;

    if (response.success && response.results != null && response.results!.isNotEmpty) {
      return response.results!.firstOrNull as T;
    }

    Error.throwWithStackTrace(
      ParseSdkException(response.error?.message ?? 'errorMessage', error: response.error),
      StackTrace.current,
    );
  }

  Future<List<T>> _handleListResponse(Future<ParseResponse> query) async {
    final response = await query;

    if (response.success && response.results != null) {
      return response.results!.cast<T>();
    }

    Error.throwWithStackTrace(
      ParseSdkException(response.error?.message ?? 'errorMessage', error: response.error),
      StackTrace.current,
    );
  }

  @override
  Future<T> create(T object) async {
    final response = object.save();
    return _handleSingleResponse(response);
  }

  @override
  Future<List<T>> createAll(List<T> objects) async {
    final futures = objects.map(create).toList();
    final results = await Future.wait(futures);
    return results;
  }

  @override
  Future<T> read(String id, {List<String>? include}) async {
    final instance = _parseObjectConstructor();
    final query = instance.getObject(id, include: include);

    return _handleSingleResponse(query);
  }

  @override
  Future<List<T>> readAll(QueryBuilder query) async {
    final listQuery = query.query();

    return _handleListResponse(listQuery);
  }

  @override
  Future<T> update(T object) async {
    final query = object.save();

    return _handleSingleResponse(query);
  }

  @override
  Future<List<T>> updateAll(List<T> objects) async {
    final futures = objects.map(update).toList();
    final results = await Future.wait(futures);
    return results;
  }

  @override
  Future<T> delete(T object) async {
    final objectId = object.objectId ?? '';

    try {
      final response = await object.delete();

      if (response.success) {
        return _parseObjectConstructor()..objectId = objectId;
      }

      Error.throwWithStackTrace(
        ParseSdkException('Failed to delete object $objectId'),
        StackTrace.current,
      );
    } on Object catch (error, stackTrace) {
      if (error is ParseSdkException) rethrow;

      Error.throwWithStackTrace(
        ParseSdkException(
          'Failed to delete object $objectId',
          error: error,
          stackTrace: stackTrace,
        ),
        stackTrace,
      );
    }
  }

  @override
  Future<List<T>> deleteAll(List<T> objects) async {
    final futures = objects.map(delete).toList();
    final results = await Future.wait(futures);
    return results;
  }
}
