// ignore_for_file: deprecated_member_use, unused_local_variable

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcareapp_try1/Pages/Booking/doctor_page.dart';
import 'package:healthcareapp_try1/Pages/Booking/lab_page.dart';
import 'package:healthcareapp_try1/Pages/Booking/nurse_page.dart';
import 'package:healthcareapp_try1/core/Theme/app_colors.dart';

class BookingPage extends StatefulWidget {
  final List<String> initialTestIds;

  const BookingPage({super.key, this.initialTestIds = const []});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late int _selectedIndex;
  late final PageController _pageController;
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTestIds.isNotEmpty ? 2 : 0;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void didUpdateWidget(BookingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTestIds.isNotEmpty &&
        widget.initialTestIds != oldWidget.initialTestIds) {
      setState(() {
        _selectedIndex = 2; // روح على tab الـ Labs
      });
    }
  }

  List<Map<String, dynamic>> tabBar = [
    {
      "name": "Doctor",
      "icon": FontAwesomeIcons.stethoscope,
      // "color": Color(0xff131ab9),
    },
    {
      "name": "Nurse",
      "icon": Icons.medical_services,
      "color": Color(0xff0082c5),
    },
    {"name": "Labs", "icon": Icons.biotech, "color": Colors.teal},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(child: _buildMainBookingContent()),
    );
  }

  Widget _buildMainBookingContent() {
    // جلب أبعاد الشاشة لاستخدامها في الحسابات النسبية
    final size = MediaQuery.of(context).size;
    final bool isSmallScreen = size.width < 360; // للهواتف الصغيرة جداً
    final bool isTablet = size.width > 600; // للأجهزة اللوحية
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // مهم جداً
        children: [
          // 1. الهيدر مع هوامش مرنة
          Padding(
            padding: EdgeInsets.only(
              left: isTablet ? 40 : 25,
              top: isTablet ? 40 : 25,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Book Appointment",
                  style: TextStyle(
                    fontSize: isTablet ? 25 : 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cotta',
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Book doctors, nurses, or lab tests",
                  style: TextStyle(
                    fontSize: isTablet ? 20 : 16,
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontFamily: 'Agency',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // 2. التبويبات (Tabs) - تقسيم بالتساوي
          Container(
            height: isTablet ? 80 : 65,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isDark ? AppColors.surfaceDark : Colors.grey.shade200,
            ),
            child: Row(
              // استبدلنا الـ ListView بـ Row
              children: List.generate(tabBar.length, (index) {
                bool isSelected = _selectedIndex == index;
                Color categoryColor = getTabColor(context, index);

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _selectedIndex = index);

                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 650),
                        curve: Curves.easeOutCubic,
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeOutCubic,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),

                        // 🔥 BACKGROUND (Glass effect)
                        color: isSelected
                            ? categoryColor.withOpacity(isDark ? 0.20 : 0.12)
                            : isDark
                            ? Colors.white.withOpacity(0.04)
                            : Colors.white,

                        // 🔥 BORDER GLOW
                        border: Border.all(
                          color: isSelected
                              ? categoryColor.withOpacity(0.9)
                              : Colors.transparent,
                          width: 1.5,
                        ),

                        // 🔥 SHADOW (Glow effect)
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: categoryColor.withOpacity(0.35),
                                  blurRadius: 18,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 6),
                                ),
                              ]
                            : [],
                      ),

                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 300),
                        scale: isSelected ? 1.05 : 1.0,

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              tabBar[index]['icon'],
                              size: isSelected ? 22 : 18,
                              color: isSelected
                                  ? categoryColor
                                  : isDark
                                  ? Colors.white60
                                  : Colors.grey[700],
                            ),

                            const SizedBox(height: 5),

                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              style: TextStyle(
                                color: isSelected
                                    ? categoryColor
                                    : isDark
                                    ? Colors.white60
                                    : Colors.grey[700],
                                fontWeight: FontWeight.w600,
                                fontSize: isSelected ? 13 : 12,
                                fontFamily: 'Agency',
                              ),
                              child: Text(tabBar[index]['name']),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 15),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.72,
            child: PageView(
              controller: _pageController,
              physics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.fast,
              ),
              pageSnapping: true,
              allowImplicitScrolling: true,
              onPageChanged: (index) {
                setState(() => _selectedIndex = index);
              },
              children: [
                _buildAnimatedPage(const DoctorPage(), 0),
                _buildAnimatedPage(const NursePage(), 1),
                _buildAnimatedPage(
                  LabPage(initialTestIds: widget.initialTestIds),
                  2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Pages Of Booking
  Color getTabColor(BuildContext context, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (index) {
      case 0: // Doctor
        return isDark ? const Color(0xfff8f0e4) : const Color(0xff131ab9);
      case 1: // Nurse
        return isDark ? const Color(0xff62f3ff) : const Color(0xff0082c5);
      case 2: // Labs
        return isDark ? const Color(0xfffcb0db) : Colors.teal;
      default:
        return Colors.grey;
    }
  }

  Widget _buildAnimatedPage(Widget child, int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, _) {
        double page = 0;

        if (_pageController.hasClients &&
            _pageController.position.haveDimensions) {
          page = _pageController.page ?? _selectedIndex.toDouble();
        }

        final diff = (page - index).abs();

        final t = Curves.easeOutCubic.transform((1 - diff).clamp(0.0, 1.0));

        final scale = 0.92 + (t * 0.08);
        final opacity = 0.80 + (t * 0.20);
        final translateX = (page - index) * 20;

        return Transform.translate(
          offset: Offset(translateX, 0),
          child: Transform.scale(
            scale: scale,
            child: Opacity(opacity: opacity, child: child),
          ),
        );
      },
    );
  }
}
