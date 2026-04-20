import 'package:flutter/material.dart';

extension ContextX on BuildContext {
  Color get primary => Theme.of(this).colorScheme.primary;

  TextTheme get text => Theme.of(this).textTheme;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
