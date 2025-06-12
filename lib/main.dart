import 'dart:io';

import 'package:desktop_/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();

  if (Platform.isWindows) {
await Window.setEffect(
  effect: WindowEffect.acrylic,
  color: Color.fromARGB(204, 0, 0, 0),
);
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: const HomeScreen(),
    );
  }
}
