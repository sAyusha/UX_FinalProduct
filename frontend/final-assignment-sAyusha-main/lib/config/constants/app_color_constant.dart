import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/size_config.dart';


class AppColorConstant {
  AppColorConstant._();

  static const Color primaryAccentColor = Color(0xFF152E4E);
  static const Color mainTeritaryColor = Color(0xffEAEAF9);
  static const Color mainSecondaryColor = Color(0xffF6F6F6);

  static Color blackTextColor = Colors.black;
  static Color whiteTextColor = Colors.white;
  static Color blueTextColor = const Color(0xff7979fb);

  static const Color appBarColor = Color(0xFFF5E8E8);
  static const Color buttomNavigationColor = Color(0xff262336);

  static const Color neutralColor = Color(0xff4D4D4D);
  static const Color lightNeutralColor1 = Color(0xff4a4858);
  static const Color lightNeutralColor2 = Color(0xff6e6c79);
  static const Color lightNeutralColor3 = Color(0xff92919A);
  static const Color lightNeutralColor4 = Color(0xffb7b6bc);
  static Color lightColor = Colors.grey;

  //system colors
  static Color errorColor = Colors.red.shade500;
  static Color warningColor = Colors.yellow.shade500;
  static Color successColor = Colors.green.shade500;
  static double kDefaultPadding = getProportionateScreenWidth(20.0);
}
