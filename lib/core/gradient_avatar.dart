// lib/core/utils/gradient_avatar.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

LinearGradient getGradientForLetter(String letter) {
  final Map<String, List<Color>> gradients = {
    'A': [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
    'B': [const Color(0xFF6B6BFF), const Color(0xFF53B8FF)],
    'C': [const Color(0xFF6BFF6B), const Color(0xFF53FFB8)],
    'D': [const Color(0xFFFF6BE8), const Color(0xFFB853FF)],
    'E': [const Color(0xFFFFD36B), const Color(0xFFFF6B6B)],
    'F': [const Color(0xFF6BFFD3), const Color(0xFF6BB8FF)],
    'G': [const Color(0xFFFF9A6B), const Color(0xFFFFD36B)],
    'H': [const Color(0xFF6B8EFF), const Color(0xFFB06EF5)],
    'I': [const Color(0xFFFF6B9A), const Color(0xFFFFB86B)],
    'J': [const Color(0xFF6BFFE8), const Color(0xFF6BFF8E)],
    'K': [const Color(0xFFD36BFF), const Color(0xFF6B8EFF)],
    'L': [const Color(0xFFFFB86B), const Color(0xFFFF6BD3)],
    'M': [const Color(0xFF6BFF6B), const Color(0xFFFFD36B)],
    'N': [const Color(0xFF536EF5), const Color(0xFF53D8FF)],
    'O': [const Color(0xFFFF536E), const Color(0xFFFF8E53)],
    'P': [const Color(0xFFB06EF5), const Color(0xFF6E8EF5)],
    'Q': [const Color(0xFF6EF5B0), const Color(0xFF6EF5F5)],
    'R': [const Color(0xFFF56E6E), const Color(0xFFF5B06E)],
    'S': [const Color(0xFF6EF56E), const Color(0xFF6EF5B0)],
    'T': [const Color(0xFFF56EB0), const Color(0xFFB06EF5)],
    'U': [const Color(0xFF6EB0F5), const Color(0xFF6E6EF5)],
    'V': [const Color(0xFFF5B06E), const Color(0xFFF5F56E)],
    'W': [const Color(0xFF6EF5F5), const Color(0xFF6EB0F5)],
    'X': [const Color(0xFFB0F56E), const Color(0xFF6EF5B0)],
    'Y': [const Color(0xFFF56EB0), const Color(0xFFF56E6E)],
    'Z': [const Color(0xFF6E6EF5), const Color(0xFFB06EF5)],
  };

  final key = letter.toUpperCase();
  final colors =
      gradients[key] ?? [const Color(0xFFB06EF5), const Color(0xFF6E8EF5)];

  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: colors,
  );
}

// ✅ Widget جاهز للاستخدام في أي مكان
class GradientAvatar extends StatelessWidget {
  final String name;
  final double size;
  final double fontSize;

  const GradientAvatar({
    super.key,
    required this.name,
    this.size = 56,
    this.fontSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    final letter = name.isNotEmpty ? name[0] : '?';
    final gradient = getGradientForLetter(letter);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          letter.toUpperCase(),
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
