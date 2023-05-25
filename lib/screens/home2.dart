import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nigerian_widows/util/app_color.dart';

import '../models/DataModel.dart';
import '../sharednotifiers/app.dart';

computeLga(List<DataModel> value) async {
  List<String> lgas = [];

  for (DataModel x in value) {
    lgas.add(x.lga!);
  }
  lgas.sort((a, b) => b.compareTo(a));
  return lgas;
}

computeNogList(List<DataModel> value) async {
  List<String> nogList = [];

  for (DataModel x in value) {
    nogList.add(x.lga!);
  }
  return nogList;
}

computeEmploymentStatList(List<DataModel> value) async {
  List<String> employmentStatList = [];

  for (DataModel x in value) {
    employmentStatList.add(x.employmentStatus!);
  }
  return employmentStatList;
}

computeOccupationList(List<DataModel> value) async {
  List<String> occupationList = [];

  for (DataModel x in value) {
    occupationList.add(x.occupation);
  }
  return occupationList;
}

computeSpouseBerList(List<DataModel> value) async {
  List<String> spouseBerList = [];

  for (DataModel x in value) {
    var lonelyYears = smartDate(x.husbandBereavementDate!, x.dob!);
    spouseBerList.add(lonelyYears);
  }
  spouseBerList.sort((a, b) => b.compareTo(a));
  return spouseBerList;
}

computeWidowYearsList(List<DataModel> value) async {
  List<String> widowYearsList = [];

  for (DataModel x in value) {
    var widowYears =
    widowTime(x.husbandBereavementDate!, x.registrationDate!);
    widowYearsList.add(widowYears);
  }
  return widowYearsList;
}

class HomeTest extends StatefulWidget {
  static const String id = "home";

  const HomeTest({Key? key}) : super(key: key);

  @override
  State<HomeTest> createState() => _HomeTestState();
}

class _HomeTestState extends State<HomeTest> {
  List<DataModel> data = [];

  execute() async {
    final String response = await rootBundle.loadString("assets/data.json");
    List<dynamic> j = json.decode(response);
    var data =
        j.map((e) => DataModel.fromJson(e as Map<String, dynamic>)).toList();
    data.sort((a, b) {
      var bList = b.husbandBereavementDate!
          .toLowerCase()
          .replaceAll(",", "")
          .split(" ");
      var aList = a.husbandBereavementDate!
          .toLowerCase()
          .replaceAll(",", "")
          .split(" ");
      return bList.last.compareTo(aList.last);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ValueListenableBuilder(
        valueListenable: AppNotifier.jsonDataModelVN,
        builder: (BuildContext context, List<DataModel> value, Widget? child) {
          return ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              FutureBuilder(
                future: compute(computeLga, value),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SpinKitCubeGrid(color: AppColor.appColor, size: 200);
                  }
                  return SpinKitCubeGrid(color: AppColor.lightBlue, size: 200);
                },
              ),
              FutureBuilder(
                future: compute(computeNogList, value),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SpinKitCubeGrid(color: AppColor.appColor, size: 200);
                  }
                  return SpinKitCubeGrid(color: AppColor.lightBlue, size: 200);
                },
              ),
              FutureBuilder(
                future: compute(computeEmploymentStatList, value),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SpinKitCubeGrid(color: AppColor.appColor, size: 200);
                  }
                  return SpinKitCubeGrid(color: AppColor.lightBlue, size: 200);
                },
              ),
              FutureBuilder(
                future: compute(computeOccupationList, value),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SpinKitCubeGrid(color: AppColor.appColor, size: 200);
                  }
                  return SpinKitCubeGrid(color: AppColor.lightBlue, size: 200);
                },
              ),
              FutureBuilder(
                future: compute(computeSpouseBerList, value),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SpinKitCubeGrid(color: AppColor.appColor, size: 200);
                  }
                  return SpinKitCubeGrid(color: AppColor.lightBlue, size: 200);
                },
              ),
              FutureBuilder(
                future: compute(computeWidowYearsList, value),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SpinKitCubeGrid(color: AppColor.appColor, size: 200);
                  }
                  return SpinKitCubeGrid(color: AppColor.lightBlue, size: 200);
                },
              ),
            ],
          );
        },
      ),
    );
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