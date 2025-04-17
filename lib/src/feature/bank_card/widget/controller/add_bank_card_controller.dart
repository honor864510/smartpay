import 'package:flutter/widgets.dart';
import 'package:smartpay/src/feature/bank_card/entity/bank_card_entity.dart';
import 'package:smartpay/src/feature/bank_card/entity/bank_entity.dart';

class AddBankCardController extends ChangeNotifier {
  String? cardHolderName;
  String? cardNumber;
  String? expirationDate;

  BankEntity? _bank;
  BankEntity? get bank => _bank;
  set bank(BankEntity? value) {
    _bank = value;
    notifyListeners();
  }

  bool get isValid => cardHolderName != null && cardNumber != null && expirationDate != null && bank != null;

  BankCardEntity? get bankCard {
    if (!isValid) {
      return null;
    }

    return BankCardEntity(
      id: '',
      bankId: bank!.id,
      cardHolderName: cardHolderName!,
      cardNumber: cardNumber!,
      expirationDate: expirationDate!,
      createdAt: DateTime.now(),
    );
  }
}
