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

  // ─── Theme helpers (identical to PatientProfilePage) ─────────────────────
  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _pageBg => _isDark ? AppColors.bgDark : const Color(0xfff4f7fb);
  Color get _cardBg => _isDark ? AppColors.surfaceDark : Colors.white;
  Color get _accent => _isDark ? Colors.blue.shade200 : const Color(0xff0861dd);
  Color get _primary => _isDark ? Colors.white : const Color(0xff0d1b4b);
  Color get _secondary => _isDark ? Colors.white60 : Colors.grey.shade600;
  Color get _divider => _isDark ? Colors.white10 : Colors.grey.shade100;
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
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    context.read<AppointmentsCubit>().getAllUserAppointments(token);
  }

  // ── Hero banner (mirrors PatientProfilePage._buildHeroBanner) ────────────
  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 56, bottom: 28),
      decoration: BoxDecoration(
        color: _cardBg,
        boxShadow: [_cardShadow],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Column(
        children: [
          // Icon with gradient ring
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [_accent, _accent.withOpacity(0.4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(shape: BoxShape.circle, color: _cardBg),
              child: CircleAvatar(
                radius: 32,
                backgroundColor: _iconBg,
                child: Icon(
                  Icons.calendar_month_rounded,
                  size: 30,
                  color: _accent,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'My Bookings',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _primary,
              fontFamily: 'Cotta',
            ),
          ),
          const SizedBox(height: 12),
          // badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: _accent.withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _accent.withOpacity(0.20)),
            ),
            child: Text(
              'All your appointments',
              style: TextStyle(
                color: _accent,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Agency',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Skeleton list ─────────────────────────────────────────────────────────
  Widget _buildSkeletonList() {
    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: _isDark ? AppColors.surfaceDark : const Color(0xFFE0E0E0),
        highlightColor: _isDark ? AppColors.bgDark : const Color(0xFFF5F5F5),
      ),
      child: ListView.builder(
        itemCount: 4,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        itemBuilder: (_, __) => _buildSkeletonCard(),
      ),
    );
  }

  Widget _buildSkeletonCard() {
    final sk = _isDark
        ? AppColors.bgDark.withOpacity(0.85)
        : Colors.grey.shade100;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [_cardShadow],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(radius: 26, backgroundColor: sk),
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
                          height: 14,
                          decoration: BoxDecoration(
                            color: sk,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Container(
                          width: 60,
                          height: 22,
                          decoration: BoxDecoration(
                            color: sk,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 100,
                      height: 11,
                      decoration: BoxDecoration(
                        color: sk,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 11,
                          decoration: BoxDecoration(
                            color: sk,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 60,
                          height: 11,
                          decoration: BoxDecoration(
                            color: sk,
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
          const SizedBox(height: 14),
          Divider(color: _divider, height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 100,
                height: 12,
                decoration: BoxDecoration(
                  color: sk,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: 80,
                height: 12,
                decoration: BoxDecoration(
                  color: sk,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Appointment list ──────────────────────────────────────────────────────
  Widget _buildList(List<AppointmentModel> list, Color statusColor) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: _iconBg, shape: BoxShape.circle),
              child: Icon(
                Icons.calendar_today_outlined,
                size: 36,
                color: _accent,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No bookings found',
              style: TextStyle(
                color: _secondary,
                fontSize: 15,
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
          child: _buildAppointmentCard(item, statusColor),
        );
      },
    );
  }

  Widget _buildAppointmentCard(AppointmentModel item, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [_cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: avatar + info + status badge ─────────────────
          Row(
            children: [
              // Avatar with accent ring
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: statusColor.withOpacity(0.30),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: _iconBg,
                  backgroundImage: item.providerImage.isNotEmpty
                      ? NetworkImage(item.providerImage)
                      : null,
                  child: item.providerImage.isEmpty
                      ? Icon(Icons.person, color: _accent, size: 24)
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
                              fontSize: 15,
                              fontFamily: 'Cotta',
                              color: _primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Status pill (same style as profile badge)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: statusColor.withOpacity(0.30),
                            ),
                          ),
                          child: Text(
                            item.status,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Agency',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Type + specialty (same as _infoTile label style)
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: _iconBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            item.type == "Doctor"
                                ? Icons.medical_services_outlined
                                : item.type == "Nurse"
                                ? Icons.person_outline
                                : Icons.biotech_outlined,
                            size: 12,
                            color: _accent,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            "${item.type} · ${item.specialty ?? 'General'}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: _secondary,
                              fontSize: 12,
                              fontFamily: 'Agency',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: _divider, height: 1),
          const SizedBox(height: 12),

          // ── Bottom row: date / time / service type / price ────────
          Row(
            children: [
              // Date
              _miniInfo(Icons.event_available_outlined, item.date, statusColor),
              const SizedBox(width: 16),
              // Time
              _miniInfo(Icons.schedule_outlined, item.time, statusColor),
              const Spacer(),
              // Service type pill
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _iconBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _accent.withOpacity(0.20)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.serviceType == "HomeVisit"
                          ? Icons.home_outlined
                          : item.serviceType == "OnSiteVisit"
                          ? Icons.location_city_outlined
                          : Icons.videocam_outlined,
                      size: 12,
                      color: _accent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.serviceType,
                      style: TextStyle(
                        color: _accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Agency',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Price row ─────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _accent.withOpacity(_isDark ? 0.10 : 0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _accent.withOpacity(0.15)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _iconBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.payments_outlined,
                    size: 14,
                    color: _accent,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 10,
                        color: _secondary,
                        fontFamily: 'Agency',
                      ),
                    ),
                    Text(
                      '${item.price} EGP',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Agency',
                        color: _primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Mini info chip (date / time) ──────────────────────────────────────────
  Widget _miniInfo(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: _iconBg,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 12, color: _accent),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 12, fontFamily: 'Agency', color: _primary),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      body: Column(
        children: [
          _buildHeroBanner(),
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
                  return _buildSkeletonList();
                }

                if (state is AppointmentsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.error_outline,
                            size: 36,
                            color: _isDark
                                ? Colors.red.shade300
                                : Colors.red.shade400,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            state.errMessage,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _isDark
                                  ? Colors.red.shade300
                                  : Colors.red.shade600,
                              fontFamily: 'Agency',
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state is AppointmentsSuccess) {
                  final all = state.data;

                  final pages = [
                    _buildList(
                      all.where((e) => e.status == "Confirmed").toList(),
                      _accent,
                    ),
                    _buildList(
                      all.where((e) => e.status == "Pending").toList(),
                      Colors.purple,
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
                    ),
                    _buildList(
                      all.where((e) => e.status == "Cancelled").toList(),
                      Colors.red,
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
