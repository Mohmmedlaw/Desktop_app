import 'package:desktop_/ui/Reverpod/color.dart';
import 'package:desktop_/ui/Reverpod/screens.dart';
import 'package:desktop_/ui/Screens/Installed_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultimate_flutter_icons/flutter_icons.dart';

class Part1ForDescktop extends ConsumerWidget {
  const Part1ForDescktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ww = MediaQuery.sizeOf(context).width;
    final hh = MediaQuery.sizeOf(context).height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: hh * 0.05),
        Text(
          "Apps",
          style: myTextStyle(context, ref, 30, Colors.white, FontWeight.w600),
        ),
        SizedBox(height: hh * 0.02),
        Expanded(
          child: SizedBox(
            width: ww * 0.5,
            child: ListView.builder(
              padding: EdgeInsets.only(right: 8),
              itemCount: 3,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    ref.watch(screensProvider.notifier).state = AppsScreen();
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2b2b2b),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        FIcon(CI.CiBoxList, color: Colors.white, size: 25),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Install apps",
                                style: myTextStyle(context, ref, 14),
                              ),
                              SizedBox(height: 6),
                              SizedBox(
                                height: 30,
                                child: Stack(
                                  children: List.generate(10, (i) {
                                    return Positioned(
                                      left: i * 10.0,
                                      child: Container(
                                        width: 30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colorapp.barapps,
                                            width: 2,
                                          ),
                                        ),
                                        child: ClipOval(
                                          child: Image.asset(
                                            "assets/image/discord-round-color-icon (1).png",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
