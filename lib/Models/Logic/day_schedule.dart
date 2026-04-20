import 'package:healthcareapp_try1/Models/Logic/time_slot.dart';

class DaySchedule {
  final String date;
  final String day;
  final List<TimeSlot> slots;

  DaySchedule({required this.date, required this.day, required this.slots});

  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    final rawSlots = (json['slots'] ?? json['shifts']) as List?;

    return DaySchedule(
      date: json['date'] ?? '',
      day: _getDayName(json['date'] ?? ''), // ✅ محسوب من الـ date مش من الـ API
      slots: rawSlots?.map((e) => TimeSlot.fromJson(e)).toList() ?? [],
    );
  }

  static String _getDayName(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      const days = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];
      return days[date.weekday - 1];
    } catch (e) {
      return '';
    }
  }
}
