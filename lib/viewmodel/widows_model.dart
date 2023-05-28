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
  bool _success = false;
  int _pagesCount = 0;
  int countPerPage = 6;
  List<String> _pageIndexView = [];

  List<Data> _specificPageData = [];

  bool get loading => _loading;

  WidowData get widowModel => _widowModel;

  bool get success => _success;

  int get pagesCount => _pagesCount;

  List<Data> get specificPageData => _specificPageData;

  List<String> get pageIndexView => _pageIndexView;

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

  getWidowsData() async {
    setLoading(true);
    var response = await UserServices.getWidowsData() as APIResponse;
    if (response.code == AppConstants.SUCCESS) {
      WidowData data = WidowData.fromJson(jsonDecode(response.response));
      _widowModel = data;
      var pageCount = ((data.lastIndex! + 1) / countPerPage).round();
      print("Page cout ******************* $pageCount");
      if (pageCount >= 1) {
        setPages(pageCount.toInt());
        var list = {
          for (int i = 1; i < _pagesCount; i++) i > 3 ? "..." : i.toString()
        }.toList();
        if (list.length > 3) list.add(">>");
        _pageIndexView = list;
      } else {
        setPages(1);
      }
      getPageData(1);
      setLoading(false);
      setSuccess(true);
    } else {
      setLoading(false);
      setSuccess(false);
    }
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
        for (int i = 1; i < _pagesCount; i++) i > 3 ? "..." : i.toString()
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
    getPageData(pagesCurrent);
  }

  getPageData(int input) {
    if (_pagesCount != 0) {
      _specificPageData = _widowModel.data!.sublist(
        (input - 1) * countPerPage,
        input * countPerPage,
      );
    }
  }
}
