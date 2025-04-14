import 'package:flutter/material.dart';

/// {@template home_screen}
/// HomeScreen widget.
/// {@endtemplate}
class HomeScreen extends StatelessWidget {
  /// {@macro home_screen}
  const HomeScreen({
    super.key, // ignore: unused_element
  });

  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: const Text('Title')), body: Center(child: Text('Home')));
}
