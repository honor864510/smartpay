import 'package:smartpay/src/common/localization/localization.dart';

String localizedText({required String ru, required String tk, required String en}) {
  final currentLocale = Localization.current.locale;

  switch (currentLocale.languageCode) {
    case 'ru':
      return ru;
    case 'tk':
      return tk;
    case 'en':
      return en;
    default:
      return ru;
  }
}
