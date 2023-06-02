import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nigerian_widows/repo/api_status.dart';
import 'package:nigerian_widows/repo/user_service.dart';

import '../models/WidowData.dart';
import '../sharednotifiers/app.dart';
import '../util/app_constants.dart';

class WidowsViewModel extends ChangeNotifier {
  bool _loading = false;
  WidowData _widowModel = WidowData();
  WidowData _nextWidowModel = WidowData();
  bool _success = false;
  int _pagesCount = 0;
  int _pagesCurrent = 1;
  int _lastPageIndex = -1;
  int countPerPage = 6;
  List<String> _pageIndexList = [];

  List<Data> _specificPageData = [];

  bool get loading => _loading;

  WidowData get widowModel => _widowModel;

  WidowData get nextWidowModel => _nextWidowModel;

  bool get success => _success;

  int get pagesCount => _pagesCount;

  int get pagesCurrent => _pagesCurrent;

  int get lastPageIndex => _lastPageIndex;

  List<Data> get specificPageData => _specificPageData;

  List<String> get pageIndexView => _pageIndexList;

  WidowsViewModel() {
    getWidowsData();
  }

  setLoading(bool loading) async {
    _loading = loading;
    notifyListeners();
  }

  setChatDataModel(WidowData input) {
    _widowModel = input;
  }

  setSuccess(bool success) {
    _success = success;
  }

  setPages(int input) {
    _pagesCount = input;
  }

  getWidowsData({int index = -1}) async {
    setLoading(true);
    var response = await UserServices.getWidowsData(
      input: index,
    ) as APIResponse;
    if (response.code == AppConstants.SUCCESS) {
      WidowData data = WidowData.fromJson(jsonDecode(response.response));
      _widowModel = data;
      _lastPageIndex = _widowModel.lastIndex!;
      double currentIndex = _lastIndexToPageNumber(_widowModel.lastIndex!);
      _smartPageIndex(currentIndex.toInt(), currentIndex.toInt() + 1, true);
      setLoading(false);
      setSuccess(true);
      _getNextData(currentIndex.toInt(), index: _lastPageIndex);
    } else {
      setLoading(false);
      setSuccess(false);
    }
  }

  _getNextData(int currentIndex, {int index = -1}) async {
    _nextWidowModel = WidowData();
    var response = await UserServices.getWidowsData(
      input: index,
    ) as APIResponse;
    if (response.code == AppConstants.SUCCESS) {
      UserServicesUserServices data = WidowData.fromJson(jsonDecode(response.response));
      _nextWidowModel = data;
      double nextIndex = _lastIndexToPageNumber(_nextWidowModel.lastIndex!);
      _smartPageIndex(currentIndex, nextIndex.toInt(), true);
      notifyListeners();
      setSuccess(true);
    } else {
      setSuccess(false);
    }
  }

  _smartPageIndex(int current, int next, bool nextSuccess) {
    if (nextSuccess == true) {
      if (current == 1 && nextSuccess) {
        _pageIndexList = ["$current", "$next", "...", ">>"];
      } else if(current != 1 && nextSuccess) {
        _pageIndexList = ["${current - 1}", "$current", "$next", "...", ">>"];
      }
    } else {
      if (current == 1) {
        _pageIndexList = ["$current", "...", ">>"];
      } else {
        _pageIndexList = ["${current - 1}", "$current", "...", ">>"];
      }
    }
    print("Next model ****** $current ******$next **** $nextSuccess **** $_pageIndexList");
    AppNotifier.selectedPageVn.value = current;
  }

  double _lastIndexToPageNumber(int lastPageIndex) {
    return lastPageIndex / 17;
  }

  double pageNumberToLastPageIndex(int lastPageIndex) {
    return lastPageIndex * 17;
  }
}
