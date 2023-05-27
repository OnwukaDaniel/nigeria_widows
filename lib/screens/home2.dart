import 'dart:convert';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nigerian_widows/util/app_color.dart';
import 'package:provider/provider.dart';

import '../models/DataModel.dart';
import '../models/HomePageData.dart';
import '../reuseables/asset_chart.dart';
import '../reuseables/bar_chart.dart';
import '../reuseables/pie_chart.dart';
import '../reuseables/resuable_text.dart';
import '../reuseables/value_notifiers.dart';
import '../sharednotifiers/app.dart';
import '../viewmodel/chart_view_model.dart';

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

computeLga(List<BaseLocalGovtData> value) async {
  List<BarChartGroupData> barLga = [];
  List<String> lgaLegend = [];
  List<int> values = [];
  value.forEach((element) {
    values.add(element.value);
  });
  double localGovtMax = values.reduce(max).toDouble();

  for (BaseLocalGovtData x in value) {
    BarChartRodData rod = BarChartRodData(
      toY: localGovtMax,
      rodStackItems: [
        BarChartRodStackItem(0, x.value.toDouble(), dark),
        BarChartRodStackItem(x.value.toDouble(), localGovtMax, light),
      ],
      borderRadius: BorderRadius.zero,
    );
    barLga.add(
      BarChartGroupData(x: lgaLegend.length, barsSpace: 4, barRods: [rod]),
    );
    lgaGroupDataVn.value = barLga;
    lgaLegend.add(x.title);
  }
  return [barLga, lgaLegend];
}

computeChildrenList(List<BaseLocalGovtData> value) {
  List<FlSpot> childrenDataList = [];
  List<String> childrenDataLegend = [];
  List<int> values = [];
  for (BaseLocalGovtData x in value) {
    String title = x.title;
    var split = title.split(" ");
    title = "${split.first}\n${split.last}";
    values.add(x.value);
    var len = childrenDataList.length;
    childrenDataList.add(FlSpot((len + 2).toDouble(), x.value.toDouble()));
    childrenDataLegend.add(title);
  }
  return [childrenDataList, childrenDataLegend, values.reduce(max).toDouble()];
}

computeYearsInMarriage(List<BaseLocalGovtData> value) async {
  List<int> values = [];
  List<String> legend = [];

  for (BaseLocalGovtData x in value) {
    values.add(x.value);
    legend.add(x.title);
  }
  return [values, legend];
}

computeOccupation(List<BaseLocalGovtData> value) async {
  List<int> values = [];
  List<String> legend = [];

  for (BaseLocalGovtData x in value) {
    values.add(x.value);
    legend.add(x.title);
  }
  return [values, legend];
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
  Widget build(BuildContext context) {
    ChartViewModel chartViewModel = context.watch<ChartViewModel>();
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
          return _ui(chartViewModel, context);
        },
      ),
    );
  }

  _ui(ChartViewModel chartViewModel, BuildContext context) {
    int width = MediaQuery.of(context).size.width.toInt();
    int w = 360;
    int h = 150;
    double aspectRatio = w / h;
    double rootAspectRatio = sqrt(aspectRatio);

    double cw = width * rootAspectRatio;
    double ch = cw / aspectRatio;

    if (chartViewModel.loading) {
      return SpinKitCubeGrid(color: AppColor.lightBlue, size: 200);
    } else {
      if (chartViewModel.success) {
        int widowsCount = chartViewModel.chartModel.data.widowsCount.count;
        int lgaCount = chartViewModel.chartModel.data.lgaCount;
        var lgaList = chartViewModel.chartModel.data.localGovData.data;
        List<BaseLocalGovtData> employmentStaList =
            chartViewModel.chartModel.data.employmentStatusData.data;
        List<BaseLocalGovtData> affiliationToNGOList =
            chartViewModel.chartModel.data.nGOAffiliation.data;
        var childListData = chartViewModel.chartModel.data.childrenData.data;
        var yearsInMarriageListData =
            chartViewModel.chartModel.data.yearsInMarriageData.data;
        var occupationData = chartViewModel.chartModel.data.occupationData.data;
        int touchedIndex = -1;
        print(
            "HomePageData  ***** ${chartViewModel.chartModel.data.childrenData.data}");

        return ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            AssetChat(
              legendText: CustomText(
                text: "TOTAL NUMBER OF WIDOWS REGISTERED",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
              countText: CustomText(
                text: widowsCount.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
              iconPath: "assets/icons/people_icons.png",
              wavePath: "assets/icons/wave_graph1.png",
            ),
            AssetChat(
              legendText: CustomText(
                text: "SELECT LOCAL GOVERNMENT",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
              countText: CustomText(
                text: lgaCount.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
              iconPath: "assets/icons/healthy_community.png",
              wavePath: "assets/icons/wave_graph.png",
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
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                      padding:
                          const EdgeInsets.only(top: 34, right: 12, left: 12),
                    ),
                    FutureBuilder(
                      future: compute(computeLga, lgaList),
                      builder: (_, AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          var raw = snapshot.data as List<dynamic>;
                          List<BarChartGroupData> barGroups =
                              raw.first as List<BarChartGroupData>;
                          List<String> lgaLegend = raw.last as List<String>;
                          FlTitlesData lgaTile = FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 90,
                                getTitlesWidget:
                                    (double value, TitleMeta meta) {
                                  var style = TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                    fontSize: 10,
                                  );
                                  return SideTitleWidget(
                                    space: 36.0,
                                    axisSide: meta.axisSide,
                                    angle: 98.96,
                                    child: Text(
                                        "${lgaLegend[value.toInt()]} - ",
                                        style: style),
                                  );
                                },
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                interval: 200,
                                getTitlesWidget:
                                    (double value, TitleMeta meta) {
                                  const style = TextStyle(
                                      color: Color(0xff939393), fontSize: 10);
                                  return SideTitleWidget(
                                    angle: 98.96,
                                    space: 15,
                                    axisSide: meta.axisSide,
                                    child: Column(
                                      children: [
                                        const RotatedBox(
                                          quarterTurns: 1,
                                          child: Text(
                                            "-",
                                            style: style,
                                          ),
                                        ),
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
                          );

                          return Container(
                            width: width.toDouble(),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                            height: 350,
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.center,
                                  groupsSpace: 8,
                                  barGroups: barGroups,
                                  titlesData: lgaTile,
                                  gridData: FlGridData(
                                    show: false,
                                    drawVerticalLine: false,
                                  ),
                                  borderData: FlBorderData(show: false),
                                  barTouchData: BarTouchData(
                                    touchTooltipData: BarTouchTooltipData(
                                      fitInsideHorizontally: true,
                                      fitInsideVertically: true,
                                      tooltipBgColor: Colors.white,
                                      getTooltipItem:
                                          (groupData, int1, rodData, int2) {
                                        return BarTooltipItem(
                                          rodData.rodStackItems.first.toY
                                              .toString(),
                                          const TextStyle(),
                                        );
                                      },
                                    ),
                                    handleBuiltInTouches: true,
                                    allowTouchBarBackDraw: true,
                                    touchCallback:
                                        (FlTouchEvent event, barTouchResponse) {
                                      if (!event.isInterestedForInteractions ||
                                          barTouchResponse == null ||
                                          barTouchResponse.spot == null) {

                                        return;
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Center(
                            child: Text(
                              "Loading",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: CustomPieGraph(
                sectionColor: empColor,
                smallRadius: (w / 12),
                largeRadius: ((w / 12)) + 20.0,
                map: employmentStaList,
                centerSpaceRadius: 60,
                centerText: CustomText(
                  text: "WIDOWS\nEMPLOYMENT\n STATUS",
                  padding: const EdgeInsets.only(right: 16, left: 16),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: CustomPieGraph(
                sectionColor: ngoColor,
                smallRadius: w / 8 + 20,
                largeRadius: (w / 8) + 50,
                map: affiliationToNGOList,
                legendText: CustomText(
                  text: "WIDOWS AFFILIATION TO NGO ",
                  padding: const EdgeInsets.only(left: 16, top: 32),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
              ),
            ),
            FutureBuilder(
              future: compute(computeChildrenList, childListData),
              builder: (_, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  List<int> showIndexes = [];
                  List<LineChartBarData> lineChartBarData = [];
                  List<FlSpot> childrenDataList =
                      (snapshot.data as List<dynamic>).first as List<FlSpot>;
                  List<String> childrenDataLegend =
                      (snapshot.data as List<dynamic>)[1] as List<String>;
                  double childrenMax =
                      (snapshot.data as List<dynamic>).last as double;

                  lineChartBarData.add(
                    LineChartBarData(
                      show: true,
                      spots: childrenDataList,
                      showingIndicators: showIndexes,
                      color: const Color(0xff5f29f8),
                      isCurved: false,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter:
                            (flSpot, value, lineChartBarData, value2) {
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
                  final tooltipsOnBar = lineChartBarData[0];
                  showIndexes.addAll([
                    for (var i = 0; i <= childrenDataList.length - 1; i++) i
                  ]);

                  var flTileData = FlTitlesData(
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
                        reservedSize: 40,
                        interval: 1,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          var style = TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            fontSize: 8,
                          );
                          var r = [
                            for (var i = 0; i <= childrenDataLegend.length; i++)
                              i
                          ];

                          if (r.contains((value - 1).toInt())) {
                            return SideTitleWidget(
                              space: 2,
                              axisSide: meta.axisSide,
                              child: Column(
                                children: [
                                  RotatedBox(
                                    quarterTurns: 1,
                                    child: Text(
                                      "- ",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .color,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    childrenDataLegend[(value).toInt() - 2],
                                    style: style,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                "",
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
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
                  );

                  return Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(12.0),
                    color: Theme.of(context).cardColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "NUMBER OF CHILDREN",
                            padding: const EdgeInsets.only(
                                right: 16, left: 16, top: 20),
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                            ),
                          ),
                          Container(
                            height: ch,
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            child: LineChart(
                              LineChartData(
                                showingTooltipIndicators:
                                    showIndexes.map((index) {
                                  return ShowingTooltipIndicators([
                                    LineBarSpot(
                                      tooltipsOnBar,
                                      lineChartBarData.indexOf(tooltipsOnBar),
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
                                titlesData: flTileData,
                                borderData: FlBorderData(show: false),
                                minX: 2,
                                maxX: (childrenDataList.length + 1).toDouble(),
                                minY: 0,
                                maxY: childrenMax * 1.5,
                                lineBarsData: lineChartBarData,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            FutureBuilder(
              future: compute(computeYearsInMarriage, yearsInMarriageListData),
              builder: (_, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  List<int> value =
                      (snapshot.data as List<dynamic>).first as List<int>;
                  List<String> legend =
                      (snapshot.data as List<dynamic>).last as List<String>;
                  var yearsMax = value.reduce(max).toDouble();
                  FlTitlesData tiles = FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 65,
                        getTitlesWidget: ((value, meta) {
                          var style = TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            fontSize: 8,
                          );
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
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                                    ),
                                  ),
                                ),
                                RotatedBox(
                                  quarterTurns: 1,
                                  child:
                                      Text(legend[value.toInt()], style: style),
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
                          const style =
                              TextStyle(color: Color(0xff939393), fontSize: 10);
                          return SideTitleWidget(
                            space: 0,
                            axisSide: meta.axisSide,
                            child:
                                Text("${meta.formattedValue}-", style: style),
                          );
                        },
                      ),
                    ),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  );
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(12.0),
                      color: Theme.of(context).cardColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "YEARS IN MARRIAGE",
                            padding: const EdgeInsets.only(
                                top: 34, right: 16, left: 16),
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 42.0, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 36,
                                  height: 18,
                                  color: dark,
                                ),
                                CustomText(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  text: "Years",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomBarChart(
                            typeMax: yearsMax,
                            smallWidth: 18,
                            largeWidth: 18 + 10,
                            map: yearsInMarriageListData,
                            groupsSpace: 10,
                            gridData: FlGridData(
                              show: false,
                              drawVerticalLine: false,
                            ),
                            borderData: FlBorderData(show: false),
                            titlesData: tiles,
                            alignment: BarChartAlignment.spaceAround,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            FutureBuilder(
              future: compute(computeOccupation, occupationData),
              builder: (_, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  List<int> value =
                      (snapshot.data as List<dynamic>).first as List<int>;
                  List<String> legend =
                      (snapshot.data as List<dynamic>).last as List<String>;
                  var valueMax = value.reduce(max).toDouble();
                  FlTitlesData tiles = FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 85,
                        getTitlesWidget: ((value, meta) {
                          var style = TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            fontSize: 8,
                          );
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
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                                    ),
                                  ),
                                ),
                                RotatedBox(
                                  quarterTurns: 1,
                                  child:
                                      Text(legend[value.toInt()], style: style),
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
                          const style =
                              TextStyle(color: Color(0xff939393), fontSize: 10);
                          return SideTitleWidget(
                            space: 0,
                            axisSide: meta.axisSide,
                            child:
                                Text("${meta.formattedValue}-", style: style),
                          );
                        },
                      ),
                    ),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  );
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(12.0),
                      color: Theme.of(context).cardColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "WIDOWS TYPE OF OCCUPATION",
                            padding: const EdgeInsets.only(
                                top: 34, right: 16, left: 16),
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                            ),
                          ),
                          CustomBarChart(
                            typeMax: valueMax,
                            smallWidth: 18,
                            largeWidth: 18 + 10,
                            map: occupationData,
                            groupsSpace: 10,
                            gridData: FlGridData(
                              show: false,
                              drawVerticalLine: false,
                            ),
                            borderData: FlBorderData(show: false),
                            titlesData: tiles,
                            alignment: BarChartAlignment.spaceAround,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        );
      } else {
        return const SpinKitCubeGrid(color: Colors.amber, size: 200);
      }
    }
  }

  FlBorderData borderData = FlBorderData(
    show: false,
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
