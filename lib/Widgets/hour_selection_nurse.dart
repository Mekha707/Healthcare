import 'package:flutter/material.dart';
import 'package:healthcareapp_try1/core/Theme/app_colors.dart';

class HourSelectionWidget extends StatefulWidget {
  final Function(int) onHourSelected;

  const HourSelectionWidget({super.key, required this.onHourSelected});

  @override
  State<HourSelectionWidget> createState() => _HourSelectionWidgetState();
}

class _HourSelectionWidgetState extends State<HourSelectionWidget> {
  int? selectedHour;
  final List<int> hours = List.generate(12, (index) => index + 1);

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _accent => _isDark ? Colors.blue.shade300 : const Color(0xff0861dd);
  Color get _unselectedBg =>
      _isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade100;
  Color get _unselectedBorder =>
      _isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade300;
  Color get _primaryText => _isDark ? AppColors.textDark : Colors.black87;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: hours.map((hour) {
        final isSelected = selectedHour == hour;

        return GestureDetector(
          onTap: () {
            setState(() => selectedHour = hour);
            widget.onHourSelected(hour);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? _accent.withOpacity(_isDark ? 0.18 : 0.08)
                  : _unselectedBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? _accent : _unselectedBorder,
                width: isSelected ? 1.5 : 0.5,
              ),
            ),
            child: Text(
              "$hour ${hour == 1 ? 'Hour' : 'Hours'}",
              style: TextStyle(
                color: isSelected ? _accent : _primaryText,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'Agency',
                fontSize: 13,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
