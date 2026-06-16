import 'dart:convert';
import 'dart:io';

class ConsoleHelpers {
  static void initialize() {
    stdout.encoding = utf8;
  }

  static void cleanScreen() {
    stdout.write('\x1B[2J\x1B[H');
  }

  static void printHeader(String title) {
    final line = '=' * (title.length + 4);
    print('\n$line');
    print('   $title');
    print('$line\n');
  }

  static void printSubHeader(String title) {
    print('\n--$title--\n');
  }

  static void printSuccess(String message) {
    print('[SUCCESS] $message');
  }

  static void printError(String message) {
    print('[ERROR $message');
  }

  static void printInfo(String message) {
    print('[INFO] $message');
  }

  static String? readLine(String prompt) {
    stdout.write(prompt);
    return stdin.readLineSync(encoding: utf8);
  }

  static int? readInt(String prompt) {
    final input = readLine(prompt);
    if (input == null || input.isEmpty) return null;
    return int.tryParse(input);
  }

  static bool confirm(String message) {
    final response = readLine('$message (y/n): ')?.toLowerCase();
    return response == 'y' ||
        response == 'yes' ||
        response == 'д' ||
        response == 'да';
  }
  static void pause([String message='\nНажмите Enter для продолжения...']){
    stdout.write(message);
    stdin.readLineSync();
  }
  static int? showSelectionList<T>(
      List<T> items,
      String Function(T) displayText, {
        String title = 'Выберите:',
        bool allowCancel = true,
      }) {
    if (items.isEmpty) {
      printInfo('Список пуст');
      return null;
    }

    print('\n$title');
    for (var i = 0; i < items.length; i++) {
      print('  ${i + 1}. ${displayText(items[i])}');
    }

    if (allowCancel) {
      print('  0. Отмена');
    }

    while (true) {
      final choice = readInt('\nВыбор: ');

      if (choice == null) {
        printError('Введите число');
        continue;
      }

      if (allowCancel && choice == 0) {
        return null;
      }

      if (choice < 1 || choice > items.length) {
        printError(
          'Неверный выбор. Введите число от ${allowCancel ? 0 : 1}'
              ' до ${items.length}',
        );
        continue;
      }

      return choice - 1;
    }
  }
}
