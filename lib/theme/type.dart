import 'package:flutter/painting.dart';

import 'tokens.dart';

/// Type scale from the Kidyoh Apps system: Inter for UI, Instrument Serif
/// (italic) for the payoff words, Noto Sans Ethiopic as the Amharic fallback.
abstract final class TType {
  static const sans = 'Inter';
  static const serif = 'InstrumentSerif';
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

  /// The italic second beat of a headline, 1.18× the line it sits in.
  static const accentHeadline = TextStyle(
    fontFamily: serif,
    fontSize: 35,
    height: 1.05,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.2,
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

  static const serifTitle = TextStyle(
    fontFamily: serif,
    fontSize: 30,
    height: 1.1,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.3,
  );

  static const wordmark = TextStyle(
    fontFamily: serif,
    fontSize: 26,
    height: 1.1,
    fontStyle: FontStyle.italic,
    letterSpacing: -0.3,
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
