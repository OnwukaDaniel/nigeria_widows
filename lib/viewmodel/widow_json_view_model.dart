import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/DataModel.dart';
import '../sharednotifiers/app.dart';

class WidowJsonViewModel extends ChangeNotifier {
  List<DataModel> _data = [];

  List<DataModel> get data => _data;

  bool _loading = false;

  bool get loading => _loading;

  _setLoading(bool input) {
    _loading = input;
    notifyListeners();
  }

  Future read() {
    return compute(readJson, "");
  }

  Future<List<DataModel>> readJson(String a) async {
    _setLoading(true);
    final String response = await rootBundle.loadString("assets/data.json");
    List<dynamic> j = json.decode(response);
    jsonDataModelVN.value =
        j.map((e) => DataModel.fromJson(e as Map<String, dynamic>)).toList();
    _setLoading(false);
    return _data;
  }
}
