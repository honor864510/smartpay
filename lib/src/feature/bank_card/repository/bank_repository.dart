import 'package:smartpay/src/feature/bank_card/entity/bank_entity.dart';

abstract interface class IBankRepository {
  Future<List<BankEntity>> fetch();
}

class MockBankRepository implements IBankRepository {
  List<BankEntity> get _banks => const [
    BankEntity(id: 'TDYBank', nameRu: 'ГБВДТ', nameEn: 'TFEB', nameTk: 'TDDYIB'),
    BankEntity(id: 'RysgalBank', nameRu: 'АКБ "Рысгал"', nameEn: 'JSCB "Rysgal"', nameTk: '"Rysgal" PTB'),
    BankEntity(id: 'SenagatBank', nameRu: 'АКБ "Сенагат"', nameEn: 'JSCB "Senagat" ', nameTk: '"Senagat" PTB'),
    BankEntity(id: 'HalkBank', nameRu: 'АКБ "Халкбанк"', nameEn: 'JSCB "Halkbank"', nameTk: '"Halkbank" PTB'),
  ];

  @override
  Future<List<BankEntity>> fetch() async => _banks;
}
