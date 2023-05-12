import 'package:fl_chart/fl_chart.dart';

class Pair{
  String first = "?loading";
  FlTitlesData second = FlTitlesData();

  Pair({this.first = "?loading", required this.second});

  Map<String, dynamic> toMap() {
    return {
      'first': first,
      'second': second,
    };
  }

  Pair.getMap(Map<String, dynamic> map) {
    first = map["first"];
    second = map["second"];
  }
}