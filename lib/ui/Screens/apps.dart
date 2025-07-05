import 'package:desktop_/ui/Reverpod/gridindex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:desktop_/ui/Reverpod/color.dart';
import 'package:desktop_/ui/Reverpod/gird.dart';

typedef GetFileIconNative =
    Int32 Function(
      Pointer<Utf16> filePath,
      Pointer<Pointer<Uint8>> outBytes,
      Pointer<Int32> outSize,
    );

typedef GetFileIconDart =
    int Function(
      Pointer<Utf16> filePath,
      Pointer<Pointer<Uint8>> outBytes,
      Pointer<Int32> outSize,
    );

class IconExtractor {
  late final DynamicLibrary _lib;
  late final GetFileIconDart _getFileIcon;

  IconExtractor(String dllPath) {
    _lib = DynamicLibrary.open(dllPath);
    _getFileIcon =
        _lib
            .lookup<NativeFunction<GetFileIconNative>>('GetFileIcon')
            .asFunction();
  }

  Uint8List? getIcon(String filePath) {
    final filePathPtr = filePath.toNativeUtf16();
    final outBytesPtr = calloc<Pointer<Uint8>>();
    final outSizePtr = calloc<Int32>();

    final result = _getFileIcon(filePathPtr, outBytesPtr, outSizePtr);

    if (result == 1) {
      final size = outSizePtr.value;
      final bytes = outBytesPtr.value.asTypedList(size);
      calloc.free(filePathPtr);
      calloc.free(outBytesPtr);
      calloc.free(outSizePtr);
      return Uint8List.fromList(bytes);
    } else {
      calloc.free(filePathPtr);
      calloc.free(outBytesPtr);
      calloc.free(outSizePtr);
      return null;
    }
  }
}

// Global provider for switch states
final switchListProvider = StateProvider<List<bool>>((ref) => []);

class AppsScreen extends ConsumerWidget {
  const AppsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final hh = MediaQuery.sizeOf(context).height;
    final isGrid = ref.watch(gridviewProvider);
    final griddd = ref.watch(gridIndexProvider);
    return Builder(
      builder: (context) {
        final desktopDir = Directory(
          '${Platform.environment['USERPROFILE']}\\Desktop',
        );

        final desktopFiles =
            desktopDir.existsSync() ? desktopDir.listSync() : [];

        // Initialize switch states if needed
        final currentSwitches = ref.watch(switchListProvider);
        if (currentSwitches.length != desktopFiles.length) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final initialSwitches = List.generate(desktopFiles.length, (index) {
              return griddd.contains(index);
            });
            ref.read(switchListProvider.notifier).state = initialSwitches;
          });
        } else {
          final shouldUpdate = List.generate(desktopFiles.length, (index) {
            return griddd.contains(index);
          });
          if (!listEquals(currentSwitches, shouldUpdate)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(switchListProvider.notifier).state = shouldUpdate;
            });
          }
        }

        return Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: screenWidth * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: hh * 0.05),
                Text(
                  "Installed Apps",
                  style: myTextStyle(
                    context,
                    ref,
                    30,
                    Colors.white,
                    FontWeight.w600,
                  ),
                ),
                SizedBox(height: hh * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${desktopFiles.length} apps found",
                      style: myTextStyle(context, ref, 14),
                    ),
                    if (griddd.isNotEmpty) ...[
                      const SizedBox(width: 16),
                      Text(
                        "${griddd.length} selected",
                        style: myTextStyle(
                          context,
                          ref,
                          14,
                          const Color(0xfff18263),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
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
                              ref.watch(gridviewProvider.notifier).state =
                                  index == 0;
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color:
                                    selected
                                        ? const Color.fromARGB(
                                          42,
                                          183,
                                          183,
                                          183,
                                        )
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(
                                index == 0
                                    ? Icons.grid_view_outlined
                                    : Icons.list,
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
                  child: SizedBox(
                    width: screenWidth * 0.6,
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
                              itemCount: desktopFiles.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (index >= desktopFiles.length) {
                                  return const SizedBox.shrink();
                                }
                                final file = desktopFiles[index];
                                final fullFileName = file.path.split('\\').last;
                                final fileName =
                                    (FileSystemEntity.isDirectorySync(
                                              file.path,
                                            ) ||
                                            !fullFileName.contains('.'))
                                        ? fullFileName
                                        : fullFileName.substring(
                                          0,
                                          fullFileName.lastIndexOf('.'),
                                        );
                                final isDir = FileSystemEntity.isDirectorySync(
                                  file.path,
                                );

                                return GestureDetector(
                                  onTap: () async {
                                    final currentSelection = List<int>.from(
                                      griddd,
                                    );
                                    if (currentSelection.contains(index)) {
                                      await Process.run('attrib', [
                                        '-h',
                                        file.path.toString(),
                                      ]);

                                      currentSelection.remove(index);
                                    } else {
                                      currentSelection.add(index);
                                      await Process.run('attrib', [
                                        '+h',
                                        file.path.toString(),
                                      ]);
                                    }
                                    ref.read(gridIndexProvider.notifier).state =
                                        currentSelection;

                                    // تحديث حالة الـ switch أيضاً
                                    final updatedSwitches = [
                                      ...ref.read(switchListProvider),
                                    ];
                                    updatedSwitches[index] = currentSelection
                                        .contains(index);
                                    ref
                                        .read(switchListProvider.notifier)
                                        .state = updatedSwitches;
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: BorderSide(
                                        color:
                                            griddd.contains(index)
                                                ? const Color(0xfff18263)
                                                : Colors.transparent,
                                        width: griddd.contains(index) ? 3 : 2,
                                      ),
                                    ),
                                    elevation: griddd.contains(index) ? 4 : 2,
                                    color:
                                        griddd.contains(index)
                                            ? const Color(0xFF3E3E3E)
                                            : const Color(0xFF2E2E2E),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            isDir
                                                ? Icons.folder
                                                : Icons.insert_drive_file,
                                            size: 32,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            child: Center(
                                              child: Text(
                                                overflow: TextOverflow.ellipsis,
                                                fileName,
                                                style: myTextStyle(
                                                  context,
                                                  ref,
                                                  12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                            : ListView.builder(
                              padding: const EdgeInsets.only(right: 8),
                              itemCount: desktopFiles.length,
                              itemBuilder: (context, index) {
                                final switches = ref.watch(switchListProvider);

                                if (index >= desktopFiles.length) {
                                  return const SizedBox.shrink();
                                }
                                final file = desktopFiles[index];
                                final fullFileName = file.path.split('\\').last;

                                final fileName =
                                    (FileSystemEntity.isDirectorySync(
                                              file.path,
                                            ) ||
                                            !fullFileName.contains('.'))
                                        ? fullFileName
                                        : fullFileName.substring(
                                          0,
                                          fullFileName.lastIndexOf('.'),
                                        );
                                final isDir = FileSystemEntity.isDirectorySync(
                                  file.path,
                                );

                                final leadingWidget = Icon(
                                  isDir
                                      ? Icons.folder
                                      : Icons.insert_drive_file,
                                  size: 32,
                                  color: Colors.white,
                                );
                                final currentSelection = List<int>.from(griddd);
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        griddd.contains(index)
                                            ? const Color.fromARGB(
                                              180,
                                              59,
                                              59,
                                              59,
                                            )
                                            : const Color.fromARGB(
                                              120,
                                              59,
                                              59,
                                              59,
                                            ),
                                    borderRadius: BorderRadius.circular(6),
                                    border: null,
                                  ),
                                  child: Row(
                                    children: [
                                      leadingWidget,
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              fileName,
                                              style: myTextStyle(
                                                context,
                                                ref,
                                                13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (switches.length > index)
                                        Row(
                                          children: [
                                            Text(
                                              currentSelection.contains(index)
                                                  ? "on"
                                                  : "Off",
                                              style: myTextStyle(
                                                context,
                                                ref,
                                                14,
                                              ),
                                            ),
                                            Transform.scale(
                                              scale:
                                                  0.8, // تصغير حجم الـ Switch إلى 70%
                                              child: Switch(
                                                activeColor: Colors.black,
                                                activeTrackColor: const Color(
                                                  0xfff18263,
                                                ),
                                                inactiveThumbColor:
                                                    Colors.white,
                                                inactiveTrackColor:
                                                    const Color.fromARGB(
                                                      0,
                                                      92,
                                                      10,
                                                      10,
                                                    ),
                                                value: griddd.contains(index),
                                                onChanged: (value) async {
                                                  if (value) {
                                                    if (!currentSelection
                                                        .contains(index)) {
                                                      currentSelection.add(
                                                        index,
                                                      );

                                                      await Process.run(
                                                        'attrib',
                                                        [
                                                          '+h',
                                                          file.path.toString(),
                                                        ],
                                                      );
                                                    }
                                                  } else {
                                                    currentSelection.remove(
                                                      index,
                                                    );
                                                    await Process.run(
                                                      'attrib',
                                                      [
                                                        '-h',
                                                        file.path.toString(),
                                                      ],
                                                    );
                                                  }
                                                  ref
                                                      .read(
                                                        gridIndexProvider
                                                            .notifier,
                                                      )
                                                      .state = currentSelection;
                                                  final updated = [...switches];
                                                  updated[index] = value;
                                                  ref
                                                      .read(
                                                        switchListProvider
                                                            .notifier,
                                                      )
                                                      .state = updated;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                );
                              },
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
