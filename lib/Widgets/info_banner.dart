// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:healthcareapp_try1/core/theme/app_colors.dart';

class InfoBanner extends StatelessWidget {
  const InfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark
        ? Colors.blue.withOpacity(0.14)
        : const Color(0xFFE6F1FB);

    final borderColor = isDark
        ? Colors.blue.withOpacity(0.24)
        : const Color(0xFFB5D4F4);

    final dotColor = isDark ? Colors.blue.shade200 : const Color(0xFF185FA5);

    final titleColor = isDark ? Colors.blue.shade100 : const Color(0xFF0C447C);

    final bodyColor = isDark ? Colors.blue.shade100 : const Color(0xFF185FA5);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'محتوى صحي موثوق',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'جميع المقالات منشورة من قِبل أطباء موثقين ومتخصصين معتمدين.',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 12, color: bodyColor, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
