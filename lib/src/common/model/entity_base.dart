import 'package:meta/meta.dart';

@immutable
abstract interface class EntityBase<T> {
  abstract final String id;
  abstract final DateTime createdAt;
  abstract final DateTime updatedAt;

  Map<String, dynamic> toJson();
}
