import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Bloc/ThemeCubit/theme_cubit.dart';

class CustomThemeSwitch extends StatefulWidget {
  const CustomThemeSwitch({super.key});

  @override
  State<CustomThemeSwitch> createState() => _CustomThemeSwitchState();
}

class _CustomThemeSwitchState extends State<CustomThemeSwitch>
    with TickerProviderStateMixin {
  late final AnimationController _sunController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 15),
  )..repeat();

  @override
  void dispose() {
    _sunController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, state) {
        final isDark = state == ThemeMode.dark;

        return GestureDetector(
          onTap: () {
            context.read<ThemeCubit>().toggleTheme(!isDark);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            width: 64,
            height: 34,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: isDark ? const Color(0xFF183153) : const Color(0xFF73C0FC),
            ),
            child: Stack(
              children: [
                // 🌙 Moon
                Positioned(
                  left: 6,
                  top: 6,
                  child: Icon(
                    Icons.nightlight_round,
                    size: 20,
                    color: isDark
                        ? const Color(0xFF73C0FC)
                        : Colors.white.withOpacity(0.5),
                  ),
                ),

                // ☀️ Sun (rotating)
                Positioned(
                  right: 6,
                  top: 6,
                  child: RotationTransition(
                    turns: _sunController,
                    child: Icon(
                      Icons.wb_sunny_rounded,
                      size: 20,
                      color: isDark
                          ? Colors.white.withOpacity(0.5)
                          : Colors.white,
                    ),
                  ),
                ),

                // 🔘 Knob
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  left: isDark ? 32 : 2,
                  top: 2,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? const Color(0xFF0F1C2E)
                          : const Color(0xFFE8E8E8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
