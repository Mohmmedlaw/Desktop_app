import 'package:desktop_/ui/Reverpod/model.dart';
import 'package:desktop_/ui/Reverpod/screens.dart';
import 'package:desktop_/ui/Reverpod/select.dart';
import 'package:desktop_/ui/Reverpod/color.dart';
import 'package:desktop_/ui/Screens/descktop.dart';
import 'package:desktop_/ui/Screens/apps.dart';
import 'package:desktop_/ui/Screens/thems.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultimate_flutter_icons/flutter_icons.dart';

class Part1 extends ConsumerWidget {
  const Part1({super.key});

  final List<Items> item = const [
    Items(
      title: "أسطح المكتب",
      icon: IO.IoIosDesktop,
      coloricon: Color(0xFF4A90E2),
    ), // أزرق هادئ
    Items(
      title: "الخلفيات",
      icon: PI.PiSelectionBackground,
      coloricon: Color(0xFF7ED6A8), // أخضر هادئ
    ),
    Items(
      title: "الثيمات",
      icon: SI.SiHackthebox,
      coloricon: Color(0xFFE57373),
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedCategoryProvider);
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.18,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text("Mohmmed", style: myTextStyle(context, ref, 16)),
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.person,
                    size: 36,
                    color: Colors.grey.shade700,
                  ),
                ),
                subtitle: Text(
                  "dawpjod@gmail.com",
                  style: myTextStyle(context, ref, 12, Colors.grey.shade200),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: item.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        ref.read(selectedCategoryProvider.notifier).state =
                            index;
                        if (index == 1) {
                          ref.watch(screensProvider.notifier).state =
                              ThemsScreen();
                        } else if (index == 0) {
                          ref.watch(screensProvider.notifier).state =
                              Part1ForDescktop();
                        } else {
                          ref.watch(screensProvider.notifier).state =
                              AppsScreen();
                        }
                      },
                      child: CustomContanerPart1(
                        item: item[index],
                        isSelected: selectedIndex == index,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            fillOverscroll: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                CustomContanerPart1(
                  isSelected: false,
                  item: Items(
                    title: "الإعدادات",
                    icon: IO.IoIosSettings,
                    coloricon: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomContanerPart1 extends ConsumerStatefulWidget {
  const CustomContanerPart1({
    super.key,
    required this.isSelected,
    required this.item,
  });

  final Items item;
  final bool isSelected;

  @override
  ConsumerState<CustomContanerPart1> createState() =>
      _CustomContanerPart1State();
}

class _CustomContanerPart1State extends ConsumerState<CustomContanerPart1> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final selectedColor = ref.watch(colorProvider);
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color:
              widget.isSelected
                  ? selectedColor
                  : _isHovering
                  ? Colors.white.withValues(alpha: .05)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 3,
              height: 20,
              decoration: BoxDecoration(
                color:
                    widget.isSelected
                        ? Colors.red.shade300
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FIcon(
                    widget.item.icon,
                    color: widget.item.coloricon,
                    size: 26,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.item.title,
                    style: myTextStyle(context, ref, 14).copyWith(
                      fontWeight:
                          widget.isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
