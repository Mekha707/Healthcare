import 'package:flutter/material.dart';
import 'package:healthcareapp_try1/core/theme/app_colors.dart';

class HomeContentAIPowerdmagicWithText extends StatelessWidget {
  const HomeContentAIPowerdmagicWithText({
    super.key,
    required this.magicText,
    this.isDark = false,
  });
  final String magicText;
  final bool isDark;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.auto_awesome,
          color: isDark ? AppColors.surfaceLight : AppColors.primary,
          size: 20,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              magicText,
              softWrap: true,
              style: TextStyle(
                color: isDark ? AppColors.textDark : AppColors.textLight,
                fontSize: 12,
                letterSpacing: 0.7,
                height: 1.4,
                fontFamily: 'Agency',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
