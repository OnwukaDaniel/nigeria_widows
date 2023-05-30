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
  List<String> _pageIndexView = [];

  List<Data> _specificPageData = [];

  bool get loading => _loading;

  WidowData get widowModel => _widowModel;

  WidowData get nextWidowModel => _nextWidowModel;

  bool get success => _success;

  int get pagesCount => _pagesCount;

  int get pagesCurrent => _pagesCurrent;

  int get lastPageIndex => _lastPageIndex;

  List<Data> get specificPageData => _specificPageData;

  List<String> get pageIndexView => _pageIndexView;

  WidowsViewModel() {
    getMoreWidowsData();
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

  getWidowsData() async {
    setLoading(true);
    var response = await UserServices.getWidowsData() as APIResponse;
    if (response.code == AppConstants.SUCCESS) {
      WidowData data = WidowData.fromJson(jsonDecode(response.response));
      _widowModel = data;
      var pageCount = ((data.lastIndex! + 1) / countPerPage).round();
      if (pageCount >= 1) {
        setPages(pageCount.toInt());
        var list = {
          for (int i = 1; i <= pageCount; i++) i > 3 ? "..." : i.toString()
        }.toList();
        if (list.length > 3) list.add(">>");
        _pageIndexView = list;
      } else {
        setPages(1);
      }
      _specificPageData = data.data!;
      setLoading(false);
      setSuccess(true);
    } else {
      setLoading(false);
      setSuccess(false);
    }
  }

  getMoreWidowsData({int index = -1}) async {
    setLoading(true);
    var response = await UserServices.getMoreWidowsData(
      input: index,
    ) as APIResponse;
    if (response.code == AppConstants.SUCCESS) {
      WidowData data = WidowData.fromJson(jsonDecode(response.response));
      _widowModel = data;
      _lastPageIndex = _widowModel.lastIndex!;
      double currentPage = lastIndexToPageNumber(_nextWidowModel.lastIndex!);
      _smartPageIndex(currentPage.toInt(), 0, false);
      setLoading(false);
      setSuccess(true);
      getNextData(index: _lastPageIndex);
    } else {
      setLoading(false);
      setSuccess(false);
    }
  }

  getNextData({int index = -1}) async {
    _nextWidowModel = WidowData();
    var response = await UserServices.getMoreWidowsData(
      input: index,
    ) as APIResponse;
    if (response.code == AppConstants.SUCCESS) {
      WidowData data = WidowData.fromJson(jsonDecode(response.response));
      _nextWidowModel = data;
      double nextIndex = lastIndexToPageNumber(_nextWidowModel.lastIndex!);
      _smartPageIndex(_lastPageIndex, 0, false);
      setSuccess(true);
    } else {
      setSuccess(false);
    }
  }

  _smartPageIndex(int current, int next, bool nextSuccess) {
    if(nextSuccess == true) {
      if (current == 1 && nextSuccess) {
        _pageIndexView = ["$current", "$next", "...", ">>"];
      } else {
        _pageIndexView = ["${current - 1}", "$current", "$next", "...", ">>"];
      }
    } else {
      if (current == 1) {
        _pageIndexView = ["$current", "...", ">>"];
      } else {
        _pageIndexView = ["${current - 1}", "$current", "...", ">>"];
      }
    }
    AppNotifier.selectedPageVn.value = current;
  }

  setPageIndex(String p) {
    try {
      _formatPageIndex(int.parse(p));
    } catch (e) {
      if (p == "<<") {
        _formatPageIndex(AppNotifier.selectedPageVn.value - 1);
      }
      if (p == ">>") {
        _formatPageIndex(AppNotifier.selectedPageVn.value + 1);
      }
    }
    notifyListeners();
  }

  _formatPageIndex(int pagesCurrent) {
    var first = pagesCurrent - 1;
    var second = pagesCurrent + 1;
    if (pagesCurrent == 1) {
      var list = {
        for (int i = 1; i <= _pagesCount; i++) i > 3 ? "..." : i.toString()
      }.toList();
      if (list.length > 3) list.add(">>");
      _pageIndexView = list;
    } else {
      List<String> list = [];
      for (int i = 1; i <= _pagesCount; i++) {
        if (_pagesCount > 3) {
          if (i == 1) {
            if (i != first) {
              list.add("<<");
            } else {
              list.add(i.toString());
            }
          } else if (i == first && first > 0) {
            list.add(first.toString());
          } else if (i == pagesCurrent) {
            list.add(pagesCurrent.toString());
          } else if (i == second && second <= _pagesCount) {
            list.add(second.toString());
          } else if (i == _pagesCount && pagesCurrent != _pagesCount) {
            //final
            //list.add(i.toString());
            list.add("...");
            list.add(">>");
          } else if (i == _pagesCount && pagesCurrent == _pagesCount) {
            //final
            list.add(i.toString());
          }
        } else {
          list.add(i.toString());
        }
      }
      _pageIndexView = list;
    }
    AppNotifier.selectedPageVn.value = pagesCurrent;
    //getPageData(pagesCurrent);
  }

  double lastIndexToPageNumber(int lastPageIndex) {
    return lastPageIndex / 17;
  }
}
