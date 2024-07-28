part of values;

class Styles {
  static const TextStyle titleTextStyleWithSecondaryTextColor = TextStyle(
    color: AppColors.secondaryText,

    fontWeight: FontWeight.w700,
    fontSize: Sizes.TEXT_SIZE_40,
  );

  static TextStyle customTitleTextStyle({
    Color color = AppColors.secondaryText,

    FontWeight fontWeight = FontWeight.w700,
    double fontSize = Sizes.TEXT_SIZE_40,
    double letterSpacing = 0,
  }) {
    return TextStyle(
      color: color,

      fontWeight: fontWeight,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
    );
  }

  static const TextStyle normalTextStyle = TextStyle(
    color: AppColors.secondaryText,

    fontWeight: FontWeight.w400,
    fontSize: Sizes.TEXT_SIZE_16,
  );

  static const TextStyle foodyBiteTitleTextStyle = TextStyle(
    color: AppColors.headingText,

    fontWeight: FontWeight.w400,
    fontSize: Sizes.TEXT_SIZE_20,
  );

  static const TextStyle foodyBiteSubtitleTextStyle = TextStyle(
    color: AppColors.accentText,

    fontWeight: FontWeight.w400,
    fontSize: Sizes.TEXT_SIZE_14,
  );

  static TextStyle customNormalTextStyle({
    Color color = AppColors.secondaryText,

    FontWeight fontWeight = FontWeight.w400,
    double fontSize = Sizes.TEXT_SIZE_16,
    double letterSpacing = 0,
  }) {
    return TextStyle(
      color: color,

      fontWeight: fontWeight,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
    );
  }

  static const TextStyle mediumTextStyle = TextStyle(
    color: AppColors.secondaryText,

    fontWeight: FontWeight.w400,
    fontSize: Sizes.TEXT_SIZE_20,
  );

  static TextStyle customMediumTextStyle({
    Color color = AppColors.secondaryText,

    FontWeight fontWeight = FontWeight.w400,
    double fontSize = Sizes.TEXT_SIZE_20,
    FontStyle fontStyle = FontStyle.normal,
    double letterSpacing = 0,
  }) {
    return TextStyle(
      color: color,

      fontWeight: fontWeight,
      fontSize: fontSize,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
    );
  }
}
