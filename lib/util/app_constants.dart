import 'dart:ui';

import 'package:nigerian_widows/util/app_color.dart';

class AppConstants {
  static String appName = "Nigerian Widows";
  static const int FAILURE = 101;
  static const int SUCCESS = 200;

  /*Background colors*/
  static int blue = 1;
  static int red = 2;
  static int yellow = 3;
  static int green = 4;
  static int lightBlue = 5;
  static int lightRed = 6;
  static int pink = 7;
  static int amber = 8;
  static int brown = 9;

  Color constantsToColor(int colorInt) {
    switch (colorInt) {
      case 1:
        return AppColor.blue;
      case 2:
        return AppColor.red;
      case 3:
        return AppColor.yellow;
      case 4:
        return AppColor.green;
      case 5:
        return AppColor.lightBlue;
      case 6:
        return AppColor.lightRed;
      case 7:
        return AppColor.pink;
      case 8:
        return AppColor.amber;
    }
    return AppColor.brown;
  }
}
