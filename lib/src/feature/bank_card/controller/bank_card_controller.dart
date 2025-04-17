import 'package:control/control.dart';
import 'package:smartpay/src/feature/bank_card/controller/bank_card_state.dart';
import 'package:smartpay/src/feature/bank_card/entity/bank_card_entity.dart';
import 'package:smartpay/src/feature/bank_card/repository/bank_card_repository.dart';

/// Controller for managing bank card operations
final class BankCardController extends StateController<BankCardState> with SequentialControllerHandler {
  /// Creates a new instance of [BankCardController]
  BankCardController({
    required IBankCardRepository repository,
    super.initialState = const BankCardState.idle(bankCards: [], message: 'Initial'),
  }) : _bankCardRepository = repository {
    fetchCards();
  }

  final IBankCardRepository _bankCardRepository;

  /// Fetches all bank cards from the repository
  void fetchCards() => handle(
    () async {
      setState(BankCardState.processing(bankCards: state.bankCards, message: 'Fetching bank cards'));

      final cards = await _bankCardRepository.fetch();

      setState(BankCardState.idle(bankCards: cards, message: 'Cards loaded successfully'));
    },
    error:
        (error, stackTrace) async => setState(
          BankCardState.idle(bankCards: state.bankCards, message: 'Failed to load cards', error: 'Error: $error'),
        ),
  );

  /// Adds a new bank card to the repository
  void addCard(BankCardEntity card) => handle(
    () async {
      setState(BankCardState.processing(bankCards: state.bankCards, message: 'Adding bank card'));

      await _bankCardRepository.add(card);
      final updatedCards = [...state.bankCards, card]..sort();

      setState(BankCardState.idle(bankCards: updatedCards, message: 'Card added successfully'));
    },
    error:
        (error, _) async => setState(
          BankCardState.idle(bankCards: state.bankCards, message: 'Failed to add card', error: 'Error: $error'),
        ),
  );

  /// Deletes a bank card from the repository
  void deleteCard(String cardId) => handle(
    () async {
      setState(BankCardState.processing(bankCards: state.bankCards, message: 'Deleting bank card'));

      await _bankCardRepository.delete(cardId);
      final updatedCards = state.bankCards.where((card) => card.id != cardId).toList();

      setState(BankCardState.idle(bankCards: updatedCards, message: 'Card deleted successfully'));
    },
    error:
        (error, _) async => setState(
          BankCardState.idle(bankCards: state.bankCards, message: 'Failed to delete card', error: 'Error: $error'),
        ),
  );
}
