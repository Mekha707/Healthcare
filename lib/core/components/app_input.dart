import 'package:flutter/material.dart';
import '../theme/app_radius.dart';

class AppInput extends StatelessWidget {
  final String hint;

  const AppInput({super.key, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }
}
