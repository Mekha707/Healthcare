import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Specialty {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  Specialty({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  // Factory لبناء الكائن من الـ API Response
  factory Specialty.fromJson(Map<String, dynamic> json) {
    final String name = (json['name'] ?? '').toString().trim().toLowerCase();

    // ربط الاسم بالأيقونة واللون يدوياً
    return Specialty(
      id: json['id'] ?? '',
      name: name,
      icon: _getIconForSpecialty(name),
      color: _getColorForSpecialty(name),
    );
  }
  static IconData _getIconForSpecialty(String name) {
    switch (name.toLowerCase()) {
      case 'cardiology':
        return Icons.favorite;

      case 'cardiac surgery':
        return FontAwesomeIcons.heartPulse;

      case 'neurology':
        return FontAwesomeIcons.brain;

      case 'neurosurgery':
        return FontAwesomeIcons.userDoctor;

      case 'pediatrics':
        return Icons.child_care;

      case 'orthopedics':
        return FontAwesomeIcons.bone;

      case 'ophthalmology':
        return Icons.remove_red_eye_outlined;

      case 'dermatology':
        return Icons.spa;

      case 'endocrinology':
        return FontAwesomeIcons.dna;

      case 'general surgery':
        return FontAwesomeIcons.userDoctor;

      case 'nephrology':
        return FontAwesomeIcons.droplet;

      case 'physical therapy':
        return Icons.fitness_center;

      case 'psychiatry':
        return FontAwesomeIcons.headSideVirus;

      case 'gastroenterology':
        return FontAwesomeIcons.bowlFood;

      case 'pulmonology':
        return FontAwesomeIcons.lungs;

      case 'plastic surgery':
        return FontAwesomeIcons.user;

      case 'dentistry':
        return FontAwesomeIcons.tooth;

      case 'ent':
        return FontAwesomeIcons.headSideCough;

      case 'oncology':
        return FontAwesomeIcons.ribbon;

      case 'nutrition':
        return Icons.restaurant;

      case 'urology':
        return FontAwesomeIcons.droplet;

      case 'internal medicine':
        return FontAwesomeIcons.stethoscope;

      case 'obstetrics and gynecology':
        return Icons.pregnant_woman;

      default:
        return FontAwesomeIcons.stethoscope;
    }
  }

  static Color _getColorForSpecialty(String name) {
    switch (name.toLowerCase()) {
      case 'cardiology':
        return const Color(0xffe7000b);

      case 'cardiac surgery':
        return const Color(0xffb30000);

      case 'neurology':
        return const Color(0xff9a16fa);

      case 'neurosurgery':
        return const Color(0xff6a0dad);

      case 'pediatrics':
        return const Color(0xff0861dd);

      case 'orthopedics':
        return const Color(0xffe58017);

      case 'ophthalmology':
        return const Color(0xff00acc1);

      case 'dermatology':
        return const Color(0xffff69b4);

      case 'endocrinology':
        return const Color(0xff4caf50);

      case 'general surgery':
        return const Color(0xff607d8b);

      case 'nephrology':
        return const Color(0xff3f51b5);

      case 'physical therapy':
        return const Color(0xff009688);

      case 'psychiatry':
        return const Color(0xff8e24aa);

      case 'gastroenterology':
        return const Color(0xffff7043);

      case 'pulmonology':
        return const Color(0xff90a4ae);

      case 'plastic surgery':
        return const Color(0xfff06292);

      case 'dentistry':
        return const Color(0xff00bcd4);

      case 'ent':
        return const Color(0xff795548);

      case 'oncology':
        return const Color(0xffd81b60);

      case 'nutrition':
        return const Color(0xff7cb342);

      case 'urology':
        return const Color(0xff3949ab);

      case 'internal medicine':
        return const Color(0xff455a64);

      case 'obstetrics and gynecology':
        return const Color(0xffec407a);

      default:
        return const Color(0xff5642f7);
    }
  }
}
