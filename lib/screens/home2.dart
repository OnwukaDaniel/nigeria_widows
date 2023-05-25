import 'dart:convert';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nigerian_widows/util/app_color.dart';

import '../models/DataModel.dart';
import '../models/pair.dart';
import '../reuseables/app_spinner.dart';
import '../reuseables/asset_chart.dart';
import '../reuseables/pie_chart.dart';
import '../reuseables/pie_indicators.dart';
import '../reuseables/resuable_text.dart';
import '../reuseables/value_notifiers.dart';
import '../sharednotifiers/app.dart';

const Color light = Color(0xfff2f2ff);
const Color normal = Color(0xff64caad);
const Color dark = Color(0xff602bfa);

List<Color> gradientColors = [
  const Color(0xff7948ff),
  const Color(0xffa08ae1),
  const Color(0xffffffff),
];

final List<Color> ngoColor = [
  const Color(0xFFADA5C2),
  const Color(0xFF039CDD),
  const Color(0xFF602BF8),
];

final List<Color> empColor = [
  const Color(0xFF723EFF),
  const Color(0xFFDC950A),
  const Color(0xFF3EBFF6),
  const Color(0xFFFDE567),
  const Color(0xFF039CDD),
  const Color(0xFF000000),
];

computeLga(List<DataModel> value) async {
  List<String> lgas = [];
  List<BarChartGroupData> barLga = [];
  List<String> lgaLegend = [];

  for (DataModel x in value) {
    lgas.add(x.lga!);
  }
  lgas.sort((a, b) => b.compareTo(a));
  var lgaMap = lgas.fold<Map<String, int>>({}, (map, element) {
    map[element] = (map[element] ?? 0) + 1;
    return map;
  });
  lgaCountVn.value = lgaMap.length;
  var localGovtMax = lgaMap.values.toList().reduce(max).toDouble();

  for (String x in lgaMap.keys) {
    BarChartRodData rod = BarChartRodData(
      toY: localGovtMax + 50,
      rodStackItems: [
        BarChartRodStackItem(0, lgaMap[x]!.toDouble(), dark),
        BarChartRodStackItem(lgaMap[x]!.toDouble(), localGovtMax + 50, light),
      ],
      borderRadius: BorderRadius.zero,
    );
    barLga.add(
      BarChartGroupData(x: lgaLegend.length, barsSpace: 4, barRods: [rod]),
    );
    lgaLegend.add(x);
  }
  return [lgaLegend, barLga];
}

computeNogList(List<DataModel> value) async {
  List<String> nogList = [];
  List<PieIndicators> nogInd = [];

  for (DataModel x in value) {
    nogList.add(x.lga!);
  }

  var nogShipMap = nogList.fold<Map<String, int>>({}, (map, element) {
    map[element] = (map[element] ?? 0) + 1;
    return map;
  });
  ngoMapVn.value = nogShipMap;

  var countNgo = 0;
  /*for (String x in nogShipMap.keys) {
    nogInd.add(
      PieIndicators(
          textWidget: Text(
            x,
            style: const TextStyle(
              fontSize: 12,
              overflow: TextOverflow.clip,
            ),
          ),
          color: ngoColor[countNgo]),
    );
    countNgo++;
  }*/
  return nogList;
}

computeEmploymentStatList(List<DataModel> value) async {
  List<String> employmentStatList = [];

  for (DataModel x in value) {
    employmentStatList.add(x.employmentStatus!);
  }
  var empMap = employmentStatList.fold<Map<String, int>>({}, (map, element) {
    map[element] = (map[element] ?? 0) + 1;
    return map;
  });
  employmentMapVn.value = empMap;

  List<PieIndicators> empInd = [];
  var countEmp = 0;
  for (String x in empMap.keys) {
    empInd.add(
      PieIndicators(
          textWidget: Text(
            x,
            style: const TextStyle(
              fontSize: 12,
              overflow: TextOverflow.clip,
            ),
          ),
          color: empColor[countEmp]),
    );
    countEmp++;
  }
  return [empMap, empInd];
}

computeOccupationList(List<DataModel> value) async {
  List<String> occupationList = [];
  List<String> occupationLegend = [];

  for (DataModel x in value) {
    occupationList.add(x.occupation);
  }
  var occupationMap = occupationList.fold<Map<String, int>>({}, (map, element) {
    map[element] = (map[element] ?? 0) + 1;
    return map;
  });
  occupationDataVn.value = occupationMap;

  for (String x in occupationMap.keys) {
    occupationLegend.add(x);
  }
  return occupationLegend;
}

computeSpouseBerList(List<DataModel> value) async {
  List<String> spouseBerList = [];
  List<String> spouseBerLegend = [];

  for (DataModel x in value) {
    var lonelyYears = smartDate(x.husbandBereavementDate!, x.dob!);
    spouseBerList.add(lonelyYears);
  }
  spouseBerList.sort((a, b) => b.compareTo(a));
  var spouseBerMap = spouseBerList.fold<Map<String, int>>({}, (map, element) {
    map[element] = (map[element] ?? 0) + 1;
    return map;
  });
  spouseBerDataVn.value = spouseBerMap;

  for (String x in spouseBerMap.keys.toList().reversed) {
    var xx = "";
    if (x == "20") {
      xx = "<20";
    } else {
      xx = x;
    }
    spouseBerLegend.add(xx);
  }
  return spouseBerLegend;
}

computeWidowYearsList(List<DataModel> value) async {
  List<String> widowYearsList = [];
  List<FlSpot> widowYearsChartList = [];
  List<String> widowYearsLegend = [];

  for (DataModel x in value) {
    var widowYears =
    widowTime(x.husbandBereavementDate!, x.registrationDate!);
    widowYearsList.add(widowYears);
  }
  var widowYearsMap = widowYearsList.fold<Map<String, int>>({}, (map, element) {
    map[element] = (map[element] ?? 0) + 1;
    return map;
  });
  var widowYearsMax = widowYearsMap.values.toList().reduce(max).toDouble();

  for (String x in widowYearsMap.keys) {
    var len = widowYearsChartList.length;
    widowYearsChartList.add(FlSpot((len + 2).toDouble(), widowYearsMap[x]!.toDouble()));
    widowYearsLegend.add(x);
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
    int width = MediaQuery.of(context).size.width.toInt();
    int w = 360;
    int h = 150;
    double aspectRatio = w / h;
    double rootAspectRatio = sqrt(aspectRatio);

    double cw = width * rootAspectRatio;
    double ch = cw / aspectRatio;

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
                    return AssetChat(
                      legendText: CustomText(
                        text: "TOTAL NUMBER OF WIDOWS REGISTERED",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),
                      countText: CustomText(
                        text: "${value.length}",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                        padding: EdgeInsets.only(bottom: ch / 4),
                      ),
                      iconPath: "assets/icons/people_icons.png",
                      wavePath: "assets/icons/wave_graph1.png",
                    );
                  }
                  return SpinKitCubeGrid(color: AppColor.lightBlue, size: 200);
                },
              ),
              FutureBuilder(
                future: compute(computeNogList, value),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return AssetChat(
                      legendText: CustomText(
                        text: "SELECT LOCAL GOVERNMENT",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),
                      countText: CustomText(
                        text: "${value.length}",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                        padding: EdgeInsets.only(bottom: ch / 4),
                      ),
                      iconPath: "assets/icons/healthy_community.png",
                      wavePath: "assets/icons/wave_graph.png",
                    );;
                  }
                  return SpinKitCubeGrid(color: AppColor.lightBlue, size: 200);
                },
              ),
              FutureBuilder(
                future: compute(computeLga, value),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var lgaLegend = (snapshot.data as List<dynamic>).first as List<String>;
                    var barData = (snapshot.data as List<dynamic>).last as List<BarChartGroupData>;
                    var pair = Pair(
                      second: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 90,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              var style = TextStyle(
                                color: Theme.of(context).textTheme.bodyText1!.color,
                                fontSize: 10,
                              );
                              var text =
                              lgaLegend.isEmpty ? "" : "${lgaLegend[value.toInt()]} - ";
                              return SideTitleWidget(
                                space: 36.0,
                                axisSide: meta.axisSide,
                                angle: 98.96,
                                child: Text(text, style: style),
                              );
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: 200,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              var style = TextStyle(
                                  color: Theme.of(context).textTheme.bodyText1!.color,
                                  fontSize: 10);
                              return SideTitleWidget(
                                angle: 98.96,
                                space: 15,
                                axisSide: meta.axisSide,
                                child: Column(
                                  children: [
                                    const RotatedBox(quarterTurns: 1, child: Text("-")),
                                    Text(meta.formattedValue, style: style),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      first: "ready",
                    );

                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Material(
                          elevation: 10,
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "WIDOWS REGISTERED BY LOCAL GOVERNMENT",
                                padding:
                                const EdgeInsets.only(top: 34, right: 12, left: 12),
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyText1!.color,
                                ),
                              ),
                              SizedBox(
                                width: width.toDouble(),
                                height: 350,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                  child: RotatedBox(
                                    quarterTurns: 1,
                                    child: BarChart(
                                      BarChartData(
                                        alignment: BarChartAlignment.center,
                                        groupsSpace: 8,
                                        barGroups: barData,
                                        titlesData: pair.second,
                                        gridData: FlGridData(
                                          show: false,
                                          drawVerticalLine: false,
                                        ),
                                        borderData: FlBorderData(show: false),
                                        barTouchData: BarTouchData(
                                          touchTooltipData: BarTouchTooltipData(
                                            fitInsideHorizontally: true,
                                            fitInsideVertically: true,
                                            tooltipBgColor: AppColor.appColor,
                                            getTooltipItem:
                                                (groupData, int1, rodData, int2) {
                                              return BarTooltipItem(
                                                rodData.rodStackItems.first.toY
                                                    .toString(),
                                                TextStyle(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .color,
                                                ),
                                              );
                                            },
                                          ),
                                          handleBuiltInTouches: true,
                                          allowTouchBarBackDraw: true,
                                          touchCallback: (FlTouchEvent event,
                                              barTouchResponse) {
                                            if (!event
                                                .isInterestedForInteractions ||
                                                barTouchResponse == null ||
                                                barTouchResponse.spot == null) {
                                              return;
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                  }
                  return SpinKitCubeGrid(color: AppColor.lightBlue, size: 200);
                },
              ),
              FutureBuilder(
                future: compute(computeEmploymentStatList, value),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map<String, int> data = (snapshot.data as List<dynamic>)[0] as Map<String, int>;
                    List<PieIndicators> empInd = (snapshot.data as List<dynamic>)[1] as List<PieIndicators>;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: CustomPieGraph(
                        sectionColor: empColor,
                        smallRadius: (w / 12),
                        largeRadius: ((w / 12)) + 20.0,
                        map: data,
                        centerSpaceRadius: 60,
                        centerText: CustomText(
                          text: "WIDOWS\nEMPLOYMENT\n STATUS",
                          padding: const EdgeInsets.only(right: 16, left: 16),
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                        ),
                      ),
                    );
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