import 'package:flutter/material.dart';

const kMainTextColor = Color(0xFF000000);
const kMainWhiteColor = Color(0xFFFFFFFF);
const kButtonColor = Color(0xFF1ABD5B);
const kHintTextColor = Color(0xFFCDCDCD);
const kScreenTitleColor = Color(0xFF117143);
const kButtonRedColor = Color(0xFFFF5252);
const ktextGreyColor = Color(0xFF9E9A9A);
const kLightBlueColor = Color(0xFF2196F3);

/// Function to get screen title color based on the theme (dark or light)
Color getGreenThemeColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? kButtonColor
      : kScreenTitleColor;
}

/// Function to get main text color based on the theme (dark or light)
Color getBlackAndWhiteColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? kMainWhiteColor
      : kMainTextColor;
}
