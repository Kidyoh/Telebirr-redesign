import 'package:flutter/painting.dart';

import 'tokens.dart';

/// Type scale from the Kidyoh Apps system, upright only: Inter throughout,
/// Noto Sans Ethiopic as the Amharic fallback. No italics anywhere.
abstract final class TType {
  static const sans = 'Inter';
  static const _fallback = ['NotoSansEthiopic'];

  static const numeralHero = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: _fallback,
    fontSize: 64,
    height: 0.95,
    fontWeight: FontWeight.w400,
    letterSpacing: -3,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const display = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: _fallback,
    fontSize: 40,
    height: 1.02,
    fontWeight: FontWeight.w600,
    letterSpacing: -1.6,
  );

  static const headline = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: _fallback,
    fontSize: 30,
    height: 1.12,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.8,
  );

  /// The second beat of a headline: same size as the line it follows,
  /// set apart by weight and the accent colour (never italic).
  static const accentHeadline = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: _fallback,
    fontSize: 30,
    height: 1.12,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.8,
  );

  static const title1 = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: _fallback,
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
  );

  static const title2 = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: _fallback,
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
  );

  /// Calm titles: dialog titles, empty states.
  static const calmTitle = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: _fallback,
    fontSize: 26,
    height: 1.15,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.5,
  );

  static const body = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: _fallback,
    fontSize: 15,
    height: 22 / 15,
    fontWeight: FontWeight.w400,
  );

  static const bodyStrong = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: _fallback,
    fontSize: 15,
    height: 22 / 15,
    fontWeight: FontWeight.w600,
  );

  static const uiLabel = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: _fallback,
    fontSize: 16,
    height: 22 / 16,
    fontWeight: FontWeight.w500,
  );

  static const caption = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: _fallback,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w400,
    color: TB.inkSoft,
  );

  static const micro = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: _fallback,
    fontSize: 11,
    height: 14 / 11,
    fontWeight: FontWeight.w500,
  );

  static const labelCaps = TextStyle(
    fontFamily: sans,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 3.2,
    color: TB.inkSoft,
  );

  static const eyebrow = TextStyle(
    fontFamily: sans,
    fontSize: 11.5,
    height: 16 / 11.5,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.6,
  );
}
