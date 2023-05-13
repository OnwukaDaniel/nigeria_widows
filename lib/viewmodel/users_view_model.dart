import 'package:flutter/material.dart';
import 'package:nigerian_widows/models/WidowsData.dart';
import 'package:nigerian_widows/repo/api_status.dart';
import 'package:nigerian_widows/repo/user_service.dart';

import '../sharednotifiers/app.dart';
import '../util/app_constants.dart';

class UsersViewModel extends ChangeNotifier {
  bool _loading = false;
  List<WidowData> _userListModel = [];
  Failure _failure = Failure(code: AppConstants.NO_RESPONSE);
  int _pagesCount = 0;
  List<String> _pageIndexView = [];

  bool get loading => _loading;

  List<WidowData> get userListModel => _userListModel;

  Failure get failure => _failure;

  int get pagesCount => _pagesCount;

  List<String> get pageIndexView => _pageIndexView;

  UsersViewModel() {
    getUsers(0);
  }

  setLoading(bool loading) async {
    _loading = loading;
    notifyListeners();
  }

  setUserListModel(List<WidowData> userList) {
    _userListModel = userList;
  }

  setFailure(Failure failure) {
    _failure = failure;
  }

  setPagesCount(int pagesCount) {
    _pagesCount = pagesCount;
  }

  setPageIndex(String p) {
    try {
      _formatPageIndex(int.parse(p));
    } catch (e) {
      if(p == "<<"){
        _formatPageIndex(AppNotifier.selectedPageVn.value - 1);
      }
      if(p == ">>"){
        _formatPageIndex(AppNotifier.selectedPageVn.value + 1);
      }
    }
    notifyListeners();
  }

  _formatPageIndex(int pagesCurrent){
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
    getUsers(pagesCurrent);
  }

  getUsers(int page) async {
    setLoading(true);
    var response = await UserServices.getUsers(page);
    if (response is Success) {
      setUserListModel(response.response as List<WidowData>);
    } else if (response is Failure) {
      setFailure(failure);
    }
    setLoading(false);
  }

  getPageCount() async {
    setLoading(true);
    var response = await UserServices.getPageCount();
    if (response is Success) {
      var list = {
        for (int i = 1; i < (response.response as int); i++)
          i > 3 ? "..." : i.toString()
      }.toList();

      if (list.length > 3) list.add(">>");
      setPagesCount(response.response as int);
      _pageIndexView = list;
    } else if (response is Failure) {
      setFailure(failure);
    }
    setLoading(false);
  }
}
