import 'package:flutter/material.dart';
import 'package:healthcareapp_try1/Buttons/buttons.dart';
import 'package:healthcareapp_try1/core/Theme/app_colors.dart';

class MedicalErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final bool isDark;
  final Color darkColor;
  final Color lightColor;

  const MedicalErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
    required this.isDark,
    required this.darkColor,
    required this.lightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Server is not available",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'ElMessiri',
                color: isDark ? darkColor : lightColor,
              ),
            ),

            const SizedBox(height: 12),

            ButtonOfAuth(
              onPressed: onRetry,
              fontcolor: isDark ? AppColors.textLight : AppColors.textDark,
              buttoncolor: isDark ? darkColor : lightColor,
              buttonText: "Try Again",
            ),
          ],
        ),
      ),
    );
  }
}
