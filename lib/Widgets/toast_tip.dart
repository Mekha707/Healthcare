// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(149, 157, 165, 0.2),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // موجة خلفية
          Positioned(
            left: -31,
            top: 32,
            child: Transform.rotate(
              angle: 90 * 3.1415926535 / 180, // 90 درجة بالـ radians
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Color(0x3A4777FF), // نفس اللون مع شفافية
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          // محتوى الكارد
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // النصوص
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Please note:',
                      style: TextStyle(
                        color: Color(0xFF124FFF),
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Online consultations can be paid for via online payment only',
                      style: TextStyle(color: Color(0xFF555555), fontSize: 14),
                    ),
                  ],
                ),
              ),
              // أيقونة الغلق
              GestureDetector(
                onTap: () {
                  // فعل عند الضغط
                  print('Close tapped');
                },
                child: Icon(Icons.close, color: Color(0xFF555555), size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
