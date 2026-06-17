import 'dart:io';

final class DotEnv {
  // Регулярка для определения целых чисел
  static final _intPattern = RegExp(r'^-?\d+$');
  // Регулярка для определения булевых значений
  static final _boolPattern = RegExp(r'^true|false|True|False$');
  // Таблица для хранения значений окружения
  final Map<String, Object?> _env = {};

  /// Конструктор класса DotEnv
  /// [platformEnv] - флаг, указывающий, нужно ли загружать
  /// переменные окружения платформы
  DotEnv({bool platformEnv = false}) {
    if (platformEnv) {
      _env.addAll(_loadPlatformEnv());
    }
  }

// остальной код без изменений

}