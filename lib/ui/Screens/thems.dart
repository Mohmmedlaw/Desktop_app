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
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: ww * 0.5,
        child: CustomScrollView(
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
                    width: ww * .18,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(width: 10),
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  SizedBox(width: ww * .05),
                  SizedBox(
                    width: ww * .2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 1.2,
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemCount: 16,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colorapp.barapps,
                    child: Center(
                      child: Text(
                        "$index",
                        style: myTextStyle(context, ref, 14),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
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
