import 'dart:ui';

class FontUtils {
  static List<FontVariation> getVariationWeight(double weight) {
    return [FontVariation.weight(weight)];
  }

  static List<FontFeature> get fontFeatures => [
    FontFeature.characterVariant(10),
    FontFeature.characterVariant(05),
    FontFeature.characterVariant(09),
    FontFeature.characterVariant(03),
    FontFeature.characterVariant(04),
  ];
}
