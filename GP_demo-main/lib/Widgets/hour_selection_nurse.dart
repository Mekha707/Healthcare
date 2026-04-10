// import 'package:flutter/material.dart';

// class HourSelectionWidget extends StatefulWidget {
//   final Function(int) onHourSelected;

//   const HourSelectionWidget({super.key, required this.onHourSelected});

//   @override
//   State<HourSelectionWidget> createState() => _HourSelectionWidgetState();
// }

// class _HourSelectionWidgetState extends State<HourSelectionWidget> {
//   int? selectedHour;

//   final List<int> hours = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 16];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 4,
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 10,
//             childAspectRatio: 1.2,
//           ),
//           itemCount: hours.length,
//           itemBuilder: (context, index) {
//             final hour = hours[index];
//             final isSelected = selectedHour == hour;

//             return GestureDetector(
//               onTap: () {
//                 setState(() => selectedHour = hour);
//                 widget.onHourSelected(hour);
//               },
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 150),
//                 decoration: BoxDecoration(
//                   color: isSelected
//                       ? const Color(0xFFE6F1FB)
//                       : Colors.transparent,
//                   border: Border.all(
//                     color: isSelected
//                         ? const Color(0xFF378ADD)
//                         : Colors.blueGrey.shade200,
//                     width: isSelected ? 2 : 0.5,
//                   ),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(
//                       Icons.schedule,
//                       size: 16,
//                       color: Colors.blueGrey,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '$hour',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                         fontFamily: 'Agency',
//                         color: isSelected
//                             ? const Color(0xFF0C447C)
//                             : Colors.blueGrey.shade700,
//                       ),
//                     ),
//                     Text(
//                       hour == 1 ? 'ساعة' : 'ساعات',
//                       style: const TextStyle(
//                         fontSize: 10,
//                         color: Colors.blueGrey,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),

//         // ملخص الاختيار
//         if (selectedHour != null)
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             margin: const EdgeInsets.only(top: 12),
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             decoration: BoxDecoration(
//               color: Colors.blueGrey.shade50,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               children: [
//                 const Icon(
//                   Icons.check_circle_outline,
//                   color: Color(0xFF378ADD),
//                   size: 20,
//                 ),
//                 const SizedBox(width: 10),
//                 Text(
//                   'الساعات المختارة: $selectedHour ${selectedHour == 1 ? 'ساعة' : 'ساعات'}',
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.blueGrey,
//                     fontFamily: 'Agency',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';

// class HourSelectionWidget extends StatefulWidget {
//   final Function(int) onHourSelected;

//   const HourSelectionWidget({super.key, required this.onHourSelected});

//   @override
//   State<HourSelectionWidget> createState() => _HourSelectionWidgetState();
// }

// class _HourSelectionWidgetState extends State<HourSelectionWidget> {
//   // متغير داخلي لتتبع الساعة المختارة حالياً لتغيير التنسيق
//   int? selectedHour;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 60, // تحديد طول العرض الأفقي
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: 24, // عدد ساعات اليوم
//         itemBuilder: (context, index) {
//           final isSelected = selectedHour == index;

//           return GestureDetector(
//             onTap: () {
//               setState(() {
//                 selectedHour = index;
//               });
//               // استدعاء الـ Callback الممرر من الـ Widget الأب
//               widget.onHourSelected(index);
//             },
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               margin: const EdgeInsets.symmetric(horizontal: 8),
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               decoration: BoxDecoration(
//                 color: isSelected ? Colors.blue : Colors.grey[200],
//                 borderRadius: BorderRadius.circular(15),
//                 border: Border.all(
//                   color: isSelected ? Colors.blueAccent : Colors.transparent,
//                 ),
//               ),
//               child: Center(
//                 child: Text(
//                   "$index:00",
//                   style: TextStyle(
//                     color: isSelected ? Colors.white : Colors.black,
//                     fontWeight: isSelected
//                         ? FontWeight.bold
//                         : FontWeight.normal,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class HourSelectionWidget extends StatefulWidget {
  final Function(int) onHourSelected;

  const HourSelectionWidget({super.key, required this.onHourSelected});

  @override
  State<HourSelectionWidget> createState() => _HourSelectionWidgetState();
}

class _HourSelectionWidgetState extends State<HourSelectionWidget> {
  int? selectedHour;

  final List<int> hours = List.generate(12, (index) => index + 1); // 1 → 12

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: hours.map((hour) {
        final isSelected = selectedHour == hour;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedHour = hour;
            });

            widget.onHourSelected(hour);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? Color(0xff0861dd) : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Color(0xff0861dd) : Colors.grey,
              ),
            ),
            child: Text(
              "$hour ${hour == 1 ? 'Hour' : 'Hours'}",
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Agency',
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
