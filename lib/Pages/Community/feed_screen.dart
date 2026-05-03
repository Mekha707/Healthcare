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

  // ─── Theme helpers ────────────────────────────────────────────────────────
  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _pageBg =>
      _isDark ? AppColors.bgDark : Theme.of(context).scaffoldBackgroundColor;
  Color get _cardBg => _isDark ? AppColors.surfaceDark : Colors.white;
  Color get _accent => _isDark ? Colors.blue.shade200 : const Color(0xff0861dd);
  Color get _primaryText =>
      _isDark ? AppColors.textDark : const Color(0xff0d1b4b);
  Color get _secondaryText =>
      _isDark ? AppColors.textDark.withOpacity(0.60) : Colors.grey.shade600;
  Color get _borderColor =>
      _isDark ? Colors.white.withOpacity(0.08) : Colors.grey.shade200;
  Color get _inputFill =>
      _isDark ? Colors.white.withOpacity(0.05) : Colors.white;
  Color get _iconBg => _isDark
      ? Colors.blue.shade900.withOpacity(0.35)
      : const Color(0xffe8f0fe);
  BoxShadow get _cardShadow => BoxShadow(
    color: _isDark ? Colors.black38 : Colors.black.withOpacity(0.06),
    blurRadius: 20,
    offset: const Offset(0, 6),
  );
  // ─────────────────────────────────────────────────────────────────────────

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

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildSpecialtyDropdown(),
          Expanded(child: _buildFeed()),
        ],
      ),
    );
  }

  // ─── AppBar ───────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _pageBg,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: _iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.health_and_safety_outlined,
              size: 16,
              color: _accent,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Health Community',
            style: TextStyle(
              color: _primaryText,
              fontWeight: FontWeight.bold,
              fontSize: 17,
              fontFamily: 'Cotta',
            ),
          ),
        ],
      ),
    );
  }

  // ─── Search bar ───────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [_cardShadow],
        ),
        child: TextField(
          controller: _searchController,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            color: _primaryText,
            fontFamily: 'Agency',
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: 'ابحث في المقالات...',
            hintTextDirection: TextDirection.rtl,
            hintStyle: TextStyle(
              color: _secondaryText,
              fontFamily: 'Agency',
              fontSize: 13,
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: _iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.search_rounded, size: 15, color: _accent),
            ),
            suffixIcon: GestureDetector(
              onTap: _showFilterSheet,
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: _iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.tune_rounded, size: 15, color: _accent),
              ),
            ),
            filled: true,
            fillColor: Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: _accent, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          onSubmitted: (_) => _applyFilters(),
        ),
      ),
    );
  }

  // ─── Specialty dropdown ───────────────────────────────────────────────────
  Widget _buildSpecialtyDropdown() {
    return BlocBuilder<SpecialtyBloc, SpecialtyState>(
      builder: (context, state) {
        final items = state is SpecialtyLoaded
            ? state.specialties
            : <Specialty>[];

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
          child: CustomDropdown<Specialty>.search(
            controller: _specialtyController,
            items: items,
            hintText: state is SpecialtyLoading
                ? 'Loading...'
                : 'Select medical specialty',
            excludeSelected: false,
            onChanged: (Specialty? value) {
              setState(() => _selectedSpecialtyId = value?.id);
              if (_debounce?.isActive ?? false) _debounce!.cancel();
              _debounce = Timer(
                const Duration(milliseconds: 500),
                _applyFilters,
              );
            },
            headerBuilder: (context, selectedItem, _) {
              if (selectedItem == null) {
                return Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _iconBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.medical_services_outlined,
                        size: 14,
                        color: _accent,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Select medical specialty',
                        style: TextStyle(
                          fontSize: 13,
                          color: _secondaryText,
                          fontFamily: 'Agency',
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: _secondaryText,
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(selectedItem.icon, size: 14, color: _accent),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      selectedItem.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _accent,
                        fontFamily: 'Agency',
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
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 12,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              );
            },
            listItemBuilder: (context, item, isSelected, onItemSelect) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isSelected ? _accent.withOpacity(0.12) : _iconBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      item.icon,
                      size: 13,
                      color: isSelected ? _accent : _secondaryText,
                    ),
                  ),
                  title: Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Agency',
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected ? _accent : _primaryText,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_rounded, size: 14, color: _accent)
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  selected: isSelected,
                  selectedTileColor: _accent.withOpacity(0.06),
                ),
              );
            },
            decoration: CustomDropdownDecoration(
              closedFillColor: _cardBg,
              expandedFillColor: _cardBg,
              closedBorderRadius: BorderRadius.circular(14),
              expandedBorderRadius: BorderRadius.circular(14),
              closedBorder: Border.all(color: _borderColor),
              expandedBorder: Border.all(color: _borderColor),
              hintStyle: TextStyle(
                fontSize: 13,
                color: _secondaryText,
                fontFamily: 'Agency',
              ),
              searchFieldDecoration: SearchFieldDecoration(
                fillColor: _inputFill,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: _borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: _accent, width: 1.5),
                ),
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: _secondaryText,
                  fontFamily: 'Agency',
                ),
                textStyle: TextStyle(
                  fontSize: 13,
                  color: _primaryText,
                  fontFamily: 'Agency',
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── Feed list ────────────────────────────────────────────────────────────
  Widget _buildFeed() {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostLoading) {
          return Center(child: CustomSpinner(size: 36, color: _accent));
        }

        if (state is PostError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _cardBg,
                      shape: BoxShape.circle,
                      boxShadow: [_cardShadow],
                    ),
                    child: Icon(
                      Icons.wifi_off_rounded,
                      size: 36,
                      color: _secondaryText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _secondaryText,
                      fontFamily: 'Agency',
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _applyFilters,
                    icon: const Icon(Icons.refresh_rounded, size: 16),
                    label: const Text(
                      'إعادة المحاولة',
                      style: TextStyle(fontFamily: 'Agency'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is PostLoaded) {
          return RefreshIndicator(
            color: _accent,
            onRefresh: () async => _applyFilters(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              physics: const BouncingScrollPhysics(),
              children: [
                const InfoBanner(),
                const SizedBox(height: 12),
                // Count pill
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _accent.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _accent.withOpacity(0.20)),
                    ),
                    child: Text(
                      '${state.totalCount} مقال',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 12,
                        color: _accent,
                        fontFamily: 'Agency',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ...state.posts.map((post) => PostCard(post: post)),
                if (state.hasNextPage)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.read<PostBloc>().add(
                            FetchPostsEvent(
                              params: state.activeParams.copyWith(
                                page: state.currentPage + 1,
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.expand_more_rounded,
                          size: 18,
                          color: _accent,
                        ),
                        label: Text(
                          'تحميل المزيد',
                          style: TextStyle(
                            fontFamily: 'Agency',
                            color: _accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: _accent.withOpacity(0.35)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  // ─── Filter sheet ─────────────────────────────────────────────────────────
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.tune_rounded, size: 16, color: _accent),
                ),
                const SizedBox(width: 10),
                Text(
                  'فلترة',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _primaryText,
                    fontFamily: 'Cotta',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: _inputFill,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _borderColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'البوستات المعلقة فقط',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: _primaryText,
                      fontFamily: 'Agency',
                      fontSize: 14,
                    ),
                  ),
                  Switch(value: false, onChanged: (_) {}, activeColor: _accent),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _applyFilters();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'تطبيق',
                  style: TextStyle(
                    fontFamily: 'Agency',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
