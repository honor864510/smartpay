import 'package:control/control.dart';
import 'package:smartpay/src/common/localization/localization.dart';
import 'package:smartpay/src/common/model/dependencies.dart';
import 'package:smartpay/src/common/navigator/app_navigator.dart';
import 'package:smartpay/src/common/navigator/routes.dart';
import 'package:smartpay/src/common/util/extension/extension.dart';
import 'package:smartpay/src/feature/bank_card/controller/bank_card_controller.dart';
import 'package:smartpay/src/feature/bank_card/controller/bank_card_state.dart';
import 'package:smartpay/src/feature/bank_card/entity/bank_card_entity.dart';
import 'package:ui/ui.dart';

/// {@template bank_card_screen}
/// BankCardsScreen widget.
/// {@endtemplate}
class BankCardsScreen extends StatelessWidget {
  /// {@macro bank_card_screen}
  const BankCardsScreen({
    super.key, // ignore: unused_element
  });

  @override
  Widget build(BuildContext context) {
    final l10n = Localization.of(context);
    final bankCardController = Dependencies.of(context).bankCardController;

    return Scaffold(
      body: StateConsumer<BankCardController, BankCardState>(
        controller: bankCardController,
        buildWhen: (previous, current) => previous != current,
        builder:
            (context, state, _) => CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  floating: true,
                  title: Text(l10n.myCards),
                  actions: [
                    IconButton(
                      onPressed: () => AppNavigator.push(context, Routes.addBankCard.page()),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),

                if (state.bankCards.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(l10n.noCards, style: context.textTheme.titleMedium),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: () => AppNavigator.push(context, Routes.addBankCard.page()),
                            child: Text(l10n.addCard),
                          ),
                        ],
                      ),
                    ),
                  ),

                SliverList.builder(
                  itemCount: state.bankCards.length,
                  itemBuilder: (context, index) => _BankCardWidget(bankCard: state.bankCards[index]),
                ),
              ],
            ),
      ),
    );
  }
}

class _BankCardWidget extends StatelessWidget {
  const _BankCardWidget({required this.bankCard});

  final BankCardEntity bankCard;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      title: Text(bankCard.cardNumber, style: context.textTheme.titleMedium),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(bankCard.cardHolderName, style: context.textTheme.bodyMedium),
          Text(bankCard.expirationDate, style: context.textTheme.bodyMedium),
        ],
      ),
    ),
  );
}
