// ignore_for_file: unused_local_variable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcareapp_try1/API/auth_service.dart';
import 'package:healthcareapp_try1/API/logout_service.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Patient_Profile.dart/patient_profile_cubit.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Patient_Profile.dart/patient_profile_state.dart';
import 'package:healthcareapp_try1/Bloc/MedicalRecordBloc/medical_record_cubit.dart';
import 'package:healthcareapp_try1/Bloc/NavigationBloc/navigation_bloc.dart';
// استيراد الـ Bloc الجديد والصفحة

import 'package:healthcareapp_try1/Buttons/icons_heart_stet.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:healthcareapp_try1/Pages/AI/ai_page.dart';
import 'package:healthcareapp_try1/Pages/Auth/change_password_page.dart';
import 'package:healthcareapp_try1/Pages/Booking/booking_page.dart';
import 'package:healthcareapp_try1/Pages/Booking/my_booking_page.dart';
import 'package:healthcareapp_try1/Pages/Communication/my_conversations.dart';
import 'package:healthcareapp_try1/Pages/Community/feed_screen.dart';
import 'package:healthcareapp_try1/Pages/Home/ambulance_page.dart';
import 'package:healthcareapp_try1/Pages/Home/homepage_content.dart';
import 'package:healthcareapp_try1/Pages/Home/profile_page.dart';
import 'package:healthcareapp_try1/Pages/MedicalRecord/medical_record_page.dart';
import 'package:healthcareapp_try1/Widgets/custom_theme_toogle.dart';
import 'package:healthcareapp_try1/core/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    checkStoredData();
  }

  Future<void> checkStoredData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys(); // بيجيب كل المفاتيح المتخزنة

    for (String key in keys) {
      log('Key: $key, Value: ${prefs.get(key)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final size = MediaQuery.of(context).size;
    final bool isTablet = size.width > 600;

    // نستخدم MultiBlocListener إذا كان لديك مستمعين كثر، أو BlocListener واحد هنا
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) async {
        if (state is ProfileLoading) {
          if (!_isNavigating) {
            // ✅ بس لو مش بنتنقل
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          }
        } else if (state is ProfileSuccess) {
          if (_isNavigating) return; // ✅ لو بالفعل بنتنقل، اتجاهل
          _isNavigating = true;

          if (Navigator.canPop(context)) Navigator.pop(context); // اقفل loading

          final updated = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PatientProfilePage(profile: state.profile),
            ),
          );

          _isNavigating = false; // ✅ خلاص رجعنا

          if (updated == true && context.mounted) {
            context.read<ProfileCubit>().getProfile();
          }
        } else if (state is ProfileError) {
          if (Navigator.canPop(context)) Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            extendBody: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              animateColor: true,
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              elevation: 0,
              toolbarHeight: isTablet ? 80 : 70,
              title: Row(
                children: [
                  const Iconheartstet(),
                  SizedBox(width: size.width * 0.03),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      "HealthCare",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.titleLarge?.color,
                        fontFamily: "Cotta",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              // أضفت زر لفتح الـ Drawer لأنك استخدمت endDrawer
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
              ],
            ),
            endDrawer: Drawer(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.bgDark
                  : AppColors.bgLight,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // 🔵 Header
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: Theme.of(context).brightness == Brightness.dark
                            ? [Color(0xFF1E3A8A), Color(0xFF2563EB)]
                            : [Color(0xff0861dd), Color(0xff4da3ff)],
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 16, bottom: 16),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Settings",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cotta',
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 👤 Section
                  _buildTile(
                    context,
                    icon: Icons.person_outline,
                    title: "Profile",
                    onTap: () {
                      Navigator.pop(context);
                      context.read<ProfileCubit>().getProfile();
                    },
                  ),

                  _buildTile(
                    context,
                    icon: Icons.calendar_month,
                    title: "My Booking",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MyBookingPage()),
                      );
                    },
                  ),

                  _buildTile(
                    context,
                    icon: FontAwesomeIcons.fileMedical,
                    title: "Medical Record",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) =>
                                MedicalRecordCubit(AuthService())
                                  ..fetchMedicalRecord(),
                            child: const MedicalRecordPage(),
                          ),
                        ),
                      );
                    },
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Divider(color: Theme.of(context).dividerColor),
                  ),

                  // 💬 Section
                  _buildTile(
                    context,
                    icon: Icons.chat,
                    title: "My Conversations",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyConversations(),
                        ),
                      );
                    },
                  ),

                  _buildTile(
                    context,
                    icon: Icons.lock,
                    title: "Change Password",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordPage(),
                        ),
                      );
                    },
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Divider(color: Theme.of(context).dividerColor),
                  ),

                  // 🌗 Theme Switch (شكل شيك)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Dark Mode",
                          style: TextStyle(fontFamily: 'Agency', fontSize: 14),
                        ),
                        CustomThemeSwitch(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 🚪 Logout
                  _buildTile(
                    context,
                    icon: Icons.logout,
                    title: "Logout",
                    isDanger: true,
                    onTap: () async {
                      context.read<NavigationBloc>().add(TabChanged(0));
                      await AuthServiceLogout.logout(context);
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
            body: SafeArea(
              bottom: false,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildPage(state.selectedIndex, state),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            ),
            bottomNavigationBar: _buildPremiumNavBar(context, state),
          );
        },
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon, color: isDanger ? Colors.red : theme.iconTheme.color),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDanger ? Colors.red : theme.textTheme.bodyLarge?.color,
          fontFamily: 'Agency',
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: onTap,
      hoverColor: theme.colorScheme.primary.withOpacity(0.08),
    );
  }

  Widget _buildPage(int index, NavigationState state) {
    switch (index) {
      case 0:
        return HomePageContent();
      case 1:
        return BookingPage(initialTestIds: state.initialTestIds);
      case 2:
        return HealthChatScreen();
      case 3:
        return FeedScreen();
      case 4:
        return AmbulancePage();
      default:
        return const SizedBox();
    }
  }

  Widget _buildPremiumNavBar(BuildContext context, NavigationState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CurvedNavigationBar(
      index: state.selectedIndex,
      backgroundColor: Colors.transparent,
      color: isDark ? AppColors.primaryDark : AppColors.primary,
      buttonBackgroundColor: isDark ? AppColors.primaryDark : AppColors.primary,
      height: 50,
      items: const <Widget>[
        Icon(Icons.home, color: Colors.white),
        Icon(Icons.calendar_today_rounded, color: Colors.white),
        Icon(Icons.smart_toy_sharp, color: Colors.white),
        Icon(Icons.supervised_user_circle_sharp, color: Colors.white),
        Icon(FontAwesomeIcons.truckMedical, color: Colors.white),
      ],
      onTap: (index) {
        context.read<NavigationBloc>().add(TabChanged(index));
      },
    );
  }
}
