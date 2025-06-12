import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:desktop_/ui/Reverpod/screens.dart';
import 'package:desktop_/ui/part1.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.sizeOf(context).width;
    final screens = ref.watch(screensProvider);
    const baseColor = Color.fromARGB(188, 28, 28, 28);

    return Scaffold(
      backgroundColor: const Color.fromARGB(136, 0, 0, 0),
      body: Stack(
        children: [
          Container(color: baseColor),
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Colors.white.withOpacity(0.025),
                  Colors.white.withOpacity(0.0),
                ],
              ),
            ),
          ),
          Row(
            children: [
              const Part1(),
              SizedBox(width: width * 0.14),
              Expanded(child: screens),
            ],
          ),
        ],
      ),
    );
  }
}
