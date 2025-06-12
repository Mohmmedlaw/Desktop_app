import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultimate_flutter_icons/flutter_icons.dart';

import 'package:desktop_/ui/Reverpod/color.dart';
import 'package:desktop_/ui/Reverpod/gird.dart';

class AppsScreen extends ConsumerWidget {
  const AppsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final hh = MediaQuery.sizeOf(context).height;
    final isGrid = ref.watch(gridviewProvider);
    return SizedBox(
      width: screenWidth * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: hh * 0.05),
          Text(
            "Installed Apps",
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 24),
          Row(
            children: [
              Text("113 apps found", style: myTextStyle(context, ref, 14)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xff2A2A2A).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.grey.shade700.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: List.generate(2, (index) {
                    final bool selected =
                        (index == 0 && isGrid) || (index == 1 && !isGrid);
                    return GestureDetector(
                      onTap: () {
                        ref.watch(gridviewProvider.notifier).state = index == 0;
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color:
                              selected
                                  ? Color.fromARGB(42, 183, 183, 183)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          index == 0 ? Icons.grid_view_outlined : Icons.list,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child:
                isGrid
                    ? GridView.builder(
                      padding: const EdgeInsets.only(top: 12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1,
                          ),
                      itemCount: 50,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                          color: const Color(0xFF2E2E2E),
                          child: Center(
                            child: Text(
                              'App ${index + 1}',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.only(right: 8),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2b2b2b),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              const FIcon(
                                CI.CiApple,
                                color: Colors.white,
                                size: 24,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "App $index",
                                      style: myTextStyle(context, ref, 13),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "19.5 MB | CapCom | 5/9/2019",
                                      style: myTextStyle(
                                        context,
                                        ref,
                                        11,
                                        Colors.grey.shade400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
