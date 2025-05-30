import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('kk'); // Стартовый язык - казахский

  Locale get locale => _locale;

  // Изменяем язык и уведомляем слушателей
  void setLocale(String code) {
    if (_locale.languageCode != code) {
      _locale = Locale(code);
      notifyListeners(); // Уведомляем слушателей об изменении языка
    }
  }
}
