import 'package:flutter/material.dart';
import 'package:nigerian_widows/models/DataModel.dart';
import '../theme/apptheme.dart';

class AppNotifier{
  static ValueNotifier<ThemeData> appTheme = ValueNotifier(AppTheme.darkTheme);
  static ValueNotifier<int> selectedPageVn = ValueNotifier(1);
  static ValueNotifier<List<DataModel>> jsonDataModelVN = ValueNotifier([]);
}

