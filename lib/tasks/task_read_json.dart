import 'dart:async';
import 'dart:convert';

import 'package:async_task/async_task.dart';
import 'package:flutter/services.dart';

import '../models/DataModel.dart';

class ReadJson extends AsyncTask<void, void> {
  ReadJson();

  Future<void> readJsonRaw() async {
    final String response = await rootBundle.loadString("assets/data.json");
    List<dynamic> j = json.decode(response);
    j.map((e) => DataModel.fromJson(e as Map<String, dynamic>)).toList();
    print("EXECUTED ******************** executed");
  }

  @override
  void parameters() {}

  @override
  Future<void> run() {
    return readJsonRaw();
  }

  @override
  ReadJson instantiate(void parameters, [Map<String, SharedData>? sharedData]) {
    return ReadJson();
  }
}
