// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:healthcareapp_try1/Bloc/User_Bloc/LabBloc/lab_bloc.dart';
// import 'package:healthcareapp_try1/Bloc/User_Bloc/LabBloc/lab_event.dart';
// import 'package:healthcareapp_try1/Bloc/User_Bloc/LabBloc/lab_state.dart';
// import 'package:healthcareapp_try1/Buttons/buttons.dart';
// import 'package:healthcareapp_try1/Buttons/filter_button.dart';
// import 'package:healthcareapp_try1/Models/Users_Models/enums.dart';
// import 'package:healthcareapp_try1/Pages/Booking/healtcare_provider.dart';
// import 'package:healthcareapp_try1/Widgets/custom_loader1.dart';
// import 'package:healthcareapp_try1/Widgets/medical_staff_cards.dart';
// import 'package:healthcareapp_try1/Widgets/search_for_medical_staff.dart';

// class LabPage extends StatefulWidget {
//   const LabPage({super.key});

//   @override
//   State<LabPage> createState() => _LabPageState();
// }

// class _LabPageState extends State<LabPage> {
//   final ScrollController _scrollController = ScrollController();
//   bool isFilterd = false;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);
//     context.read<LabsBloc>().add(FetchLabs());
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
//       context.read<LabsBloc>().add(LoadMoreLabs());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // لاحظي هنا: لم نعد نغلف الشاشة كلها بـ BlocConsumer
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       // أضفت Scaffold للتأكد من الخلفية
//       body: RefreshIndicator(
//         onRefresh: () async {
//           context.read<LabsBloc>().add(RefreshLabs());
//         },
//         child: CustomScrollView(
//           controller: _scrollController,
//           slivers: [
//             // زر الفلتر يظل يستخدم setState لأنه يغير حالة local (isFilterd)
//             CustomFilterButton(
//               isSelected: isFilterd,
//               inactiveText: "Filter Labs",
//               onTap: () {
//                 setState(() {
//                   isFilterd = !isFilterd;
//                 });
//               },
//               activeColor: Colors.teal,
//             ),

//             // 1. الفلتر الآن "خارج" الـ BlocBuilder الخاص بالنتائج
//             // لن يتأثر بتغير الـ State بتاع الـ Bloc (إلا لو إنتِ عايزة كده)
//             SliverAnimatedOpacity(
//               opacity: isFilterd ? 1.0 : 0.0,
//               duration: const Duration(milliseconds: 400),
//               sliver: isFilterd
//                   ? SliverToBoxAdapter(
//                       child: SearchForNurseAndLab(
//                         medicalStaff: MedicalStaff.lab,
//                         onFilterChanged: (name, specialty, location) {
//                           // هنا نرسل الـ Event للـ Bloc فقط، ولا نحتاج لعمل setState في الـ Parent
//                           context.read<LabsBloc>().add(
//                             FilterLabs(name: name, location: location),
//                           );
//                         },
//                       ),
//                     )
//                   : const SliverToBoxAdapter(child: SizedBox.shrink()),
//             ),

//             const SliverToBoxAdapter(child: SizedBox(height: 10)),

//             // 2. هنا نضع الـ BlocBuilder فقط للجزء الذي يتغير فعلياً (القائمة)
//             BlocBuilder<LabsBloc, LabsState>(
//               builder: (context, state) {
//                 if (state is LabsLoading) {
//                   return const SliverFillRemaining(
//                     child: Center(
//                       child: CustomSpinner(size: 40, color: Colors.teal),
//                     ),
//                   );
//                 }

//                 if (state is LabsError) {
//                   return SliverFillRemaining(
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             state.message,
//                             style: const TextStyle(color: Colors.teal),
//                           ),
//                           const SizedBox(height: 12),
//                           ButtonOfAuth(
//                             onPressed: () =>
//                                 context.read<LabsBloc>().add(FetchLabs()),
//                             buttonText: "Try Again",
//                             fontcolor: Colors.white,
//                             buttoncolor: Colors.teal,
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }

//                 if (state is LabsLoaded) {
//                   if (state.filteredLabs.isEmpty) {
//                     return const SliverFillRemaining(
//                       child: Center(child: Text('لا توجد معامل مطابقة للبحث')),
//                     );
//                   }

//                   return SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                       (context, index) {
//                         if (index == state.filteredLabs.length) {
//                           return const Center(
//                             child: Padding(
//                               padding: EdgeInsets.all(16),
//                               child: CustomSpinner(
//                                 color: Colors.teal,
//                                 size: 40,
//                               ),
//                             ),
//                           );
//                         }
//                         final lab = state.filteredLabs[index];
//                         return UniversalMedicalCard(
//                           provider: lab as HealthcareProvider,
//                         );
//                       },
//                       childCount:
//                           state.filteredLabs.length +
//                           (state.isLoadingMore ? 1 : 0),
//                     ),
//                   );
//                 }
//                 return const SliverToBoxAdapter(child: SizedBox());
//               },
//             ),

//             const SliverToBoxAdapter(child: SizedBox(height: 150)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Models/Users_Models/lab_model.dart';
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
  // Widget build(BuildContext context) {
  //   return BlocBuilder<LabsBloc, LabsState>(
  //     builder: (context, state) {
  //       // 1. حالة الخطأ (Error)
  //       if (state is LabsError) {
  //         return Center(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text(
  //                 state.message,
  //                 style: const TextStyle(color: Colors.teal, fontSize: 16),
  //               ),
  //               const SizedBox(height: 12),
  //               ButtonOfAuth(
  //                 onPressed: () => context.read<LabsBloc>().add(FetchLabs()),
  //                 buttonText: "Try Again",
  //                 fontcolor: Colors.white,
  //                 buttoncolor: Colors.teal,
  //               ),
  //             ],
  //           ),
  //         );
  //       }
  //       // 2. تجهيز حالة التحميل (Loading) والبيانات
  //       final bool isLoading = state is LabsLoading;
  //       // هنا بنستخدم الـ LabModel الحقيقي بتاعك
  //       final List<dynamic> labsList = isLoading
  //           ? List.generate(
  //               5,
  //               (index) => LabModel(
  //                 id: "loading",
  //                 name:
  //                     "Laboratory Name Placeholder", // نص طويل شوية للـ Shimmer
  //                 address: '',
  //                 rating: 0,
  //                 ratingsCount: 0,
  //                 profilePictureUrl: '',
  //                 // ضيف هنا أي حقول required تانية بيطلبها الـ LabModel بتاعك
  //               ),
  //             )
  //           : (state is LabsLoaded ? state.filteredLabs : []);
  //       // 3. تغليف الشاشة كلها بالـ Skeletonizer عشان زر الفلتر يختفي (يظهر مكانه لمعان)
  //       return Skeletonizer(
  //         enabled: isLoading,
  //         child: RefreshIndicator(
  //           onRefresh: () async {
  //             context.read<LabsBloc>().add(RefreshLabs());
  //           },
  //           child: CustomScrollView(
  //             controller: _scrollController,
  //             slivers: [
  //               // زر الفلتر (هيظهر عليه تأثير اللمعان لأنه جزء من الـ Skeletonizer)
  //               CustomFilterButton(
  //                 isSelected: isFilterd,
  //                 inactiveText: "Filter Labs",
  //                 onTap: () {
  //                   setState(() {
  //                     isFilterd = !isFilterd;
  //                   });
  //                 },
  //                 activeColor: Colors.teal,
  //               ),
  //               const SliverToBoxAdapter(child: SizedBox(height: 10)),
  //               // قائمة البحث
  //               SliverAnimatedOpacity(
  //                 opacity: isFilterd ? 1.0 : 0.0,
  //                 duration: const Duration(milliseconds: 400),
  //                 sliver: isFilterd
  //                     ? SliverToBoxAdapter(
  //                         child: SearchForNurseAndLab(
  //                           medicalStaff: MedicalStaff.lab,
  //                           initialTestIds: _initialTestIds,
  //                           onFilterChanged: (name, specialty, location) {
  //                             context.read<LabsBloc>().add(
  //                               FilterLabs(name: name, location: location),
  //                             );
  //                           },
  //                         ),
  //                       )
  //                     : const SliverToBoxAdapter(child: SizedBox.shrink()),
  //               ),
  //               const SliverToBoxAdapter(child: SizedBox(height: 10)),
  //               // قائمة النتائج أو رسالة "لا يوجد"
  //               (!isLoading && labsList.isEmpty)
  //                   ? const SliverFillRemaining(
  //                       child: Center(
  //                         child: Text('لا توجد معامل مطابقة للبحث'),
  //                       ),
  //                     )
  //                   : SliverList(
  //                       delegate: SliverChildBuilderDelegate(
  //                         (context, index) {
  //                           // منطق تحميل المزيد (Pagination)
  //                           if (!isLoading && index == labsList.length) {
  //                             return const Center(
  //                               child: Padding(
  //                                 padding: EdgeInsets.all(16),
  //                                 child: CircularProgressIndicator(
  //                                   color: Colors.teal,
  //                                 ),
  //                               ),
  //                             );
  //                           }
  //                           final lab = labsList[index];
  //                           return UniversalMedicalCard(
  //                             provider: lab as HealthcareProvider,
  //                             initialTestIds: _initialTestIds,
  //                           );
  //                         },
  //                         // لو بيحمل اظهر 5 كروت، لو خلص اظهر العدد الحقيقي + 1 للودر لو متاح
  //                         childCount: isLoading
  //                             ? 5
  //                             : labsList.length +
  //                                   (state is LabsLoaded && state.isLoadingMore
  //                                       ? 1
  //                                       : 0),
  //                       ),
  //                     ),
  //               const SliverToBoxAdapter(child: SizedBox(height: 150)),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    // لاحظ: الـ Scaffold والـ Search Widget خارج الـ BlocBuilder الرئيسي للنتائج
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: RefreshIndicator(
        onRefresh: () async => context.read<LabsBloc>().add(RefreshLabs()),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // 1. زر الفلتر - ثابت لا يتأثر بالـ Loading
            CustomFilterButton(
              isSelected: isFilterd,
              inactiveText: "Filter Labs",
              onTap: () => setState(() => isFilterd = !isFilterd),
              activeColor: Colors.teal,
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 10)),

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
            const SliverToBoxAdapter(child: SizedBox(height: 150)),
          ],
        ),
      ),
    );
  }
}
