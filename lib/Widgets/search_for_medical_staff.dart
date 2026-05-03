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
        color: isDark ? Colors.white38 : Colors.grey.shade500,
      ),
      prefixIcon: Icon(
        prefixIcon,
        size: 18,
        color: isDark ? Colors.white38 : Colors.grey.shade500,
      ),
      filled: true,
      fillColor: isDark ? AppColors.bgDark : Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? Colors.white12 : Colors.grey.shade300,
          width: 0.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? Colors.white12 : Colors.grey.shade300,
          width: 0.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? Colors.blue.shade700 : Colors.blue.shade300,
          width: 0.5,
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
        color: isDark ? Colors.white38 : Colors.grey.shade500,
        fontFamily: 'Agency',
        fontSize: 12,
      ),
      closedBorder: Border.all(
        color: isDark ? Colors.white12 : Colors.grey.shade300,
        width: 0.5,
      ),
      expandedBorder: Border.all(
        color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade200,
        width: 0.5,
      ),
      closedBorderRadius: BorderRadius.circular(12),
      expandedBorderRadius: BorderRadius.circular(12),
      searchFieldDecoration: SearchFieldDecoration(
        fillColor: isDark
            ? Colors.white.withOpacity(0.04)
            : Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.grey.shade200,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? Colors.blue.shade700 : Colors.blue.shade300,
            width: 0.5,
          ),
        ),
        hintStyle: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.white38 : Colors.grey.shade500,
          fontFamily: 'Agency',
        ),
        textStyle: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.white : Colors.black87,
          fontFamily: 'Agency',
        ),
      ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<SpecialtyBloc, SpecialtyState>(
      builder: (context, state) {
        final items = state is SpecialtyLoaded
            ? state.specialties
            : <Specialty>[];

        return Theme(
          data: Theme.of(context).copyWith(
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
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.06)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Icon(
                        Icons.medical_services_outlined,
                        size: 13,
                        color: isDark ? Colors.white38 : Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Select Specialty',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Agency',
                          color: isDark ? Colors.white38 : Colors.grey.shade500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.blue.withOpacity(0.15)
                          : Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Icon(
                      selectedItem.icon,
                      size: 13,
                      color: isDark
                          ? Colors.blue.shade300
                          : Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      selectedItem.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Agency',
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? Colors.blue.shade200
                            : Colors.blue.shade800,
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
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.blue.withOpacity(0.2)
                            : Colors.blue.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 11,
                        color: isDark
                            ? Colors.blue.shade300
                            : Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              );
            },
            listItemBuilder: (context, item, isSelected, onItemSelect) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark
                                  ? Colors.blue.withOpacity(0.15)
                                  : Colors.blue.shade50)
                            : (isDark
                                  ? Colors.white.withOpacity(0.06)
                                  : Colors.grey.shade100),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Icon(
                        item.icon,
                        size: 13,
                        color: isSelected
                            ? (isDark
                                  ? Colors.blue.shade300
                                  : Colors.blue.shade700)
                            : (isDark ? Colors.white54 : Colors.grey.shade600),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Agency',
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isSelected
                              ? (isDark
                                    ? Colors.blue.shade200
                                    : Colors.blue.shade800)
                              : (isDark ? Colors.white : Colors.black87),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: isDark
                            ? Colors.blue.shade300
                            : Colors.blue.shade600,
                      ),
                  ],
                ),
              );
            },
            decoration: _commonDropdownDecoration(context),
          ),
        );
      },
    );
  }

  Widget buildLocationField(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<CitiesCubit, CitiesState>(
      builder: (context, state) {
        final cityItems = state is CitiesSuccess ? state.cities : <String>[];

        return Theme(
          data: Theme.of(context).copyWith(
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
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.06)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: isDark ? Colors.white38 : Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Select City',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Agency',
                          color: isDark ? Colors.white38 : Colors.grey.shade500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.red.withOpacity(0.15)
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Icon(
                      Icons.location_on,
                      size: 13,
                      color: isDark ? Colors.red.shade300 : Colors.red.shade400,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      selectedItem,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Agency',
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.black87,
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
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 11,
                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              );
            },
            listItemBuilder: (context, item, isSelected, onItemSelect) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark
                                  ? Colors.red.withOpacity(0.15)
                                  : Colors.red.shade50)
                            : (isDark
                                  ? Colors.white.withOpacity(0.06)
                                  : Colors.grey.shade100),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: isSelected
                            ? (isDark
                                  ? Colors.red.shade300
                                  : Colors.red.shade400)
                            : (isDark ? Colors.white38 : Colors.grey.shade500),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Agency',
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isSelected
                              ? (isDark ? Colors.white : Colors.black87)
                              : (isDark
                                    ? Colors.white70
                                    : Colors.grey.shade700),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: isDark
                            ? Colors.red.shade300
                            : Colors.red.shade400,
                      ),
                  ],
                ),
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
