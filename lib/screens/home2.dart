import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nigerian_widows/models/pair.dart';
import 'package:nigerian_widows/util/app_color.dart';

import '../models/DataModel.dart';
import '../reuseables/app_spinner.dart';
import '../reuseables/asset_chart.dart';
import '../reuseables/bar_chart.dart';
import '../reuseables/pie_chart.dart';
import '../reuseables/pie_indicators.dart';
import '../reuseables/resuable_text.dart';
import '../reuseables/value_notifiers.dart';

class HomeTest extends StatefulWidget {
  static const String id = "home";

  const HomeTest({Key? key}) : super(key: key);

  @override
  State<HomeTest> createState() => _HomeTestState();
}

class _HomeTestState extends State<HomeTest> {
  ValueNotifier<Pair> ageAtBereavementTileVn =
      ValueNotifier(Pair(second: FlTitlesData()));

  ValueNotifier<Pair> occupationTileVn =
      ValueNotifier(Pair(second: FlTitlesData()));

  ValueNotifier<Pair> lgaTileVn = ValueNotifier(Pair(second: FlTitlesData()));

  ValueNotifier<Pair> widowsTileVn =
      ValueNotifier(Pair(second: FlTitlesData()));

  List<DataModel> data = [];
  List<int> showIndexes = [];
  bool showMe = false;

  List<Color> gradientColors = [
    const Color(0xff7948ff),
    const Color(0xffa08ae1),
    const Color(0xffffffff),
  ];

  final Color light = const Color(0xfff2f2ff);
  final Color normal = const Color(0xff64caad);
  final Color dark = const Color(0xff602bfa);

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

  List<BarChartGroupData> barLga = [];
  List<LineChartBarData> lineChartBarData = [];

  List<String> lgaLegend = [];
  List<String> spouseBerLegend = [];
  List<String> occupationLegend = [];
  List<String> widowYearsLegend = [];

  List<String> lgas = [];
  List<String> nogList = [];
  List<String> spouseBerList = [];
  List<String> occupationList = [];
  List<String> employmentStatList = [];
  List<String> widowYearsList = [];

  Map<String, int> lgaMap = {};
  Map<String, int> empMap = {};
  Map<String, int> nogShipMap = {};
  Map<String, int> widowYearsMap = {};
  Map<String, int> spouseBerMap = {};
  Map<String, int> occupationMap = {};

  List<PieIndicators> nogInd = [];
  List<PieIndicators> empInd = [];

  List<PieChartSectionData> ngoChartList = [];
  List<PieChartSectionData> empChartList = [];

  List<FlSpot> widowYearsChartList = [];

  double localGovtMax = 1;
  double widowYearsMax = 1;
  double occupationTypeMax = 1;
  double spouseBerMax = 1;
  int lgaTouchedIndex = -1;

  readJson() async {
    final String response = await rootBundle.loadString("assets/data.json");
    List<dynamic> j = json.decode(response);
    data = j.map((e) => DataModel.fromJson(e as Map<String, dynamic>)).toList();
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
    readMore();
  }

  readMore() {
    widowsCountVn.value = data.length;
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

    // SORT FOR SPOUSE BEREAVEMENT AGE RAGE (Important)
    lgas.sort((a, b) => b.compareTo(a));
    spouseBerList.sort((a, b) => b.compareTo(a));

    lgaMap = lgas.fold<Map<String, int>>({}, (map, element) {
      map[element] = (map[element] ?? 0) + 1;
      return map;
    });
    lgaCountVn.value = lgaMap.length;

    nogShipMap = nogList.fold<Map<String, int>>({}, (map, element) {
      map[element] = (map[element] ?? 0) + 1;
      return map;
    });
    ngoMapVn.value = nogShipMap;

    empMap = employmentStatList.fold<Map<String, int>>({}, (map, element) {
      map[element] = (map[element] ?? 0) + 1;
      return map;
    });
    employmentMapVn.value = empMap;

    spouseBerMap = spouseBerList.fold<Map<String, int>>({}, (map, element) {
      map[element] = (map[element] ?? 0) + 1;
      return map;
    });
    spouseBerDataVn.value = spouseBerMap;

    occupationMap = occupationList.fold<Map<String, int>>({}, (map, element) {
      map[element] = (map[element] ?? 0) + 1;
      return map;
    });
    occupationDataVn.value = occupationMap;

    widowYearsMap = widowYearsList.fold<Map<String, int>>({}, (map, element) {
      map[element] = (map[element] ?? 0) + 1;
      return map;
    });

    localGovtMax = lgaMap.values.toList().reduce(max).toDouble();
    widowYearsMax = widowYearsMap.values.toList().reduce(max).toDouble();

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
      lgaGroupDataVn.value = barLga;
      lgaLegend.add(x);
    }

    for (String x in spouseBerMap.keys.toList().reversed) {
      var xx = "";
      if (x == "20") {
        xx = "<20";
      } else {
        xx = x;
      }
      spouseBerLegend.add(xx);
    }

    for (String x in occupationMap.keys) {
      occupationLegend.add(x);
    }

    for (String x in widowYearsMap.keys) {
      var len = widowYearsChartList.length;
      widowYearsChartList
          .add(FlSpot((len + 2).toDouble(), widowYearsMap[x]!.toDouble()));
      widowYearsLegend.add(x);
    }

    var countNgo = 0;
    for (String x in nogShipMap.keys) {
      nogInd.add(
        PieIndicators(
            textWidget: Text(
              x,
              style: TextStyle(
                fontSize: 12,
                overflow: TextOverflow.clip,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            color: ngoColor[countNgo]),
      );
      countNgo++;
    }

    var countEmp = 0;
    for (String x in empMap.keys) {
      empInd.add(
        PieIndicators(
            textWidget: Text(
              x,
              style: TextStyle(
                fontSize: 12,
                overflow: TextOverflow.clip,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            color: empColor[countEmp]),
      );
      countEmp++;
    }

    setState(() {
      if (widowYearsChartList.isNotEmpty) {
        showMe = true;
      } else {
        showMe = false;
      }
    });

    lineChartBarData.add(
      LineChartBarData(
        show: true,
        spots: widowYearsChartList,
        showingIndicators: showIndexes,
        color: const Color(0xff5f29f8),
        isCurved: false,
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
          getDotPainter: (flSpot, value, lineChartBarData, value2) {
            return FlDotCirclePainter(
              radius: 3,
              strokeWidth: 3,
              strokeColor: const Color(0xff5f29f8),
              color: Colors.white,
            );
          },
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
          ),
        ),
      ),
    );
    lineChartDataVn.value = lineChartBarData;
    final tooltipsOnBar = lineChartBarData[0];

    showIndexes
        .addAll([for (var i = 0; i <= widowYearsChartList.length - 1; i++) i]);
  }

  @override
  void initState() {
    readJson();
    setAgeAtBereavementTile();
    setOccupationTile();
    setLgaTile();
    setWidowsTile();
    super.initState();
  }

  @override
  void dispose() {
    //widowsCountVn.dispose();
    //lgaCountVn.dispose();
    //lgaGroupDataVn.dispose();
    //employmentMapVn.dispose();
    //ngoMapVn.dispose();
    //lineChartDataVn.dispose();
    //spouseBerDataVn.dispose();
    //occupationDataVn.dispose();
    super.dispose();
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
    final tooltipsOnBar = lineChartBarData[0];

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          ValueListenableBuilder(
            builder: (context, int value, child) {
              if (value == 0) return const SizedBox();
              return AssetChat(
                legendText: CustomText(
                  text: "TOTAL NUMBER OF WIDOWS REGISTERED",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
                countText: CustomText(
                  text: "$value",
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
            },
            valueListenable: widowsCountVn,
          ),
          ValueListenableBuilder(
            builder: (context, int value, child) {
              if (value == 0) return const SizedBox();
              return AssetChat(
                legendText: CustomText(
                  text: "SELECT LOCAL GOVERNMENT",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
                countText: CustomText(
                  text: "$value",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                  padding: EdgeInsets.only(bottom: ch / 4),
                ),
                iconPath: "assets/icons/healthy_community.png",
                wavePath: "assets/icons/wave_graph.png",
              );
            },
            valueListenable: lgaCountVn,
          ),
          Padding(
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
                        child: ValueListenableBuilder(
                          builder:
                              (context, List<BarChartGroupData> value, child) {
                            if (value.isEmpty) return const SizedBox();
                            return ValueListenableBuilder(
                              valueListenable: lgaTileVn,
                              builder: (_, Pair pair, Widget? child) {
                                if (pair.first == "?loading") {
                                  return const Spinner(size: 100);
                                }
                                return BarChart(
                                  BarChartData(
                                    alignment: BarChartAlignment.center,
                                    groupsSpace: 8,
                                    barGroups: value,
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
                                );
                              },
                            );
                          },
                          valueListenable: lgaGroupDataVn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ValueListenableBuilder(
            builder: (context, Map<String, int> value, child) {
              if (value.isEmpty) return const SizedBox();
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: CustomPieGraph(
                  sectionColor: empColor,
                  chartList: empChartList,
                  smallRadius: (w / 12),
                  largeRadius: ((w / 12)) + 20.0,
                  map: value,
                  centerSpaceRadius: 60,
                  indicatorList: empInd,
                  employmentStaDataList: empChartList,
                  centerText: CustomText(
                    text: "WIDOWS\nEMPLOYMENT\n STATUS",
                    padding: const EdgeInsets.only(right: 16, left: 16),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1!.color,
                    ),
                  ),
                ),
              );
            },
            valueListenable: employmentMapVn,
          ),
          ValueListenableBuilder(
            builder: (context, Map<String, int> value, child) {
              if (value.isEmpty) return const SizedBox();
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: CustomPieGraph(
                  sectionColor: ngoColor,
                  chartList: ngoChartList,
                  smallRadius: w / 8 + 20,
                  largeRadius: (w / 8) + 50,
                  map: value,
                  indicatorList: nogInd,
                  legendText: CustomText(
                    text: "WIDOWS AFFILIATION TO NGO",
                    padding:
                        const EdgeInsets.only(top: 34, right: 16, left: 16),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1!.color,
                    ),
                  ),
                  employmentStaDataList: ngoChartList,
                ),
              );
            },
            valueListenable: ngoMapVn,
          ),
          Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(12.0),
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "YEARS SPENT AS A WIDOW",
                    padding:
                        const EdgeInsets.only(right: 16, left: 16, top: 20),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1!.color,
                    ),
                  ),
                  SizedBox(
                    width: cw,
                    height: ch,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: ValueListenableBuilder(
                        builder:
                            (context, List<LineChartBarData> value, child) {
                          if (value.isEmpty) return const SizedBox();
                          return ValueListenableBuilder(
                            valueListenable: widowsTileVn,
                            builder: (_, Pair pair, Widget? child) {
                              if (pair.first == "?loading") {
                                return const Spinner(size: 100);
                              }
                              return LineChart(
                                LineChartData(
                                  showingTooltipIndicators:
                                      showIndexes.map((index) {
                                    return ShowingTooltipIndicators([
                                      LineBarSpot(
                                        tooltipsOnBar,
                                        value.indexOf(tooltipsOnBar),
                                        tooltipsOnBar.spots[index],
                                      ),
                                    ]);
                                  }).toList(),
                                  gridData: FlGridData(show: false),
                                  lineTouchData: LineTouchData(
                                    getTouchLineEnd: (data, index) => 0,
                                    getTouchedSpotIndicator:
                                        (barData, List<int> spotIndexes) {
                                      return spotIndexes
                                          .map((spotIndex) {})
                                          .toList();
                                    },
                                    enabled: true,
                                    touchTooltipData: LineTouchTooltipData(
                                      tooltipBgColor: const Color(0xff602bf8),
                                      tooltipRoundedRadius: 5,
                                      tooltipPadding: const EdgeInsets.all(4),
                                      getTooltipItems:
                                          (List<LineBarSpot> lineBarsSpot) {
                                        return lineBarsSpot.map((lineBarSpot) {
                                          return LineTooltipItem(
                                            lineBarSpot.y.toInt().toString(),
                                            TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .color,
                                            ),
                                          );
                                        }).toList();
                                      },
                                    ),
                                  ),
                                  titlesData: pair.second,
                                  borderData: FlBorderData(show: false),
                                  minX: 2,
                                  maxX: (widowYearsChartList.length + 1)
                                      .toDouble(),
                                  minY: 0,
                                  maxY: widowYearsMax * 2,
                                  lineBarsData: value,
                                ),
                              );
                            },
                          );
                        },
                        valueListenable: lineChartDataVn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(12.0),
              color: Theme.of(context).cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "WIDOWS AGE AT SPOUSE BEREAVEMENT",
                    padding:
                        const EdgeInsets.only(top: 34, right: 16, left: 16),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1!.color,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 42.0, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 36,
                          height: 18,
                          color: dark,
                        ),
                        CustomText(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          text: "Age range",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ValueListenableBuilder(
                    builder: (context, Map<String, int> value, child) {
                      if (value.isEmpty) return const SizedBox();
                      return ValueListenableBuilder(
                        valueListenable: ageAtBereavementTileVn,
                        builder: (_, Pair pair, Widget? child) {
                          if (pair.first == "?loading") {
                            return const Spinner(size: 100);
                          }
                          return CustomBarChart(
                            typeMax: spouseBerMax,
                            smallWidth: 18,
                            largeWidth: 18 + 10,
                            map: value,
                            groupsSpace: 10,
                            gridData: FlGridData(
                              show: false,
                              drawVerticalLine: false,
                            ),
                            borderData: FlBorderData(show: false),
                            titlesData: pair.second,
                            alignment: BarChartAlignment.spaceAround,
                          );
                        },
                      );
                    },
                    valueListenable: spouseBerDataVn,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Material(
              elevation: 10,
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "WIDOWS TYPE OF OCCUPATION",
                    padding:
                        const EdgeInsets.only(top: 34, right: 16, left: 16),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1!.color,
                    ),
                  ),
                  ValueListenableBuilder(
                    builder: (context, Map<String, int> value, child) {
                      if (value.isEmpty) return const SizedBox();
                      return ValueListenableBuilder(
                        valueListenable: occupationTileVn,
                        builder: (_, Pair pair, Widget? child) {
                          if (pair.first == "?loading") {
                            return const Spinner(size: 100);
                          }
                          return CustomBarChart(
                            typeMax: occupationTypeMax,
                            smallWidth: 18,
                            largeWidth: 18 + 10,
                            map: value,
                            groupsSpace: 10,
                            gridData: FlGridData(
                              show: false,
                              drawVerticalLine: false,
                            ),
                            borderData: FlBorderData(show: false),
                            titlesData: pair.second,
                            alignment: BarChartAlignment.spaceAround,
                          );
                        },
                      );
                    },
                    valueListenable: occupationDataVn,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(widowYearsLegend[value.toInt()], style: style),
    );
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

  Future<void> setAgeAtBereavementTile() async {
    ageAtBereavementTileVn.value = Pair(
      second: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 65,
            getTitlesWidget: ((value, meta) {
              var style = TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontSize: 8);
              return SideTitleWidget(
                space: 4,
                axisSide: meta.axisSide,
                child: Column(
                  children: [
                    RotatedBox(
                      quarterTurns: 1,
                      child: Text(
                        " - ",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),
                    ),
                    Text(spouseBerLegend[value.toInt()], style: style),
                  ],
                ),
              );
            }),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 500,
            getTitlesWidget: (double value, TitleMeta meta) {
              const style = TextStyle(color: Color(0xff939393), fontSize: 10);
              return SideTitleWidget(
                space: 0,
                axisSide: meta.axisSide,
                child: Text("${meta.formattedValue}-", style: style),
              );
            },
          ),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      first: "ready",
    );
  }

  Future<void> setOccupationTile() async {
    occupationTileVn.value = Pair(
      second: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 95,
            getTitlesWidget: ((v, meta) {
              var style = TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontSize: 8);
              return SideTitleWidget(
                space: 4,
                axisSide: meta.axisSide,
                child: Column(
                  children: [
                    const RotatedBox(quarterTurns: 1, child: Text(" - ")),
                    Expanded(
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Text(occupationLegend[v.toInt()], style: style),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 500,
            getTitlesWidget: (double value, TitleMeta meta) {
              const style = TextStyle(color: Color(0xff939393), fontSize: 10);
              return SideTitleWidget(
                space: 0,
                axisSide: meta.axisSide,
                child: Text("${meta.formattedValue}-", style: style),
              );
            },
          ),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      first: "ready",
    );
  }

  Future<void> setLgaTile() async {
    lgaTileVn.value = Pair(
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
  }

  Future<void> setWidowsTile() async {
    widowsTileVn.value = Pair(
      second: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (double value, TitleMeta meta) {
              var style = TextStyle(
                color: Theme.of(context).textTheme.bodyText1!.color,
                fontSize: 10,
              );
              var r = [for (var i = 0; i <= widowYearsChartList.length; i++) i];

              if (r.contains((value - 1).toInt())) {
                return SideTitleWidget(
                  space: 4,
                  axisSide: meta.axisSide,
                  child: Column(
                    children: [
                      RotatedBox(
                        quarterTurns: 1,
                        child: Text(
                          "- ",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                        ),
                      ),
                      Text(widowYearsLegend[(value).toInt() - 2], style: style),
                    ],
                  ),
                );
              } else {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    "",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1!.color,
                    ),
                  ),
                );
              }
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      first: "ready",
    );
  }
}
