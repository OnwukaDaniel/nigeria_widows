import 'dart:async';

import 'package:async_task/async_task.dart';

';
import '../models/DataModel.dart';

class Tasks extends AsyncTask<List<DataModel>, List<String>> {
  List<String> lgas = [];
  List<String> nogList = [];
  List<String> spouseBerList = [];
  List<String> occupationList = [];
  List<String> employmentStatList = [];
  List<String> widowYearsList = [];

  final List<DataModel> data;

  Tasks(this.data);

  @override
  AsyncTask<List<DataModel>, List<String>> instantiate(
      List<DataModel>parameters, [Map<String, SharedData>? sharedData]) {
    return Tasks(parameters);
  }

  @override
  List<DataModel> parameters() {
    return data;
  }
  @override
  FutureOr<List<String>> run() {
    throw UnimplementedError();
  }

  d(){
    for (DataModel x in data) {
      lgas.add(x.lga!);
      nogList.add(x.ngoMembership!);
      employmentStatList.add(x.employmentStatus!);
      var lonelyYears = smartDate(x.husbandBereavementDate!, x.dob!);
      spouseBerList.add(lonelyYears);
      occupationList.add(x.occupation);
      var widowYears =
      widowTime(x.husbandBereavementDate!, x.registrationDate!);
      widowYearsList.add(widowYears);
    }
  }

  String smartDate(String input, String dob) {
    List<String> months = [
      "january",
      "february",
      "march",
      "april",
      "may",
      "june",
      "july",
      "august",
      "september",
      "october",
      "november",
      "december",
    ];
    var dateOdBirth = DateTime.parse(dob);

    var list = input.toLowerCase().replaceAll(",", "").split(" ");
    var year = int.parse(list.last);
    var month = months.indexOf(list[1]);
    var day = int.parse(list[0]);
    var d = DateTime(year, month, day);
    var difference = d.difference(dateOdBirth);
    var lonelyYears = difference.inDays / 365;

    if (lonelyYears < 20) {
      return "20";
    } else if (lonelyYears > 19 && lonelyYears < 25) {
      return "20-24";
    } else if (lonelyYears > 24 && lonelyYears < 30) {
      return "25-29";
    } else if (lonelyYears > 29 && lonelyYears < 35) {
      return "30-34";
    } else if (lonelyYears > 34 && lonelyYears < 40) {
      return "35-39";
    } else if (lonelyYears > 39 && lonelyYears < 45) {
      return "40-44";
    } else if (lonelyYears > 44 && lonelyYears < 50) {
      return "45-49";
    } else if (lonelyYears > 49 && lonelyYears < 55) {
      return "50-54";
    } else if (lonelyYears > 54 && lonelyYears < 60) {
      return "55-59";
    } else if (lonelyYears >= 60) {
      return "60+";
    }
    return "";
  }

  String widowTime(String input, String regDate) {
    var regD = DateTime.parse(regDate);

    var d = DateTime(regD.year);

    var list = input.toLowerCase().replaceAll(",", "").split(" ");
    var year = int.parse(list.last);
    var dateBereavement = DateTime(year);
    var difference = d.difference(dateBereavement);
    var lonelyYears = difference.inDays / 365;

    if (lonelyYears < 3) {
      return "0-2";
    } else if (lonelyYears >= 3 && lonelyYears < 6) {
      return "3-5";
    } else if (lonelyYears >= 6 && lonelyYears < 9) {
      return "6-8";
    } else if (lonelyYears >= 9 && lonelyYears < 12) {
      return "9-11";
    } else if (lonelyYears >= 12 && lonelyYears < 16) {
      return "12-15";
    } else if (lonelyYears >= 16 && lonelyYears < 21) {
      return "16-20";
    } else if (lonelyYears >= 21 && lonelyYears < 26) {
      return "21-25";
    } else if (lonelyYears >= 26 && lonelyYears < 30) {
      return "26-29";
    } else if (lonelyYears > 30) {
      return "30+";
    }
    return lonelyYears.toString();
  }
}