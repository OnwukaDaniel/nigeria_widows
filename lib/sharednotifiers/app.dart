import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nigerian_widows/models/DataModel.dart';

import '../models/WidowData.dart';
import '../theme/apptheme.dart';
import '../util/app_constants.dart';

class AppNotifier {
  static ValueNotifier<ThemeData> appTheme = ValueNotifier(AppTheme.darkTheme);
  static ValueNotifier<int> selectedPageVn = ValueNotifier(1);
  static ValueNotifier<List<BarChartGroupData>> lgaGroupDataVn = ValueNotifier(
    [],
  );
  static ValueNotifier<String> toolbarTitleVn = ValueNotifier(
    AppConstants.appName,
  );
  static ValueNotifier<String> backgroundPrefDataVn = ValueNotifier("");
  static ValueNotifier<List<String>> paginationVn = ValueNotifier([]);
  static ValueNotifier<WidowData> cacheWidowDataVn = ValueNotifier(WidowData());
  static ValueNotifier<bool> widowsPageShowShimmerVn = ValueNotifier(true);
}
