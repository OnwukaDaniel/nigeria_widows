import 'package:flutter/material.dart';
import '../theme/apptheme.dart';

class AppNotifier{
  static ValueNotifier<ThemeData> appTheme = ValueNotifier(AppTheme.darkTheme);
  static ValueNotifier<List<String>> restaurantList = ValueNotifier([]);
}