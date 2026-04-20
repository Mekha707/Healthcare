// ignore_for_file: deprecated_member_use, unnecessary_import, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import "package:flutter/cupertino.dart";
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/user_service.dart';
import 'package:healthcareapp_try1/Bloc/Appointment_details_/appointment_details_cubit.dart';
import 'package:healthcareapp_try1/Bloc/MyBookingBloc/mybooking_cubit.dart';
import 'package:healthcareapp_try1/Bloc/MyBookingBloc/mybooking_state.dart';
import 'package:healthcareapp_try1/Models/Booking_Models/appointment_model.dart';
import 'package:healthcareapp_try1/Pages/Booking/every_appointment_details_page.dart';
import 'package:healthcareapp_try1/Widgets/custom_tab_bar.dart';
import 'package:healthcareapp_try1/core/Theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyBookingPage extends StatefulWidget {
  const MyBookingPage({super.key});

  @override
  State<MyBookingPage> createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    context.read<AppointmentsCubit>().getAllUserAppointments(token);
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      height: 120,
      padding: const EdgeInsets.only(top: 40),
      width: double.infinity,
      color: isDark ? AppColors.primaryDark : const Color(0xff0861dd),
      child: const Center(
        child: Text(
          'My Bookings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cotta',
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonList(bool isDark) {
    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: isDark ? AppColors.surfaceDark : const Color(0xFFE0E0E0),
        highlightColor: isDark ? AppColors.bgDark : const Color(0xFFF5F5F5),
      ),
      child: ListView.builder(
        itemCount: 4,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        itemBuilder: (context, index) => _buildSkeletonCard(isDark),
      ),
    );
  }

  Widget _buildSkeletonCard(bool isDark) {
    final cardColor = isDark ? AppColors.surfaceDark : Colors.white;
    final skeletonColor = isDark
        ? AppColors.bgDark.withOpacity(0.85)
        : Colors.grey.shade100;
    final bottomColor = isDark
        ? AppColors.bgDark.withOpacity(0.45)
        : Colors.grey.shade50;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.withOpacity(0.25), width: 1.3),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(radius: 28, backgroundColor: skeletonColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 140,
                            height: 16,
                            decoration: BoxDecoration(
                              color: skeletonColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Container(
                            width: 70,
                            height: 24,
                            decoration: BoxDecoration(
                              color: skeletonColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 100,
                        height: 12,
                        decoration: BoxDecoration(
                          color: skeletonColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 12,
                            decoration: BoxDecoration(
                              color: skeletonColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 60,
                            height: 12,
                            decoration: BoxDecoration(
                              color: skeletonColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: bottomColor,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(18),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  height: 14,
                  decoration: BoxDecoration(
                    color: skeletonColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  width: 80,
                  height: 14,
                  decoration: BoxDecoration(
                    color: skeletonColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(
    List<AppointmentModel> list,
    Color statusColor,
    bool isDark,
  ) {
    final textPrimary = isDark ? AppColors.textDark : AppColors.textLight;
    final textSecondary = isDark
        ? AppColors.textDark.withOpacity(0.75)
        : AppColors.textLight.withOpacity(0.75);
    final cardColor = isDark ? AppColors.surfaceDark : Colors.white;
    final pageBg = isDark ? AppColors.bgDark : Colors.grey.shade50;
    final bottomSectionColor = isDark
        ? AppColors.bgDark.withOpacity(0.35)
        : Colors.grey.shade50;

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 60,
              color: textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 15),
            Text(
              "No bookings found",
              style: TextStyle(
                color: textSecondary,
                fontSize: 16,
                fontFamily: 'Agency',
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: list.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      itemBuilder: (context, index) {
        final item = list[index];

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
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: statusColor.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.18)
                      : Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: statusColor.withOpacity(0.25),
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: pageBg,
                          backgroundImage: item.providerImage.isNotEmpty
                              ? NetworkImage(item.providerImage)
                              : null,
                          child: item.providerImage.isEmpty
                              ? Icon(
                                  Icons.person,
                                  color: textSecondary,
                                  size: 26,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.providerName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: textPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item.status,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Agency',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  item.type == "Doctor"
                                      ? Icons.medical_services_outlined
                                      : item.type == "Nurse"
                                      ? Icons.person_outline
                                      : Icons.biotech_outlined,
                                  size: 14,
                                  color: textSecondary,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    "${item.type} - ${item.specialty ?? 'General'}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: textSecondary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Agency',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              runSpacing: 6,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.event_available,
                                      size: 14,
                                      color: statusColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      item.date,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.schedule,
                                      size: 14,
                                      color: statusColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      item.time,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Agency',
                                        color: textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: bottomSectionColor,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(18),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total: ${item.price} EGP",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Agency',
                          color: textPrimary,
                        ),
                      ),
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item.serviceType == "HomeVisit"
                                  ? Icons.home_outlined
                                  : item.serviceType == "OnSiteVisit"
                                  ? Icons.location_city_outlined
                                  : Icons.videocam_outlined,
                              size: 16,
                              color: statusColor,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                item.serviceType,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Agency',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : Colors.grey.shade50,
      body: Column(
        children: [
          _buildHeader(isDark),
          const SizedBox(height: 20),
          CustomRadioGroup(
            tabs: const ['Upcoming', 'Pending', 'Completed', 'Cancelled'],
            onSelectionChange: (index) => setState(() => _currentIndex = index),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<AppointmentsCubit, AppointmentsState>(
              builder: (context, state) {
                if (state is AppointmentsLoading) {
                  return _buildSkeletonList(isDark);
                }

                if (state is AppointmentsError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        state.errMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.textLight
                              : AppColors.textDark,
                        ),
                      ),
                    ),
                  );
                }

                if (state is AppointmentsSuccess) {
                  final all = state.data;

                  final pages = [
                    _buildList(
                      all.where((e) => e.status == "Confirmed").toList(),
                      const Color(0xff0861dd),
                      isDark,
                    ),
                    _buildList(
                      all.where((e) => e.status == "Pending").toList(),
                      Colors.purple,
                      isDark,
                    ),
                    _buildList(
                      all
                          .where(
                            (e) =>
                                e.status == "Completed" ||
                                e.status == "ResultsDone",
                          )
                          .toList(),
                      Colors.green,
                      isDark,
                    ),
                    _buildList(
                      all.where((e) => e.status == "Cancelled").toList(),
                      Colors.red,
                      isDark,
                    ),
                  ];

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: pages[_currentIndex],
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
