import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kPrimary = Color(0xFFFF6B9D);
const Color kSecondary = Color(0xFF4FC3F7);
const Color kBackground = Color(0xFFFFF0F8);
const Color kSurface = Color(0xFFFFFFFF);
const Color kCellFixed = Color(0xFF2C3E50);
const Color kConstraint = Color(0xFFFF6B9D);
const Color kConstraintErr = Color(0xFFE53935);

const Map<int, Color> kDigitPadColours = {
  1: Color(0xFFFFB3BA),
  2: Color(0xFFFFDFBA),
  3: Color(0xFFFFFFBA),
  4: Color(0xFFBAFFC9),
  5: Color(0xFFBAE1FF),
  6: Color(0xFFE8BAFF),
  7: Color(0xFFFFBEF0),
};

final ThemeData adultsTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: kPrimary,
    secondary: kSecondary,
    surface: kSurface,
    brightness: Brightness.light,
  ).copyWith(surface: kBackground),
  scaffoldBackgroundColor: kBackground,
  textTheme: GoogleFonts.nunitoTextTheme(),
  appBarTheme: AppBarTheme(
    backgroundColor: kPrimary,
    foregroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: GoogleFonts.nunito(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  ),
);
