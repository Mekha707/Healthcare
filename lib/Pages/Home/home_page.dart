// // ignore_for_file: unused_local_variable

// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:healthcareapp_try1/API/auth_service.dart';
// import 'package:healthcareapp_try1/API/logout_service.dart';
// import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Patient_Profile.dart/patient_profile_cubit.dart';
// import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Patient_Profile.dart/patient_profile_state.dart';
// import 'package:healthcareapp_try1/Bloc/MedicalRecordBloc/medical_record_cubit.dart';
// import 'package:healthcareapp_try1/Bloc/NavigationBloc/navigation_bloc.dart';
// // استيراد الـ Bloc الجديد والصفحة

// import 'package:healthcareapp_try1/Buttons/icons_heart_stet.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:healthcareapp_try1/Pages/AI/ai_page.dart';
// import 'package:healthcareapp_try1/Pages/Auth/change_password_page.dart';
// import 'package:healthcareapp_try1/Pages/Booking/booking_page.dart';
// import 'package:healthcareapp_try1/Pages/Booking/my_booking_page.dart';
// import 'package:healthcareapp_try1/Pages/Communication/my_conversations.dart';
// import 'package:healthcareapp_try1/Pages/Community/feed_screen.dart';
// import 'package:healthcareapp_try1/Pages/Home/ambulance_page.dart';
// import 'package:healthcareapp_try1/Pages/Home/homepage_content.dart';
// import 'package:healthcareapp_try1/Pages/Home/profile_page.dart';
// import 'package:healthcareapp_try1/Pages/MedicalRecord/medical_record_page.dart';
// import 'package:healthcareapp_try1/Widgets/custom_theme_toogle.dart';
// import 'package:healthcareapp_try1/core/theme/app_colors.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   bool _isNavigating = false;

//   @override
//   void initState() {
//     super.initState();
//     checkStoredData();
//   }

//   Future<void> checkStoredData() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final keys = prefs.getKeys(); // بيجيب كل المفاتيح المتخزنة

//     for (String key in keys) {
//       log('Key: $key, Value: ${prefs.get(key)}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     final size = MediaQuery.of(context).size;
//     final bool isTablet = size.width > 600;

//     // نستخدم MultiBlocListener إذا كان لديك مستمعين كثر، أو BlocListener واحد هنا
//     return BlocListener<ProfileCubit, ProfileState>(
//       listener: (context, state) async {
//         if (state is ProfileLoading) {
//           if (!_isNavigating) {
//             // ✅ بس لو مش بنتنقل
//             showDialog(
//               context: context,
//               barrierDismissible: false,
//               builder: (_) => const Center(child: CircularProgressIndicator()),
//             );
//           }
//         } else if (state is ProfileSuccess) {
//           if (_isNavigating) return; // ✅ لو بالفعل بنتنقل، اتجاهل
//           _isNavigating = true;

//           if (Navigator.canPop(context)) Navigator.pop(context); // اقفل loading

//           final updated = await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => PatientProfilePage(profile: state.profile),
//             ),
//           );

//           _isNavigating = false; // ✅ خلاص رجعنا

//           if (updated == true && context.mounted) {
//             context.read<ProfileCubit>().getProfile();
//           }
//         } else if (state is ProfileError) {
//           if (Navigator.canPop(context)) Navigator.pop(context);
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.message), backgroundColor: Colors.red),
//           );
//         }
//       },
//       child: BlocBuilder<NavigationBloc, NavigationState>(
//         builder: (context, state) {
//           return Scaffold(
//             extendBody: true,
//             backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//             appBar: AppBar(
//               backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//               animateColor: true,
//               scrolledUnderElevation: 0,
//               automaticallyImplyLeading: false,
//               elevation: 0,
//               toolbarHeight: isTablet ? 80 : 70,
//               title: Row(
//                 children: [
//                   const Iconheartstet(),
//                   SizedBox(width: size.width * 0.03),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 6),
//                     child: Text(
//                       "HealthCare",
//                       style: TextStyle(
//                         color: Theme.of(context).textTheme.titleLarge?.color,
//                         fontFamily: "Cotta",
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               // أضفت زر لفتح الـ Drawer لأنك استخدمت endDrawer
//               actions: [
//                 Builder(
//                   builder: (context) => IconButton(
//                     icon: Icon(
//                       Icons.menu,
//                       color: Theme.of(context).iconTheme.color,
//                     ),
//                     onPressed: () => Scaffold.of(context).openEndDrawer(),
//                   ),
//                 ),
//               ],
//             ),
//             endDrawer: Drawer(
//               backgroundColor: Theme.of(context).brightness == Brightness.dark
//                   ? AppColors.bgDark
//                   : AppColors.bgLight,
//               child: ListView(
//                 padding: EdgeInsets.zero,
//                 children: [
//                   // 🔵 Header
//                   Container(
//                     height: 140,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: Theme.of(context).brightness == Brightness.dark
//                             ? [Color(0xFF1E3A8A), Color(0xFF2563EB)]
//                             : [Color(0xff0861dd), Color(0xff4da3ff)],
//                       ),
//                     ),
//                     child: const Padding(
//                       padding: EdgeInsets.only(left: 16, bottom: 16),
//                       child: Align(
//                         alignment: Alignment.bottomLeft,
//                         child: Text(
//                           "Settings",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 26,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: 'Cotta',
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 10),

//                   // 👤 Section
//                   _buildTile(
//                     context,
//                     icon: Icons.person_outline,
//                     title: "Profile",
//                     onTap: () {
//                       Navigator.pop(context);
//                       context.read<ProfileCubit>().getProfile();
//                     },
//                   ),

//                   _buildTile(
//                     context,
//                     icon: Icons.calendar_month,
//                     title: "My Booking",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => MyBookingPage()),
//                       );
//                     },
//                   ),

//                   _buildTile(
//                     context,
//                     icon: FontAwesomeIcons.fileMedical,
//                     title: "Medical Record",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => BlocProvider(
//                             create: (_) =>
//                                 MedicalRecordCubit(AuthService())
//                                   ..fetchMedicalRecord(),
//                             child: const MedicalRecordPage(),
//                           ),
//                         ),
//                       );
//                     },
//                   ),

//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     child: Divider(color: Theme.of(context).dividerColor),
//                   ),

//                   // 💬 Section
//                   _buildTile(
//                     context,
//                     icon: Icons.chat,
//                     title: "My Conversations",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const MyConversations(),
//                         ),
//                       );
//                     },
//                   ),

//                   _buildTile(
//                     context,
//                     icon: Icons.lock,
//                     title: "Change Password",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const ChangePasswordPage(),
//                         ),
//                       );
//                     },
//                   ),

//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     child: Divider(color: Theme.of(context).dividerColor),
//                   ),

//                   // 🌗 Theme Switch (شكل شيك)
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 8,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Dark Mode",
//                           style: TextStyle(fontFamily: 'Agency', fontSize: 14),
//                         ),
//                         CustomThemeSwitch(),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 10),

//                   // 🚪 Logout
//                   _buildTile(
//                     context,
//                     icon: Icons.logout,
//                     title: "Logout",
//                     isDanger: true,
//                     onTap: () async {
//                       context.read<NavigationBloc>().add(TabChanged(0));
//                       await AuthServiceLogout.logout(context);
//                     },
//                   ),

//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//             body: SafeArea(
//               bottom: false,
//               child: AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 300),
//                 child: _buildPage(state.selectedIndex, state),
//                 transitionBuilder: (Widget child, Animation<double> animation) {
//                   return FadeTransition(opacity: animation, child: child);
//                 },
//               ),
//             ),
//             bottomNavigationBar: _buildPremiumNavBar(context, state),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildTile(
//     BuildContext context, {
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     bool isDanger = false,
//   }) {
//     final theme = Theme.of(context);

//     return ListTile(
//       leading: Icon(icon, color: isDanger ? Colors.red : theme.iconTheme.color),
//       title: Text(
//         title,
//         style: TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//           color: isDanger ? Colors.red : theme.textTheme.bodyLarge?.color,
//           fontFamily: 'Agency',
//         ),
//       ),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       onTap: onTap,
//       hoverColor: theme.colorScheme.primary.withOpacity(0.08),
//     );
//   }

//   Widget _buildPage(int index, NavigationState state) {
//     switch (index) {
//       case 0:
//         return HomePageContent();
//       case 1:
//         return BookingPage(initialTestIds: state.initialTestIds);
//       case 2:
//         return HealthChatScreen();
//       case 3:
//         return FeedScreen();
//       case 4:
//         return AmbulancePage();
//       default:
//         return const SizedBox();
//     }
//   }

//   Widget _buildPremiumNavBar(BuildContext context, NavigationState state) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return CurvedNavigationBar(
//       index: state.selectedIndex,
//       backgroundColor: Colors.transparent,
//       color: isDark ? AppColors.primaryDark : AppColors.primary,
//       buttonBackgroundColor: isDark ? AppColors.primaryDark : AppColors.primary,
//       height: 50,
//       items: const <Widget>[
//         Icon(Icons.home, color: Colors.white),
//         Icon(Icons.calendar_today_rounded, color: Colors.white),
//         Icon(Icons.smart_toy_sharp, color: Colors.white),
//         Icon(Icons.supervised_user_circle_sharp, color: Colors.white),
//         Icon(FontAwesomeIcons.truckMedical, color: Colors.white),
//       ],
//       onTap: (index) {
//         context.read<NavigationBloc>().add(TabChanged(index));
//       },
//     );
//   }
// }

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
    checkStoredData();
  }

  Future<void> checkStoredData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (String key in keys) {
      log('Key: $key, Value: ${prefs.get(key)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.width > 600;

    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) async {
        if (state is ProfileLoading) {
          if (!_isNavigating) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          }
        } else if (state is ProfileSuccess) {
          if (_isNavigating) return;
          _isNavigating = true;
          if (Navigator.canPop(context)) Navigator.pop(context);
          final updated = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PatientProfilePage(profile: state.profile),
            ),
          );
          _isNavigating = false;
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
              actions: [
                Builder(
                  builder: (context) => GestureDetector(
                    onTap: () => Scaffold.of(context).openEndDrawer(),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _iconBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.menu, color: _accent, size: 20),
                    ),
                  ),
                ),
              ],
            ),
            endDrawer: _buildDrawer(context),
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

  // ── Drawer ────────────────────────────────────────────────────────────────
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: _pageBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(32)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header card ───────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _cardBg,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [_cardShadow],
                  ),
                  child: Row(
                    children: [
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
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _cardBg,
                          ),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: _iconBg,
                            child: Icon(
                              Icons.person_outline_rounded,
                              color: _accent,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'HealthCare',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cotta',
                              color: _primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _accent.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _accent.withOpacity(0.20),
                              ),
                            ),
                            child: Text(
                              'Settings',
                              style: TextStyle(
                                color: _accent,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Agency',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Account section ───────────────────────────────
                _sectionLabel('Account'),
                const SizedBox(height: 10),
                _buildSection([
                  _drawerTile(
                    context,
                    icon: Icons.person_outline_rounded,
                    title: 'Profile',
                    onTap: () {
                      Navigator.pop(context);
                      context.read<ProfileCubit>().getProfile();
                    },
                  ),
                  _drawerDivider(),
                  _drawerTile(
                    context,
                    icon: Icons.calendar_month_outlined,
                    title: 'My Booking',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MyBookingPage()),
                      );
                    },
                  ),
                  _drawerDivider(),
                  _drawerTile(
                    context,
                    icon: FontAwesomeIcons.fileMedical,
                    title: 'Medical Record',
                    onTap: () {
                      Navigator.pop(context);
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
                ]),

                const SizedBox(height: 20),

                // ── Communication section ─────────────────────────
                _sectionLabel('Communication'),
                const SizedBox(height: 10),
                _buildSection([
                  _drawerTile(
                    context,
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'My Conversations',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyConversations(),
                        ),
                      );
                    },
                  ),
                  _drawerDivider(),
                  _drawerTile(
                    context,
                    icon: Icons.lock_outline_rounded,
                    title: 'Change Password',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordPage(),
                        ),
                      );
                    },
                  ),
                ]),

                const SizedBox(height: 20),

                // ── Preferences section ───────────────────────────
                _sectionLabel('Preferences'),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: _cardBg,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [_cardShadow],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _iconBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _isDark
                              ? Icons.dark_mode_outlined
                              : Icons.light_mode_outlined,
                          size: 16,
                          color: _accent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Dark Mode',
                          style: TextStyle(
                            fontFamily: 'Agency',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _primary,
                          ),
                        ),
                      ),
                      const CustomThemeSwitch(),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Logout ────────────────────────────────────────
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    context.read<NavigationBloc>().add(TabChanged(0));
                    await AuthServiceLogout.logout(context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(_isDark ? 0.15 : 0.07),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red.withOpacity(0.25)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          size: 18,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.red.shade400,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Agency',
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Section card wrapper ──────────────────────────────────────────────────
  Widget _buildSection(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [_cardShadow],
      ),
      child: Column(children: children),
    );
  }

  // ── Section label ─────────────────────────────────────────────────────────
  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: 'Agency',
          color: _secondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ── Drawer tile ───────────────────────────────────────────────────────────
  Widget _drawerTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 16, color: _accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Agency',
                  color: _primary,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 13, color: _secondary),
          ],
        ),
      ),
    );
  }

  Widget _drawerDivider() =>
      Divider(color: _divider, height: 1, indent: 16, endIndent: 16);

  // ── Pages & nav bar (unchanged logic) ────────────────────────────────────
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
    return CurvedNavigationBar(
      index: state.selectedIndex,
      backgroundColor: Colors.transparent,
      color: _isDark ? AppColors.primaryDark : AppColors.primary,
      buttonBackgroundColor: _isDark
          ? AppColors.primaryDark
          : AppColors.primary,
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
