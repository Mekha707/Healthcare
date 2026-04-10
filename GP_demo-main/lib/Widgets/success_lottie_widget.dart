import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessLottieWidget extends StatelessWidget {
  const SuccessLottieWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/animations/Success.json',
        width: 100,
        height: 100,
        fit: BoxFit.contain,
      ),
    );
  }
}
