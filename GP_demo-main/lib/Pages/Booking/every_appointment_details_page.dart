// lib/Pages/AppointmentDetails/appointment_details_page.dart
// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/user_service.dart';
import 'package:healthcareapp_try1/Bloc/Appointment_details_/appointment_details_cubit.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/ReviewBloc/review_submit.cubit.dart';
import 'package:healthcareapp_try1/Models/AppointmentDetails/review_details.dart';
import 'package:healthcareapp_try1/core/gradient_avatar.dart';
import 'package:healthcareapp_try1/core/string_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointmentDetailsPage extends StatelessWidget {
  const AppointmentDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: BlocBuilder<AppointmentDetailsCubit, AppointmentDetailsState>(
        builder: (context, state) {
          if (state is AppointmentDetailsLoading) return _buildSkeleton();
          if (state is AppointmentDetailsError) {
            return _buildError(state.message, context);
          }
          if (state is DoctorAppointmentLoaded) {
            return _buildDoctor(state.data, context);
          }
          if (state is NurseAppointmentLoaded) {
            return _buildNurse(state.data, context);
          }
          if (state is LabAppointmentLoaded) {
            return _buildLab(state.data, context);
          }
          return const SizedBox();
        },
      ),
    );
  }

  // ══════════════════════════════════════════
  //  DOCTOR
  // ══════════════════════════════════════════
  Widget _buildDoctor(DoctorAppointmentDetails d, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildBlueHeader(
            name: d.doctorName,
            subtitle: 'Doctor · ${d.appointmentType}',
            status: d.status,
            context: context,
            stats: [
              _statItem('Date', d.date),
              _statItem(
                'Time',
                '${d.startTime.substring(0, 5)} – ${d.endTime.substring(0, 5)}',
              ),
              _statItem('Fee', '${d.fee.toStringAsFixed(0)} EGP'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _infoCard('Appointment info', [
                  if (d.address != null) _rowItem('Address', d.address!),
                  _rowItem('Payment', d.paymentType),
                  if (d.notes != null) _rowItem('Notes', d.notes!),
                ]),

                if (d.diagnosis != null || d.prescriptions != null)
                  _sectionCard(
                    'Diagnosis & prescription',
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (d.diagnosis != null) ...[
                          _subLabel('Diagnosis'),
                          _arabicBox(d.diagnosis!, Colors.grey.shade50),
                          const SizedBox(height: 12),
                        ],
                        if (d.prescriptions != null) ...[
                          _subLabel('Prescription'),
                          _arabicBox(
                            d.prescriptions!,
                            Colors.blue.shade50,
                            textColor: Colors.blue.shade800,
                          ),
                        ],
                      ],
                    ),
                  ),

                if (d.requiredTests.isNotEmpty)
                  _sectionCard(
                    'Required tests',
                    Column(
                      children: d.requiredTests
                          .map((t) => _testRow(t.testName, t.status))
                          .toList(),
                    ),
                  ),

                if (d.review != null) _reviewCard(d.review!),

                if (d.review == null)
                  _reviewButton(
                    context,
                    targetId: d.doctorId,
                    targetType: 'Doctor',
                  ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════
  //  NURSE
  // ══════════════════════════════════════════
  Widget _buildNurse(NurseAppointmentDetails n, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildBlueHeader(
            name: n.nurseName,
            subtitle: 'Nurse · ${n.serviceType}',
            status: n.status,
            context: context,
            stats: [
              _statItem('Date', n.date),
              _statItem(
                'Shift',
                '${n.shiftStartTime.substring(0, 5)} – ${n.shiftEndTime.substring(0, 5)}',
              ),
              _statItem('Fee', '${n.totalFee.toStringAsFixed(0)} EGP'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _infoCard('Appointment info', [
                  _rowItem('Service', n.serviceType),
                  if (n.address != null) _rowItem('Address', n.address!),
                  if (n.hours != null) _rowItem('Hours', '${n.hours}h'),
                  if (n.notes != null) _rowItem('Notes', n.notes!),
                ]),

                if (n.review != null) _reviewCard(n.review!),

                if (n.review == null)
                  _reviewButton(
                    context,
                    targetId: n.nurseId,
                    targetType: 'Nurse',
                  ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════
  //  LAB
  // ══════════════════════════════════════════
  Widget _buildLab(LabAppointmentDetails l, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildBlueHeader(
            name: l.labName,
            subtitle: 'Lab · ${l.appointmentType}',
            status: l.status,
            context: context,
            stats: [
              _statItem('Date', l.date),
              _statItem('Fee', '${l.totalFee.toStringAsFixed(0)} EGP'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _infoCard('Appointment info', [
                  if (l.address != null) _rowItem('Address', l.address!),
                  if (l.notes != null) _rowItem('Notes', l.notes!),
                ]),

                if (l.testResults.isNotEmpty)
                  _sectionCard(
                    'Test results',
                    Column(
                      children: l.testResults
                          .map((r) => _labResultItem(r))
                          .toList(),
                    ),
                  ),

                if (l.review != null) _reviewCard(l.review!),

                if (l.review == null)
                  _reviewButton(context, targetId: l.labId, targetType: 'Lab'),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════
  //  SHARED WIDGETS
  // ══════════════════════════════════════════

  Widget _buildBlueHeader({
    required String name,
    required String subtitle,
    required String status,
    required BuildContext context,
    required List<Widget> stats,
  }) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff0A74FF), Color(0xff0047CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),

      padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
      child: Column(
        children: [
          Row(
            children: [
              GradientAvatar(name: name, size: 52, fontSize: 22),
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
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                        fontFamily: 'Agency',
                      ),
                    ),
                  ],
                ),
              ),
              _statusBadge(status),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 18,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(children: stats.map((s) => Expanded(child: s)).toList()),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.75),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Agency',
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(String title, List<Widget> rows) {
    return _sectionCard(title, Column(children: rows));
  }

  Widget _sectionCard(String title, Widget child) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _rowItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textDirection: value.getDirection,
              textAlign: value.getTextAlign,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _testRow(String name, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 13, fontFamily: 'Agency'),
          ),
          _statusBadge(status),
        ],
      ),
    );
  }

  Widget _labResultItem(LabTestResult r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  r.testName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                r.value.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0861dd),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            r.summary,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statusBadge(r.status),
              if (r.resultFileUrl.isNotEmpty)
                GestureDetector(
                  onTap: () => launchUrl(Uri.parse(r.resultFileUrl)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.download_outlined,
                          size: 14,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Download PDF',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade700,
                            fontFamily: 'Agency',
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

  Widget _reviewCard(ReviewDetails r) {
    return _sectionCard(
      'Patient review',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GradientAvatar(name: r.patientName, size: 36, fontSize: 14),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.patientName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${r.date.day}/${r.date.month}/${r.date.year}${r.isUpdated ? ' · edited' : ''}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < r.rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 16,
                    color: i < r.rating ? Colors.amber : Colors.grey.shade300,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _arabicBox(r.comment, Colors.grey.shade50),
        ],
      ),
    );
  }

  Widget _arabicBox(String text, Color bg, {Color? textColor}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        textDirection: text.getDirection,
        textAlign: text.getTextAlign,
        style: TextStyle(fontSize: 13, height: 1.5, color: textColor),
      ),
    );
  }

  Widget _subLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(
      text,
      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
    ),
  );

  Widget _statusBadge(String status) {
    Color bg;
    Color fg;
    switch (status) {
      case 'Completed':
      case 'ResultsDone':
        bg = Colors.green.shade50;
        fg = Colors.green.shade800;
        break;
      case 'Pending':
        bg = Colors.orange.shade50;
        fg = Colors.orange.shade800;
        break;
      case 'Confirmed':
        bg = Colors.blue.shade50;
        fg = Colors.blue.shade800;
        break;
      case 'Cancelled':
        bg = Colors.red.shade50;
        fg = Colors.red.shade800;
        break;
      default:
        bg = Colors.grey.shade100;
        fg = Colors.grey.shade700;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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

  Widget _buildSkeleton() =>
      const Center(child: CircularProgressIndicator(color: Color(0xff0861dd)));

  Widget _buildError(String msg, BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, color: Colors.red.shade300, size: 48),
        const SizedBox(height: 12),
        Text(msg, style: const TextStyle(color: Colors.red)),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Go back'),
        ),
      ],
    ),
  );

  // ── أضف الـ method دي في الصفحة ──
  void _showReviewSheet(
    BuildContext context, {
    required String targetId,
    required String targetType,
  }) {
    int selectedRating = 0;
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider(
        create: (_) => ReviewSubmitCubit(UserService()),
        child: StatefulBuilder(
          builder: (ctx, setSheetState) {
            return BlocListener<ReviewSubmitCubit, ReviewSubmitState>(
              listener: (ctx, state) {
                if (state is ReviewSubmitSuccess) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم إرسال التقييم بنجاح'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
                if (state is ReviewSubmitError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  20,
                  16,
                  MediaQuery.of(ctx).viewInsets.bottom + 20,
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
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Add your review',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cotta',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Stars
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          5,
                          (i) => GestureDetector(
                            onTap: () =>
                                setSheetState(() => selectedRating = i + 1),
                            child: Icon(
                              i < selectedRating
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              size: 40,
                              color: i < selectedRating
                                  ? Colors.amber
                                  : Colors.grey.shade300,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Comment
                    TextField(
                      controller: commentController,
                      maxLines: 3,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        hintText: 'اكتب تعليقك هنا...',
                        hintTextDirection: TextDirection.rtl,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xff0861dd),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Submit Button
                    BlocBuilder<ReviewSubmitCubit, ReviewSubmitState>(
                      builder: (ctx, state) {
                        final isLoading = state is ReviewSubmitLoading;
                        return SizedBox(
                          width: double.infinity,
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
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff0861dd),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
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
                                : const Text(
                                    'Submit Review',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'Agency',
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

  // ── الـ button widget ──
  Widget _reviewButton(
    BuildContext context, {
    required String targetId,
    required String targetType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _showReviewSheet(
            context,
            targetId: targetId,
            targetType: targetType,
          ),
          icon: const Icon(
            Icons.star_outline_rounded,
            color: Color(0xff0861dd),
          ),
          label: const Text(
            'Add Review',
            style: TextStyle(color: Color(0xff0861dd), fontFamily: 'Agency'),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: const BorderSide(color: Color(0xff0861dd)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
