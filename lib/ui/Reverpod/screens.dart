import 'package:desktop_/ui/Screens/descktop.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final screensProvider = StateProvider<Widget>((ref) {
  return Part1ForDescktop();
});
