// ignore_for_file: unnecessary_null_comparison, dead_code

import 'dart:async';
import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Bloc/PostBloc/post_bloc.dart';
import 'package:healthcareapp_try1/Bloc/PostBloc/post_event.dart';
import 'package:healthcareapp_try1/Bloc/PostBloc/post_state.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/SpecialtyBloc/specialty_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/SpecialtyBloc/specialty_event.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/SpecialtyBloc/specialty_state.dart';
import 'package:healthcareapp_try1/Models/Posts/post_query_params.dart';
import 'package:healthcareapp_try1/Models/Users_Models/specialty_model.dart';
import 'package:healthcareapp_try1/Pages/Community/community_page.dart';
import 'package:healthcareapp_try1/Widgets/custom_loader1.dart';
import 'package:healthcareapp_try1/Widgets/info_banner.dart';
import 'package:healthcareapp_try1/core/theme/app_colors.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _specialtyController = SingleSelectController<Specialty?>(null);

  String? _selectedSpecialtyId;
  Timer? _debounce;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _pageBg => _isDark ? AppColors.bgDark : Colors.grey.shade100;
  Color get _cardBg => _isDark ? AppColors.surfaceDark : Colors.white;
  Color get _primaryText => _isDark ? AppColors.textDark : AppColors.textDark;
  Color get _secondaryText =>
      _isDark ? AppColors.textDark.withOpacity(0.7) : Colors.grey.shade600;
  Color get _borderColor =>
      _isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFE0E0E0);

  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(FetchPostsEvent());
    context.read<SpecialtyBloc>().add(LoadSpecialties());
  }

  void _applyFilters() {
    log("specialtyId = $_selectedSpecialtyId");
    context.read<PostBloc>().add(
      FetchPostsEvent(
        params: PostQueryParams(
          search: _searchController.text.trim(),
          specialtyId: _selectedSpecialtyId,
          page: 1,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      appBar: AppBar(
        title: const Text(
          'Health Community',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            fontFamily: 'Cotta',
          ),
        ),
        centerTitle: true,
        backgroundColor: _pageBg,
        foregroundColor: _primaryText,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withOpacity(_isDark ? 0.18 : 0.08),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 5, right: 5, top: 0),
        child: Column(
          children: [
            Container(
              color: _cardBg,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: TextField(
                controller: _searchController,
                textDirection: TextDirection.rtl,
                style: TextStyle(color: _primaryText),
                decoration: InputDecoration(
                  hintText: 'ابحث في المقالات...',
                  hintTextDirection: TextDirection.rtl,
                  hintStyle: TextStyle(
                    color: _secondaryText,
                    fontFamily: 'Agency',
                  ),
                  prefixIcon: Icon(Icons.search, color: _secondaryText),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.tune, color: _secondaryText),
                    onPressed: _showFilterSheet,
                  ),
                  filled: true,
                  fillColor: _isDark
                      ? AppColors.bgDark.withOpacity(0.8)
                      : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: _borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: _borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xff0861dd)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                onSubmitted: (_) => _applyFilters(),
              ),
            ),
            buildDropDownSpecialty(context),
            Expanded(
              child: BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  if (state is PostLoading) {
                    return Center(
                      child: CustomSpinner(
                        size: 40,
                        color: _isDark
                            ? AppColors.textLight
                            : Colors.blueAccent,
                      ),
                    );
                  }

                  if (state is PostError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.wifi_off_rounded,
                              size: 48,
                              color: _secondaryText,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: _secondaryText),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _applyFilters,
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is PostLoaded) {
                    return RefreshIndicator(
                      onRefresh: () async => _applyFilters(),
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          const InfoBanner(),
                          const SizedBox(height: 8),
                          Text(
                            '${state.totalCount} مقال',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 13,
                              color: _secondaryText,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...state.posts.map((post) => PostCard(post: post)),
                          if (state.hasNextPage)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: OutlinedButton(
                                onPressed: () {
                                  context.read<PostBloc>().add(
                                    FetchPostsEvent(
                                      params: state.activeParams.copyWith(
                                        page: state.currentPage + 1,
                                      ),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: _borderColor),
                                  foregroundColor: _primaryText,
                                ),
                                child: const Text('تحميل المزيد'),
                              ),
                            ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'فلترة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _primaryText,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Switch(value: false, onChanged: (_) {}),
                Text(
                  'البوستات المعلقة فقط',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: _primaryText),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _applyFilters();
                },
                child: const Text('تطبيق'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropDownSpecialty(BuildContext context) {
    return BlocBuilder<SpecialtyBloc, SpecialtyState>(
      builder: (context, state) {
        final items = state is SpecialtyLoaded
            ? state.specialties
            : <Specialty>[];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: _isDark ? AppColors.surfaceDark : Colors.white,
            ),
            child: CustomDropdown<Specialty>.search(
              controller: _specialtyController,
              items: items,
              hintText: state is SpecialtyLoading
                  ? 'Loading specialties...'
                  : 'Select medical specialty',
              excludeSelected: false,
              onChanged: (Specialty? value) {
                setState(() {
                  _selectedSpecialtyId = value?.id;
                });

                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  _applyFilters();
                });
              },
              headerBuilder: (context, selectedItem, _) {
                if (selectedItem == null) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: _isDark
                          ? AppColors.bgDark.withOpacity(0.75)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.medical_services_outlined,
                          size: 16,
                          color: _secondaryText,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Select medical specialty',
                            style: TextStyle(
                              fontSize: 12,
                              color: _secondaryText,
                              fontFamily: 'Agency',
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: _isDark
                        ? Colors.blue.withOpacity(0.12)
                        : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        selectedItem.icon,
                        color: selectedItem.color,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selectedItem.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _primaryText,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _specialtyController.clear();
                            _selectedSpecialtyId = null;
                          });
                          _applyFilters();
                        },
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: _secondaryText,
                        ),
                      ),
                    ],
                  ),
                );
              },
              listItemBuilder: (context, item, isSelected, onItemSelect) {
                return ListTile(
                  leading: Icon(item.icon, color: item.color, size: 16),
                  title: Text(item.name, style: TextStyle(color: _primaryText)),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                );
              },
              decoration: CustomDropdownDecoration(
                closedFillColor: _cardBg,
                expandedFillColor: _isDark
                    ? AppColors.surfaceDark
                    : Colors.grey.shade50,
                closedBorderRadius: BorderRadius.circular(12),
                expandedBorderRadius: BorderRadius.circular(12),
                closedBorder: Border.all(color: _borderColor),
                expandedBorder: Border.all(
                  color: _isDark
                      ? Colors.white.withOpacity(0.12)
                      : Colors.grey.shade300,
                ),
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: _secondaryText,
                  fontFamily: 'Agency',
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
