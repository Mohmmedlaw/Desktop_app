import 'package:desktop_/ui/Reverpod/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:desktop_/ui/Reverpod/select.dart';
import 'package:desktop_/ui/Reverpod/color.dart';
import 'package:ultimate_flutter_icons/flutter_icons.dart';

class ThemsScreen extends ConsumerWidget {
  const ThemsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ww = MediaQuery.sizeOf(context).width;
    final hh = MediaQuery.sizeOf(context).height;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: hh * 0.05)),
        SliverToBoxAdapter(
          child: Text("الثيمات", style: myTextStyle(context, ref, 20)),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: Row(
            children: <Widget>[
              Container(
                width: ww * 0.18,
                height: hh * .2,
                decoration: BoxDecoration(
                  border: Border.all(width: 10),
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              SizedBox(width: ww * .05),
              SizedBox(
                width: ww * .2,
                height: hh * .2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LayoutBuilder(
                    builder: (
                      BuildContext context,
                      BoxConstraints constraints,
                    ) {
                      const int crossAxisCount = 3;
                      final int mainAxisCount = (5 / crossAxisCount).ceil();
                      const double mainAxisSpacing = 8;
                      const double crossAxisSpacing = 8;
                      final double itemWidth =
                          (constraints.maxWidth -
                              (crossAxisCount - 1) * crossAxisSpacing) /
                          crossAxisCount;
                      final double itemHeight =
                          (constraints.maxHeight -
                              (mainAxisCount - 1) * mainAxisSpacing) /
                          mainAxisCount;

                      final double childAspectRatio = itemWidth / itemHeight;
                      return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: mainAxisSpacing,
                          crossAxisSpacing: crossAxisSpacing,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomContanerPart1 extends ConsumerWidget {
  const CustomContanerPart1({
    super.key,
    required this.isSelected,
    required this.item,
  });
  final Items item;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedColor = ref.watch(colorProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: isSelected ? selectedColor : Colors.transparent,
        child: SizedBox(
          child: Row(
            children: [
              Container(
                width: 5,
                height: MediaQuery.sizeOf(context).height * 0.02,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.red : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                child: Row(
                  children: <Widget>[
                    FIcon(item.icon, color: item.coloricon, size: 30),
                    const SizedBox(width: 10),
                    Text(item.title, style: myTextStyle(context, ref, 14)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
