// // ignore_for_file: deprecated_member_use, use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Patient_Profile.dart/patient_profile_cubit.dart';
// import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Patient_Profile.dart/patient_profile_state.dart';
// import 'package:healthcareapp_try1/Buttons/buttons.dart';
// import 'package:healthcareapp_try1/Models/Auth_Models/patient_profile_model.dart';
// import 'package:healthcareapp_try1/Pages/Home/edit_profile_page.dart';
// import 'package:healthcareapp_try1/core/Theme/app_colors.dart';
// import 'package:healthcareapp_try1/core/gradient_avatar.dart';
// import 'package:skeletonizer/skeletonizer.dart';
// import 'package:url_launcher/url_launcher.dart';

// class PatientProfilePage extends StatefulWidget {
//   final PatientProfile profile;
//   const PatientProfilePage({super.key, required this.profile});

//   @override
//   State<PatientProfilePage> createState() => _PatientProfilePageState();
// }

// class _PatientProfilePageState extends State<PatientProfilePage> {
//   late PatientProfile _currentProfile;

//   @override
//   void initState() {
//     super.initState();
//     _currentProfile = widget.profile;
//   }

//   @override
//   Widget build(BuildContext context) {
//     // تحديد ما إذا كان التطبيق في الوضع الليلي
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       // استخدام لون الخلفية من الثيم بدلاً من لون ثابت
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       appBar: AppBar(
//         title: const Text('My Profile'),
//         // جعل لون الأشرطة متناسق مع الوضعين
//         backgroundColor: isDark
//             ? AppColors.surfaceDark
//             : const Color(0xff0861dd),
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),

//       // body: BlocListener<ProfileCubit, ProfileState>(
//       //   listener: (context, state) {
//       //     if (state is ProfileSuccess) {
//       //       setState(() {
//       //         _currentProfile = state.profile;
//       //       });
//       //     }
//       //   },
//       //   child: _buildProfile(context, _currentProfile, isDark: isDark),
//       // ),
//       body: BlocBuilder<ProfileCubit, ProfileState>(
//         builder: (context, state) {
//           final isLoading = state is ProfileLoading;

//           final profile = state is ProfileSuccess
//               ? state.profile
//               : _currentProfile; // fallback للـ profile الحالي

//           return BlocListener<ProfileCubit, ProfileState>(
//             listener: (context, state) {
//               if (state is ProfileSuccess) {
//                 setState(() => _currentProfile = state.profile);
//               }
//             },
//             child: Skeletonizer(
//               enabled: isLoading,
//               child: _buildProfile(context, profile, isDark: isDark),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildProfile(
//     BuildContext context,
//     PatientProfile p, {
//     required bool isDark,
//   }) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           _buildHeaderCard(context, p),
//           const SizedBox(height: 16),
//           _buildSection(context, 'Personal Information', [
//             _buildInfoRow(context, Icons.email, 'Email', p.email),
//             _buildInfoRow(context, Icons.phone, 'Phone', p.phoneNumber),
//             _buildInfoRow(context, Icons.location_city, 'City', p.city),
//             _buildInfoRow(context, Icons.home, 'Address', p.address),
//             _buildInfoRow(context, Icons.cake, 'Date of Birth', p.dateOfBirth),
//             _buildInfoRow(context, Icons.wc, 'Gender', p.gender),
//             if (p.weight != null)
//               _buildInfoRow(
//                 context,
//                 Icons.monitor_weight,
//                 'Weight',
//                 '${p.weight} kg',
//               ),
//             if (p.addressUrl != null) _buildLinkRow(context, p.addressUrl!),
//           ]),
//           const SizedBox(height: 16),
//           _buildSection(context, 'Medical Conditions', [
//             _buildConditionRow('Diabetes', p.hasDiabetes),
//             _buildConditionRow('Blood Pressure', p.hasBloodPressure),
//             _buildConditionRow('Asthma', p.hasAsthma),
//             _buildConditionRow('Heart Disease', p.hasHeartDisease),
//             _buildConditionRow('Kidney Disease', p.hasKidneyDisease),
//             _buildConditionRow('Arthritis', p.hasArthritis),
//             _buildConditionRow('Cancer', p.hasCancer),
//             _buildConditionRow('High Cholesterol', p.hasHighCholesterol),
//             if (p.otherMedicalConditions != null)
//               _buildInfoRow(
//                 context,
//                 Icons.note,
//                 'Other',
//                 p.otherMedicalConditions!,
//               ),
//           ]),
//           const SizedBox(height: 25),
//           ButtonOfAuth(
//             borderSide: BorderSide(
//               color: Theme.of(context).colorScheme.primary,
//             ),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => EditProfilePage(profile: _currentProfile),
//                 ),
//               );
//             },
//             fontcolor: isDark
//                 ? Colors.white
//                 : Theme.of(context).colorScheme.primary,
//             buttoncolor: isDark
//                 ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
//                 : Colors.white,
//             buttonText: "Edit Profile",
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeaderCard(BuildContext context, PatientProfile p) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final primaryColor = Theme.of(context).colorScheme.primary;

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: isDark ? AppColors.surfaceDark : Colors.white,
//         border: Border.all(color: primaryColor.withOpacity(0.5)),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: isDark
//             ? []
//             : [
//                 BoxShadow(
//                   color: AppColors.surfaceDark.withOpacity(0.05),
//                   blurRadius: 10,
//                 ),
//               ],
//       ),
//       child: Column(
//         children: [
//           GradientAvatar(name: p.name),
//           const SizedBox(height: 12),
//           Text(
//             p.name,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: isDark ? Colors.white : primaryColor,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             p.email,
//             style: TextStyle(
//               color: isDark ? Colors.grey[400] : primaryColor,
//               fontSize: 15,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSection(
//     BuildContext context,
//     String title,
//     List<Widget> children,
//   ) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: isDark ? AppColors.surfaceDark : Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: isDark
//             ? []
//             : [const BoxShadow(color: Colors.black12, blurRadius: 6)],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Theme.of(context).colorScheme.primary,
//             ),
//           ),
//           Divider(color: isDark ? Colors.grey[800] : Colors.grey[200]),
//           ...children,
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoRow(
//     BuildContext context,
//     IconData icon,
//     String label,
//     String value,
//   ) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         children: [
//           Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
//           const SizedBox(width: 10),
//           Text(
//             '$label: ',
//             style: TextStyle(
//               fontWeight: FontWeight.w600,
//               color: isDark ? Colors.grey[300] : Colors.black87,
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 color: isDark ? Colors.grey[400] : Colors.grey[700],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildConditionRow(String label, bool hasCondition) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Icon(
//             hasCondition ? Icons.check_circle : Icons.cancel,
//             size: 18,
//             color: hasCondition ? Colors.greenAccent : Colors.redAccent,
//           ),
//           const SizedBox(width: 10),
//           Text(label, style: const TextStyle(fontSize: 14)),
//         ],
//       ),
//     );
//   }

//   Widget _buildLinkRow(BuildContext context, String url) {
//     final primaryColor = Theme.of(context).colorScheme.primary;
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         children: [
//           Icon(Icons.map, size: 18, color: primaryColor),
//           const SizedBox(width: 10),
//           const Text(
//             'Location: ',
//             style: TextStyle(fontWeight: FontWeight.w600),
//           ),
//           Expanded(
//             child: GestureDetector(
//               onTap: () async {
//                 final uri = Uri.parse(url);
//                 if (await canLaunchUrl(uri)) {
//                   await launchUrl(uri, mode: LaunchMode.externalApplication);
//                 }
//               },
//               child: Text(
//                 url,
//                 style: const TextStyle(
//                   color: Colors.blueAccent,
//                   decoration: TextDecoration.underline,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Patient_Profile.dart/patient_profile_cubit.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Patient_Profile.dart/patient_profile_state.dart';
import 'package:healthcareapp_try1/Buttons/buttons.dart';
import 'package:healthcareapp_try1/Models/Auth_Models/patient_profile_model.dart';
import 'package:healthcareapp_try1/Pages/Home/edit_profile_page.dart';
import 'package:healthcareapp_try1/core/Theme/app_colors.dart';
import 'package:healthcareapp_try1/core/gradient_avatar.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class PatientProfilePage extends StatefulWidget {
  final PatientProfile profile;
  const PatientProfilePage({super.key, required this.profile});

  @override
  State<PatientProfilePage> createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
  late PatientProfile _currentProfile;

  @override
  void initState() {
    super.initState();
    _currentProfile = widget.profile;
  }

  // ─── Theme helpers ────────────────────────────────────────────────────────
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
          'My Profile',
          style: TextStyle(
            color: _primary,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cotta',
            fontSize: 18,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfilePage(profile: _currentProfile),
                ),
              );
              if (result is PatientProfile) {
                setState(() => _currentProfile = result);
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: _accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _accent.withOpacity(0.25)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_outlined, size: 14, color: _accent),
                  const SizedBox(width: 5),
                  Text(
                    'Edit',
                    style: TextStyle(
                      color: _accent,
                      fontSize: 13,
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
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final isLoading = state is ProfileLoading;
          final profile = state is ProfileSuccess
              ? state.profile
              : _currentProfile;

          return BlocListener<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is ProfileSuccess) {
                setState(() => _currentProfile = state.profile);
              }
            },
            child: Skeletonizer(enabled: isLoading, child: _buildBody(profile)),
          );
        },
      ),
    );
  }

  Widget _buildBody(PatientProfile p) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // ── Hero banner ───────────────────────────────────────────────
          _buildHeroBanner(p),
          // ── Content ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildStatsRow(p),
                const SizedBox(height: 20),
                _buildSection(
                  title: 'Personal Information',
                  icon: Icons.person_outline_rounded,
                  children: [
                    _infoTile(Icons.email_outlined, 'Email', p.email),
                    _infoTile(Icons.phone_outlined, 'Phone', p.phoneNumber),
                    _infoTile(Icons.location_city_outlined, 'City', p.city),
                    _infoTile(Icons.home_outlined, 'Address', p.address),
                    _infoTile(Icons.cake_outlined, 'Birthday', p.dateOfBirth),
                    _infoTile(Icons.wc_rounded, 'Gender', p.gender),
                    if (p.weight != null)
                      _infoTile(
                        Icons.monitor_weight_outlined,
                        'Weight',
                        '${p.weight} kg',
                      ),
                    if (p.addressUrl != null) _linkTile(p.addressUrl!),
                  ],
                ),
                const SizedBox(height: 16),
                _buildConditionsSection(p),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Hero banner ──────────────────────────────────────────────────────────
  Widget _buildHeroBanner(PatientProfile p) {
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
          // Avatar with ring
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
              child: GradientAvatar(name: p.name),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            p.name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _primary,
              fontFamily: 'Cotta',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            p.email,
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
              'Patient',
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

  // ── Stats row ────────────────────────────────────────────────────────────
  Widget _buildStatsRow(PatientProfile p) {
    final conditions = [
      p.hasDiabetes,
      p.hasBloodPressure,
      p.hasAsthma,
      p.hasHeartDisease,
      p.hasKidneyDisease,
      p.hasArthritis,
      p.hasCancer,
      p.hasHighCholesterol,
    ].where((c) => c).length;

    return Row(
      children: [
        _statCard(
          icon: Icons.monitor_weight_outlined,
          label: 'Weight',
          value: p.weight != null ? '${p.weight} kg' : 'N/A',
        ),
        const SizedBox(width: 12),
        _statCard(icon: Icons.wc_rounded, label: 'Gender', value: p.gender),
        const SizedBox(width: 12),
        _statCard(
          icon: Icons.medical_services_outlined,
          label: 'Conditions',
          value: '$conditions',
          valueColor: conditions > 0 ? Colors.orange : Colors.green,
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

  // ── Generic section card ─────────────────────────────────────────────────
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
          // Section header
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

  // ── Info tile ────────────────────────────────────────────────────────────
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

  // ── Link tile ────────────────────────────────────────────────────────────
  Widget _linkTile(String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: _iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.map_outlined, size: 15, color: _accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 11,
                    color: _secondary,
                    fontFamily: 'Agency',
                  ),
                ),
                const SizedBox(height: 2),
                GestureDetector(
                  onTap: () async {
                    final uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  child: Text(
                    url,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: _accent,
                      fontFamily: 'Agency',
                      decoration: TextDecoration.underline,
                      decorationColor: _accent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Medical conditions section ───────────────────────────────────────────
  Widget _buildConditionsSection(PatientProfile p) {
    final conditions = [
      ('Diabetes', p.hasDiabetes),
      ('Blood Pressure', p.hasBloodPressure),
      ('Asthma', p.hasAsthma),
      ('Heart Disease', p.hasHeartDisease),
      ('Kidney Disease', p.hasKidneyDisease),
      ('Arthritis', p.hasArthritis),
      ('Cancer', p.hasCancer),
      ('High Cholesterol', p.hasHighCholesterol),
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
          // Chip grid
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: conditions.map((c) {
              final hasIt = c.$2;
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
                      c.$1,
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
          // Other conditions note
          if (p.otherMedicalConditions != null) ...[
            const SizedBox(height: 16),
            Divider(color: _divider, height: 1),
            const SizedBox(height: 12),
            _infoTile(
              Icons.note_outlined,
              'Other Conditions',
              p.otherMedicalConditions!,
            ),
          ],
        ],
      ),
    );
  }
}
