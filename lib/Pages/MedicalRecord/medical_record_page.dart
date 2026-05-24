// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Bloc/MedicalRecordBloc/medical_record_cubit.dart';
import 'package:healthcareapp_try1/Bloc/NavigationBloc/navigation_bloc.dart';
import 'package:healthcareapp_try1/Models/DetailsModel.dart/medical_record_model.dart';
import 'package:healthcareapp_try1/core/gradient_avatar.dart';
import 'package:healthcareapp_try1/core/string_extension.dart';
import 'package:healthcareapp_try1/core/theme/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class MedicalRecordPage extends StatefulWidget {
  const MedicalRecordPage({super.key});

  @override
  State<MedicalRecordPage> createState() => _MedicalRecordPageState();
}

class _MedicalRecordPageState extends State<MedicalRecordPage> {
  @override
  void initState() {
    super.initState();
    context.read<MedicalRecordCubit>().fetchMedicalRecord();
  }

  // ─── Theme helpers (same as PatientProfilePage) ───────────────────────────
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _cardBg.withOpacity(0.85),
              shape: BoxShape.circle,
              boxShadow: [_cardShadow],
            ),
            child: Icon(Icons.arrow_back_ios_new, size: 16, color: _primary),
          ),
        ),
        title: Text(
          'Medical Record',
          style: TextStyle(
            color: _primary,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cotta',
            fontSize: 18,
          ),
        ),
      ),
      body: BlocBuilder<MedicalRecordCubit, MedicalRecordState>(
        builder: (context, state) {
          if (state is MedicalRecordLoading) return _buildSkeleton();
          if (state is MedicalRecordError) {
            return _buildError(state.message, context);
          }
          if (state is MedicalRecordLoaded) {
            return _buildBody(state.data);
          }
          return const SizedBox();
        },
      ),
    );
  }

  // ── Body ─────────────────────────────────────────────────────────────────
  Widget _buildBody(MedicalRecordModel r) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildHeroBanner(r),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildStatsRow(r),
                const SizedBox(height: 20),
                _buildConditionsSection(r.medicalConditions),
                const SizedBox(height: 16),
                _buildDiagnosesSection(r.diagnoses),
                const SizedBox(height: 16),
                _buildLabResultsSection(r.labResults),
                if (r.pendingRequiredTests.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildPendingTestsSection(r.pendingRequiredTests),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Hero banner (mirrors PatientProfilePage._buildHeroBanner) ────────────
  Widget _buildHeroBanner(MedicalRecordModel r) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 100, bottom: 32),
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
          // Avatar with gradient ring
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
              child: GradientAvatar(name: r.name),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            r.name,
            textDirection: r.name.getDirection,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _primary,
              fontFamily: 'Cotta',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${r.gender} · ${r.weight.toStringAsFixed(0)} kg',
            style: TextStyle(
              color: _secondary,
              fontSize: 13,
              fontFamily: 'Agency',
            ),
          ),
          const SizedBox(height: 12),
          // Patient badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: _accent.withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _accent.withOpacity(0.20)),
            ),
            child: Text(
              'Medical Record',
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

  // ── Stats row (mirrors PatientProfilePage._buildStatsRow) ────────────────
  Widget _buildStatsRow(MedicalRecordModel r) {
    final activeConditions = [
      r.medicalConditions.hasDiabetes,
      r.medicalConditions.hasBloodPressure,
      r.medicalConditions.hasAsthma,
      r.medicalConditions.hasHeartDisease,
      r.medicalConditions.hasKidneyDisease,
      r.medicalConditions.hasArthritis,
      r.medicalConditions.hasCancer,
      r.medicalConditions.hasHighCholesterol,
    ].where((c) => c).length;

    return Row(
      children: [
        _statCard(
          icon: Icons.biotech_outlined,
          label: 'Diagnoses',
          value: '${r.diagnoses.length}',
        ),
        const SizedBox(width: 12),
        _statCard(
          icon: Icons.science_outlined,
          label: 'Lab Results',
          value: '${r.labResults.length}',
        ),
        const SizedBox(width: 12),
        _statCard(
          icon: Icons.medical_services_outlined,
          label: 'Conditions',
          value: '$activeConditions',
          valueColor: activeConditions > 0 ? Colors.orange : Colors.green,
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [_cardShadow],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: _iconBg, shape: BoxShape.circle),
              child: Icon(icon, size: 18, color: _accent),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: valueColor ?? _primary,
                fontFamily: 'Agency',
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: _secondary,
                fontFamily: 'Agency',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Generic section card (mirrors PatientProfilePage._buildSection) ───────
  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [_cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: _accent),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: _primary,
                  fontFamily: 'Cotta',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: _divider, height: 1),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  // ── Info tile (mirrors PatientProfilePage._infoTile) ─────────────────────
  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: _iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 15, color: _accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: _secondary,
                    fontFamily: 'Agency',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isNotEmpty ? value : '—',
                  textDirection: value.getDirection,
                  textAlign: value.getTextAlign,
                  style: TextStyle(
                    fontSize: 14,
                    color: _primary,
                    fontFamily: 'Agency',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Medical Conditions section ────────────────────────────────────────────
  Widget _buildConditionsSection(MedicalConditions c) {
    final conditions = [
      ('Diabetes', c.hasDiabetes),
      ('Blood Pressure', c.hasBloodPressure),
      ('Asthma', c.hasAsthma),
      ('Heart Disease', c.hasHeartDisease),
      ('Kidney Disease', c.hasKidneyDisease),
      ('Arthritis', c.hasArthritis),
      ('Cancer', c.hasCancer),
      ('High Cholesterol', c.hasHighCholesterol),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [_cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.health_and_safety_outlined,
                  size: 16,
                  color: _accent,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Medical Conditions',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: _primary,
                  fontFamily: 'Cotta',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: _divider, height: 1),
          const SizedBox(height: 14),

          // Chip grid (same as PatientProfilePage._buildConditionsSection)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: conditions.map((cond) {
              final hasIt = cond.$2;
              final color = hasIt ? Colors.orange : Colors.green;
              final bg = hasIt
                  ? Colors.orange.withOpacity(_isDark ? 0.18 : 0.10)
                  : Colors.green.withOpacity(_isDark ? 0.18 : 0.10);
              final border = hasIt
                  ? Colors.orange.withOpacity(0.30)
                  : Colors.green.withOpacity(0.30);

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      hasIt
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_outline_rounded,
                      size: 13,
                      color: color,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      cond.$1,
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Agency',
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          if (c.otherMedicalConditions != null &&
              c.otherMedicalConditions!.trim().isNotEmpty) ...[
            const SizedBox(height: 16),
            Divider(color: _divider, height: 1),
            const SizedBox(height: 12),
            _infoTile(
              Icons.note_outlined,
              'Other Conditions',
              c.otherMedicalConditions!,
            ),
          ],
        ],
      ),
    );
  }

  // ── Diagnoses section ─────────────────────────────────────────────────────
  Widget _buildDiagnosesSection(List<DiagnosisModel> diagnoses) {
    return _buildSection(
      title: 'Diagnoses',
      icon: Icons.biotech_outlined,
      children: diagnoses.map((d) => _buildDiagnosisCard(d)).toList(),
    );
  }

  Widget _buildDiagnosisCard(DiagnosisModel d) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isDark
            ? Colors.white.withOpacity(0.03)
            : const Color(0xfff9fbff),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor name + type tag
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: _iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 15,
                  color: _accent,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.doctorName,
                      textDirection: d.doctorName.getDirection,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'Cotta',
                        color: _primary,
                      ),
                    ),
                    Text(
                      d.appointmentDate,
                      style: TextStyle(
                        fontSize: 11,
                        color: _secondary,
                        fontFamily: 'Agency',
                      ),
                    ),
                  ],
                ),
              ),
              _serviceTag(d.appointmentType),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: _divider, height: 1),
          const SizedBox(height: 10),

          // Diagnosis text
          Text(
            'Diagnosis',
            style: TextStyle(
              fontSize: 11,
              color: _secondary,
              fontFamily: 'Agency',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            d.diagnosis,
            textDirection: d.diagnosis.getDirection,
            textAlign: d.diagnosis.getTextAlign,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: _primary,
              fontFamily: 'Agency',
            ),
          ),
          const SizedBox(height: 12),

          // Prescription box (blue tint, same approach as profile info tiles)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _accent.withOpacity(_isDark ? 0.12 : 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _accent.withOpacity(0.18)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _iconBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.medication_outlined,
                    size: 14,
                    color: _accent,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prescription',
                        style: TextStyle(
                          fontSize: 10,
                          color: _secondary,
                          fontFamily: 'Agency',
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        d.prescription,
                        textDirection: d.prescription.getDirection,
                        textAlign: d.prescription.getTextAlign,
                        style: TextStyle(
                          fontSize: 13,
                          color: _primary,
                          fontFamily: 'Agency',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Required tests
          if (d.requiredTests.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Required Tests',
              style: TextStyle(
                fontSize: 11,
                color: _secondary,
                fontFamily: 'Agency',
              ),
            ),
            const SizedBox(height: 6),
            ...d.requiredTests.map(
              (t) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              t.testName,
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Agency',
                                color: _primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _statusBadge(t.status),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Lab Results section ───────────────────────────────────────────────────
  Widget _buildLabResultsSection(List<LabResultModel> labs) {
    return _buildSection(
      title: 'Lab Results',
      icon: Icons.science_outlined,
      children: labs.map((l) => _buildLabResultCard(l)).toList(),
    );
  }

  Widget _buildLabResultCard(LabResultModel lab) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isDark
            ? Colors.white.withOpacity(0.03)
            : const Color(0xfff9fbff),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lab name + tag
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: _iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.account_balance_outlined,
                  size: 15,
                  color: _accent,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lab.labName,
                      textDirection: lab.labName.getDirection,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'Cotta',
                        color: _primary,
                      ),
                    ),
                    Text(
                      lab.appointmentDate,
                      style: TextStyle(
                        fontSize: 11,
                        color: _secondary,
                        fontFamily: 'Agency',
                      ),
                    ),
                  ],
                ),
              ),
              _serviceTag(lab.appointmentType),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: _divider, height: 1),
          const SizedBox(height: 10),

          // Results
          ...lab.results.map(
            (r) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isDark
                    ? Colors.white.withOpacity(0.04)
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _divider),
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
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Agency',
                            color: _primary,
                          ),
                        ),
                      ),
                      Text(
                        r.value.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _accent,
                          fontFamily: 'Cotta',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    r.summary,
                    textDirection: r.summary.getDirection,
                    textAlign: r.summary.getTextAlign,
                    style: TextStyle(
                      fontSize: 12,
                      color: _secondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statusBadge(r.status),
                      if (r.resultFileUrl.isNotEmpty)
                        GestureDetector(
                          onTap: () async {
                            final uri = Uri.parse(r.resultFileUrl.trim());
                            try {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Could not open file: $e'),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _accent.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _accent.withOpacity(0.20),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.download_outlined,
                                  size: 14,
                                  color: _accent,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Download PDF',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _accent,
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
            ),
          ),
        ],
      ),
    );
  }

  // ── Pending tests section ─────────────────────────────────────────────────
  Widget _buildPendingTestsSection(List<RequiredTest> tests) {
    return _buildSection(
      title: 'Required Tests',
      icon: Icons.pending_actions_outlined,
      children: tests
          .map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(_isDark ? 0.18 : 0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.pending_outlined,
                      size: 15,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      t.testName,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Agency',
                        color: _primary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      context.read<NavigationBloc>().add(
                        TabChanged(1, initialTestIds: [t.testId]),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: _accent.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _accent.withOpacity(0.25)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search, size: 14, color: _accent),
                          const SizedBox(width: 5),
                          Text(
                            'Find lab',
                            style: TextStyle(
                              color: _accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Agency',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  // ── Skeleton ──────────────────────────────────────────────────────────────
  Widget _buildSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            // Hero banner skeleton
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 100, bottom: 32),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: _isDark
                        ? Colors.white12
                        : Colors.grey.shade200,
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: 140,
                    height: 18,
                    color: _isDark ? Colors.white12 : Colors.grey.shade200,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 13,
                    color: _isDark ? Colors.white10 : Colors.grey.shade200,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Column(
                children: [
                  // Stats row skeleton
                  Row(
                    children: List.generate(
                      3,
                      (i) => Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: i < 2 ? 12 : 0),
                          height: 90,
                          decoration: BoxDecoration(
                            color: _cardBg,
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Section cards skeleton
                  ...List.generate(
                    3,
                    (_) => Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      height: 150,
                      decoration: BoxDecoration(
                        color: _cardBg,
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Shared helpers ────────────────────────────────────────────────────────
  Widget _serviceTag(String type) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: _accent.withOpacity(0.10),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: _accent.withOpacity(0.20)),
    ),
    child: Text(
      type,
      style: TextStyle(
        fontSize: 11,
        color: _accent,
        fontFamily: 'Agency',
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _statusBadge(String status) {
    final isCompleted = status == 'Completed';
    final color = isCompleted ? Colors.green : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(_isDark ? 0.18 : 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCompleted
                ? Icons.check_circle_outline_rounded
                : Icons.schedule_rounded,
            size: 11,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'Agency',
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String msg, BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: 48,
          color: _isDark ? Colors.red.shade300 : Colors.red.shade400,
        ),
        const SizedBox(height: 12),
        Text(
          msg,
          style: TextStyle(
            color: _isDark ? Colors.red.shade300 : Colors.red.shade600,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => context.read<MedicalRecordCubit>().fetchMedicalRecord(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: _accent.withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _accent.withOpacity(0.25)),
            ),
            child: Text(
              'Try again',
              style: TextStyle(
                color: _accent,
                fontWeight: FontWeight.w600,
                fontFamily: 'Agency',
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
