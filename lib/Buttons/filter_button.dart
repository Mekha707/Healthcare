// // ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:healthcareapp_try1/core/Theme/app_colors.dart';

// class CustomFilterButton extends StatelessWidget {
//   final bool isSelected;
//   final VoidCallback onTap;
//   final String activeText;
//   final String inactiveText;
//   final Color activeLightColor;
//   final Color activeDarkColor;

//   const CustomFilterButton({
//     super.key,
//     required this.isSelected,
//     required this.onTap,
//     this.activeText = "Clear Filter",
//     this.inactiveText = "Filter Doctors",
//     required this.activeLightColor,
//     required this.activeDarkColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return GestureDetector(
//       onTap: onTap,

//       child: AnimatedContainer(
//         margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
//         duration: const Duration(milliseconds: 200),
//         height: 50,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: isDark
//               ? (isSelected ? activeDarkColor : AppColors.bgDark)
//               : (isSelected
//                     ? activeLightColor.withOpacity(0.5)
//                     : AppColors.bgLight),

//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isDark
//                 ? (isSelected ? activeDarkColor : AppColors.textDark)
//                 : (isSelected
//                       ? activeLightColor.withOpacity(0.5)
//                       : AppColors.bgLight),
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               isSelected ? Icons.filter_alt_off : Icons.filter_alt_outlined,
//               color: isDark
//                   ? (isSelected ? AppColors.textLight : AppColors.textDark)
//                   : (isSelected
//                         ? activeLightColor.withOpacity(0.5)
//                         : AppColors.bgLight),
//               fontWeight: FontWeight.bold,
//               size: 20,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               isSelected ? activeText : inactiveText,
//               style: TextStyle(
//                 color: isDark
//                     ? (isSelected ? AppColors.textLight : AppColors.textDark)
//                     : (isSelected
//                           ? activeLightColor.withOpacity(0.5)
//                           : AppColors.bgLight),
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//                 letterSpacing: 1.1,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:healthcareapp_try1/core/Theme/app_colors.dart';

class CustomFilterButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final String activeText;
  final String inactiveText;
  final Color activeLightColor;
  final Color activeDarkColor;

  const CustomFilterButton({
    super.key,
    required this.isSelected,
    required this.onTap,
    this.activeText = "Clear Filter",
    this.inactiveText = "Filter Doctors",
    required this.activeLightColor,
    required this.activeDarkColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? (isSelected ? activeDarkColor : AppColors.bgDark)
        : (isSelected ? activeLightColor.withOpacity(0.12) : AppColors.bgLight);

    final borderColor = isDark
        ? (isSelected ? activeDarkColor : AppColors.textDark.withOpacity(0.25))
        : (isSelected ? activeLightColor : AppColors.textLight);

    final contentColor = isDark
        ? (isSelected ? AppColors.textLight : AppColors.textDark)
        : (isSelected ? activeLightColor : AppColors.textLight);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        duration: const Duration(milliseconds: 200),
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? Icons.filter_alt_off : Icons.filter_alt_outlined,
              color: contentColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              isSelected ? activeText : inactiveText,
              style: TextStyle(
                color: contentColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
