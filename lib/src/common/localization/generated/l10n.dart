// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class GeneratedLocalization {
  GeneratedLocalization();

  static GeneratedLocalization? _current;

  static GeneratedLocalization get current {
    assert(
      _current != null,
      'No instance of GeneratedLocalization was loaded. Try to initialize the GeneratedLocalization delegate before accessing GeneratedLocalization.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<GeneratedLocalization> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = GeneratedLocalization();
      GeneratedLocalization._current = instance;

      return instance;
    });
  }

  static GeneratedLocalization of(BuildContext context) {
    final instance = GeneratedLocalization.maybeOf(context);
    assert(
      instance != null,
      'No instance of GeneratedLocalization present in the widget tree. Did you add GeneratedLocalization.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static GeneratedLocalization? maybeOf(BuildContext context) {
    return Localizations.of<GeneratedLocalization>(
      context,
      GeneratedLocalization,
    );
  }

  /// `Что-то пошло не так`
  String get somethingWentWrong {
    return Intl.message(
      'Что-то пошло не так',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Настройки`
  String get settings {
    return Intl.message('Настройки', name: 'settings', desc: '', args: []);
  }

  /// `Биометрическая безопасность`
  String get biometricalSecurity {
    return Intl.message(
      'Биометрическая безопасность',
      name: 'biometricalSecurity',
      desc: '',
      args: [],
    );
  }

  /// `Тема`
  String get themeMode {
    return Intl.message('Тема', name: 'themeMode', desc: '', args: []);
  }

  /// `Язык`
  String get language {
    return Intl.message('Язык', name: 'language', desc: '', args: []);
  }

  /// `О приложении`
  String get aboutApp {
    return Intl.message('О приложении', name: 'aboutApp', desc: '', args: []);
  }

  /// `Мои карты`
  String get myCards {
    return Intl.message('Мои карты', name: 'myCards', desc: '', args: []);
  }

  /// `Добавить карту`
  String get addCard {
    return Intl.message('Добавить карту', name: 'addCard', desc: '', args: []);
  }

  /// `Выберите банк`
  String get selectBank {
    return Intl.message(
      'Выберите банк',
      name: 'selectBank',
      desc: '',
      args: [],
    );
  }

  /// `Номер карты`
  String get cardNumber {
    return Intl.message('Номер карты', name: 'cardNumber', desc: '', args: []);
  }

  /// `Имя/Фамилия на карте`
  String get cardHolderName {
    return Intl.message(
      'Имя/Фамилия на карте',
      name: 'cardHolderName',
      desc: '',
      args: [],
    );
  }

  /// `Срок действия`
  String get expiryDate {
    return Intl.message(
      'Срок действия',
      name: 'expiryDate',
      desc: '',
      args: [],
    );
  }

  /// `Пожалуйста заполните все данные`
  String get fillInAllData {
    return Intl.message(
      'Пожалуйста заполните все данные',
      name: 'fillInAllData',
      desc: '',
      args: [],
    );
  }

  /// `Вы пока не добавили ни одной карты`
  String get noCards {
    return Intl.message(
      'Вы пока не добавили ни одной карты',
      name: 'noCards',
      desc: '',
      args: [],
    );
  }

  /// `Пожалуйста, введите email правильно`
  String get enterEmailCorrectly {
    return Intl.message(
      'Пожалуйста, введите email правильно',
      name: 'enterEmailCorrectly',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate
    extends LocalizationsDelegate<GeneratedLocalization> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'tk'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<GeneratedLocalization> load(Locale locale) =>
      GeneratedLocalization.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
