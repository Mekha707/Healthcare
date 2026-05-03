// ignore_for_file: unused_local_variable, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcareapp_try1/API/user_service.dart';
import 'package:healthcareapp_try1/Bloc/Appointment_details_/appointment_details_cubit.dart';
import 'package:healthcareapp_try1/Bloc/MyBookingBloc/mybooking_cubit.dart';
import 'package:healthcareapp_try1/Bloc/MyBookingBloc/mybooking_state.dart';
import 'package:healthcareapp_try1/Bloc/NavigationBloc/navigation_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/DoctorBloc/doctor_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/DoctorBloc/doctor_event.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/DoctorBloc/doctor_state.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/SpecialtyBloc/specialty_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/SpecialtyBloc/specialty_event.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/SpecialtyBloc/specialty_state.dart';
import 'package:healthcareapp_try1/Buttons/buttons.dart';
import 'package:healthcareapp_try1/Models/Booking_Models/appointment_model.dart';
import 'package:healthcareapp_try1/Models/Users_Models/doctor_model.dart';
import 'package:healthcareapp_try1/Models/Users_Models/specialty_model.dart';
import 'package:healthcareapp_try1/Pages/Booking/every_appointment_details_page.dart';
import 'package:healthcareapp_try1/Pages/Booking/my_booking_page.dart';
import 'package:healthcareapp_try1/Pages/Booking/universal_details_page.dart';
import 'package:healthcareapp_try1/Widgets/home_content_ourservices_card.dart';
import 'package:healthcareapp_try1/Widgets/homecontent_ai_powerd_magic.dart';
import 'package:healthcareapp_try1/Widgets/specialty_card.dart';
import 'package:healthcareapp_try1/core/extension/context_extension.dart';
import 'package:healthcareapp_try1/core/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomepageContentState();
}

class _HomepageContentState extends State<HomePageContent> {
  @override
  void initState() {
    super.initState();
    context.read<DoctorsBloc>().add(FetchDoctors());
    context.read<SpecialtyBloc>().add(LoadSpecialties());
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    if (!mounted || token.isEmpty) return;
    context.read<AppointmentsCubit>().getAllUserAppointments(token);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.width > 600;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(
            right: size.width * 0.05,
            left: size.width * 0.05,
            bottom: 60,
            top: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMainBanner(context, isTablet, size),

              const SizedBox(height: 30),

              _buildTomorrowAppointmentsCard(isTablet, isDark),
              const SizedBox(height: 30),

              _buildSectionHeader("Browse By Specialty", isTablet, null),
              const SizedBox(height: 20),

              _buildSpecialtyGrid(isDark),

              _buildAISymptomCheckerCard(size),

              const SizedBox(height: 30),

              _buildSectionHeader("Top Doctors", isTablet, () {
                context.read<NavigationBloc>().add(TabChanged(1));
              }),
              _buildSubText("Consult with our expert healthcare professionals"),
              const SizedBox(height: 15),

              // Top Doctors Card
              BlocBuilder<DoctorsBloc, DoctorsState>(
                builder: (context, state) {
                  if (state is DoctorsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is DoctorsLoaded) {
                    if (state.filteredDoctors.isEmpty) {
                      return const Text("No doctors found");
                    }

                    return _buildDoctorsList(state.filteredDoctors);
                  }

                  if (state is DoctorsError) {
                    return Text(
                      state.message,
                      style: TextStyle(color: Colors.red),
                    );
                  }

                  return const SizedBox();
                },
              ),

              const SizedBox(height: 15),

              _buildSectionHeader("0ur Services", isTablet, null),

              _buildSubText("Comprehensive healthcare solutions for you"),

              const SizedBox(height: 15),

              _buildServicesList(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- MAIN BANNER ----------------

  Widget _buildMainBanner(BuildContext context, bool isTablet, Size size) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Container(
        width: size.width > 800 ? 800 : double.infinity,
        padding: EdgeInsets.all(isTablet ? 30.0 : 20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [AppColors.surfaceDark, AppColors.primaryDark]
                : [AppColors.primary, const Color(0xff7012ce)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Health, Our Priority",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cotta',
              ),
            ),
            const SizedBox(height: 10),

            Text(
              "Access quality healthcare from the comfort of your home. Book appointments, consult with specialists, and get AI-powered health insights.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFamily: 'Agency',
              ),
            ),

            const SizedBox(height: 20),

            HomeContentPurpuleCardButton(
              icon: Icons.calendar_today_rounded,
              buttonText: 'Book Appointment',
              foreColor: isDark ? AppColors.textDark : AppColors.primary,
              backColor: isDark
                  ? AppColors.surfaceDark
                  : AppColors.surfaceLight,
              onpressed: () =>
                  context.read<NavigationBloc>().add(TabChanged(1)),
            ),

            const SizedBox(height: 10),

            HomeContentPurpuleCardButton(
              icon: FontAwesomeIcons.robot,
              buttonText: 'Try AI Sympotom Checker ',
              foreColor: isDark ? AppColors.textDark : AppColors.primary,
              backColor: isDark
                  ? AppColors.surfaceDark
                  : AppColors.surfaceLight,
              onpressed: () =>
                  context.read<NavigationBloc>().add(TabChanged(2)),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- SECTION HEADER ----------------

  Widget _buildSectionHeader(
    String title,
    bool isTablet,
    VoidCallback? onSeeAll,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: Text(
              "See All",
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.textDark
                    : Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  // ---------------- SUB TEXT ----------------

  Widget _buildSubText(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
      ),
    );
  }

  Widget _buildTomorrowAppointmentsCard(bool isTablet, bool isDark) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final cardColor = isDark ? AppColors.surfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.blue.shade200.withOpacity(0.18)
        : const Color(0xff0861dd).withOpacity(0.12);
    final iconBg = isDark
        ? Colors.blue.shade300.withOpacity(0.15)
        : const Color(0xffe9f3ff);
    final subtleText = isDark
        ? AppColors.textDark.withOpacity(0.72)
        : AppColors.textLight.withOpacity(0.7);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.16 : 0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: BlocBuilder<AppointmentsCubit, AppointmentsState>(
        builder: (context, state) {
          final tomorrowAppointments = state is AppointmentsSuccess
              ? _getTomorrowAppointments(state.data)
              : <AppointmentModel>[];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.event_available_outlined,
                      color: isDark ? Colors.blue.shade200 : AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tomorrow's Appointments",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('EEEE, dd MMM').format(tomorrow),
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: subtleText),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MyBookingPage()),
                      );
                    },
                    child: Text(
                      "View all",
                      style: TextStyle(color: subtleText),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              if (state is AppointmentsLoading)
                const Center(child: LinearProgressIndicator(color: Colors.grey))
              else if (tomorrowAppointments.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.bgDark.withOpacity(0.45)
                        : const Color(0xfff7f9fc),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: subtleText,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "No appointments scheduled for tomorrow.",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: subtleText),
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
                ...tomorrowAppointments
                    .take(3)
                    .map((item) => _buildAppointmentPreviewTile(item, isDark)),
                if (tomorrowAppointments.length > 3) ...[
                  const SizedBox(height: 8),
                  Text(
                    "+${tomorrowAppointments.length - 3} more appointments tomorrow",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: subtleText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ],
          );
        },
      ),
    );
  }

  List<AppointmentModel> _getTomorrowAppointments(
    List<AppointmentModel> items,
  ) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return items.where((item) {
      final parsedDate = _parseAppointmentDate(item.date, item.time);
      if (parsedDate == null) return false;
      return parsedDate.year == tomorrow.year &&
          parsedDate.month == tomorrow.month &&
          parsedDate.day == tomorrow.day;
    }).toList()..sort((a, b) {
      final first = _parseAppointmentDate(a.date, a.time);
      final second = _parseAppointmentDate(b.date, b.time);
      if (first == null || second == null) return 0;
      return first.compareTo(second);
    });
  }

  DateTime? _parseAppointmentDate(String date, String time) {
    final normalizedDate = date.trim();
    final normalizedTime = time.trim();

    final directDate = DateTime.tryParse(normalizedDate);
    if (directDate != null) {
      final merged = _mergeDateAndTime(directDate, normalizedTime);
      return merged ?? directDate;
    }

    for (final pattern in ['yyyy-MM-dd', 'dd/MM/yyyy', 'MM/dd/yyyy']) {
      try {
        final parsed = DateFormat(pattern).parseStrict(normalizedDate);
        final merged = _mergeDateAndTime(parsed, normalizedTime);
        return merged ?? parsed;
      } catch (_) {}
    }

    return null;
  }

  DateTime? _mergeDateAndTime(DateTime date, String time) {
    if (time.isEmpty) return date;

    for (final pattern in ['HH:mm:ss', 'HH:mm', 'h:mm a']) {
      try {
        final parsedTime = DateFormat(pattern).parseStrict(time);
        return DateTime(
          date.year,
          date.month,
          date.day,
          parsedTime.hour,
          parsedTime.minute,
          parsedTime.second,
        );
      } catch (_) {}
    }

    return date;
  }

  Widget _buildAppointmentPreviewTile(AppointmentModel item, bool isDark) {
    final subtleText = isDark
        ? AppColors.textDark.withOpacity(0.72)
        : AppColors.textLight.withOpacity(0.72);
    final chipColor = _statusColor(item.status);
    final itemBg = isDark
        ? AppColors.bgDark.withOpacity(0.4)
        : const Color(0xfff7f9fc);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) =>
                  AppointmentDetailsCubit(UserService())
                    ..fetchDetails(item.id, item.type),
              child: const AppointmentDetailsPage(),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: itemBg,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            ClipOval(
              child: item.providerImage.isNotEmpty
                  ? Image.network(
                      item.providerImage,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => CircleAvatar(
                        radius: 24,
                        backgroundColor: chipColor.withOpacity(0.12),
                        child: Icon(Icons.person_outline, color: chipColor),
                      ),
                      loadingBuilder: (_, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return CircleAvatar(
                          radius: 24,
                          backgroundColor: chipColor.withOpacity(0.12),
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: chipColor,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                    )
                  : CircleAvatar(
                      radius: 24,
                      backgroundColor: chipColor.withOpacity(0.12),
                      child: Icon(Icons.person_outline, color: chipColor),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.providerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${item.type} • ${item.specialty ?? item.serviceType}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: subtleText),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time, size: 14, color: subtleText),
                    const SizedBox(width: 4),
                    Text(
                      item.time,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: subtleText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: chipColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    item.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
      case 'canceled':
        return Colors.redAccent;
      default:
        return Colors.orange;
    }
  }

  // ---------------- SPECIALTY GRID ----------------

  Widget _buildSpecialtyGrid(bool isDark) {
    return BlocBuilder<SpecialtyBloc, SpecialtyState>(
      builder: (context, state) {
        if (state is SpecialtyLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SpecialtyError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is SpecialtyLoaded) {
          final specialties = state.specialties;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: specialties.length > 9 ? 9 : specialties.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 1,
              mainAxisSpacing: 20,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final item = specialties[index];

              return SpecialtyCard(
                isDark: isDark,
                icon: item.icon,
                specialtyName: item.name,
                iconColor: item.color,
                backGroundColor: isDark
                    ? item.color.withOpacity(0.15)
                    : item.color.withOpacity(0.1),
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }

  // ---------------- AI CARD ----------------

  Widget _buildAISymptomCheckerCard(Size size) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : const Color(0xfff2f5fe),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.robot,
                color: isDark ? AppColors.surfaceLight : AppColors.primary,
              ),
              const SizedBox(width: 15),
              Text(
                "AI Symptom Checker",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),

          const SizedBox(height: 15),

          HomeContentAIPowerdmagicWithText(
            magicText: 'Instant symptom analysis',
            isDark: isDark,
          ),
          const SizedBox(height: 8),

          HomeContentAIPowerdmagicWithText(
            magicText: 'Recommended specialists',
            isDark: isDark,
          ),
          const SizedBox(height: 8),

          HomeContentAIPowerdmagicWithText(
            magicText: '24/7 availability',
            isDark: isDark,
          ),

          const SizedBox(height: 15),

          HomeContentPurpuleCardButton(
            icon: Icons.bolt,
            buttonText: "Check Now",
            onpressed: () {
              context.read<NavigationBloc>().add(TabChanged(2));
            },
            foreColor: AppColors.bgLight,
            backColor: isDark ? AppColors.bgDark : AppColors.primary,
          ),
        ],
      ),
    );
  }

  // ---------------- SERVICES ----------------

  Widget _buildServicesList() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        HomeContentOurServiceCard(
          iconColor: Color(0xff26b0ff),
          title: "Easy Booking",
          isDark: isDark,
          description: "Book appointments with top doctors instantly.",
          icon: FontAwesomeIcons.calendar,
          onpressed: () {
            context.read<NavigationBloc>().add(TabChanged(1));
          },
        ),
        const SizedBox(height: 10),

        HomeContentOurServiceCard(
          iconColor: const Color(0xffd100ff),
          title: "AI Health Assistant",
          isDark: isDark,
          description: "24/7 AI-powered health insights.",
          icon: FontAwesomeIcons.robot,
          onpressed: () {
            context.read<NavigationBloc>().add(TabChanged(2));
          },
        ),
        const SizedBox(height: 10),
        HomeContentOurServiceCard(
          iconColor: Colors.lightGreen,
          title: "Health Community",
          isDark: isDark,

          description:
              "Connect with healthcare professionals and get expert advice on health topics.",
          icon: FontAwesomeIcons.message,
          onpressed: () {
            context.read<NavigationBloc>().add(TabChanged(3));
          },
        ),
      ],
    );
  }

  // Top Doctor
  Widget _buildDoctorsList(List doctors) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProviderDetailsPage(
                    provider: doctor,
                    selectedServiceType: 'Clinic Visit',
                  ),
                ),
              );
            },
            child: Container(
              width: 160,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    child: ClipOval(
                      child: doctor.profilePictureUrl.isNotEmpty
                          ? Image.network(
                              doctor.profilePictureUrl,
                              fit: BoxFit.cover,
                              width: 56,
                              height: 56,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.person, size: 30),
                            )
                          : const Icon(Icons.person, size: 30),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    doctor.name ?? "Doctor",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    doctor.specialty ?? "Specialist",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.star, size: 14, color: Colors.amber),
                          SizedBox(width: 3),
                          Text("4.8", style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 12,
                        color: isDark ? Colors.white38 : Colors.grey.shade400,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
