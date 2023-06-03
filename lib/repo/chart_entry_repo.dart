import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nigerian_widows/repo/user_service.dart';

import '../models/HomePageData.dart';
import '../util/app_constants.dart';
import 'entry_repo.dart';

final chartRepositoryProvider = Provider((_) => ChartEntryRepo());

class ChartEntryRepo {

  Future<HomePageData> getChartData() async {
    EntryRepository().getWidoData();
    var response = await UserServices().getChatData();
    if (response.code == AppConstants.SUCCESS) {
      return HomePageData.fromJson(jsonDecode(response.response));
    } else {
      return HomePageData.getDefault();
    }
  }
}