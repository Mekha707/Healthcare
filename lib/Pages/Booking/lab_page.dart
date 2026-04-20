// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Models/Users_Models/lab_model.dart';
import 'package:healthcareapp_try1/Widgets/medical_error_widget.dart';
import 'package:healthcareapp_try1/Widgets/medical_staff_cards.dart';
import 'package:healthcareapp_try1/Widgets/search_for_medical_staff.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/LabBloc/lab_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/LabBloc/lab_event.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/LabBloc/lab_state.dart';
import 'package:healthcareapp_try1/Buttons/filter_button.dart';
import 'package:healthcareapp_try1/Models/Users_Models/enums.dart';
import 'package:healthcareapp_try1/Pages/Booking/healtcare_provider.dart';
// تأكد من استيراد الموديل بتاعك هنا
// import 'package:healthcareapp_try1/Models/lab_model.dart';

class LabPage extends StatefulWidget {
  const LabPage({super.key, this.initialTestIds = const []});
  final List<String> initialTestIds;
  @override
  State<LabPage> createState() => _LabPageState();
}

class _LabPageState extends State<LabPage> {
  final ScrollController _scrollController = ScrollController();
  bool isFilterd = false;
  late List<String> _initialTestIds;

  @override
  void initState() {
    super.initState();
    _initialTestIds = widget.initialTestIds; // ✅
    _scrollController.addListener(_onScroll);

    // ✅ لو في testIds افتح الفلتر تلقائياً وابعت الفلتر

    if (_initialTestIds.isNotEmpty) {
      isFilterd = true; // ✅ افتح الفلتر تلقائياً
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<LabsBloc>().add(
          FilterLabs(testIds: _initialTestIds), // ✅ بس الفلتر من غير FetchLabs
        );
      });
    } else {
      context.read<LabsBloc>().add(FetchLabs()); // ✅ عادي من غير فلتر
    }
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
      context.read<LabsBloc>().add(LoadMoreLabs());
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    // لاحظ: الـ Scaffold والـ Search Widget خارج الـ BlocBuilder الرئيسي للنتائج
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () async => context.read<LabsBloc>().add(RefreshLabs()),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              sliver: SliverToBoxAdapter(
                child: CustomFilterButton(
                  isSelected: isFilterd,
                  inactiveText: "Filter Labs",
                  onTap: () => setState(() => isFilterd = !isFilterd),
                  activeLightColor: Colors.teal,
                  activeDarkColor: const Color(0xfffcb0db),
                ),
              ),
            ),

            // 2. الفلتر - ثابت ومفتوح دائماً طالما isFilterd بـ true
            // لا نضعه داخل BlocBuilder للـ Labs عشان ميرمش
            SliverAnimatedOpacity(
              opacity: isFilterd ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 400),
              sliver: isFilterd
                  ? SliverToBoxAdapter(
                      child: SearchForNurseAndLab(
                        medicalStaff: MedicalStaff.lab,
                        initialTestIds: _initialTestIds,
                        onFilterChanged: (name, specialty, location) {
                          context.read<LabsBloc>().add(
                            FilterLabs(
                              name: name,
                              location: location,
                              testIds: _initialTestIds,
                            ),
                          );
                        },
                      ),
                    )
                  : const SliverToBoxAdapter(child: SizedBox.shrink()),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 10)),

            // 3. هنا فقط نضع الـ BlocBuilder والـ Skeletonizer للنتائج
            BlocBuilder<LabsBloc, LabsState>(
              builder: (context, state) {
                final bool isLoading = state is LabsLoading;

                // ⭐ هنا مكان الخطأ
                if (state is LabsError) {
                  return SliverFillRemaining(
                    child: MedicalErrorWidget(
                      message: state.message,
                      isDark: Theme.of(context).brightness == Brightness.dark,
                      onRetry: () {
                        context.read<LabsBloc>().add(FetchLabs());
                      },
                      darkColor: Color(0xfffcb0db),
                      lightColor: Colors.teal,
                    ),
                  );
                }

                // نجهز البيانات الوهمية فقط لو فعلاً مفيش بيانات سابقة
                final List<dynamic> labsList = (state is LabsLoaded)
                    ? state.filteredLabs
                    : (isLoading
                          ? List.generate(
                              5,
                              (i) => LabModel(
                                id: "loading",
                                name: "Loading...",
                                address: '',
                                rating: 0,
                                ratingsCount: 0,
                                profilePictureUrl: '',
                              ),
                            )
                          : []);

                return Skeletonizer.sliver(
                  // نستخدم .sliver لأننا داخل CustomScrollView
                  enabled: isLoading,
                  child: labsList.isEmpty && !isLoading
                      ? const SliverFillRemaining(
                          child: Center(child: Text('لا توجد معامل مطابقة')),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (!isLoading &&
                                  state is LabsLoaded &&
                                  index == labsList.length) {
                                return state.isLoadingMore
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : const SizedBox();
                              }
                              final lab = labsList[index];
                              return UniversalMedicalCard(
                                provider: lab as HealthcareProvider,
                                initialTestIds: _initialTestIds,
                              );
                            },
                            childCount: isLoading
                                ? 5
                                : labsList.length +
                                      (state is LabsLoaded &&
                                              state.isLoadingMore
                                          ? 1
                                          : 0),
                          ),
                        ),
                );
              },
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 120,
              ), // مساحة كافية للتمرير فوق الـ Navigation Bar
            ),
          ],
        ),
      ),
    );
  }
}
