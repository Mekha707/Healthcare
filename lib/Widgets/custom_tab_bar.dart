// ignore_for_file: deprecated_member_use, use_super_parameters, library_private_types_in_public_api, unnecessary_import
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcareapp_try1/core/Theme/app_colors.dart';

class CustomRadioGroup extends StatefulWidget {
  final List<String> tabs;
  final double width;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? textColor;
  final Function(int) onSelectionChange;

  const CustomRadioGroup({
    Key? key,
    required this.tabs,
    required this.onSelectionChange,
    this.width = 300.0,
    this.backgroundColor,
    this.selectedColor,
    this.textColor,
  }) : super(key: key);

  @override
  _CustomRadioGroupState createState() => _CustomRadioGroupState();
}

class _CustomRadioGroupState extends State<CustomRadioGroup> {
  int _selectedValue = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor =
        widget.backgroundColor ??
        (isDark ? AppColors.surfaceDark : const Color(0xFFEEEEEE));

    final selectedColor =
        widget.selectedColor ?? (isDark ? AppColors.bgDark : Colors.white);

    final textColor =
        widget.textColor ??
        (isDark ? AppColors.textDark : Colors.grey.shade700);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade300,
        ),
      ),
      child: CupertinoSlidingSegmentedControl<int>(
        backgroundColor: backgroundColor,
        thumbColor: selectedColor,
        groupValue: _selectedValue,
        children: {
          for (int i = 0; i < widget.tabs.length; i++)
            i: _buildTab(
              widget.tabs[i],
              i == _selectedValue,
              textColor,
              isDark,
            ),
        },
        onValueChanged: (value) {
          if (value != null) {
            setState(() => _selectedValue = value);
            widget.onSelectionChange(value);
          }
        },
      ),
    );
  }

  Widget _buildTab(String text, bool isSelected, Color textColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          color: textColor,
          fontFamily: 'Agency',
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }
}
