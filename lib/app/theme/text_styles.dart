import 'package:flutter/material.dart';
import 'package:readwise/core/utils/font_utils.dart';

class TextStyles {
  static TextStyle get _regularText => TextStyle(
    decoration: TextDecoration.none,
    color: Colors.black,
    fontSize: 16,
    fontFamily: 'Inter',
    fontFeatures: FontUtils.fontFeatures,
    fontWeight: FontWeight.normal,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static TextStyle get ui15Regular => _regularText.copyWith(
    fontVariations: FontUtils.getVariationWeight(400),
    fontSize: 15,
    height: 22 / 15,
    letterSpacing: -0.009,
  );

  static TextStyle get ui15SemiBold => ui15Regular.copyWith(fontVariations: FontUtils.getVariationWeight(600));

  static TextStyle get ui15Medium => ui15Regular.copyWith(fontVariations: FontUtils.getVariationWeight(500));

  static TextStyle get ui13Regular => _regularText.copyWith(
    fontSize: 13,
    fontVariations: FontUtils.getVariationWeight(400),
    letterSpacing: -0.0025,
    height: 20 / 13,
  );

  static TextStyle get ui13Medium => ui13Regular.copyWith(fontVariations: FontUtils.getVariationWeight(500));

  static TextStyle get ui13SemiBold => ui13Regular.copyWith(fontVariations: FontUtils.getVariationWeight(600));

  static TextStyle get ui18Regular =>
      _regularText.copyWith(fontSize: 18, fontVariations: FontUtils.getVariationWeight(400), height: 28 / 18);

  static TextStyle get ui18Medium => ui18Regular.copyWith(fontVariations: FontUtils.getVariationWeight(500));

  static TextStyle get ui18SemiBold => ui18Regular.copyWith(fontVariations: FontUtils.getVariationWeight(600));

  static TextStyle get ui12Regular =>
      _regularText.copyWith(fontSize: 12, fontVariations: FontUtils.getVariationWeight(400), height: 16 / 12);

  static TextStyle get ui12Medium => ui12Regular.copyWith(fontVariations: FontUtils.getVariationWeight(500));

  static TextStyle get ui12SemiBold => ui12Regular.copyWith(fontVariations: FontUtils.getVariationWeight(600));

  static TextStyle get ui11Regular =>
      _regularText.copyWith(fontSize: 11, fontVariations: FontUtils.getVariationWeight(400), height: 14 / 11);

  static TextStyle get ui11Medium => ui11Regular.copyWith(fontVariations: FontUtils.getVariationWeight(600));

  static TextStyle get ui20Regular => _regularText.copyWith(
    fontSize: 20,
    fontVariations: FontUtils.getVariationWeight(400),
    height: 28 / 20,
    letterSpacing: -0.017,
  );

  static TextStyle get ui20Medium => ui20Regular.copyWith(fontVariations: FontUtils.getVariationWeight(500));

  static TextStyle get ui20SemiBold => ui20Regular.copyWith(fontVariations: FontUtils.getVariationWeight(600));

  static TextStyle get ui24Regular => _regularText.copyWith(fontSize: 24, height: 32 / 24, letterSpacing: -0.019);

  static TextStyle get ui24SemiBold => ui24Regular.copyWith(fontVariations: FontUtils.getVariationWeight(600));

  static TextStyle get ui32Regular => _regularText.copyWith(fontSize: 32, height: 40 / 32, letterSpacing: -0.021);

  static TextStyle get ui32SemiBold => ui32Regular.copyWith(fontVariations: FontUtils.getVariationWeight(600));

  static TextStyle get ui32Bold => ui32Regular.copyWith(fontVariations: FontUtils.getVariationWeight(800));

  static TextStyle get ui40Regular => _regularText.copyWith(fontSize: 40, height: 48 / 40, letterSpacing: -0.021);

  static TextStyle get ui40SemiBold => ui40Regular.copyWith(fontVariations: FontUtils.getVariationWeight(600));

  static TextStyle get ui40Bold => ui40Regular.copyWith(fontVariations: FontUtils.getVariationWeight(900));

  static TextStyle get ui36Regular => _regularText.copyWith(fontSize: 36, height: 44 / 36, letterSpacing: -0.025);

  static TextStyle get ui36Bold => ui32Regular.copyWith(fontVariations: FontUtils.getVariationWeight(800));

  static TextStyle get header => _regularText.copyWith(
    fontSize: 40,
    fontVariations: FontUtils.getVariationWeight(900),
    height: 48.41 / 40,
    letterSpacing: -0.014,
  );

  static TextStyle mergeWithUi(TextStyle defaultTestStyle, TextStyle uiTextStyle) {
    return defaultTestStyle.copyWith(
      fontVariations: uiTextStyle.fontVariations,
      decoration: uiTextStyle.decoration,
      fontSize: uiTextStyle.fontSize,
      fontFamily: uiTextStyle.fontFamily,
      fontWeight: uiTextStyle.fontWeight,
      leadingDistribution: uiTextStyle.leadingDistribution,
      height: uiTextStyle.height,
      letterSpacing: uiTextStyle.letterSpacing,
    );
  }
}
