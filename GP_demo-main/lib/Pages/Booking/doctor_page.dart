// // ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Models/Users_Models/doctor_model.dart';
import 'package:skeletonizer/skeletonizer.dart'; // ✅ استيراد المكتبة
import 'package:healthcareapp_try1/Bloc/User_Bloc/DoctorBloc/doctor_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/DoctorBloc/doctor_event.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/DoctorBloc/doctor_state.dart';
import 'package:healthcareapp_try1/Buttons/buttons.dart';
import 'package:healthcareapp_try1/Buttons/filter_button.dart';
import 'package:healthcareapp_try1/Pages/Booking/healtcare_provider.dart';
import 'package:healthcareapp_try1/Widgets/medical_staff_cards.dart';
import 'package:healthcareapp_try1/Widgets/search_for_medical_staff.dart';

class DoctorPage extends StatefulWidget {
  const DoctorPage({super.key});

  @override
  State<DoctorPage> createState() => _DoctorPage();
}

class _DoctorPage extends State<DoctorPage> {
  final ScrollController _scrollController = ScrollController();
  bool isFilterd = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<DoctorsBloc>().add(FetchDoctors());
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
      context.read<DoctorsBloc>().add(LoadMoreDoctors());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorsBloc, DoctorsState>(
      listener: (context, state) {},
      builder: (context, state) {
        // 1. حالة الخطأ (Error)
        if (state is DoctorsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.message,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'ElMessiri',
                    color: Color(0xff131ab9),
                  ),
                ),
                const SizedBox(height: 12),
                ButtonOfAuth(
                  onPressed: () =>
                      context.read<DoctorsBloc>().add(FetchDoctors()),
                  fontcolor: Colors.grey.shade100,
                  buttoncolor: const Color(0xff131ab9),
                  buttonText: "Try Again",
                ),
              ],
            ),
          );
        }

        // 2. استخدام Skeletonizer في حالتي التحميل الأولي (DoctorsLoading) أو وجود البيانات (DoctorsLoaded)
        // الفكرة هنا أننا نمرر بيانات "وهمية" للـ Skeletonizer أثناء التحميل
        final isLoading = state is DoctorsLoading;

        // إذا كان يحمل، نستخدم قائمة وهمية، وإذا انتهى نستخدم القائمة الحقيقية
        final doctorsList = isLoading
            ? List.generate(
                5,
                (index) => Doctor(
                  id: 'loading',
                  name: 'Doctor Name Placeholder', // نص وهمي
                  specialty: 'Specialty',
                  profilePictureUrl: '',
                  title: '',
                  address: '',
                  fee: 0,
                  rating: 0,
                  ratingsCount: 0,
                  allowHome: false,
                  allowOnline: false, // سيبه فاضي والـ Skeletonizer هيتعامل
                  // باقي الحقول المطلوبة في الـ Constructor بتاعك...
                ),
              )
            : (state as DoctorsLoaded).filteredDoctors;

        return Skeletonizer(
          enabled: isLoading, // ✅ يعمل الهيكل فقط عندما تكون الحالة Loading
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<DoctorsBloc>().add(RefreshDoctors());
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                CustomFilterButton(
                  isSelected: isFilterd,
                  onTap: () => setState(() => isFilterd = !isFilterd),
                  activeColor: const Color(0xff131ab9),
                ),

                SliverAnimatedOpacity(
                  opacity: isFilterd ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 800),
                  sliver: isFilterd
                      ? SliverToBoxAdapter(
                          child: SearchForDoctor(
                            onFilterChanged:
                                (name, specialty, location, serviceType) {
                                  context.read<DoctorsBloc>().add(
                                    FilterDoctors(
                                      name: name,
                                      specialtyId: specialty?.id,
                                      cityName: location,
                                      serviceType: serviceType.toString(),
                                    ),
                                  );
                                },
                          ),
                        )
                      : const SliverToBoxAdapter(child: SizedBox.shrink()),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 10)),

                // عرض النتائج أو رسالة "لا يوجد"
                (!isLoading && doctorsList.isEmpty)
                    ? const SliverFillRemaining(
                        child: Center(
                          child: Text('No doctors found matching your search.'),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            // التعامل مع الـ Load More
                            if (!isLoading && index == doctorsList.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final doctor = doctorsList[index];
                            return UniversalMedicalCard(
                              provider: doctor as HealthcareProvider,
                            );
                          },
                          childCount: isLoading
                              ? 5 // عدد الكروت الوهمية أثناء التحميل
                              : doctorsList.length +
                                    ((state as DoctorsLoaded).isLoadingMore
                                        ? 1
                                        : 0),
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
