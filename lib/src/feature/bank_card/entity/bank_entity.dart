import 'package:meta/meta.dart';
import 'package:smartpay/src/common/util/helper_functions.dart';

@immutable
final class BankEntity implements Comparable<BankEntity> {
  const BankEntity({required this.id, required this.nameEn, required this.nameTk, required this.nameRu});

  final String id;

  final String nameEn;
  final String nameTk;
  final String nameRu;

  String get name => localizedText(en: nameEn, ru: nameRu, tk: nameTk);

  @override
  int compareTo(BankEntity other) => name.compareTo(other.name);

  @override
  int get hashCode => Object.hashAll([id, nameEn, nameTk, nameRu]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankEntity &&
          id == other.id &&
          nameEn == other.nameEn &&
          nameTk == other.nameTk &&
          nameRu == other.nameRu;
}
