import 'package:control/control.dart';
import 'package:flutter/cupertino.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:smartpay/src/common/localization/localization.dart';
import 'package:smartpay/src/common/model/dependencies.dart';
import 'package:smartpay/src/common/navigator/app_navigator.dart';
import 'package:smartpay/src/common/util/extension/extension.dart';
import 'package:smartpay/src/feature/bank_card/widget/controller/add_bank_card_controller.dart';
import 'package:ui/ui.dart';

/// {@template add_bank_card_screen}
/// AddCardScreen widget.
/// {@endtemplate}
class AddBankCardScreen extends StatelessWidget {
  /// {@macro add_bank_card_screen}
  const AddBankCardScreen({
    super.key, // ignore: unused_element
  });

  @override
  Widget build(BuildContext context) => ControllerScope(AddBankCardController.new, child: _Screen());
}

class _Screen extends StatelessWidget {
  void _onAddNewCard(BuildContext context) {
    final addBankCardController = context.controllerOf<AddBankCardController>();

    if (addBankCardController.isValid) {
      Dependencies.of(context).bankCardController.addCard(addBankCardController.bankCard!);
      Future<void>.delayed(const Duration(seconds: 1));
      AppNavigator.pop(context);
      return;
    }

    Toast.showError(context, message: Localization.of(context).fillInAllData);
  }

  @override
  Widget build(BuildContext context) {
    final addBankCardController = context.controllerOf<AddBankCardController>();

    final l10n = Localization.of(context);
    final cardNumberFormatter = MaskTextInputFormatter(
      mask: '#### #### #### ####',
      filter: {'#': RegExp('[0-9]')},
      type: MaskAutoCompletionType.lazy,
    );
    final expiryDateFormatter = MaskTextInputFormatter(
      mask: '##/##',
      filter: {'#': RegExp('[0-9]')},
      type: MaskAutoCompletionType.lazy,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addCard)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ...[
            _BankSelector(),

            TextFormField(
              inputFormatters: [cardNumberFormatter],
              onChanged: (value) => addBankCardController.cardNumber = value,
              decoration: InputDecoration(
                labelText: l10n.cardNumber,
                hintText: '**** **** **** 1234',
                counterText: '',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: TextInputType.number,
              maxLength: 20,
            ),
            TextFormField(
              onChanged: (value) => addBankCardController.cardHolderName = value,
              decoration: InputDecoration(
                labelText: l10n.cardHolderName,
                hintText: 'Atayev Ata',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
            TextFormField(
              onChanged: (value) => addBankCardController.expirationDate = value,
              inputFormatters: [expiryDateFormatter],
              decoration: InputDecoration(
                labelText: l10n.expiryDate,
                hintText: '08/42',
                counterText: '',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: TextInputType.datetime,
              maxLength: 5,
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _onAddNewCard(context),
              child: Text(l10n.addCard),
            ),
          ].expand((e) => [e, const SizedBox(height: 12)]),
        ],
      ),
    );
  }
}

class _BankSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = Localization.of(context);
    final banks = Dependencies.of(context).bankListController.select((state) => state.banks).value;
    final addBankCardController = context.controllerOf<AddBankCardController>();

    return ListenableBuilder(
      listenable: addBankCardController,
      builder: (context, _) {
        final selectedBank = addBankCardController.bank;

        return PopupBuilder(
          followerAnchor: Alignment.topRight,
          targetAnchor: Alignment.topRight,
          enforceLeaderWidth: true,
          followerBuilder:
              (context, controller) => PopupFollower(
                onDismiss: () => controller.hide(),
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 8,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: banks.length,
                    itemBuilder: (context, index) {
                      final current = banks[index];
                      final isSelected = current == selectedBank;

                      final borderRadiusTop = Radius.circular(banks.first == current ? 12 : 0);
                      final borderRadiusBottom = Radius.circular(banks.last == current ? 12 : 0);
                      final borderRadius = BorderRadius.vertical(top: borderRadiusTop, bottom: borderRadiusBottom);

                      return ListTile(
                        title: Center(child: Text(current.name)),
                        titleTextStyle: context.textTheme.labelLarge,
                        selected: isSelected,
                        shape: RoundedRectangleBorder(borderRadius: borderRadius),
                        onTap: () {
                          addBankCardController.bank = current;
                          controller.hide();
                        },
                      );
                    },
                  ),
                ),
              ),
          targetBuilder:
              (context, controller) => DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: context.colorScheme.outline),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: InkWell(
                  onTap: () => controller.show(),
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(selectedBank?.name ?? l10n.selectBank),
                        const SizedBox(width: 12),
                        const Icon(CupertinoIcons.chevron_down, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
        );
      },
    );
  }
}
