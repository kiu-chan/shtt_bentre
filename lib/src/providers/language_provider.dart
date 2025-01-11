import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  static const String _languageKey = 'selected_language';
  late SharedPreferences _prefs;
  Locale _currentLocale;

  LanguageProvider() : _currentLocale = const Locale('vi') {
    _loadSavedLanguage();
  }

  Locale get currentLocale => _currentLocale;
  String get currentLanguage => _currentLocale.languageCode;

  Future<void> _loadSavedLanguage() async {
    _prefs = await SharedPreferences.getInstance();
    final savedLanguage = _prefs.getString(_languageKey);
    if (savedLanguage != null) {
      _currentLocale = Locale(savedLanguage);
      notifyListeners();
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    _currentLocale = Locale(languageCode);
    await _prefs.setString(_languageKey, languageCode);
    notifyListeners();
  }
}