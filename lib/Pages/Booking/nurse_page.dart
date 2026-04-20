// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Models/Users_Models/nurse_model.dart';
import 'package:healthcareapp_try1/Widgets/medical_staff_cards.dart';
import 'package:healthcareapp_try1/Widgets/search_for_medical_staff.dart';
import 'package:healthcareapp_try1/core/theme/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/NurseBloc/nurse_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/NurseBloc/nurse_event.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/NurseBloc/nurse_state.dart';
import 'package:healthcareapp_try1/Buttons/buttons.dart';
import 'package:healthcareapp_try1/Buttons/filter_button.dart';
import 'package:healthcareapp_try1/Models/Users_Models/enums.dart';
import 'package:healthcareapp_try1/Pages/Booking/healtcare_provider.dart';

class NursePage extends StatefulWidget {
  const NursePage({super.key});

  @override
  State<NursePage> createState() => _NursePage();
}

class _NursePage extends State<NursePage> {
  final ScrollController _scrollController = ScrollController();
  bool isFilterd = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // بدء جلب البيانات فور دخول الصفحة
    context.read<NursesBloc>().add(FetchNurses());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final atBottom =
        _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200;
    if (atBottom) {
      context.read<NursesBloc>().add(LoadMoreNurses());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<NursesBloc, NursesState>(
      listener: (context, state) {},
      builder: (context, state) {
        // 1. معالجة حالة الخطأ
        if (state is NursesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.message,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'ElMessiri',
                    color: isDark
                        ? const Color(0xff62f3ff)
                        : const Color(0xff0082c5),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ButtonOfAuth(
                    onPressed: () =>
                        context.read<NursesBloc>().add(FetchNurses()),
                    fontcolor: isDark
                        ? AppColors.textLight
                        : AppColors.textDark,
                    buttoncolor: isDark
                        ? const Color(0xff62f3ff)
                        : const Color(0xff0082c5),
                    buttonText: "Try Again",
                  ),
                ),
              ],
            ),
          );
        }

        // 2. فحص حالة البيانات (جاهزة أم لا)
        final bool isReady = state is NursesLoaded;
        // نعتبر الـ Initial والـ Loading حالة تحميل بالنسبة للواجهة
        final bool isLoading = state is NursesLoading || state is NursesInitial;

        // تجهيز القائمة: بيانات حقيقية أو كروت وهمية للـ Skeletonizer
        final List<Nurse> nursesList = isReady
            ? state.filteredNurses
            : List.generate(
                6,
                (index) => Nurse(
                  id: "loading",
                  name: "Nurse Full Name Placeholder",
                  city: "City Name",
                  visitFee: 0,
                  hourPrice: 0,
                  rating: 0,
                  ratingsCount: 0,
                  profilePictureUrl: '',
                ),
              );

        return Skeletonizer(
          enabled: isLoading,
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<NursesBloc>().add(RefreshNurses());
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // زر الفلترة
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: CustomFilterButton(
                        isSelected: isFilterd,
                        inactiveText: "Filter Nurses",
                        onTap: () => setState(() => isFilterd = !isFilterd),
                        activeLightColor: const Color(0xff0082c5),
                        activeDarkColor: const Color(0xff62f3ff),
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 10)),

                // واجهة البحث
                SliverAnimatedOpacity(
                  opacity: isFilterd ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 400),
                  sliver: isFilterd
                      ? SliverToBoxAdapter(
                          child: SearchForNurseAndLab(
                            key: const PageStorageKey(
                              'nurse_search_unique_key',
                            ),
                            medicalStaff: MedicalStaff.nurse,
                            onFilterChanged: (name, specialty, selectedCity) {
                              context.read<NursesBloc>().add(
                                FilterNurses(
                                  name: name,
                                  cityName: selectedCity,
                                ),
                              );
                            },
                          ),
                        )
                      : const SliverToBoxAdapter(child: SizedBox.shrink()),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 10)),

                // عرض النتائج أو رسالة "لا يوجد"
                if (isReady && nursesList.isEmpty)
                  const SliverFillRemaining(
                    child: Center(
                      child: Text('No Nurses found matching your search.'),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        // مؤشر التحميل السفلي للـ Pagination
                        if (isReady && index == nursesList.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xff0082c5),
                              ),
                            ),
                          );
                        }

                        final nurse = nursesList[index];
                        return UniversalMedicalCard(
                          provider: nurse as HealthcareProvider,
                        );
                      },
                      // تحديد عدد العناصر بناءً على الحالة
                      childCount: isReady
                          ? (nursesList.length + (state.isLoadingMore ? 1 : 0))
                          : nursesList.length,
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 150)),
              ],
            ),
          ),
        );
      },
    );
  }
}
