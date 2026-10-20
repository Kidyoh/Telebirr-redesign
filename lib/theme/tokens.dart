import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';

/// Kidyoh Apps design-system tokens, skinned for telebirr.
///
/// The house structure (Paper ground, ink primary actions, glass over
/// something rich, pills, a giant number, springy motion) comes from the
/// design system. The telebirr skin keeps the brand's own colours: the green
/// hero, the blue Scan QR action and the orange "one app" ribbon.
abstract final class TB {
  // ── Paper theme (house) ────────────────────────────────────────────────
  static const ground = Color(0xFFF4F5F2); // light neutral, a hint of leaf
  static const surface = Color(0xFFF8F8F4);
  static const surfaceRaised = Color(0xFFFFFFFF);
  static const ink = Color(0xFF1C1B19);
  static const inkSoft = Color(0xFF5E5A54);
  static const inkFaint = Color(0xFF8A857D); // hints only, below 4.5:1
  static const hairline = Color(0x1A1C1B19);
  static const track = Color(0x14000000);
  static const button = Color(0xFF1C1B19);
  static const onButton = Color(0xFFF2EFEA);
  static const featureCard = Color(0xFF1C1B19);

  /// The near-black of the balance card, the Send Money header and the
  /// Send Money quick action.
  static const night = Color(0xFF151515);
  static const keyFill = Color(0xFFFFFFFF);
  static const keyRim = Color(0xFFEDEEEA);
  static const onFeature = Color(0xFFF2EFEA);
  static const scrim = Color(0x99000000);

  // ── telebirr skin ──────────────────────────────────────────────────────
  /// The telebirr leaf green, used for the hero ground and marks.
  static const brand = Color(0xFF8CC63F);
  static const brandDeep = Color(0xFF5E9A1E);
  static const brandShade = Color(0xFF3F6F12);

  /// Text-safe green for small labels on light grounds (4.6:1 on surface).
  static const brandInk = Color(0xFF3D6B10);
  static const brandMist = Color(0xFFE6F2D6);
  static const brandBright = Color(0xFFB8E65A);

  /// The Scan QR blue: the one hero CTA, which glows.
  static const accent = Color(0xFF0A7FD6);
  static const accentDeep = Color(0xFF0565B0);
  static const onAccent = Color(0xFFFFFFFF);
  static const accentGlow = Color(0x590A7FD6);

  /// The ribbon orange ("One app for all your needs", "Up to 35%").
  static const ribbon = Color(0xFFF7B731);
  static const ribbonInk = Color(0xFF5E4310);

  // ── glass ──────────────────────────────────────────────────────────────
  static const glassFill = Color(0x2EFFFFFF); // on the green hero
  static const glassRim = Color(0x47FFFFFF);
  static const glassFillPaper = Color(0x8CFFFFFF);
  static const glassRimPaper = Color(0xB3FFFFFF);

  // ── status ─────────────────────────────────────────────────────────────
  static const success = Color(0xFF4E7D5B);
  static const warn = Color(0xFFB7791F);
  static const danger = Color(0xFFB4473F);

  // ── pastels (content colour, never chrome) ─────────────────────────────
  static const pastelSage = Color(0xFFC5CE9B);
  static const pastelSageInk = Color(0xFF485418);
  static const pastelTeal = Color(0xFF9ECBC7);
  static const pastelTealInk = Color(0xFF0F5A57);
  static const pastelAmber = Color(0xFFE6BA6E);
  static const pastelAmberInk = Color(0xFF5E4310);
  static const pastelLavender = Color(0xFFBDB4D4);
  static const pastelLavenderInk = Color(0xFF4B4170);
  static const paperSky = Color(0xFFCDE8F5);
  static const paperMint = Color(0xFFCDEBD3);
  static const paperButter = Color(0xFFFDE99B);
  static const paperPeach = Color(0xFFFFDBC5);

  // ── spacing ────────────────────────────────────────────────────────────
  static const s4 = 4.0;
  static const s8 = 8.0;
  static const s12 = 12.0;
  static const s16 = 16.0;
  static const s20 = 20.0;
  static const s24 = 24.0;
  static const s28 = 28.0;
  static const s32 = 32.0;
  static const s40 = 40.0;

  // ── radius ─────────────────────────────────────────────────────────────
  static const rSm = 10.0;
  static const rMd = 16.0;
  static const rLg = 24.0;
  static const rXl = 28.0;
  static const r2xl = 32.0;
  static const r3xl = 36.0;
  static const rPill = 999.0;

  // ── blur ───────────────────────────────────────────────────────────────
  static const blurBar = 18.0;
  static const blurGlass = 20.0;
  static const blurGlassHeavy = 26.0;

  // ── shadows ────────────────────────────────────────────────────────────
  static const shadowSoft = [
    BoxShadow(color: Color(0x14281E14), blurRadius: 24, offset: Offset(0, 8)),
  ];
  static const shadowCard = [
    BoxShadow(color: Color(0x38000000), blurRadius: 40, offset: Offset(0, 18)),
  ];
  static const shadowGlass = [
    BoxShadow(color: Color(0x1F000000), blurRadius: 24, offset: Offset(0, 8)),
  ];
  static const shadowAccentGlow = [
    BoxShadow(color: accentGlow, blurRadius: 22, offset: Offset(0, 10)),
  ];
}

/// Motion tokens. Soft, springy, never showy.
abstract final class Motion {
  static const press = Duration(milliseconds: 110);
  static const fast = Duration(milliseconds: 220);
  static const release = Duration(milliseconds: 320);
  static const medium = Duration(milliseconds: 420);
  static const slow = Duration(milliseconds: 620);
  static const stagger = Duration(milliseconds: 60);

  static const easeOut = Cubic(0.33, 1, 0.68, 1);
  static const easeInOut = Cubic(0.65, 0, 0.35, 1);
  static const easeSpring = Cubic(0.2, 1.35, 0.4, 1);
  static const easeExpo = Cubic(0.32, 0.72, 0, 1);
  static const easeBack = Cubic(0.34, 1.56, 0.64, 1);

  static const pressCard = 0.96;
  static const pressPill = 0.97;
  static const pressRound = 0.9;
}
