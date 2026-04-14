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

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _specialtyController = SingleSelectController<Specialty?>(null);

  String? _selectedSpecialtyId;

  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(FetchPostsEvent()); // ✅
    context.read<SpecialtyBloc>().add(LoadSpecialties());
  }

  void _applyFilters() {
    log("🔥 specialtyId = $_selectedSpecialtyId");
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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Health Care Community',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            fontFamily: 'Cotta',
          ),
        ),
        centerTitle: true,

        backgroundColor: Colors.grey.shade100,
        foregroundColor: Colors.black87,

        elevation: 0,

        // مهم جدًا لمنع تغيير اللون عند scroll
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,

        // Shadow طبي خفيف
        shadowColor: Colors.black.withOpacity(0.08),

        // شكل أنعم
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
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: TextField(
                controller: _searchController,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  hintText: 'ابحث في المقالات...',
                  hintTextDirection: TextDirection.rtl,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.tune),
                    onPressed: _showFilterSheet,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
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
                    return const Center(
                      child: CustomSpinner(size: 40, color: Colors.blueAccent),
                    );
                  }

                  if (state is PostError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.wifi_off_rounded,
                              size: 48,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.black54),
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
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black45,
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'فلترة',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Switch(value: false, onChanged: (_) {}),
                const Text(
                  'البوستات المعلقة فقط',
                  textDirection: TextDirection.rtl,
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
    Timer? debounce;
    return BlocBuilder<SpecialtyBloc, SpecialtyState>(
      builder: (context, state) {
        final List<Specialty> items = state is SpecialtyLoaded
            ? state.specialties
            : [];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              if (debounce?.isActive ?? false) debounce!.cancel();

              debounce = Timer(const Duration(milliseconds: 500), () {
                _applyFilters();
              });
            },

            // ================= HEADER =================
            headerBuilder: (context, selectedItem, _) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
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
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _specialtyController.clear();
                          _selectedSpecialtyId = null;
                        });
                      },
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            },

            // ================= ITEM =================
            listItemBuilder: (context, item, isSelected, onItemSelect) {
              return ListTile(
                leading: Icon(item.icon, color: item.color, size: 16),
                title: Text(item.name),
                trailing: isSelected
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
              );
            },

            // ================= STYLE =================
            decoration: CustomDropdownDecoration(
              closedFillColor: Colors.white,
              expandedFillColor: Colors.grey.shade50,
              closedBorderRadius: BorderRadius.circular(12),
              expandedBorderRadius: BorderRadius.circular(12),
              hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}
