import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class Colorapp {
  static Color colorback = Color(0xff181818);
  static Color desktop = Color(0xff2b2b2b);
  static Color barapps = Color.fromARGB(120, 59, 59, 59);
}

TextStyle myTextStyle(
  BuildContext context,
  WidgetRef ref,
  double baseSize, [
  Color color = Colors.white,
  FontWeight weight = FontWeight.normal,
]) {
  double responsiveSize = getResponsiveText(context, fontsize: baseSize);
  return GoogleFonts.notoSans(
    fontSize: responsiveSize,
    color: color,
    fontWeight: weight,
  );
}

double getResponsiveText(BuildContext context, {required double fontsize}) {
  double scaleFactor = getScaleFactor(context);
  double responsiveSize = fontsize * scaleFactor;
  return responsiveSize.clamp(fontsize * 0.8, fontsize * 1.2);
}

double getScaleFactor(BuildContext context) {
  double width = MediaQuery.of(context).size.width;

  if (width < 600) {
    return 0.9; // أجهزة صغيرة (هواتف)
  } else if (width < 900) {
    return 1.0; // أجهزة متوسطة (تابلت صغير)
  } else {
    return 1.1; // أجهزة كبيرة (تابلت كبير وشاشات)
  }
}
