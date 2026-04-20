// // ignore_for_file: deprecated_member_use, dead_code, unnecessary_null_comparison, unused_field, no_leading_underscores_for_local_identifiers

// import 'dart:async';

// import 'package:animated_custom_dropdown/custom_dropdown.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:healthcareapp_try1/Bloc/Auth_Bloc/CityCubit/city_cubit.dart';
// import 'package:healthcareapp_try1/Bloc/User_Bloc/LabBloc/lab_bloc.dart';
// import 'package:healthcareapp_try1/Bloc/User_Bloc/LabBloc/lab_event.dart';
// import 'package:healthcareapp_try1/Bloc/User_Bloc/NurseBloc/nurse_bloc.dart';
// import 'package:healthcareapp_try1/Bloc/User_Bloc/NurseBloc/nurse_event.dart';
// import 'package:healthcareapp_try1/Bloc/User_Bloc/SpecialtyBloc/specialty_bloc.dart';
// import 'package:healthcareapp_try1/Bloc/User_Bloc/SpecialtyBloc/specialty_state.dart';
// import 'package:healthcareapp_try1/Bloc/User_Bloc/Tests_Bloc/test_bloc.dart';
// import 'package:healthcareapp_try1/Bloc/User_Bloc/Tests_Bloc/test_events.dart';
// import 'package:healthcareapp_try1/Models/Auth_Models/location_model.dart';
// import 'package:healthcareapp_try1/Models/Users_Models/enums.dart';
// import 'package:healthcareapp_try1/Models/Users_Models/specialty_model.dart';
// import 'package:healthcareapp_try1/Widgets/service_type_widget.dart';
// import 'package:healthcareapp_try1/Widgets/tests_dropdown.dart';
// import 'package:healthcareapp_try1/core/theme/app_colors.dart';

// // Nurse && Lab
// class SearchForNurseAndLab extends StatefulWidget {
//   const SearchForNurseAndLab({
//     super.key,
//     required this.medicalStaff,
//     required this.onFilterChanged,
//     this.initialTestIds = const [],
//   });
//   final MedicalStaff medicalStaff;
//   final List<String> initialTestIds; // ✅ جديد

//   final Function(String name, Specialty? specialty, String? _selectedCity)
//   onFilterChanged; // الدالة المرسلة

//   @override
//   State<SearchForNurseAndLab> createState() => _SearchForNurseAndLab();
// }

// class _SearchForNurseAndLab extends State<SearchForNurseAndLab> {
//   // أضف هذا السطر مع تعريف المتغيرات في البداية
//   final _cityController = SingleSelectController<String?>(null);
//   String? _selectedCity;
//   Timer? _debounce;
//   List<String> selectedTestIds = [];
//   String _searchName = "";
//   Specialty? _selectedSpecialty;

//   @override
//   void initState() {
//     super.initState();
//     selectedTestIds = List.from(widget.initialTestIds);

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<CitiesCubit>().getCities();
//       context.read<TestBloc>().add(FetchLabTests());
//     });
//   }

//   void _onSearchChanged(String query) {
//     _searchName = query;

//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 700), () {
//       // نستخدم الدالة الموحدة بدل كتابة منطق الـ Bloc هنا
//       _updateFilters();
//     });
//   }

//   @override
//   void dispose() {
//     _debounce?.cancel();
//     super.dispose();
//   }

//   void _updateFilters() {
//     if (widget.medicalStaff == MedicalStaff.lab) {
//       // إرسال لـ LabsBloc
//       context.read<LabsBloc>().add(
//         FilterLabs(
//           name: _searchName,
//           location: _selectedCity,
//           testIds: selectedTestIds,
//         ),
//       );
//     } else if (widget.medicalStaff == MedicalStaff.nurse) {
//       // إرسال لـ NursesBloc
//       context.read<NursesBloc>().add(
//         FilterNurses(
//           name: _searchName,
//           cityName:
//               _selectedCity, // تأكد إن الاسم في الـ Event هو cityName أو location
//         ),
//       );
//     }

//     // إبلاغ الـ Parent بالتحديث (اختياري حسب حاجتك)
//     widget.onFilterChanged(_searchName, _selectedSpecialty, _selectedCity);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.grey[300]!),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             widget.medicalStaff == MedicalStaff.nurse
//                 ? "Book a Nurse for Home Care"
//                 : (widget.medicalStaff == MedicalStaff.lab
//                       ? "Book Lab Tests"
//                       : " "),
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 17,
//               fontFamily: 'Cotta',
//             ),
//           ),
//           Text(
//             (widget.medicalStaff == MedicalStaff.nurse
//                 ? "Professional nursing services at your doorstep"
//                 : (widget.medicalStaff == MedicalStaff.lab
//                       ? "Get lab tests done at home or visit the lab"
//                       : "")),
//             style: TextStyle(
//               color: Colors.grey.shade800,
//               fontSize: 13,
//               fontFamily: 'Agency',
//             ),
//             maxLines: 1,
//           ),

//           SizedBox(height: 10),
//           // Search by Name
//           Text(
//             "Search By Name",
//             style: TextStyle(color: Colors.grey.shade800, fontFamily: 'Agency'),
//           ),
//           SizedBox(height: 5),
//           TextField(
//             onChanged: _onSearchChanged,
//             decoration: InputDecoration(
//               hintStyle: TextStyle(
//                 color: Colors.grey.shade800,
//                 fontSize: 14,
//                 fontFamily: 'Agency',
//               ),
//               hintText: widget.medicalStaff == MedicalStaff.nurse
//                   ? "Nurse Name..."
//                   : (widget.medicalStaff == MedicalStaff.lab
//                         ? "Lab Name..."
//                         : " "),
//               prefixIcon: const Icon(Icons.search, size: 20),
//               filled: true,
//               fillColor: Colors.grey[100],
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),

//           // Test Dropdown (يظهر فقط لو المستخدم بيبحث عن Lab)
//           widget.medicalStaff == MedicalStaff.lab
//               ? Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Lab Test ",
//                       style: TextStyle(
//                         color: Colors.grey.shade800,
//                         fontFamily: 'Agency',
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     TestDropdownScreen(
//                       initialTestIds: widget.initialTestIds,
//                       onTestsChanged: (tests) {
//                         selectedTestIds = tests.map((e) => e.id).toList();
//                         if (_debounce?.isActive ?? false) _debounce!.cancel();
//                         _debounce = Timer(const Duration(milliseconds: 600), () {
//                           // نرسل الطلب بعد توقف المستخدم عن الضغط بـ 600 مللي ثانية
//                           _updateFilters();
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 12),
//                   ],
//                 )
//               : const SizedBox.shrink(),

//           // Location
//           Text(
//             "Location",
//             style: TextStyle(color: Colors.grey.shade800, fontFamily: 'Agency'),
//           ),
//           SizedBox(height: 5),
//           buildLocationField(context),
//         ],
//       ),
//     );
//   }

//   Widget buildLocationField(BuildContext context) {
//     return BlocBuilder<CitiesCubit, CitiesState>(
//       builder: (context, state) {
//         List<String> cityItems = [];
//         if (state is CitiesSuccess) {
//           cityItems = state.cities;
//         }

//         return CustomDropdown<String>.search(
//           controller: _cityController,
//           hintText: state is CitiesLoading ? 'Loading...' : 'Select City',
//           items: cityItems,
//           onChanged: (value) {
//             setState(() {
//               _selectedCity = value;
//               _updateFilters();
//             });
//           },
//           headerBuilder: (context, selectedItem, _) {
//             return Row(
//               children: [
//                 const Icon(
//                   Icons.location_on,
//                   color: Colors.redAccent,
//                   size: 18,
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     selectedItem,
//                     style: const TextStyle(fontSize: 14, fontFamily: 'Agency'),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 if (selectedItem != null)
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _cityController.clear();
//                         _selectedCity = null;
//                         _updateFilters();
//                       });
//                     },
//                     child: const Icon(
//                       Icons.close,
//                       size: 14,
//                       color: Colors.grey,
//                     ),
//                   ),
//               ],
//             );
//           },
//           listItemBuilder: (context, item, isSelected, onItemSelect) {
//             return Text(
//               item,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontFamily: 'Agency',
//                 color: isSelected ? Colors.blue : Colors.black,
//               ),
//             );
//           },
//           decoration: CustomDropdownDecoration(
//             closedFillColor: Colors.grey.shade100,
//             expandedFillColor: Colors.white,
//             hintStyle: TextStyle(
//               color: Colors.grey.shade800,
//               fontFamily: 'Agency',
//               fontSize: 14,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// // Doctor
// class SearchForDoctor extends StatefulWidget {
//   const SearchForDoctor({super.key, required this.onFilterChanged});
//   final Function(
//     String name,
//     Specialty? specialty,
//     String? cityName,
//     String serviceType,
//   )
//   onFilterChanged; // الدالة المرسلة

//   @override
//   State<SearchForDoctor> createState() => _SearchForDoctor();
// }

// class _SearchForDoctor extends State<SearchForDoctor> {
//   // أضف هذا السطر مع تعريف المتغيرات في البداية
//   final _specialtyController = SingleSelectController<Specialty?>(null);
//   final _cityController = SingleSelectController<String?>(null);
//   String? _selectedCity;

//   // تعريف المتغير الذي سيحمل القيمة المختارة
//   String _searchName = "";
//   Specialty? _selectedSpecialty;
//   String _selectedServiceString = "clinic";
//   LocationModel? _selectedLocation;
//   Timer? _debounce;

//   void _updateFiltersWithDebounce() {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();

//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       widget.onFilterChanged(
//         _searchName,
//         _selectedSpecialty,
//         _selectedCity,
//         _selectedServiceString,
//       );
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     // تأكد من استدعاء الدالة التي تجلب المدن هنا
//     context.read<CitiesCubit>().getCities();
//   }

//   @override
//   void dispose() {
//     _debounce?.cancel();
//     super.dispose();
//   }

//   void _onSearchChanged(String query) {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 700), () {
//       // 700ms وقت مثالي
//       _searchName = query;
//       _updateFiltersWithDebounce();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     return Container(
//       padding: const EdgeInsets.all(16),
//       margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//       decoration: BoxDecoration(
//         color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: isDark ? AppColors.bgLight : AppColors.bgDark,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Find a Doctor",
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//               fontFamily: 'Cotta',
//             ),
//           ),
//           SizedBox(height: 4),

//           _buildSearchByName(),

//           const SizedBox(height: 12),

//           Row(
//             children: [
//               // Specialty
//               Expanded(
//                 flex: 2,
//                 child: Column(
//                   children: [
//                     SizedBox(height: 5),
//                     buildDropDownSpecialty(context),
//                   ],
//                 ),
//               ),

//               const SizedBox(width: 8),

//               // Location
//               Expanded(
//                 flex: 2,
//                 child: Column(
//                   children: [SizedBox(height: 5), buildLocationField(context)],
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 12),

//           Text("Service Type", style: TextStyle(fontFamily: 'Agency')),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               FlipRadioButton<String>(
//                 value: "clinic",
//                 groupValue: _selectedServiceString,
//                 onChanged: (val) {
//                   setState(() {
//                     _selectedServiceString = val;
//                     _updateFiltersWithDebounce();
//                   });
//                 },
//                 labelA: "Clinic",
//                 labelB: "Clinic",
//               ),
//               FlipRadioButton<String>(
//                 value: "online",
//                 groupValue: _selectedServiceString,
//                 onChanged: (val) {
//                   setState(() {
//                     _selectedServiceString = val;
//                     _updateFiltersWithDebounce();
//                   });
//                 },
//                 labelA: "Online",
//                 labelB: "Online",
//               ),
//               FlipRadioButton<String>(
//                 value: "home",
//                 groupValue: _selectedServiceString,
//                 onChanged: (val) {
//                   setState(() {
//                     _selectedServiceString = val;
//                     _updateFiltersWithDebounce();
//                   });
//                 },
//                 labelA: "home",
//                 labelB: "home",
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildDropDownSpecialty(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;

//     final textColor = isDark ? Colors.white : Colors.black87;
//     final secondaryTextColor = isDark ? Colors.white70 : Colors.grey.shade800;
//     final primaryColor = theme.colorScheme.primary;

//     return BlocBuilder<SpecialtyBloc, SpecialtyState>(
//       builder: (context, state) {
//         List<Specialty> items = [];

//         if (state is SpecialtyLoaded) {
//           items = state.specialties;
//         }

//         return CustomDropdown<Specialty>.search(
//           controller: _specialtyController,
//           hintText: state is SpecialtyLoading
//               ? 'Loading...'
//               : 'Select Specialty',
//           items: items,
//           excludeSelected: false,

//           onChanged: (value) {
//             setState(() {
//               _selectedSpecialty = value;
//               _updateFiltersWithDebounce();
//             });
//           },

//           /// ================= HEADER =================
//           headerBuilder: (context, selectedItem, _) {
//             if (selectedItem == null) {
//               return Text(
//                 'Select Specialty',
//                 style: TextStyle(fontSize: 11, color: secondaryTextColor),
//               );
//             }

//             return Row(
//               crossAxisAlignment: CrossAxisAlignment.start, // 👈 مهم للسطرين
//               children: [
//                 Icon(selectedItem.icon, color: selectedItem.color, size: 14),
//                 const SizedBox(width: 6),

//                 Expanded(
//                   child: Text(
//                     selectedItem.name,
//                     style: TextStyle(
//                       fontSize: 11,
//                       fontWeight: FontWeight.w600,
//                       color: textColor,
//                     ),
//                     maxLines: 2, // 👈 سطرين
//                     overflow: TextOverflow.ellipsis,
//                     softWrap: true,
//                   ),
//                 ),

//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _specialtyController.clear();
//                       _selectedSpecialty = null;
//                       _updateFiltersWithDebounce();
//                     });
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.all(4),
//                     child: Icon(
//                       Icons.close,
//                       size: 14,
//                       color: secondaryTextColor,
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },

//           /// ================= LIST ITEMS =================
//           listItemBuilder: (context, item, isSelected, onItemSelect) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(
//                 vertical: 8,
//               ), // 👈 يساعد في التمدد
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start, // 👈 مهم
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: item.color.withOpacity(isDark ? 0.2 : 0.1),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(item.icon, color: item.color, size: 12),
//                   ),

//                   const SizedBox(width: 12),

//                   Expanded(
//                     child: Text(
//                       item.name,
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: isSelected
//                             ? FontWeight.w600
//                             : FontWeight.normal,
//                         color: isSelected ? primaryColor : textColor,
//                       ),
//                       maxLines: 2, // 👈 سطرين
//                       overflow: TextOverflow.ellipsis,
//                       softWrap: true,
//                     ),
//                   ),

//                   if (isSelected)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 2),
//                       child: Icon(Icons.check, color: primaryColor, size: 14),
//                     ),
//                 ],
//               ),
//             );
//           },

//           /// ================= DECORATION =================
//           decoration: CustomDropdownDecoration(
//             hintStyle: TextStyle(
//               color: secondaryTextColor,
//               fontSize: 11,
//               fontWeight: FontWeight.w400,
//               fontFamily: 'Agency',
//             ),

//             closedFillColor: isDark ? AppColors.bgDark : AppColors.bgLight,

//             expandedFillColor: isDark ? AppColors.bgDark : Colors.white,
//             closedBorder: Border.all(
//               color: isDark ? Colors.white12 : Colors.grey.shade300,
//             ),

//             expandedBorder: Border.all(color: primaryColor.withOpacity(0.5)),
//           ),
//         );
//       },
//     );
//   }

//   Widget buildLocationField(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;

//     final textColor = isDark ? Colors.white : Colors.black87;
//     final secondaryTextColor = isDark ? Colors.white70 : Colors.grey.shade800;
//     final primaryColor = theme.colorScheme.primary;

//     return BlocBuilder<CitiesCubit, CitiesState>(
//       builder: (context, state) {
//         List<String> cityItems = [];
//         if (state is CitiesSuccess) {
//           cityItems = state.cities;
//         }

//         return Theme(
//           data: theme.copyWith(
//             canvasColor: isDark
//                 ? const Color(0xFF1E1E1E)
//                 : Colors.white, // 👈 يحل البوكس الأبيض
//           ),
//           child: CustomDropdown<String>.search(
//             controller: _cityController,
//             hintText: state is CitiesLoading ? 'Loading...' : 'Select City',
//             items: cityItems,

//             onChanged: (value) {
//               setState(() {
//                 _selectedCity = value;
//                 _updateFiltersWithDebounce();
//               });
//             },

//             /// ============ HEADER ============
//             headerBuilder: (context, selectedItem, _) {
//               if (selectedItem == null) {
//                 return Text(
//                   'Select City',
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontFamily: 'Agency',
//                     color: secondaryTextColor,
//                   ),
//                 );
//               }

//               return Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Icon(Icons.location_on, color: Colors.redAccent, size: 18),
//                   const SizedBox(width: 8),

//                   Expanded(
//                     child: Text(
//                       selectedItem,
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontFamily: 'Agency',
//                         color: textColor,
//                       ),
//                       maxLines: 2, // 👈 سطرين
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),

//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _cityController.clear();
//                         _selectedCity = null;
//                         _updateFiltersWithDebounce();
//                       });
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(4),
//                       child: Icon(
//                         Icons.close,
//                         size: 14,
//                         color: secondaryTextColor,
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },

//             /// ============ LIST ITEMS ============
//             listItemBuilder: (context, item, isSelected, onItemSelect) {
//               return Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 child: Text(
//                   item,
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontFamily: 'Agency',
//                     color: isSelected ? primaryColor : textColor,
//                     fontWeight: isSelected
//                         ? FontWeight.w600
//                         : FontWeight.normal,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               );
//             },

//             /// ============ DECORATION ============
//             decoration: CustomDropdownDecoration(
//               closedFillColor: isDark ? AppColors.bgDark : Colors.grey.shade100,

//               expandedFillColor: isDark ? AppColors.bgDark : Colors.white,

//               hintStyle: TextStyle(
//                 color: secondaryTextColor,
//                 fontFamily: 'Agency',
//                 fontSize: 12,
//               ),

//               closedBorder: Border.all(
//                 color: isDark ? Colors.white12 : Colors.grey.shade300,
//               ),

//               expandedBorder: Border.all(color: primaryColor.withOpacity(0.5)),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSearchByName() {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     return Row(
//       children: [
//         Expanded(
//           child: TextField(
//             onChanged: _onSearchChanged,
//             decoration: InputDecoration(
//               hintStyle: TextStyle(fontSize: 12, fontFamily: 'Agency'),
//               hintText: "Doctor name...",
//               prefixIcon: const Icon(Icons.search, size: 20),
//               filled: true,
//               fillColor: isDark ? AppColors.bgDark : AppColors.textDark,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// ignore_for_file: deprecated_member_use, dead_code, unnecessary_null_comparison, unused_field, no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/CityCubit/city_cubit.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/LabBloc/lab_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/LabBloc/lab_event.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/NurseBloc/nurse_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/NurseBloc/nurse_event.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/SpecialtyBloc/specialty_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/SpecialtyBloc/specialty_state.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/Tests_Bloc/test_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/Tests_Bloc/test_events.dart';
import 'package:healthcareapp_try1/Models/Auth_Models/location_model.dart';
import 'package:healthcareapp_try1/Models/Users_Models/enums.dart';
import 'package:healthcareapp_try1/Models/Users_Models/specialty_model.dart';
import 'package:healthcareapp_try1/Widgets/service_type_widget.dart';
import 'package:healthcareapp_try1/Widgets/tests_dropdown.dart';
import 'package:healthcareapp_try1/core/theme/app_colors.dart';

// Nurse && Lab
class SearchForNurseAndLab extends StatefulWidget {
  const SearchForNurseAndLab({
    super.key,
    required this.medicalStaff,
    required this.onFilterChanged,
    this.initialTestIds = const [],
  });

  final MedicalStaff medicalStaff;
  final List<String> initialTestIds;
  final Function(String name, Specialty? specialty, String? selectedCity)
  onFilterChanged;

  @override
  State<SearchForNurseAndLab> createState() => _SearchForNurseAndLab();
}

class _SearchForNurseAndLab extends State<SearchForNurseAndLab> {
  final _cityController = SingleSelectController<String?>(null);

  String? _selectedCity;
  Timer? _debounce;
  List<String> selectedTestIds = [];
  String _searchName = "";
  Specialty? _selectedSpecialty;

  @override
  void initState() {
    super.initState();
    selectedTestIds = List.from(widget.initialTestIds);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CitiesCubit>().getCities();
      context.read<TestBloc>().add(FetchLabTests());
    });
  }

  void _onSearchChanged(String query) {
    _searchName = query;

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), () {
      _updateFilters();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _updateFilters() {
    if (widget.medicalStaff == MedicalStaff.lab) {
      context.read<LabsBloc>().add(
        FilterLabs(
          name: _searchName,
          location: _selectedCity,
          testIds: selectedTestIds,
        ),
      );
    } else if (widget.medicalStaff == MedicalStaff.nurse) {
      context.read<NursesBloc>().add(
        FilterNurses(name: _searchName, cityName: _selectedCity),
      );
    }

    widget.onFilterChanged(_searchName, _selectedSpecialty, _selectedCity);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? Colors.white60 : Colors.grey.shade800;
    final primaryColor = AppColors.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.medicalStaff == MedicalStaff.nurse
                ? "Book a Nurse for Home Care"
                : (widget.medicalStaff == MedicalStaff.lab
                      ? "Book Lab Tests"
                      : " "),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              fontFamily: 'Cotta',
              color: textColor,
            ),
          ),
          Text(
            widget.medicalStaff == MedicalStaff.nurse
                ? "Professional nursing services at your doorstep"
                : (widget.medicalStaff == MedicalStaff.lab
                      ? "Get lab tests done at home or visit the lab"
                      : ""),
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 13,
              fontFamily: 'Agency',
            ),
            maxLines: 1,
          ),
          const SizedBox(height: 10),
          Text(
            "Search By Name",
            style: TextStyle(color: secondaryTextColor, fontFamily: 'Agency'),
          ),
          const SizedBox(height: 5),
          TextField(
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintStyle: TextStyle(
                color: secondaryTextColor,
                fontFamily: 'Agency',
              ),
              hintText: widget.medicalStaff == MedicalStaff.nurse
                  ? "Nurse Name..."
                  : (widget.medicalStaff == MedicalStaff.lab
                        ? "Lab Name..."
                        : " "),
              prefixIcon: const Icon(Icons.search, size: 20),
              filled: true,
              fillColor: isDark ? AppColors.bgDark : Colors.grey.shade100,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? Colors.white12 : Colors.grey.shade300,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          widget.medicalStaff == MedicalStaff.lab
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lab Test ",
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontFamily: 'Agency',
                      ),
                    ),
                    const SizedBox(height: 5),
                    TestDropdownScreen(
                      initialTestIds: widget.initialTestIds,
                      onTestsChanged: (tests) {
                        selectedTestIds = tests.map((e) => e.id).toList();
                        if (_debounce?.isActive ?? false) _debounce!.cancel();
                        _debounce = Timer(
                          const Duration(milliseconds: 600),
                          () {
                            _updateFilters();
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                )
              : const SizedBox.shrink(),
          Text(
            "Location",
            style: TextStyle(color: secondaryTextColor, fontFamily: 'Agency'),
          ),
          const SizedBox(height: 5),
          buildLocationField(context, isDark: isDark),
        ],
      ),
    );
  }

  Widget buildLocationField(BuildContext context, {required bool isDark}) {
    final textColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? Colors.white60 : Colors.grey.shade800;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return BlocBuilder<CitiesCubit, CitiesState>(
      builder: (context, state) {
        List<String> cityItems = [];
        if (state is CitiesSuccess) {
          cityItems = state.cities;
        }

        return CustomDropdown<String>.search(
          controller: _cityController,
          hintText: state is CitiesLoading ? 'Loading...' : 'Select City',
          items: cityItems,
          onChanged: (value) {
            setState(() {
              _selectedCity = value;
              _updateFilters();
            });
          },
          headerBuilder: (context, selectedItem, _) {
            return Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.redAccent,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedItem,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Agency',
                      color: textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (selectedItem != null)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _cityController.clear();
                        _selectedCity = null;
                        _updateFilters();
                      });
                    },
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ),
              ],
            );
          },
          listItemBuilder: (context, item, isSelected, onItemSelect) {
            return Text(
              item,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Agency',
                color: isSelected ? primaryColor : textColor,
              ),
            );
          },
          decoration: CustomDropdownDecoration(
            closedFillColor: isDark ? AppColors.bgDark : Colors.grey.shade100,
            expandedFillColor: isDark ? AppColors.bgDark : Colors.white,
            hintStyle: TextStyle(color: secondaryTextColor),
            closedBorder: Border.all(
              color: isDark ? Colors.white12 : Colors.grey.shade300,
            ),
            expandedBorder: Border.all(color: primaryColor.withOpacity(0.5)),
          ),
        );
      },
    );
  }
}

// Doctor
class SearchForDoctor extends StatefulWidget {
  const SearchForDoctor({super.key, required this.onFilterChanged});

  final Function(
    String name,
    Specialty? specialty,
    String? cityName,
    String serviceType,
  )
  onFilterChanged;

  @override
  State<SearchForDoctor> createState() => _SearchForDoctor();
}

class _SearchForDoctor extends State<SearchForDoctor> {
  final _specialtyController = SingleSelectController<Specialty?>(null);
  final _cityController = SingleSelectController<String?>(null);

  String? _selectedCity;
  String _searchName = "";
  Specialty? _selectedSpecialty;
  String _selectedServiceString = "clinic";
  LocationModel? _selectedLocation;
  Timer? _debounce;

  void _updateFiltersWithDebounce() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onFilterChanged(
        _searchName,
        _selectedSpecialty,
        _selectedCity,
        _selectedServiceString,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<CitiesCubit>().getCities();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), () {
      _searchName = query;
      _updateFiltersWithDebounce();
    });
  }

  InputDecoration _commonFieldDecoration({
    required BuildContext context,
    required String hintText,
    required IconData prefixIcon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: 12,
        fontFamily: 'Agency',
        color: isDark ? Colors.white70 : Colors.grey.shade700,
      ),
      prefixIcon: Icon(
        prefixIcon,
        size: 18,
        color: isDark ? Colors.white70 : Colors.grey.shade700,
      ),
      filled: true,
      fillColor: isDark ? AppColors.bgDark : Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? Colors.white12 : Colors.grey.shade300,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? Colors.white12 : Colors.grey.shade300,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
        ),
      ),
    );
  }

  CustomDropdownDecoration _commonDropdownDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomDropdownDecoration(
      closedFillColor: isDark ? AppColors.bgDark : Colors.grey.shade100,
      expandedFillColor: isDark ? AppColors.bgDark : Colors.white,
      hintStyle: TextStyle(
        color: isDark ? Colors.white70 : Colors.grey.shade700,
        fontFamily: 'Agency',
        fontSize: 12,
      ),
      closedBorder: Border.all(
        color: isDark ? Colors.white12 : Colors.grey.shade300,
      ),
      expandedBorder: Border.all(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      ),
      closedBorderRadius: BorderRadius.circular(12),
      expandedBorderRadius: BorderRadius.circular(12),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.bgLight : AppColors.bgDark,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Find a Doctor",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'Cotta',
            ),
          ),
          const SizedBox(height: 10),

          _buildSearchByName(),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(child: buildDropDownSpecialty(context)),
              const SizedBox(width: 8),
              Expanded(child: buildLocationField(context)),
            ],
          ),

          const SizedBox(height: 12),

          const Text("Service Type", style: TextStyle(fontFamily: 'Agency')),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FlipRadioButton<String>(
                value: "clinic",
                groupValue: _selectedServiceString,
                onChanged: (val) {
                  setState(() {
                    _selectedServiceString = val;
                    _updateFiltersWithDebounce();
                  });
                },
                labelA: "Clinic",
                labelB: "Clinic",
              ),
              FlipRadioButton<String>(
                value: "online",
                groupValue: _selectedServiceString,
                onChanged: (val) {
                  setState(() {
                    _selectedServiceString = val;
                    _updateFiltersWithDebounce();
                  });
                },
                labelA: "Online",
                labelB: "Online",
              ),
              FlipRadioButton<String>(
                value: "home",
                groupValue: _selectedServiceString,
                onChanged: (val) {
                  setState(() {
                    _selectedServiceString = val;
                    _updateFiltersWithDebounce();
                  });
                },
                labelA: "Home",
                labelB: "Home",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDropDownSpecialty(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? Colors.white70 : Colors.grey.shade700;
    final primaryColor = theme.colorScheme.primary;

    return BlocBuilder<SpecialtyBloc, SpecialtyState>(
      builder: (context, state) {
        List<Specialty> items = [];

        if (state is SpecialtyLoaded) {
          items = state.specialties;
        }

        return Theme(
          data: theme.copyWith(
            canvasColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          ),
          child: CustomDropdown<Specialty>.search(
            controller: _specialtyController,
            hintText: state is SpecialtyLoading
                ? 'Loading...'
                : 'Select Specialty',
            items: items,
            excludeSelected: false,
            onChanged: (value) {
              setState(() {
                _selectedSpecialty = value;
                _updateFiltersWithDebounce();
              });
            },
            headerBuilder: (context, selectedItem, _) {
              if (selectedItem == null) {
                return Row(
                  children: [
                    Icon(
                      Icons.medical_services_outlined,
                      size: 18,
                      color: secondaryTextColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Select Specialty',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Agency',
                          color: secondaryTextColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Icon(selectedItem.icon, color: selectedItem.color, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      selectedItem.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Agency',
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _specialtyController.clear();
                        _selectedSpecialty = null;
                        _updateFiltersWithDebounce();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.close,
                        size: 14,
                        color: secondaryTextColor,
                      ),
                    ),
                  ),
                ],
              );
            },
            listItemBuilder: (context, item, isSelected, onItemSelect) {
              return Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: item.color.withOpacity(isDark ? 0.2 : 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(item.icon, color: item.color, size: 14),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Agency',
                        color: isSelected ? primaryColor : textColor,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isSelected)
                    Icon(Icons.check, color: primaryColor, size: 16),
                ],
              );
            },
            decoration: _commonDropdownDecoration(context),
          ),
        );
      },
    );
  }

  Widget buildLocationField(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? Colors.white70 : Colors.grey.shade700;
    final primaryColor = theme.colorScheme.primary;

    return BlocBuilder<CitiesCubit, CitiesState>(
      builder: (context, state) {
        List<String> cityItems = [];
        if (state is CitiesSuccess) {
          cityItems = state.cities;
        }

        return Theme(
          data: theme.copyWith(
            canvasColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          ),
          child: CustomDropdown<String>.search(
            controller: _cityController,
            hintText: state is CitiesLoading ? 'Loading...' : 'Select City',
            items: cityItems,
            onChanged: (value) {
              setState(() {
                _selectedCity = value;
                _updateFiltersWithDebounce();
              });
            },
            headerBuilder: (context, selectedItem, _) {
              if (selectedItem == null) {
                return Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: secondaryTextColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Select City',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Agency',
                          color: secondaryTextColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.redAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      selectedItem,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Agency',
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _cityController.clear();
                        _selectedCity = null;
                        _updateFiltersWithDebounce();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.close,
                        size: 14,
                        color: secondaryTextColor,
                      ),
                    ),
                  ),
                ],
              );
            },
            listItemBuilder: (context, item, isSelected, onItemSelect) {
              return Text(
                item,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Agency',
                  color: isSelected ? primaryColor : textColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            },
            decoration: _commonDropdownDecoration(context),
          ),
        );
      },
    );
  }

  Widget _buildSearchByName() {
    return TextField(
      onChanged: _onSearchChanged,
      style: TextStyle(
        fontSize: 12,
        fontFamily: 'Agency',
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black87,
      ),
      decoration: _commonFieldDecoration(
        context: context,
        hintText: "Doctor name...",
        prefixIcon: Icons.search,
      ),
    );
  }
}
