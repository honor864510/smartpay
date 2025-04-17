import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartpay/src/feature/bank_card/entity/bank_card_entity.dart';

abstract interface class IBankCardRepository {
  Future<List<BankCardEntity>> fetch();
  Future<void> add(BankCardEntity bankCard);
  Future<void> delete(String id);
}

final class BankCardRepository implements IBankCardRepository {
  BankCardRepository({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  static const String _bankCardsKey = 'bank_cards';

  @override
  Future<List<BankCardEntity>> fetch() async {
    final jsonStrings = _prefs.getStringList(_bankCardsKey);
    if (jsonStrings == null) return [];

    return jsonStrings
        .map((jsonString) => BankCardEntity.fromJson(json.decode(jsonString) as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> add(BankCardEntity bankCard) async {
    final existingCards = await fetch();
    final updatedCards = [...existingCards, bankCard];
    final jsonStrings = updatedCards.map((card) => json.encode(card.toJson())).toList();
    await _prefs.setStringList(_bankCardsKey, jsonStrings);
  }

  @override
  Future<void> delete(String id) async {
    final existingCards = await fetch();
    final updatedCards = existingCards.where((card) => card.id != id).toList();
    final jsonStrings = updatedCards.map((card) => json.encode(card.toJson())).toList();
    await _prefs.setStringList(_bankCardsKey, jsonStrings);
  }
}
