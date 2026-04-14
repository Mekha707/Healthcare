// // ignore_for_file: library_private_types_in_public_api, deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:healthcareapp_try1/Bloc/User_Bloc/Tests_Bloc/test_bloc.dart';
// import 'package:healthcareapp_try1/Bloc/User_Bloc/Tests_Bloc/test_states.dart';
// import 'package:healthcareapp_try1/Models/Booking_Models/test_model.dart';

// class TestDropdownScreen extends StatefulWidget {
//   final Function(List<Test> selectedTests) onTestsChanged; // لاحظ هنا بقت List
//   final List<String> initialTestIds;

//   const TestDropdownScreen({
//     super.key,
//     required this.onTestsChanged,
//     this.initialTestIds = const [],
//   });

//   @override
//   _TestDropdownScreenState createState() => _TestDropdownScreenState();
// }

// class _TestDropdownScreenState extends State<TestDropdownScreen> {
//   // قائمة لتخزين التحاليل المختارة
//   List<Test> selectedTests = [];
//   bool _initializedFromIds = false;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<TestBloc, TestStates>(
//       builder: (context, state) {
//         if (state is TestLoading) {
//           return const Center(child: LinearProgressIndicator());
//         } else if (state is TestLoaded) {
//           if (!_initializedFromIds && widget.initialTestIds.isNotEmpty) {
//             _initializedFromIds = true;
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               setState(() {
//                 selectedTests = state.tests
//                     .where((t) => widget.initialTestIds.contains(t.id))
//                     .toList();
//               });
//             });
//           }

//           return Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: ExpansionTile(
//                   initiallyExpanded: widget.initialTestIds.isNotEmpty,
//                   title: Text(
//                     selectedTests.isEmpty
//                         ? "Select Medical Tests"
//                         : "${selectedTests.length} Tests Selected",
//                     style: const TextStyle(fontSize: 14, fontFamily: 'Agency'),
//                   ),
//                   children: state.tests.map((test) {
//                     // فحص هل التحليل ده مختار ولا لا
//                     bool isSelected = selectedTests.any((t) => t.id == test.id);

//                     return CheckboxListTile(
//                       title: Text(
//                         test.name,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontFamily: 'Agency',
//                         ),
//                       ),
//                       value: isSelected,
//                       activeColor: Colors.teal, // لون المربع لما يتحدد
//                       checkColor: Colors.white, // لون علامة الصح نفسها
//                       side: BorderSide(color: Colors.grey.shade400),

//                       onChanged: (bool? checked) {
//                         setState(() {
//                           if (checked == true) {
//                             selectedTests.add(test);
//                           } else {
//                             selectedTests.removeWhere((t) => t.id == test.id);
//                           }
//                         });
//                         // نبعت القائمة كاملة للأب
//                         widget.onTestsChanged(selectedTests);
//                       },
//                     );
//                   }).toList(),
//                 ),
//               ),

//               // عرض التحاليل المختارة على شكل Chips (اختياري بس شكلها شيك)
//               if (selectedTests.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: Wrap(
//                     spacing: 8,
//                     children: selectedTests
//                         .map(
//                           (test) => Chip(
//                             label: Text(
//                               test.name,
//                               style: const TextStyle(
//                                 fontSize: 10,
//                                 fontFamily: 'Agency',
//                                 color: Colors.black,
//                               ),
//                             ),
//                             backgroundColor: Colors.teal.withOpacity(0.5),

//                             deleteIcon: const Icon(
//                               Icons.cancel,
//                               size: 16,
//                               color: Colors.black,
//                             ),
//                             onDeleted: () {
//                               setState(() {
//                                 selectedTests.removeWhere(
//                                   (t) => t.id == test.id,
//                                 );
//                               });
//                               widget.onTestsChanged(selectedTests);
//                             },
//                             // 4. (اختياري) حواف الـ Chip
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               side: BorderSide(color: Colors.black, width: 1),
//                             ),

//                             // 5. (اختياري) إضافة أيقونة في الأول
//                             avatar: const Icon(
//                               Icons.science_outlined,
//                               size: 12,
//                               color: Colors.black,
//                             ),

//                             // 6. (اختياري) تحسين المسافات الداخلية
//                             padding: const EdgeInsets.all(4),
//                           ),
//                         )
//                         .toList(),
//                   ),
//                 ),
//             ],
//           );
//         }
//         return const SizedBox.shrink();
//       },
//     );
//   }
// }

// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/Tests_Bloc/test_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/Tests_Bloc/test_states.dart';
import 'package:healthcareapp_try1/Models/Booking_Models/test_model.dart';

class TestDropdownScreen extends StatefulWidget {
  final Function(List<Test> selectedTests) onTestsChanged;
  final List<String> initialTestIds;

  const TestDropdownScreen({
    super.key,
    required this.onTestsChanged,
    this.initialTestIds = const [],
  });

  @override
  _TestDropdownScreenState createState() => _TestDropdownScreenState();
}

class _TestDropdownScreenState extends State<TestDropdownScreen> {
  List<Test> selectedTests = [];
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestBloc, TestStates>(
      buildWhen: (previous, current) {
        if (current is TestLoading && previous is TestLoaded) {
          return false; // لا تظهر الـ LinearProgressIndicator مرة أخرى
        }
        return true;
      },
      builder: (context, state) {
        if (state is TestLoading) {
          return const Center(child: LinearProgressIndicator());
        }

        if (state is TestLoaded) {
          if (selectedTests.isEmpty &&
              widget.initialTestIds.isNotEmpty &&
              !_initialized) {
            selectedTests = state.tests
                .where((t) => widget.initialTestIds.contains(t.id))
                .toList();
            _initialized = true;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ExpansionTile(
                  shape:
                      const Border(), // يزيل الخطوط الافتراضية للـ ExpansionTile
                  initiallyExpanded: widget.initialTestIds.isNotEmpty,
                  title: Text(
                    selectedTests.isEmpty
                        ? "Select Medical Tests"
                        : "${selectedTests.length} Tests Selected",
                    style: const TextStyle(fontSize: 14, fontFamily: 'Agency'),
                  ),
                  children: state.tests.map((test) {
                    bool isSelected = selectedTests.any((t) => t.id == test.id);

                    return CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        test.name,
                        style: const TextStyle(fontSize: 14),
                      ),
                      value: isSelected,
                      activeColor: Colors.teal,
                      // داخل _TestDropdownScreenState
                      onChanged: (bool? checked) {
                        setState(() {
                          if (checked == true) {
                            // تأكد من إضافة العنصر فقط إذا لم يكن موجوداً
                            if (!selectedTests.any((t) => t.id == test.id)) {
                              selectedTests.add(test);
                            }
                          } else {
                            selectedTests.removeWhere((t) => t.id == test.id);
                          }
                        });

                        // نرسل نسخة من القائمة لضمان عدم حدوث مشاكل في الـ Reference
                        widget.onTestsChanged(List.from(selectedTests));
                      },
                    );
                  }).toList(),
                ),
              ),

              // عرض الـ Chips
              if (selectedTests.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: selectedTests
                        .map((test) => _buildTestChip(test))
                        .toList(),
                  ),
                ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  // ميثود منفصلة للـ Chip لجعل الكود أنظف
  Widget _buildTestChip(Test test) {
    return Chip(
      label: Text(
        test.name,
        style: const TextStyle(fontSize: 11, color: Colors.white),
      ),
      backgroundColor: Colors.teal,
      deleteIcon: const Icon(Icons.cancel, size: 16, color: Colors.white70),
      onDeleted: () {
        setState(() {
          selectedTests.removeWhere((t) => t.id == test.id);
        });
        widget.onTestsChanged(selectedTests);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      avatar: const Icon(Icons.science_outlined, size: 14, color: Colors.white),
    );
  }
}
