import 'package:flutter/material.dart';

class PagingViewModel extends ChangeNotifier{
  int _currentPage = 0;
  List<String> _pageIndexView = [];
  int get currentPage => _currentPage;
  List<String> get pageIndexView => _pageIndexView;

  setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  setPageIndexView(List<String> pageIndexView) {
    _pageIndexView = pageIndexView;
    notifyListeners();
  }
}