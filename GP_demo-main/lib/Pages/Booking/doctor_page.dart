import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Models/Users_Models/doctor_model.dart';
import 'package:skeletonizer/skeletonizer.dart';
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
    // نطلب البيانات عند الدخول للصفحة
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
        // 1. حالة الخطأ - نعرض واجهة الخطأ فوراً
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

        // 2. إدارة الحالات (التحميل vs البيانات الجاهزة)
        // الحالة تكون جاهزة فقط إذا كانت DoctorsLoaded
        final bool isReady = state is DoctorsLoaded;
        final bool isLoading =
            state is DoctorsLoading || state is DoctorsInitial;

        // تجهيز القائمة: إذا كانت جاهزة نأخذ البيانات، وإلا ننشئ بيانات وهمية للـ Skeletonizer
        final List<Doctor> doctorsList = isReady
            ? state.filteredDoctors
            : List.generate(
                5,
                (index) => Doctor(
                  id: 'loading',
                  name: 'Doctor Name Placeholder',
                  specialty: 'Medical Specialty',
                  profilePictureUrl: '',
                  title: 'Specialist',
                  address: 'Street Address, City',
                  fee: 0,
                  rating: 0,
                  ratingsCount: 0,
                  allowHome: false,
                  allowOnline: false,
                ),
              );

        return Skeletonizer(
          enabled: isLoading,
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<DoctorsBloc>().add(RefreshDoctors());
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // زر الفلترة
                CustomFilterButton(
                  isSelected: isFilterd,
                  onTap: () => setState(() => isFilterd = !isFilterd),
                  activeColor: const Color(0xff131ab9),
                ),

                // قسم البحث (يظهر ويختفي بالأنيميشن)
                SliverAnimatedOpacity(
                  opacity: isFilterd ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 400),
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

                // عرض النتائج
                if (isReady && doctorsList.isEmpty)
                  const SliverFillRemaining(
                    child: Center(
                      child: Text('No doctors found matching your search.'),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        // عرض مؤشر التحميل في الأسفل عند الـ Pagination
                        if (isReady && index == doctorsList.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final doctor = doctorsList[index];
                        return UniversalMedicalCard(
                          // التأكد من عمل Cast للموديل إذا كان الـ Card يتوقع HealthcareProvider
                          provider: doctor as HealthcareProvider,
                        );
                      },
                      // تحديد عدد العناصر بدقة لتجنب الـ RangeError
                      childCount: isReady
                          ? (doctorsList.length + (state.isLoadingMore ? 1 : 0))
                          : doctorsList.length,
                    ),
                  ),

                // مساحة إضافية في الأسفل (مثلاً للـ Navigation Bar)
                const SliverToBoxAdapter(child: SizedBox(height: 150)),
              ],
            ),
          ),
        );
      },
    );
  }
}
