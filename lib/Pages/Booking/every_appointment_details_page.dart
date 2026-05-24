// lib/Pages/AppointmentDetails/appointment_details_page.dart
// ignore_for_file: deprecated_member_use, use_build_context_synchronously, unused_local_variable, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:healthcareapp_try1/API/user_service.dart';
import 'package:healthcareapp_try1/API/prepare_meeting_service.dart';
import 'package:healthcareapp_try1/Bloc/Appointment_details_/appointment_details_cubit.dart';
import 'package:healthcareapp_try1/Bloc/Prepare_Meeting/prepare_meeting_bloc.dart';
import 'package:healthcareapp_try1/Bloc/Prepare_Meeting/prepare_meeting_events.dart';
import 'package:healthcareapp_try1/Bloc/Prepare_Meeting/prepare_meeting_state.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/ReviewBloc/review_submit.cubit.dart';
import 'package:healthcareapp_try1/Models/AppointmentDetails/review_details.dart';
import 'package:healthcareapp_try1/Widgets/custom_loader1.dart';
import 'package:healthcareapp_try1/core/gradient_avatar.dart';
import 'package:healthcareapp_try1/core/string_extension.dart';
import 'package:healthcareapp_try1/core/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointmentDetailsPage extends StatelessWidget {
  const AppointmentDetailsPage({super.key});

  // ─── Theme helpers ────────────────────────────────────────────────────────
  bool _isDark(BuildContext c) => Theme.of(c).brightness == Brightness.dark;
  Color _pageBg(BuildContext c) =>
      _isDark(c) ? AppColors.bgDark : const Color(0xfff4f7fb);
  Color _cardBg(BuildContext c) =>
      _isDark(c) ? AppColors.surfaceDark : Colors.white;
  Color _accent(BuildContext c) =>
      _isDark(c) ? Colors.blue.shade200 : const Color(0xff0861dd);
  Color _primary(BuildContext c) =>
      _isDark(c) ? Colors.white : const Color(0xff0d1b4b);
  Color _secondary(BuildContext c) =>
      _isDark(c) ? Colors.white60 : Colors.grey.shade600;
  Color _divider(BuildContext c) =>
      _isDark(c) ? Colors.white.withOpacity(0.08) : Colors.grey.shade100;
  Color _iconBg(BuildContext c) => _isDark(c)
      ? Colors.blue.shade900.withOpacity(0.35)
      : const Color(0xffe8f0fe);
  BoxShadow _shadow(BuildContext c) => BoxShadow(
    color: _isDark(c) ? Colors.black38 : Colors.black.withOpacity(0.06),
    blurRadius: 20,
    offset: const Offset(0, 6),
  );
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg(context),
      body: BlocBuilder<AppointmentDetailsCubit, AppointmentDetailsState>(
        builder: (context, state) {
          if (state is AppointmentDetailsLoading)
            return _buildSkeleton(context);
          if (state is AppointmentDetailsError)
            return _buildError(state.message, context);
          if (state is DoctorAppointmentLoaded)
            return _buildDoctor(state.data, context);
          if (state is NurseAppointmentLoaded)
            return _buildNurse(state.data, context);
          if (state is LabAppointmentLoaded)
            return _buildLab(state.data, context);
          return const SizedBox();
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DOCTOR
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildDoctor(DoctorAppointmentDetails d, BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildHeroHeader(
            context: context,
            name: d.doctorName,
            subtitle: 'Doctor · ${d.appointmentType}',
            status: d.status,
            stats: [
              _StatData('Date', d.date, Icons.calendar_today_outlined),
              _StatData(
                'Time',
                '${d.startTime.substring(0, 5)} – ${d.endTime.substring(0, 5)}',
                Icons.access_time_rounded,
              ),
              _StatData(
                'Fee',
                '${d.fee.toStringAsFixed(0)} EGP',
                Icons.payments_outlined,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            child: Column(
              children: [
                _infoCard(
                  context,
                  'Appointment Info',
                  Icons.info_outline_rounded,
                  [
                    if (d.address != null)
                      _rowTile(
                        context,
                        Icons.location_on_outlined,
                        'Address',
                        d.address!,
                      ),
                    _rowTile(
                      context,
                      Icons.payment_outlined,
                      'Payment',
                      d.paymentType,
                    ),
                    if (d.notes != null)
                      _rowTile(context, Icons.notes_rounded, 'Notes', d.notes!),
                  ],
                ),

                if (d.diagnosis != null || d.prescriptions != null)
                  _sectionCard(
                    context,
                    'Diagnosis & Prescription',
                    Icons.medical_information_outlined,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (d.diagnosis != null) ...[
                          _chipLabel(context, 'Diagnosis', Colors.orange),
                          const SizedBox(height: 6),
                          _textBox(
                            context,
                            d.diagnosis!,
                            _isDark(context)
                                ? Colors.orange.withOpacity(0.10)
                                : Colors.orange.shade50,
                            textColor: _isDark(context)
                                ? Colors.orange.shade200
                                : Colors.orange.shade900,
                          ),
                          const SizedBox(height: 14),
                        ],
                        if (d.prescriptions != null) ...[
                          _chipLabel(context, 'Prescription', _accent(context)),
                          const SizedBox(height: 6),
                          _textBox(
                            context,
                            d.prescriptions!,
                            _isDark(context)
                                ? Colors.blue.withOpacity(0.10)
                                : Colors.blue.shade50,
                            textColor: _isDark(context)
                                ? Colors.blue.shade200
                                : Colors.blue.shade800,
                          ),
                        ],
                      ],
                    ),
                  ),

                if (d.requiredTests.isNotEmpty)
                  _sectionCard(
                    context,
                    'Required Tests',
                    Icons.biotech_outlined,
                    Column(
                      children: d.requiredTests
                          .map((t) => _testRow(context, t.testName, t.status))
                          .toList(),
                    ),
                  ),

                if (d.review != null) _reviewCard(context, d.review!),

                _reviewButton(
                  context,
                  targetId: d.doctorId,
                  targetType: 'Doctor',
                  existingReview: d.review,
                ),

                if (d.appointmentType == 'Online') ...[
                  const SizedBox(height: 4),
                  _joinMeetingButton(
                    context,
                    d.id,
                    d.date,
                    d.startTime,
                    d.endTime,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // NURSE
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildNurse(NurseAppointmentDetails n, BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildHeroHeader(
            context: context,
            name: n.nurseName,
            subtitle: 'Nurse · ${n.serviceType}',
            status: n.status,
            stats: [
              _StatData('Date', n.date, Icons.calendar_today_outlined),
              _StatData(
                'Shift',
                '${n.shiftStartTime.substring(0, 5)} – ${n.shiftEndTime.substring(0, 5)}',
                Icons.access_time_rounded,
              ),
              _StatData(
                'Fee',
                '${n.totalFee.toStringAsFixed(0)} EGP',
                Icons.payments_outlined,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            child: Column(
              children: [
                _infoCard(
                  context,
                  'Appointment Info',
                  Icons.info_outline_rounded,
                  [
                    _rowTile(
                      context,
                      Icons.medical_services_outlined,
                      'Service',
                      n.serviceType,
                    ),
                    if (n.address != null)
                      _rowTile(
                        context,
                        Icons.location_on_outlined,
                        'Address',
                        n.address!,
                      ),
                    if (n.hours != null)
                      _rowTile(
                        context,
                        Icons.timer_outlined,
                        'Hours',
                        '${n.hours}h',
                      ),
                    if (n.notes != null)
                      _rowTile(context, Icons.notes_rounded, 'Notes', n.notes!),
                  ],
                ),
                if (n.review != null) _reviewCard(context, n.review!),
                _reviewButton(
                  context,
                  targetId: n.nurseId,
                  targetType: 'Nurse',
                  existingReview: n.review,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LAB
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildLab(LabAppointmentDetails l, BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildHeroHeader(
            context: context,
            name: l.labName,
            subtitle: 'Lab · ${l.appointmentType}',
            status: l.status,
            stats: [
              _StatData('Date', l.date, Icons.calendar_today_outlined),
              _StatData(
                'Fee',
                '${l.totalFee.toStringAsFixed(0)} EGP',
                Icons.payments_outlined,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            child: Column(
              children: [
                _infoCard(
                  context,
                  'Appointment Info',
                  Icons.info_outline_rounded,
                  [
                    if (l.address != null)
                      _rowTile(
                        context,
                        Icons.location_on_outlined,
                        'Address',
                        l.address!,
                      ),
                    if (l.notes != null)
                      _rowTile(context, Icons.notes_rounded, 'Notes', l.notes!),
                  ],
                ),
                if (l.testResults.isNotEmpty)
                  _sectionCard(
                    context,
                    'Test Results',
                    Icons.science_outlined,
                    Column(
                      children: l.testResults
                          .map((r) => _labResultItem(context, r))
                          .toList(),
                    ),
                  ),
                if (l.review != null) _reviewCard(context, l.review!),
                _reviewButton(
                  context,
                  targetId: l.labId,
                  targetType: 'Lab',
                  existingReview: l.review,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HERO HEADER
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildHeroHeader({
    required BuildContext context,
    required String name,
    required String subtitle,
    required String status,
    required List<_StatData> stats,
  }) {
    final isDark = _isDark(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.surfaceDark, AppColors.primaryDark]
              : [const Color(0xff1565C0), const Color(0xff0861dd)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff0861dd).withOpacity(isDark ? 0.15 : 0.30),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
      child: Column(
        children: [
          // ── Top row: back + avatar + status ──────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Avatar + name
              Expanded(
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.30),
                          width: 2.5,
                        ),
                      ),
                      child: GradientAvatar(name: name, size: 52, fontSize: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            textDirection: name.getDirection,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cotta',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.80),
                              fontSize: 12,
                              fontFamily: 'Agency',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _statusBadge(context, status, onHeader: true),
            ],
          ),

          const SizedBox(height: 20),

          // ── Stats row ─────────────────────────────────────────────────
          Row(
            children: stats
                .map((s) => Expanded(child: _statCard(context, s)))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _statCard(BuildContext context, _StatData s) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(s.icon, size: 14, color: Colors.white.withOpacity(0.70)),
          const SizedBox(height: 6),
          Text(
            s.label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withOpacity(0.65),
              fontFamily: 'Agency',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            s.value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Agency',
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION CARDS
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _infoCard(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> rows,
  ) {
    if (rows.isEmpty) return const SizedBox.shrink();
    return _sectionCard(context, title, icon, Column(children: rows));
  }

  Widget _sectionCard(
    BuildContext context,
    String title,
    IconData icon,
    Widget child,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardBg(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [_shadow(context)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _iconBg(context),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 15, color: _accent(context)),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _primary(context),
                  fontFamily: 'Cotta',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: _divider(context), height: 1),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  // ── Row tile ──────────────────────────────────────────────────────────────
  Widget _rowTile(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _iconBg(context),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 13, color: _accent(context)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: _secondary(context),
                    fontFamily: 'Agency',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  textDirection: value.getDirection,
                  textAlign: value.getTextAlign,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _primary(context),
                    fontFamily: 'Agency',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Chip label ────────────────────────────────────────────────────────────
  Widget _chipLabel(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
          fontFamily: 'Agency',
        ),
      ),
    );
  }

  // ── Text box (diagnosis / prescription) ──────────────────────────────────
  Widget _textBox(
    BuildContext context,
    String text,
    Color bg, {
    Color? textColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        textDirection: text.getDirection,
        textAlign: text.getTextAlign,
        style: TextStyle(
          fontSize: 13,
          height: 1.6,
          color: textColor ?? _primary(context),
          fontFamily: 'Agency',
        ),
      ),
    );
  }

  // ── Test row ──────────────────────────────────────────────────────────────
  Widget _testRow(BuildContext context, String name, String status) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _iconBg(context),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.science_outlined,
              size: 13,
              color: _accent(context),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 13,
                color: _primary(context),
                fontFamily: 'Agency',
              ),
            ),
          ),
          _statusBadge(context, status),
        ],
      ),
    );
  }

  // ── Lab result item ───────────────────────────────────────────────────────
  Widget _labResultItem(BuildContext context, LabTestResult r) {
    final isDark = _isDark(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _divider(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  r.testName,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _primary(context),
                    fontFamily: 'Agency',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _accent(context).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  r.value.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _accent(context),
                    fontFamily: 'Agency',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            r.summary,
            style: TextStyle(
              fontSize: 12,
              color: _secondary(context),
              height: 1.5,
              fontFamily: 'Agency',
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statusBadge(context, r.status),
              if (r.resultFileUrl.isNotEmpty)
                GestureDetector(
                  onTap: () => launchUrl(
                    Uri.parse(r.resultFileUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _accent(context).withOpacity(0.10),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _accent(context).withOpacity(0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.download_outlined,
                          size: 13,
                          color: _accent(context),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Download PDF',
                          style: TextStyle(
                            fontSize: 12,
                            color: _accent(context),
                            fontFamily: 'Agency',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Review card ───────────────────────────────────────────────────────────
  Widget _reviewCard(BuildContext context, ReviewDetails r) {
    return _sectionCard(
      context,
      'Patient Review',
      Icons.reviews_outlined,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GradientAvatar(name: r.patientName, size: 38, fontSize: 14),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.patientName,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _primary(context),
                        fontFamily: 'Agency',
                      ),
                    ),
                    Text(
                      '${r.date.day}/${r.date.month}/${r.date.year}'
                      '${r.isUpdated ? ' · edited' : ''}',
                      style: TextStyle(
                        fontSize: 11,
                        color: _secondary(context),
                        fontFamily: 'Agency',
                      ),
                    ),
                  ],
                ),
              ),
              // Stars
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < r.rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 16,
                    color: i < r.rating ? Colors.amber : Colors.grey.shade400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _textBox(
            context,
            r.comment,
            _isDark(context)
                ? Colors.white.withOpacity(0.04)
                : Colors.grey.shade50,
          ),
        ],
      ),
    );
  }

  // ── Review button ─────────────────────────────────────────────────────────
  Widget _reviewButton(
    BuildContext context, {
    required String targetId,
    required String targetType,
    ReviewDetails? existingReview,
  }) {
    final isEdit = existingReview != null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: OutlinedButton.icon(
          onPressed: () => _showReviewSheet(
            context,
            targetId: targetId,
            targetType: targetType,
            existingReview: existingReview,
          ),
          icon: Icon(
            isEdit ? Icons.edit_outlined : Icons.star_outline_rounded,
            size: 16,
            color: _accent(context),
          ),
          label: Text(
            isEdit ? 'Edit Review' : 'Add Review',
            style: TextStyle(
              color: _accent(context),
              fontFamily: 'Agency',
              fontWeight: FontWeight.w600,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: _accent(context).withOpacity(0.40)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }

  // ── Join Meeting button ───────────────────────────────────────────────────
  Widget _joinMeetingButton(
    BuildContext context,
    String id,
    String date,
    String startTime,
    String endTime,
  ) {
    return BlocProvider(
      create: (_) => PrepareMeetingBloc(repository: AppointmentRepository()),
      child: BlocConsumer<PrepareMeetingBloc, PrepareMeetingState>(
        listener: (ctx, state) async {
          if (state is PrepareMeetingSuccess) {
            final uri = Uri.parse(state.data.meetingUrl);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              showAppToast(
                context,
                'Could not open meeting link',
                isError: true,
              );
            }
          }
          if (state is PrepareMeetingFailure) {
            showAppToast(context, state.error, isError: true);
          }
        },
        builder: (ctx, state) {
          final isLoading = state is PrepareMeetingLoading;
          final canJoin = _canJoinMeeting(date, startTime, endTime);
          final accent = _accent(context);

          return Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: (!canJoin || isLoading)
                      ? null
                      : () async {
                          final prefs = await SharedPreferences.getInstance();
                          final token = prefs.getString('token') ?? '';
                          ctx.read<PrepareMeetingBloc>().add(
                            PrepareMeetingRequested(
                              appointmentId: id,
                              token: token,
                            ),
                          );
                        },
                  icon: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.videocam_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                  label: Text(
                    isLoading ? 'Connecting...' : 'Join Now',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Agency',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canJoin
                        ? accent
                        : accent.withOpacity(0.38),
                    disabledBackgroundColor: accent.withOpacity(0.28),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              if (!canJoin) ...[
                const SizedBox(height: 6),
                Text(
                  _joinAvailableText(date, startTime, endTime),
                  style: TextStyle(
                    fontSize: 11,
                    color: _secondary(context),
                    fontFamily: 'Agency',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }

  // ── Status badge ──────────────────────────────────────────────────────────
  Widget _statusBadge(
    BuildContext context,
    String status, {
    bool onHeader = false,
  }) {
    final isDark = _isDark(context);
    Color bg, fg;

    switch (status) {
      case 'Completed':
      case 'ResultsDone':
        bg = isDark ? Colors.green.withOpacity(0.18) : Colors.green.shade50;
        fg = isDark ? Colors.green.shade200 : Colors.green.shade800;
        break;
      case 'Pending':
        bg = isDark ? Colors.orange.withOpacity(0.18) : Colors.orange.shade50;
        fg = isDark ? Colors.orange.shade200 : Colors.orange.shade800;
        break;
      case 'Confirmed':
        bg = isDark ? Colors.blue.withOpacity(0.18) : Colors.blue.shade50;
        fg = isDark ? Colors.blue.shade200 : Colors.blue.shade800;
        break;
      case 'Cancelled':
        bg = isDark ? Colors.red.withOpacity(0.18) : Colors.red.shade50;
        fg = isDark ? Colors.red.shade200 : Colors.red.shade800;
        break;
      default:
        bg = isDark ? Colors.white.withOpacity(0.10) : Colors.grey.shade100;
        fg = isDark ? Colors.white70 : Colors.grey.shade700;
    }

    // On the blue hero header, use semi-transparent white
    if (onHeader) {
      bg = Colors.white.withOpacity(0.18);
      fg = Colors.white;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 6, color: fg),
          const SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: fg,
              fontFamily: 'Agency',
            ),
          ),
        ],
      ),
    );
  }

  // ── Skeleton / Error ──────────────────────────────────────────────────────
  Widget _buildSkeleton(BuildContext context) => Center(
    child: CustomSpinner(
      size: 36,
      color: _isDark(context) ? AppColors.textLight : const Color(0xff0861dd),
    ),
  );

  Widget _buildError(String msg, BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _cardBg(context),
              shape: BoxShape.circle,
              boxShadow: [_shadow(context)],
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 36,
              color: Colors.red.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            msg,
            textAlign: TextAlign.center,
            style: TextStyle(color: _secondary(context), fontFamily: 'Agency'),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded, size: 16),
            label: const Text(
              'Go back',
              style: TextStyle(fontFamily: 'Agency'),
            ),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  // ── Review bottom sheet ───────────────────────────────────────────────────
  void _showReviewSheet(
    BuildContext context, {
    required String targetId,
    required String targetType,
    ReviewDetails? existingReview,
  }) {
    int selectedRating = existingReview?.rating ?? 0;
    final commentController = TextEditingController(
      text: existingReview?.comment ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _cardBg(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider(
        create: (_) => ReviewSubmitCubit(UserService()),
        child: StatefulBuilder(
          builder: (ctx, setSheetState) {
            return BlocListener<ReviewSubmitCubit, ReviewSubmitState>(
              listener: (ctx, state) {
                if (state is ReviewSubmitSuccess) {
                  context.read<AppointmentDetailsCubit>().refresh().then((_) {
                    Navigator.pop(ctx);
                    showToast(
                      existingReview != null
                          ? 'تم تعديل التقييم بنجاح'
                          : 'تم إرسال التقييم بنجاح',
                    );
                  });
                }
                if (state is ReviewSubmitError) showToast(state.message);
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  16,
                  20,
                  MediaQuery.of(ctx).viewInsets.bottom + 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: _divider(ctx),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _iconBg(ctx),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            existingReview != null
                                ? Icons.edit_outlined
                                : Icons.star_outline_rounded,
                            size: 15,
                            color: _accent(ctx),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          existingReview != null
                              ? 'Edit your review'
                              : 'Add your review',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cotta',
                            color: _primary(ctx),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Stars
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          5,
                          (i) => GestureDetector(
                            onTap: () =>
                                setSheetState(() => selectedRating = i + 1),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: Icon(
                                i < selectedRating
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                size: 38,
                                color: i < selectedRating
                                    ? Colors.amber
                                    : (_isDark(ctx)
                                          ? Colors.white24
                                          : Colors.grey.shade300),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Comment field
                    TextField(
                      controller: commentController,
                      maxLines: 3,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: _primary(ctx),
                        fontFamily: 'Agency',
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'اكتب تعليقك هنا...',
                        hintTextDirection: TextDirection.rtl,
                        hintStyle: TextStyle(
                          color: _secondary(ctx),
                          fontFamily: 'Agency',
                        ),
                        filled: true,
                        fillColor: _isDark(ctx)
                            ? Colors.white.withOpacity(0.05)
                            : Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: _divider(ctx)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: _divider(ctx)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: _accent(ctx),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Submit button
                    BlocBuilder<ReviewSubmitCubit, ReviewSubmitState>(
                      builder: (ctx, state) {
                        final isLoading = state is ReviewSubmitLoading;
                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: selectedRating == 0 || isLoading
                                ? null
                                : () async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    final token =
                                        prefs.getString('token') ?? '';
                                    ctx.read<ReviewSubmitCubit>().submit(
                                      targetId: targetId,
                                      targetType: targetType,
                                      rating: selectedRating,
                                      comment: commentController.text,
                                      token: token,
                                      reviewId: existingReview?.id,
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _accent(ctx),
                              disabledBackgroundColor: _isDark(ctx)
                                  ? Colors.white12
                                  : Colors.grey.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    existingReview != null
                                        ? 'Update Review'
                                        : 'Submit Review',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'Agency',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  void showAppToast(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    showToast(
      message,
      context: context,
      duration: const Duration(seconds: 2),
      position: StyledToastPosition.bottom,
      backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
      textStyle: const TextStyle(color: Colors.white, fontSize: 13),
      borderRadius: BorderRadius.circular(12),
      animation: StyledToastAnimation.fade,
    );
  }

  bool _canJoinMeeting(String? date, String? startTime, String? endTime) {
    try {
      if (date == null ||
          date.isEmpty ||
          startTime == null ||
          startTime.isEmpty ||
          endTime == null ||
          endTime.isEmpty)
        return false;
      final now = DateTime.now();
      final dp = date.split('-'),
          sp = startTime.split(':'),
          ep = endTime.split(':');
      if (dp.length < 3 || sp.length < 2 || ep.length < 2) return false;
      final start = DateTime(
        int.parse(dp[0]),
        int.parse(dp[1]),
        int.parse(dp[2]),
        int.parse(sp[0]),
        int.parse(sp[1]),
      );
      final end = DateTime(
        int.parse(dp[0]),
        int.parse(dp[1]),
        int.parse(dp[2]),
        int.parse(ep[0]),
        int.parse(ep[1]),
      );
      return now.isAfter(start.subtract(const Duration(minutes: 15))) &&
          now.isBefore(end);
    } catch (_) {
      return false;
    }
  }

  String _joinAvailableText(String? date, String? startTime, String? endTime) {
    try {
      if (date == null ||
          date.isEmpty ||
          startTime == null ||
          startTime.isEmpty ||
          endTime == null ||
          endTime.isEmpty)
        return '';
      final now = DateTime.now();
      final dp = date.split('-'),
          sp = startTime.split(':'),
          ep = endTime.split(':');
      if (dp.length < 3 || sp.length < 2 || ep.length < 2) return '';
      final start = DateTime(
        int.parse(dp[0]),
        int.parse(dp[1]),
        int.parse(dp[2]),
        int.parse(sp[0]),
        int.parse(sp[1]),
      );
      final end = DateTime(
        int.parse(dp[0]),
        int.parse(dp[1]),
        int.parse(dp[2]),
        int.parse(ep[0]),
        int.parse(ep[1]),
      );
      if (now.isAfter(end)) return 'Meeting has ended';
      final open = start.subtract(const Duration(minutes: 15));
      final diff = open.difference(now);
      if (diff.inDays > 0)
        return 'Available in ${diff.inDays}d ${diff.inHours % 24}h';
      if (diff.inHours > 0)
        return 'Available in ${diff.inHours}h ${diff.inMinutes % 60}m';
      if (diff.inMinutes > 0) return 'Available in ${diff.inMinutes}m';
      return '';
    } catch (_) {
      return '';
    }
  }
}

// ── Helper data class ─────────────────────────────────────────────────────────
class _StatData {
  final String label, value;
  final IconData icon;
  const _StatData(this.label, this.value, this.icon);
}
