import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultimate_flutter_icons/flutter_icons.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:ffi';
import 'dart:typed_data';
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

class AppsScreen extends ConsumerWidget {
  const AppsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final hh = MediaQuery.sizeOf(context).height;
    final isGrid = ref.watch(gridviewProvider);
    return Builder(
      builder: (context) {
        final desktopDir = Directory(
          '${Platform.environment['USERPROFILE']}\\Desktop',
        );
        final desktopFiles =
            desktopDir.existsSync() ? desktopDir.listSync() : [];

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
                  Text(
                    "${desktopFiles.length} apps found",
                    style: myTextStyle(context, ref, 14),
                  ),
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
                                      ? Color.fromARGB(42, 183, 183, 183)
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
                child:
                    isGrid
                        ? Builder(
                          builder: (context) {
                            final desktopDir = Directory(
                              '${Platform.environment['USERPROFILE']}\\Desktop',
                            );
                            final desktopFiles =
                                desktopDir.existsSync()
                                    ? desktopDir.listSync()
                                    : [];
                            return GridView.builder(
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
                                if (index >= desktopFiles.length)
                                  return SizedBox.shrink();
                                final file = desktopFiles[index];
                                final fullFileName = file.path.split('\\').last;
                                final fileName = (FileSystemEntity.isDirectorySync(file.path) || !fullFileName.contains('.'))
                                    ? fullFileName
                                    : fullFileName.substring(0, fullFileName.lastIndexOf('.'));
                                final isDir = FileSystemEntity.isDirectorySync(
                                  file.path,
                                );

                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 2,
                                  color: const Color(0xFF2E2E2E),
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
                                        Text(
                                          fileName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        )
                        : Builder(
                          builder: (context) {
                            final desktopDir = Directory(
                              '${Platform.environment['USERPROFILE']}\\Desktop',
                            );
                            final desktopFiles =
                                desktopDir.existsSync()
                                    ? desktopDir.listSync()
                                    : [];

                            return ListView.builder(
                              padding: const EdgeInsets.only(right: 8),
                              itemCount: desktopFiles.length,
                              itemBuilder: (context, index) {
                                if (index >= desktopFiles.length)
                                  return SizedBox.shrink();
                                final file = desktopFiles[index];
                                final fullFileName = file.path.split('\\').last;
                                final fileName = (FileSystemEntity.isDirectorySync(file.path) || !fullFileName.contains('.'))
                                    ? fullFileName
                                    : fullFileName.substring(0, fullFileName.lastIndexOf('.'));
                                final isDir = FileSystemEntity.isDirectorySync(
                                  file.path,
                                );

                                Widget leadingWidget;
                                leadingWidget = Icon(
                                  isDir
                                      ? Icons.folder
                                      : Icons.insert_drive_file,
                                  size: 32,
                                  color: Colors.white,
                                );

                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      120,
                                      59,
                                      59,
                                      59,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
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
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
              ),
            ],
          ),
        );
      },
    );
  }
}
