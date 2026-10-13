import 'package:flutter/material.dart';
import '../platform.dart';

// ── Site palette (appversegames.com) — used by the web embed only ────────────

const Color kSiteIvory = Color(0xFFF6F3EC);
const Color kSiteNavy = Color(0xFF16193A);
const Color kSiteAmber = Color(0xFFF2A541);
const Color kSiteTeal = Color(0xFF0B6B63);

// ── Mobile palette (unchanged) ───────────────────────────────────────────────

const Color _mPrimary = Color(0xFFFF6B9D);
const Color _mSecondary = Color(0xFF4FC3F7);
const Color _mBackground = Color(0xFFFFF0F8);
const Color _mCellFixed = Color(0xFF2C3E50);

const Map<int, Color> _mDigitPadColours = {
  1: Color(0xFFFFB3BA),
  2: Color(0xFFFFDFBA),
  3: Color(0xFFFFFFBA),
  4: Color(0xFFBAFFC9),
  5: Color(0xFFBAE1FF),
  6: Color(0xFFE8BAFF),
  7: Color(0xFFFFBEF0),
};

// ── Roles (web picks the site palette, mobile keeps its colours) ─────────────

Color get kPrimary => isWebEmbed ? kSiteTeal : _mPrimary;
Color get kSecondary => isWebEmbed ? kSiteAmber : _mSecondary;
Color get kBackground => isWebEmbed ? kSiteIvory : _mBackground;
const Color kSurface = Color(0xFFFFFFFF);
Color get kCellFixed => isWebEmbed ? kSiteNavy : _mCellFixed;
Color get kConstraint => isWebEmbed ? kSiteNavy : _mPrimary;
const Color kConstraintErr = Color(0xFFE53935);

/// Digits filled in by Hint or Show Solution.
Color get kRevealed =>
    isWebEmbed ? const Color(0xFFA35F00) : const Color(0xFF7B1FA2);

/// Background of the selected cell.
Color get kSelectedCell => isWebEmbed
    ? kSiteAmber.withValues(alpha: 0.55)
    : _mPrimary.withValues(alpha: 0.40);

/// Background of cells sharing the selected digit.
Color get kSameDigitCell => isWebEmbed
    ? kSiteTeal.withValues(alpha: 0.16)
    : _mSecondary.withValues(alpha: 0.35);

/// Background of cells in the selected row and column.
Color get kHighlightCell => isWebEmbed
    ? kSiteAmber.withValues(alpha: 0.14)
    : _mPrimary.withValues(alpha: 0.12);

Color digitPadColour(int digit) =>
    isWebEmbed ? const Color(0xFFEAE3D3) : _mDigitPadColours[digit]!;

Color get kDigitPadText => isWebEmbed ? kSiteNavy : Colors.black87;

Color get kHintButton => isWebEmbed ? kSiteAmber : const Color(0xFFFFD700);

/// "Show Solution" / gave-up accents.
Color get kSolutionAccent =>
    isWebEmbed ? kSiteNavy : const Color(0xFF9C27B0);
Color get kSolutionBanner =>
    isWebEmbed ? const Color(0xFFFFFFFF) : const Color(0xFFF3E5F5);

ThemeData appTheme() {
  var scheme = ColorScheme.fromSeed(
    seedColor: kPrimary,
    secondary: kSecondary,
    surface: kSurface,
    brightness: Brightness.light,
  ).copyWith(surface: kBackground);
  if (isWebEmbed) {
    scheme = scheme.copyWith(
      primary: kSiteTeal,
      onSurface: kSiteNavy,
      surfaceContainerHigh: kSiteIvory,
    );
  }

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: kBackground,
    fontFamily: 'Nunito',
    appBarTheme: AppBarTheme(
      backgroundColor: kPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: const TextStyle(
        fontFamily: 'Nunito',
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
}
