// // import 'package:flutter/material.dart';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// // class Specialty {
// //   final String id;
// //   final String name;
// //   final IconData icon;
// //   final Color color;

// //   Specialty({
// //     required this.id,
// //     required this.name,
// //     required this.icon,
// //     required this.color,
// //   });

// //   // Factory لبناء الكائن من الـ API Response
// //   factory Specialty.fromJson(Map<String, dynamic> json) {
// //     final String name = (json['name'] ?? '').toString().trim().toLowerCase();

// //     // ربط الاسم بالأيقونة واللون يدوياً
// //     return Specialty(
// //       id: json['id'] ?? '',
// //       name: name,
// //       icon: _getIconForSpecialty(name),
// //       color: _getColorForSpecialty(name),
// //     );
// //   }

// //    @override
// //   String toString() => name;

// //   static IconData _getIconForSpecialty(String name) {
// //     switch (name.toLowerCase()) {
// //       case 'cardiology':
// //         return Icons.favorite;

// //       case 'cardiac surgery':
// //         return FontAwesomeIcons.heartPulse;

// //       case 'neurology':
// //         return FontAwesomeIcons.brain;

// //       case 'neurosurgery':
// //         return FontAwesomeIcons.userDoctor;

// //       case 'pediatrics':
// //         return Icons.child_care;

// //       case 'orthopedics':
// //         return FontAwesomeIcons.bone;

// //       case 'ophthalmology':
// //         return Icons.remove_red_eye_outlined;

// //       case 'dermatology':
// //         return Icons.spa;

// //       case 'endocrinology':
// //         return FontAwesomeIcons.dna;

// //       case 'general surgery':
// //         return FontAwesomeIcons.userDoctor;

// //       case 'nephrology':
// //         return FontAwesomeIcons.droplet;

// //       case 'physical therapy':
// //         return Icons.fitness_center;

// //       case 'psychiatry':
// //         return FontAwesomeIcons.headSideVirus;

// //       case 'gastroenterology':
// //         return FontAwesomeIcons.bowlFood;

// //       case 'pulmonology':
// //         return FontAwesomeIcons.lungs;

// //       case 'plastic surgery':
// //         return FontAwesomeIcons.user;

// //       case 'dentistry':
// //         return FontAwesomeIcons.tooth;

// //       case 'ent':
// //         return FontAwesomeIcons.headSideCough;

// //       case 'oncology':
// //         return FontAwesomeIcons.ribbon;

// //       case 'nutrition':
// //         return Icons.restaurant;

// //       case 'urology':
// //         return FontAwesomeIcons.droplet;

// //       case 'internal medicine':
// //         return FontAwesomeIcons.stethoscope;

// //       case 'obstetrics and gynecology':
// //         return Icons.pregnant_woman;

// //       default:
// //         return FontAwesomeIcons.stethoscope;
// //     }
// //   }

// //   static Color _getColorForSpecialty(String name) {
// //     switch (name.toLowerCase()) {
// //       case 'cardiology':
// //         return const Color(0xffe7000b);

// //       case 'cardiac surgery':
// //         return const Color(0xffb30000);

// //       case 'neurology':
// //         return const Color(0xff9a16fa);

// //       case 'neurosurgery':
// //         return const Color(0xff6a0dad);

// //       case 'pediatrics':
// //         return const Color(0xff0861dd);

// //       case 'orthopedics':
// //         return const Color(0xffe58017);

// //       case 'ophthalmology':
// //         return const Color(0xff00acc1);

// //       case 'dermatology':
// //         return const Color(0xffff69b4);

// //       case 'endocrinology':
// //         return const Color(0xff4caf50);

// //       case 'general surgery':
// //         return const Color(0xff607d8b);

// //       case 'nephrology':
// //         return const Color(0xff3f51b5);

// //       case 'physical therapy':
// //         return const Color(0xff009688);

// //       case 'psychiatry':
// //         return const Color(0xff8e24aa);

// //       case 'gastroenterology':
// //         return const Color(0xffff7043);

// //       case 'pulmonology':
// //         return const Color(0xff90a4ae);

// //       case 'plastic surgery':
// //         return const Color(0xfff06292);

// //       case 'dentistry':
// //         return const Color(0xff00bcd4);

// //       case 'ent':
// //         return const Color(0xff795548);

// //       case 'oncology':
// //         return const Color(0xffd81b60);

// //       case 'nutrition':
// //         return const Color(0xff7cb342);

// //       case 'urology':
// //         return const Color(0xff3949ab);

// //       case 'internal medicine':
// //         return const Color(0xff455a64);

// //       case 'obstetrics and gynecology':
// //         return const Color(0xffec407a);

// //       default:
// //         return const Color(0xff5642f7);
// //     }
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class Specialty {
//   final String id;
//   final String name;
//   final IconData icon;
//   final Color color;

//   Specialty({
//     required this.id,
//     required this.name,
//     required this.icon,
//     required this.color,
//   });

//   factory Specialty.fromJson(Map<String, dynamic> json) {
//     final String name = (json['name'] ?? '').toString().trim().toLowerCase();

//     return Specialty(
//       id: json['id'] ?? '',
//       name: name,
//       icon: _getIconForSpecialty(name),
//       color: _getColorForSpecialty(name),
//     );
//   }

//   static IconData _getIconForSpecialty(String name) {
//     switch (name.toLowerCase()) {
//       case 'cardiology':
//         return Icons.favorite;
//       case 'cardiac surgery':
//         return FontAwesomeIcons.heartPulse;
//       case 'neurology':
//         return FontAwesomeIcons.brain;
//       case 'neurosurgery':
//         return FontAwesomeIcons.userDoctor;
//       case 'pediatrics':
//         return Icons.child_care;
//       case 'orthopedics':
//         return FontAwesomeIcons.bone;
//       case 'ophthalmology':
//         return Icons.remove_red_eye_outlined;
//       case 'dermatology':
//         return Icons.spa;
//       case 'endocrinology':
//         return FontAwesomeIcons.dna;
//       case 'general surgery':
//         return FontAwesomeIcons.userDoctor;
//       case 'nephrology':
//         return FontAwesomeIcons.droplet;
//       case 'physical therapy':
//         return Icons.fitness_center;
//       case 'psychiatry':
//         return FontAwesomeIcons.headSideVirus;
//       case 'gastroenterology':
//         return FontAwesomeIcons.bowlFood;
//       case 'pulmonology':
//         return FontAwesomeIcons.lungs;
//       case 'plastic surgery':
//         return FontAwesomeIcons.user;
//       case 'dentistry':
//         return FontAwesomeIcons.tooth;
//       case 'ent':
//         return FontAwesomeIcons.headSideCough;
//       case 'oncology':
//         return FontAwesomeIcons.ribbon;
//       case 'nutrition':
//         return Icons.restaurant;
//       case 'urology':
//         return FontAwesomeIcons.droplet;
//       case 'internal medicine':
//         return FontAwesomeIcons.stethoscope;
//       case 'obstetrics and gynecology':
//         return Icons.pregnant_woman;
//       default:
//         return FontAwesomeIcons.stethoscope;
//     }
//   }

//   static Color _getColorForSpecialty(String name) {
//     switch (name.toLowerCase()) {
//       case 'cardiology':
//         return const Color(0xffe7000b);
//       case 'cardiac surgery':
//         return const Color(0xffb30000);
//       case 'neurology':
//         return const Color(0xff9a16fa);
//       case 'neurosurgery':
//         return const Color(0xff6a0dad);
//       case 'pediatrics':
//         return const Color(0xff0861dd);
//       case 'orthopedics':
//         return const Color(0xffe58017);
//       case 'ophthalmology':
//         return const Color(0xff00acc1);
//       case 'dermatology':
//         return const Color(0xffff69b4);
//       case 'endocrinology':
//         return const Color(0xff4caf50);
//       case 'general surgery':
//         return const Color(0xff607d8b);
//       case 'nephrology':
//         return const Color(0xff3f51b5);
//       case 'physical therapy':
//         return const Color(0xff009688);
//       case 'psychiatry':
//         return const Color(0xff8e24aa);
//       case 'gastroenterology':
//         return const Color(0xffff7043);
//       case 'pulmonology':
//         return const Color(0xff90a4ae);
//       case 'plastic surgery':
//         return const Color(0xfff06292);
//       case 'dentistry':
//         return const Color(0xff00bcd4);
//       case 'ent':
//         return const Color(0xff795548);
//       case 'oncology':
//         return const Color(0xffd81b60);
//       case 'nutrition':
//         return const Color(0xff7cb342);
//       case 'urology':
//         return const Color(0xff3949ab);
//       case 'internal medicine':
//         return const Color(0xff455a64);
//       case 'obstetrics and gynecology':
//         return const Color(0xffec407a);
//       default:
//         return const Color(0xff5642f7);
//     }
//   }

//   @override
//   String toString() => name;
// }

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

  factory Specialty.fromJson(Map<String, dynamic> json) {
    // تنظيف النص وإزالة المسافات الزائدة
    final String name = (json['name'] ?? '').toString().trim();

    return Specialty(
      id: json['id'] ?? '',
      name: name,
      icon: _getIconForSpecialty(name),
      color: _getColorForSpecialty(name),
    );
  }

  static IconData _getIconForSpecialty(String name) {
    switch (name.trim()) {
      case 'أمراض القلب':
      case 'أمراض القلب والأوعية الدموية':
        return Icons.favorite;
      case 'جراحة القلب':
        return FontAwesomeIcons.heartPulse;
      case 'المخ والأعصاب':
      case 'أمراض مخ وأعصاب':
      case 'أمراض المخ والأعصاب':
        return FontAwesomeIcons.brain;
      case 'جراحة المخ والأعصاب':
        return FontAwesomeIcons.userDoctor;
      case 'طب الأطفال':
      case 'أطفال':
        return Icons.child_care;
      case 'العظام':
      case 'جراحة العظام':
        return FontAwesomeIcons.bone;
      case 'الرمد':
      case 'طب العيون':
        return Icons.remove_red_eye_outlined;
      case 'الجلدية':
      case 'الأمراض الجلدية':
        return Icons.spa;
      case 'الغدد الصماء':
      case 'غدد صماء وسكر':
        return FontAwesomeIcons.dna;
      case 'الجراحة العامة':
      case 'جراحة عامة':
        return FontAwesomeIcons.userDoctor;
      case 'أمراض الكلى':
      case 'كلى':
        return FontAwesomeIcons.droplet;
      case 'العلاج الطبيعي':
      case 'علاج طبيعي':
        return Icons.fitness_center;
      case 'الطب النفسي':
      case 'طبي نفسي':
        return FontAwesomeIcons.headSideVirus;
      case 'الجهاز الهضمي':
      case 'جهاز هضمي ومناظير':
        return FontAwesomeIcons.bowlFood;
      case 'الصدر والجهاز التنفسي':
      case 'أمراض صدرية':
        return FontAwesomeIcons.lungs;
      case 'جراحة التجميل':
      case 'تجميل':
        return FontAwesomeIcons.user;
      case 'طب الأسنان':
      case 'أسنان':
        return FontAwesomeIcons.tooth;
      case 'أنف وأذن وحنجرة':
        return FontAwesomeIcons.headSideCough;
      case 'الأورام':
      case 'أمراض أورام':
        return FontAwesomeIcons.ribbon;
      case 'التغذية العلاجية':
      case 'تغذية':
        return Icons.restaurant;
      case 'المسالك البولية':
      case 'مسالك بولية':
        return FontAwesomeIcons.droplet;
      case 'الباطنة':
      case 'أمراض باطنة':
        return FontAwesomeIcons.stethoscope;
      case 'النساء والتوليد':
      case 'أمراض النساء والتوليد':
        return Icons.pregnant_woman;
      default:
        return FontAwesomeIcons.stethoscope;
    }
  }

  static Color _getColorForSpecialty(String name) {
    switch (name.trim()) {
      case 'أمراض القلب و الأوعية الدموية':
      case 'قلب وأوعية دموية':
        return const Color(0xffe7000b);
      case 'جراحة القلب':
        return const Color(0xffb30000);
      case 'المخ والأعصاب':
      case 'أمراض مخ وأعصاب':
      case 'أمراض المخ والأعصاب':
        return const Color(0xff9a16fa);
      case 'جراحة المخ والأعصاب':
        return const Color(0xff6a0dad);
      case 'طب الأطفال':
      case 'أطفال':
        return const Color(0xff0861dd);
      case 'العظام':
      case 'جراحة العظام':
        return const Color(0xffe58017);
      case 'الرمد':
      case 'طب العيون':
        return const Color(0xff00acc1);
      case 'الجلدية':
      case 'الأمراض الجلدية':
        return const Color(0xffff69b4);
      case 'الغدد الصماء':
      case 'غدد صماء وسكر':
        return const Color(0xff4caf50);
      case 'الجراحة العامة':
      case 'جراحة عامة':
        return const Color(0xff607d8b);
      case 'أمراض الكلى':
      case 'كلى':
        return const Color(0xff3f51b5);
      case 'العلاج الطبيعي':
      case 'علاج طبيعي':
        return const Color(0xff009688);
      case 'الطب النفسي':
      case 'طبي نفسي':
        return const Color(0xff8e24aa);
      case 'الجهاز الهضمي':
      case 'جهاز هضمي ومناظير':
        return const Color(0xffff7043);
      case 'الصدر والجهاز التنفسي':
      case 'أمراض صدرية':
        return const Color(0xff90a4ae);
      case 'جراحة التجميل':
      case 'تجميل':
        return const Color(0xfff06292);
      case 'طب الأسنان':
      case 'أسنان':
        return const Color(0xff00bcd4);
      case 'أنف وأذن وحنجرة':
        return const Color(0xff795548);
      case 'الأورام':
      case 'أمراض أورام':
        return const Color(0xffd81b60);
      case 'التغذية العلاجية':
      case 'تغذية':
        return const Color(0xff7cb342);
      case 'المسالك البولية':
      case 'مسالك بولية':
        return const Color(0xff3949ab);
      case 'الباطنة':
      case 'أمراض باطنة':
        return const Color(0xff455a64);
      case 'النساء والتوليد':
      case 'أمراض النساء والتوليد':
        return const Color(0xffec407a);
      default:
        return const Color(0xff5642f7);
    }
  }

  @override
  String toString() => name;
}
