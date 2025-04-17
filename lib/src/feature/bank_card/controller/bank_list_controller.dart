import 'package:control/control.dart';
import 'package:smartpay/src/feature/bank_card/controller/bank_list_state.dart';
import 'package:smartpay/src/feature/bank_card/repository/bank_repository.dart';

/// Controller for managing bank card list operations
final class BankListController extends StateController<BankListState> with SequentialControllerHandler {
  /// Creates a new instance of [BankListController]
  BankListController({
    required IBankRepository repository,
    super.initialState = const BankListState.idle(banks: [], message: 'Initial'),
  }) : _bankRepository = repository {
    fetchCards();
  }

  final IBankRepository _bankRepository;

  /// Fetches all bank cards from the repository
  void fetchCards() => handle(
    () async {
      setState(BankListState.processing(banks: state.banks, message: 'Fetching bank cards'));

      final banks = await _bankRepository.fetch();

      setState(BankListState.idle(banks: banks, message: 'Cards loaded successfully'));
    },
    error:
        (error, stackTrace) async =>
            setState(BankListState.idle(banks: state.banks, message: 'Failed to load cards', error: 'Error: $error')),
  );
}
