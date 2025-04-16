import 'package:smartpay/src/common/localization/localization.dart';
import 'package:smartpay/src/common/navigator/app_navigator.dart';
import 'package:smartpay/src/common/navigator/routes.dart';
import 'package:smartpay/src/common/util/extension/extension.dart';
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

    return Scaffold(
      body: CustomScrollView(
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
          SliverList.builder(
            itemBuilder:
                (context, index) => Card(
                  child: ListTile(
                    title: Text('**** **** **** 1234', style: context.textTheme.titleMedium),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Atayev Ata', style: context.textTheme.bodyMedium),
                        Text('08/42', style: context.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
