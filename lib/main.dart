// ignore_for_file: unused_local_variable
import 'dart:io';
import 'dart:ui'; // 🔥 مهم للـ blur

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/auth_service.dart';
import 'package:healthcareapp_try1/API/chat_service.dart';
import 'package:healthcareapp_try1/API/notification_service.dart';
import 'package:healthcareapp_try1/API/post_service.dart';
import 'package:healthcareapp_try1/API/profile_service.dart';
import 'package:healthcareapp_try1/API/signal_service.dart';
import 'package:healthcareapp_try1/API/user_service.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/CityCubit/city_cubit.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/LoginBloc/login_bloc.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Patient_Profile.dart/patient_profile_cubit.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/RegisterationBloc/register_bloc.dart';
import 'package:healthcareapp_try1/Bloc/AI_Chat_Bloc/ai_chat_cubit.dart';
import 'package:healthcareapp_try1/Bloc/DetailsBoc/universal_details_cubit.dart';
import 'package:healthcareapp_try1/Bloc/MedicalRecordBloc/medical_record_cubit.dart';
import 'package:healthcareapp_try1/Bloc/Message_Bloc/message_bloc.dart';
import 'package:healthcareapp_try1/Bloc/MyBookingBloc/mybooking_cubit.dart';
import 'package:healthcareapp_try1/Bloc/NavigationBloc/navigation_bloc.dart';
import 'package:healthcareapp_try1/Bloc/PostBloc/post_bloc.dart';
import 'package:healthcareapp_try1/Bloc/ThemeCubit/theme_cubit.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/DoctorBloc/doctor_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/LabBloc/lab_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/NurseBloc/nurse_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/SpecialtyBloc/specialty_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/SpecialtyBloc/specialty_event.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/Tests_Bloc/test_bloc.dart';
import 'package:healthcareapp_try1/Pages/Auth/change_password_page.dart';
import 'package:healthcareapp_try1/Pages/Auth/forget_password_page.dart';
import 'package:healthcareapp_try1/Pages/Auth/login_page.dart';
import 'package:healthcareapp_try1/Pages/Auth/register_step1.dart';
import 'package:healthcareapp_try1/Pages/Auth/register_step2.dart';
import 'package:healthcareapp_try1/Pages/Booking/booking_page.dart';
import 'package:healthcareapp_try1/Pages/Communication/chat_details_page.dart';
import 'package:healthcareapp_try1/Pages/Home/home_page.dart';
import 'package:healthcareapp_try1/Pages/Home/splash_page.dart';
import 'package:healthcareapp_try1/Widgets/slide_route.dart';
import 'package:healthcareapp_try1/core/Theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHttpOverrides extends HttpOverrides {
  // ✅ أضف الـ class هنا
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final initialTheme = await ThemeCubit.loadInitialTheme();
  try {
    // 2. تشغيل خدمة الإشعارات المحلية
    await NotificationService.init();
    print("تم تهيئة نظام الإشعارات بنجاح ✅");
  } catch (e) {
    print("خطأ أثناء تهيئة الإشعارات: $e ❌");
  }
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  final authService = AuthService();

  HttpOverrides.global = MyHttpOverrides();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(authService),
        ),
        BlocProvider<LoginBloc>(create: (context) => LoginBloc(authService)),
        BlocProvider<NavigationBloc>(create: (context) => NavigationBloc()),
        BlocProvider<DoctorsBloc>(
          create: (context) => DoctorsBloc(UserService()),
        ),
        BlocProvider<LabsBloc>(create: (context) => LabsBloc(UserService())),
        BlocProvider<AppointmentsCubit>(
          create: (context) => AppointmentsCubit(ProfileService()),
        ),

        BlocProvider(
          create: (context) =>
              ProfileCubit(AuthService()), // تأكد من تمرير الـ Service الصحيح
        ),
        BlocProvider(
          create: (context) => NursesBloc(nurseService: UserService()),
        ),
        BlocProvider(
          create: (context) =>
              SpecialtyBloc(UserService())..add(LoadSpecialties()),
        ),
        BlocProvider(create: (context) => CitiesCubit(authService)),
        BlocProvider(
          create: (context) => HealthcareDetailsCubit(UserService()),
        ),
        BlocProvider(create: (_) => PostBloc(PostRepository())),
        BlocProvider(create: (context) => TestBloc(UserService())),
        BlocProvider(create: (context) => MedicalRecordCubit(authService)),
        BlocProvider(create: (ctx) => MessageBloc(ChatService())),
        BlocProvider(create: (ctx) => AiChatCubit()),
        BlocProvider(create: (context) => SpecialtyBloc(UserService())),
        // BlocProvider(create: (context) => ChatCubit()),
        BlocProvider(create: (_) => ThemeCubit(initialTheme)), // 🔥 هنا السر
        RepositoryProvider<UserService>(create: (_) => UserService()),
      ],
      child: MainApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MainApp extends StatefulWidget {
  final bool isLoggedIn; // تعريف المتغير
  const MainApp({super.key, required this.isLoggedIn});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _appLinks = AppLinks();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _initChatNotifications();
    _appLinks.uriLinkStream.listen((uri) {
      if (uri.host == 'confirm-email') {
        final userId = uri.queryParameters['userId'];
        final token = uri.queryParameters['token'];
        navigatorKey.currentState?.pushReplacementNamed(
          'VerifyEmail',
          arguments: {'email': '', 'token': token},
        );
      }
    });
  }

  Future<void> _initChatNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final userId = prefs.getString('userId') ?? '';

    if (token.isEmpty) return;

    await SignalRService().initHub(token, currentUserId: userId);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black, // جعل شريط النظام شفاف
        systemNavigationBarIconBrightness:
            Brightness.dark, // لون الأيقونات (أندرويد)
      ),
    );

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 700),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            return Directionality(
              textDirection: TextDirection.ltr, // 🔥 الحل هنا
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, _) {
                  final blurValue = (1 - animation.value) * 10;

                  return Stack(
                    children: [
                      BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: blurValue,
                          sigmaY: blurValue,
                        ),
                        child: Container(color: Colors.transparent),
                      ),
                      Opacity(
                        opacity: animation.value,
                        child: Transform.scale(
                          scale: 0.96 + (animation.value * 0.04),
                          child: child,
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
          child: MaterialApp(
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: state,
            themeAnimationDuration: Duration(milliseconds: 500),
            themeAnimationCurve: Curves.easeInOut,
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case 'Login':
                  return slideLeft2Right(LoginPage());
                case 'Register1':
                  return slideRight2Left(RegisterStep1());
                case 'Register2':
                  return slideRight2Left(RegisterStep2());
                case 'Home':
                  return slideRight2Left(HomePage());
                case 'BookingPage':
                  return slideRight2Left(BookingPage());
                case 'ForgotPassword':
                  return slideRight2Left(ForgotPasswordPage());
                case 'ChangePassword':
                  return slideRight2Left(ChangePasswordPage());
                case '/':
                  return slideRight2Left(
                    SplashScreen(isLoggedIn: widget.isLoggedIn),
                  );
                default:
                  return slideRight2Left(LoginPage());
              }
            },

            initialRoute: 'Home',
          ),
        );
      },
    );
  }
}
