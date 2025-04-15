import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartpay/src/feature/bank_card/widget/bank_cards_screen.dart';
import 'package:smartpay/src/feature/bank_transaction/widget/bank_transactions_screen.dart';
import 'package:smartpay/src/feature/settings/widget/settings_screen.dart';

part '__home_screen.dart';

/// {@template home_screen}
/// HomeScreen widget.
/// {@endtemplate}
class HomeScreen extends StatefulWidget {
  /// {@macro home_screen}
  const HomeScreen({
    super.key, // ignore: unused_element
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int activeIndex = 0;

  void _onItemTapped(int index) {
    activeIndex = index;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(
      index: activeIndex,
      children: [_HomeScreen(), const BankCardsScreen(), const BankTransactionsScreen(), const SettingsScreen()],
    ),
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: activeIndex,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: _onItemTapped,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.creditcard), label: ''),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.doc), label: ''),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.settings), label: ''),
      ],
    ),
  );
}
