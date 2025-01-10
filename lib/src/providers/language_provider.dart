import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  Locale _currentLocale = const Locale('vi');

  Locale get currentLocale => _currentLocale;

  String get currentLanguage => _currentLocale.languageCode;

  void changeLanguage(String languageCode) {
    _currentLocale = Locale(languageCode);
    notifyListeners();
  }
}