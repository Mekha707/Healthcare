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

  @override
  Widget build(BuildContext context) {
    // تحديد ما إذا كان التطبيق في الوضع الليلي
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // استخدام لون الخلفية من الثيم بدلاً من لون ثابت
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Profile'),
        // جعل لون الأشرطة متناسق مع الوضعين
        backgroundColor: isDark
            ? AppColors.surfaceDark
            : const Color(0xff0861dd),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileSuccess) {
            setState(() {
              _currentProfile = state.profile;
            });
          }
        },
        child: _buildProfile(context, _currentProfile, isDark: isDark),
      ),
    );
  }

  Widget _buildProfile(
    BuildContext context,
    PatientProfile p, {
    required bool isDark,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildHeaderCard(context, p),
          const SizedBox(height: 16),
          _buildSection(context, 'Personal Information', [
            _buildInfoRow(context, Icons.email, 'Email', p.email),
            _buildInfoRow(context, Icons.phone, 'Phone', p.phoneNumber),
            _buildInfoRow(context, Icons.location_city, 'City', p.city),
            _buildInfoRow(context, Icons.home, 'Address', p.address),
            _buildInfoRow(context, Icons.cake, 'Date of Birth', p.dateOfBirth),
            _buildInfoRow(context, Icons.wc, 'Gender', p.gender),
            if (p.weight != null)
              _buildInfoRow(
                context,
                Icons.monitor_weight,
                'Weight',
                '${p.weight} kg',
              ),
            if (p.addressUrl != null) _buildLinkRow(context, p.addressUrl!),
          ]),
          const SizedBox(height: 16),
          _buildSection(context, 'Medical Conditions', [
            _buildConditionRow('Diabetes', p.hasDiabetes),
            _buildConditionRow('Blood Pressure', p.hasBloodPressure),
            _buildConditionRow('Asthma', p.hasAsthma),
            _buildConditionRow('Heart Disease', p.hasHeartDisease),
            _buildConditionRow('Kidney Disease', p.hasKidneyDisease),
            _buildConditionRow('Arthritis', p.hasArthritis),
            _buildConditionRow('Cancer', p.hasCancer),
            _buildConditionRow('High Cholesterol', p.hasHighCholesterol),
            if (p.otherMedicalConditions != null)
              _buildInfoRow(
                context,
                Icons.note,
                'Other',
                p.otherMedicalConditions!,
              ),
          ]),
          const SizedBox(height: 25),
          ButtonOfAuth(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfilePage(profile: _currentProfile),
                ),
              );
            },
            fontcolor: isDark
                ? Colors.white
                : Theme.of(context).colorScheme.primary,
            buttoncolor: isDark
                ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                : Colors.white,
            buttonText: "Edit Profile",
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, PatientProfile p) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        border: Border.all(color: primaryColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: AppColors.surfaceDark.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
      ),
      child: Column(
        children: [
          GradientAvatar(name: p.name),
          const SizedBox(height: 12),
          Text(
            p.name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            p.email,
            style: TextStyle(
              color: isDark ? Colors.grey[400] : primaryColor,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? []
            : [const BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Divider(color: isDark ? Colors.grey[800] : Colors.grey[200]),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey[300] : Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionRow(String label, bool hasCondition) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            hasCondition ? Icons.check_circle : Icons.cancel,
            size: 18,
            color: hasCondition ? Colors.greenAccent : Colors.redAccent,
          ),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildLinkRow(BuildContext context, String url) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(Icons.map, size: 18, color: primaryColor),
          const SizedBox(width: 10),
          const Text(
            'Location: ',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: Text(
                url,
                style: const TextStyle(
                  color: Colors.blueAccent,
                  decoration: TextDecoration.underline,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
