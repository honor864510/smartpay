import 'package:flutter/cupertino.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:smartpay/src/common/localization/localization.dart';
import 'package:smartpay/src/common/util/extension/extension.dart';
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
  Widget build(BuildContext context) {
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
            // TODO Bank Selector
            _BankSelector(),

            TextFormField(
              inputFormatters: [cardNumberFormatter],
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
              decoration: InputDecoration(
                labelText: l10n.cardHolderName,
                hintText: 'Atayev Ata',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
            TextFormField(
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
              onPressed: () {},
              child: Text(l10n.addCard),
            ),
          ].expand((e) => [e, const SizedBox(height: 12)]),
        ],
      ),
    );
  }
}

class _BankSelector extends StatefulWidget {
  @override
  State<_BankSelector> createState() => _BankSelectorState();
}

class _BankSelectorState extends State<_BankSelector> {
  final _banks = ['Rysgal', 'Senagat', 'SBFEAT', 'Altyn Asyr (other)'];
  String selectedBank = 'Rysgal';

  @override
  Widget build(BuildContext context) => PopupBuilder(
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
              itemCount: _banks.length,
              itemBuilder: (context, index) {
                final current = _banks[index];
                final isSelected = current == selectedBank;

                final borderRadiusTop = Radius.circular(_banks.first == current ? 12 : 0);
                final borderRadiusBottom = Radius.circular(_banks.last == current ? 12 : 0);
                final borderRadius = BorderRadius.vertical(top: borderRadiusTop, bottom: borderRadiusBottom);

                return ListTile(
                  title: Center(child: Text(current)),
                  titleTextStyle: context.textTheme.labelLarge,
                  selected: isSelected,
                  shape: RoundedRectangleBorder(borderRadius: borderRadius),
                  onTap: () {
                    selectedBank = current;
                    setState(() {});
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
                  Text(selectedBank),
                  const SizedBox(width: 12),
                  const Icon(CupertinoIcons.chevron_down, size: 16),
                ],
              ),
            ),
          ),
        ),
  );
}
