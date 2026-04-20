// ignore_for_file: library_private_types_in_public_api, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/Tests_Bloc/test_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/Tests_Bloc/test_states.dart';
import 'package:healthcareapp_try1/Models/Booking_Models/test_model.dart';
import 'package:healthcareapp_try1/core/Theme/app_colors.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? Colors.white60 : Colors.grey.shade800;
    final bgColor = isDark ? AppColors.bgDark : Colors.grey.shade100;
    final borderColor = isDark ? Colors.white12 : Colors.grey.shade300;

    return BlocBuilder<TestBloc, TestStates>(
      buildWhen: (previous, current) {
        if (current is TestLoading && previous is TestLoaded) {
          return false; // لا تظهر الـ LinearProgressIndicator مرة أخرى
        }
        return true;
      },
      builder: (context, state) {
        if (state is TestLoading) {
          return const Center(
            child: LinearProgressIndicator(color: Colors.grey),
          );
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
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: ExpansionTile(
                  shape:
                      const Border(), // يزيل الخطوط الافتراضية للـ ExpansionTile
                  initiallyExpanded: widget.initialTestIds.isNotEmpty,
                  title: Text(
                    selectedTests.isEmpty
                        ? "Select Medical Tests"
                        : "${selectedTests.length} Tests Selected",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Agency',
                      color: textColor,
                    ),
                  ),
                  children: state.tests.map((test) {
                    bool isSelected = selectedTests.any((t) => t.id == test.id);

                    return CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        test.name,
                        style: TextStyle(fontSize: 14, color: textColor),
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
                        .map((test) => _buildTestChip(test, isDark: isDark))
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
  Widget _buildTestChip(Test test, {required bool isDark}) {
    return Chip(
      label: Text(
        test.name,
        style: const TextStyle(fontSize: 11, color: Colors.white),
      ),
      backgroundColor: isDark ? Colors.teal.shade800 : Colors.teal,
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
