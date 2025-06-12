import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedCategoryProvider = StateProvider<int>((ref) => 0);
final selectedDesct = StateProvider<int>((ref) => 0);

final colorProvider = StateProvider<Color>((ref) {
  return const Color(0xff2d2d2d);
});
