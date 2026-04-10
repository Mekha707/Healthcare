// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:healthcareapp_try1/Bloc/User_Bloc/NurseBloc/nurse_bloc.dart';
// import 'package:healthcareapp_try1/Bloc/User_Bloc/NurseBloc/nurse_event.dart';
// import 'package:healthcareapp_try1/Bloc/User_Bloc/NurseBloc/nurse_state.dart';
// import 'package:healthcareapp_try1/Buttons/buttons.dart';
// import 'package:healthcareapp_try1/Buttons/filter_button.dart';
// import 'package:healthcareapp_try1/Models/Users_Models/enums.dart';
// import 'package:healthcareapp_try1/Pages/Booking/healtcare_provider.dart';
// import 'package:healthcareapp_try1/Widgets/custom_loader1.dart';
// import 'package:healthcareapp_try1/Widgets/medical_staff_cards.dart';
// import 'package:healthcareapp_try1/Widgets/search_for_medical_staff.dart';

// class NursePage extends StatefulWidget {
//   const NursePage({super.key});

//   @override
//   State<NursePage> createState() => _NursePage();
// }

// class _NursePage extends State<NursePage> {
//   final ScrollController _scrollController = ScrollController();
//   bool isFilterd = false;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);

//     // ✅ أضيف السطر ده
//     context.read<NursesBloc>().add(FetchNurses());
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _onScroll() {
//     final atBottom =
//         _scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent - 200;
//     if (atBottom) {
//       context.read<NursesBloc>().add(LoadMoreNurses());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<NursesBloc, NursesState>(
//       listener: (context, state) {},
//       builder: (context, state) {
//         if (state is NursesLoading) {
//           return const Center(
//             child: CustomSpinner(size: 40, color: Color(0xff0082c5)),
//           );
//         }

//         if (state is NursesError) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   state.message,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontFamily: 'ElMessiri',
//                     color: Color(0xff0082c5),
//                   ),
//                 ),
//                 const SizedBox(height: 12),

//                 ButtonOfAuth(
//                   onPressed: () =>
//                       context.read<NursesBloc>().add(FetchNurses()),
//                   fontcolor: Colors.grey.shade100,
//                   buttoncolor: Color(0xff0082c5),
//                   buttonText: "Try Again",
//                 ),
//               ],
//             ),
//           );
//         }

//         if (state is NursesLoaded) {
//           return RefreshIndicator(
//             onRefresh: () async {
//               context.read<NursesBloc>().add(RefreshNurses());
//             },
//             child: CustomScrollView(
//               controller: _scrollController,
//               slivers: [
//                 // 1. الزرار الـ 3D اللي حطيناه في Class منفصل
//                 CustomFilterButton(
//                   isSelected: isFilterd,
//                   inactiveText: "Filter Nurses",
//                   onTap: () {
//                     setState(() {
//                       isFilterd = !isFilterd;
//                     });
//                   },
//                   activeColor: Color(0xff0082c5),
//                 ),
//                 const SliverToBoxAdapter(child: SizedBox(height: 10)),

//                 // 2. الفلتر مع أنميشن الظهور
//                 SliverAnimatedOpacity(
//                   opacity: isFilterd ? 1.0 : 0.0,
//                   duration: const Duration(milliseconds: 400),
//                   sliver: isFilterd
//                       ? SliverToBoxAdapter(
//                           child: SearchForNurseAndLab(
//                             key: const PageStorageKey(
//                               'nurse_search_unique_key',
//                             ),
//                             medicalStaff: MedicalStaff.nurse,
//                             // ignore: no_leading_underscores_for_local_identifiers
//                             onFilterChanged: (name, specialty, _selectedCity) {
//                               context.read<NursesBloc>().add(
//                                 FilterNurses(
//                                   name: name,
//                                   cityName: _selectedCity,
//                                 ),
//                               );
//                             },
//                           ),
//                         )
//                       : const SliverToBoxAdapter(child: SizedBox.shrink()),
//                 ),

//                 const SliverToBoxAdapter(child: SizedBox(height: 10)),
//                 state.filteredNurses.isEmpty
//                     ? const SliverFillRemaining(
//                         child: Center(
//                           child: Text('No Nurses found matching your search.'),
//                         ),
//                       )
//                     : SliverList(
//                         delegate: SliverChildBuilderDelegate(
//                           (context, index) {
//                             if (index == state.filteredNurses.length) {
//                               return const Center(
//                                 child: Padding(
//                                   padding: EdgeInsets.all(16),
//                                   child: CustomSpinner(
//                                     size: 40,
//                                     color: Color(0xff0082c5),
//                                   ),
//                                 ),
//                               );
//                             }
//                             final nurse = state.filteredNurses[index];

//                             return UniversalMedicalCard(
//                               provider: nurse as HealthcareProvider,
//                             );
//                           },
//                           childCount:
//                               state.filteredNurses.length +
//                               (state.isLoadingMore ? 1 : 0),
//                         ),
//                       ),
//                 const SliverToBoxAdapter(child: SizedBox(height: 150)),
//               ],
//             ),
//           );
//         }

//         return const SizedBox();
//       },
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Models/Users_Models/nurse_model.dart';
import 'package:healthcareapp_try1/Widgets/medical_staff_cards.dart';
import 'package:healthcareapp_try1/Widgets/search_for_medical_staff.dart';
import 'package:skeletonizer/skeletonizer.dart'; // ✅ تأكد من إضافة المكتبة
import 'package:healthcareapp_try1/Bloc/User_Bloc/NurseBloc/nurse_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/NurseBloc/nurse_event.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/NurseBloc/nurse_state.dart';
import 'package:healthcareapp_try1/Buttons/buttons.dart';
import 'package:healthcareapp_try1/Buttons/filter_button.dart';
import 'package:healthcareapp_try1/Models/Users_Models/enums.dart';
import 'package:healthcareapp_try1/Pages/Booking/healtcare_provider.dart';
// استورد الـ NurseModel الخاص بك هنا (تأكد من المسار الصحيح)
// import 'package:healthcareapp_try1/Models/nurse_model.dart';

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
    return BlocConsumer<NursesBloc, NursesState>(
      listener: (context, state) {},
      builder: (context, state) {
        // --- 1. معالجة حالة الخطأ ---
        if (state is NursesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.message,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'ElMessiri',
                    color: Color(0xff0082c5),
                  ),
                ),
                const SizedBox(height: 12),
                ButtonOfAuth(
                  onPressed: () =>
                      context.read<NursesBloc>().add(FetchNurses()),
                  fontcolor: Colors.grey.shade100,
                  buttoncolor: const Color(0xff0082c5),
                  buttonText: "Try Again",
                ),
              ],
            ),
          );
        }

        // --- 2. إعداد بيانات الـ Skeletonizer ---
        final bool isLoading = state is NursesLoading;

        // إنشاء قائمة وهمية باستخدام الموديل الحقيقي بتاعك
        final List<dynamic> nursesList = isLoading
            ? List.generate(
                6,
                (index) => Nurse(
                  id: "loading",
                  name: "Nurse Full Name Placeholder", // نص طويل للـ Shimmer
                  city: "City Name",
                  visitFee: 0,
                  hourPrice: 0,
                  rating: 0,
                  ratingsCount: 0,
                  profilePictureUrl: '',
                  // أضف أي حقول Required في الموديل عندك ببيانات وهمية
                ),
              )
            : (state as NursesLoaded).filteredNurses;

        return Skeletonizer(
          enabled: isLoading,
          // يمكنك تخصيص التأثير ليكون ناعم أكثر
          effect: ShimmerEffect(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            duration: const Duration(milliseconds: 1000),
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<NursesBloc>().add(RefreshNurses());
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // زر الفلتر
                CustomFilterButton(
                  isSelected: isFilterd,
                  inactiveText: "Filter Nurses",
                  onTap: () => setState(() => isFilterd = !isFilterd),
                  activeColor: const Color(0xff0082c5),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 10)),

                // قائمة البحث (تظهر وتختفي بأنيميشن)
                SliverAnimatedOpacity(
                  opacity: isFilterd ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 400),
                  sliver: isFilterd
                      ? SliverToBoxAdapter(
                          child: SearchForNurseAndLab(
                            key: const PageStorageKey('nurse_search_key'),
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

                // القائمة الأساسية
                (state is NursesLoaded &&
                        state.filteredNurses.isEmpty &&
                        !isLoading)
                    ? const SliverFillRemaining(
                        child: Center(
                          child: Text('No Nurses found matching your search.'),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            // منطق الـ Pagination (تحميل المزيد)
                            if (!isLoading && index == nursesList.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
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
                          // عدد العناصر: لو بيحمل اظهر 6 كروت هيكلية، لو خلص اظهر القائمة + لودر لو فيه صفحة تانية
                          childCount: isLoading
                              ? 6
                              : (state as NursesLoaded).filteredNurses.length +
                                    (state.isLoadingMore ? 1 : 0),
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
