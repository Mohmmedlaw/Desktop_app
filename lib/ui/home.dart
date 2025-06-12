import 'dart:ui';
import 'package:desktop_/ui/Reverpod/screens.dart'; // مساراتك الخاصة
import 'package:desktop_/ui/part1.dart'; // مساراتك الخاصة
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ww = MediaQuery.sizeOf(context).width;
    final screens = ref.watch(screensProvider);

    // -- التعديل الأول: استخدام لون أساسي أغمق --
    const windowsDarkerColor = Color(0xFF1C1C1C);

    return Scaffold(
      body: Stack(
        children: [
          Container(color: windowsDarkerColor),
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  // -- التعديل الثاني: تقليل شفافية الإضاءة --
                  Colors.white.withOpacity(0.025), // كانت 0.035
                  Colors.white.withOpacity(0.0),
                ],
              ),
            ),
          ),

          Row(
            children: [
              Part1(),

              SizedBox(width: ww * .14),

              Expanded(child: screens),
            ],
          ),
        ],
      ),
    );
  }
}
