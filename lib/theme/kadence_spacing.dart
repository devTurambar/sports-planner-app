/// Spacing tokens from the design system. 4px base unit.
class KSpace {
  const KSpace._();

  static const double s1 = 4;
  static const double s2 = 8;
  static const double s3 = 12;
  static const double s4 = 16;
  static const double s5 = 20;
  static const double s6 = 24;
  static const double s8 = 32;
  static const double s10 = 40;
  static const double s12 = 48;
  static const double s16 = 64;
  static const double s20 = 80;

  static const double pageGutter = 20;
  static const double sectionGap = 32;
  static const double cardPadding = 16;
  static const double itemGap = 12;
  static const double tightGap = 8;
  static const double inlineGap = 6;
}

/// Border radius tokens.
class KRadius {
  const KRadius._();

  static const double xs = 4;
  static const double sm = 6;
  static const double md = 10;
  static const double lg = 14;
  static const double xl = 20;
  static const double xxl = 28;
  static const double full = 9999;
}

/// Motion tokens.
class KMotion {
  const KMotion._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration base = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 300);
  static const Duration sheet = Duration(milliseconds: 320);
}
