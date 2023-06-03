import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nigerian_widows/models/WidowData.dart';
import 'package:nigerian_widows/repo/user_service.dart';

import '../sharednotifiers/app.dart';
import '../util/app_constants.dart';

final entryRepositoryProvider = Provider((_) => EntryRepository());

class EntryRepository {
  WidowData _widowData = WidowData();

  Future<WidowData> getData() async {
    return _widowData;
  }

  Future<WidowData> getWidoData({int index = -1}) async {
    var response = await UserServices().getWidowsData(input: index);
    if (response.code == AppConstants.SUCCESS) {
      _widowData = WidowData.fromJson(jsonDecode(response.response));
      AppNotifier.cacheWidowDataVn.value = _widowData;
      int currentIndex = _widowData.lastIndex! ~/ 17;
      AppNotifier.selectedPageVn.value = currentIndex;
      return _widowData;
    } else {
      return _widowData;
    }
  }
}
