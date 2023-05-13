import 'package:flutter/material.dart';
import '../theme/apptheme.dart';

class AppNotifier{
  static ValueNotifier<ThemeData> appTheme = ValueNotifier(AppTheme.darkTheme);
  static ValueNotifier<int> selectedPageVn = ValueNotifier(1);
}