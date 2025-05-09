import 'package:flutter/widgets.dart';
import 'package:pocketbase_sdk/pocketbase_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartpay/src/common/model/app_metadata.dart';
import 'package:smartpay/src/feature/authentication/controller/authentication_controller.dart';
import 'package:smartpay/src/feature/authentication/data/authentication_repository.dart';
import 'package:smartpay/src/feature/bank_card/controller/bank_card_controller.dart';
import 'package:smartpay/src/feature/bank_card/controller/bank_list_controller.dart';
import 'package:smartpay/src/feature/bank_card/repository/bank_card_repository.dart';
import 'package:smartpay/src/feature/bank_card/repository/bank_repository.dart';
import 'package:smartpay/src/feature/bank_transaction/repository/bank_transaction_local_data_source.dart';
import 'package:smartpay/src/feature/bank_transaction/repository/bank_transaction_repository.dart';
import 'package:smartpay/src/feature/settings/controller/settings_controller.dart';
import 'package:smartpay/src/feature/settings/repository/settings_repository.dart';

/// {@template dependencies}
/// Application dependencies.
/// {@endtemplate}
class Dependencies {
  /// {@macro dependencies}
  Dependencies();

  /// The state from the closest instance of this class.
  ///
  /// {@macro dependencies}
  factory Dependencies.of(BuildContext context) => InheritedDependencies.of(context);

  /// Injest dependencies to the widget tree.
  Widget inject({required Widget child, Key? key}) => InheritedDependencies(dependencies: this, key: key, child: child);

  /// App metadata
  late final AppMetadata metadata;

  /// Data

  /// Shared preferences
  late final SharedPreferences sharedPreferences;

  /// Local data source

  /// Bank transaction local data source
  late final IBankTransactionLocalDataSource bankTransactionLocalDataSource;

  /// Sdk

  /// Pocketbase
  late final PocketBase pocketBase;

  /// User sdk
  late final UserSdk userSdk;

  /// P2PTransaction sdk
  late final P2pTransactionSdk p2pTransactionSdk;

  /// Repository

  /// Settings repository
  late final SettingsRepository settingsRepository;

  /// Authentication repository
  late final AuthenticationRepository authenticationRepository;

  /// Bank card repository
  late final BankCardRepository bankCardRepository;

  /// Banks List repository
  late final MockBankRepository bankRepository;

  /// Bank transaction repository
  late final BankTransactionRepository bankTransactionRepository;

  /// Controllers

  /// Authentication controller
  late final AuthenticationController authenticationController;

  /// Bank card controller
  late final BankCardController bankCardController;

  /// Bank list controller
  late final BankListController bankListController;

  /// Settings controller
  late final SettingsController settingsController;
}

/// {@template inherited_dependencies}
/// InheritedDependencies widget.
/// {@endtemplate}
class InheritedDependencies extends InheritedWidget {
  /// {@macro inherited_dependencies}
  const InheritedDependencies({required this.dependencies, required super.child, super.key});

  final Dependencies dependencies;

  /// The state from the closest instance of this class
  /// that encloses the given context, if any.
  static Dependencies? maybeOf(BuildContext context) =>
      (context.getElementForInheritedWidgetOfExactType<InheritedDependencies>()?.widget as InheritedDependencies?)
          ?.dependencies;

  static Never _notFoundInheritedWidgetOfExactType() =>
      throw ArgumentError(
        'Out of scope, not found inherited widget '
            'a InheritedDependencies of the exact type',
        'out_of_scope',
      );

  /// The state from the closest instance of this class
  /// that encloses the given context.
  static Dependencies of(BuildContext context) => maybeOf(context) ?? _notFoundInheritedWidgetOfExactType();

  @override
  bool updateShouldNotify(covariant InheritedDependencies oldWidget) => false;
}
