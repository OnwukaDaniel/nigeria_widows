import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:particle_field/particle_field.dart';
import 'package:particles_flutter/particles_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rnd/rnd.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/DataModel.dart';
import '../models/HomePageData.dart';
import '../reuseables/asset_chart.dart';
import '../reuseables/bar_chart.dart';
import '../reuseables/pie_chart.dart';
import '../reuseables/resuable_text.dart';
import '../reuseables/value_notifiers.dart';
import '../sharednotifiers/app.dart';
import '../util/app_constants.dart';
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

class Home extends StatefulWidget {
  static const String id = "home";

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BackgroundPrefData decodeBackgroundFromString(String input,
      {int identity = 1}) {
    if (input == "") {
      return BackgroundPrefData();
    }
    return BackgroundPrefData.fromJson(
      jsonDecode(input) as Map<String, dynamic>,
    );
  }

  getBackgroundPref() async {
    var pref = await SharedPreferences.getInstance();
    var value = pref.getString("backgroundPrefData") ?? "";
    AppNotifier.backgroundPrefDataVn.value = value;
    var decoded = decodeBackgroundFromString(value);
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      getBackgroundPref();
    });
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      AppNotifier.toolbarTitleVn.value = "Nigerian Widows";
      getBackgroundPref();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    ChartViewModel chartViewModel = context.watch<ChartViewModel>();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: [
          ValueListenableBuilder(
            valueListenable: AppNotifier.backgroundPrefDataVn,
            builder: (_, String value, Widget? child) {
              if (value == "") return const SizedBox();
              BackgroundPrefData data = decodeBackgroundFromString(value);

              print(
                  "data.numberOfParticles ********** ${data.numberOfParticles}");

              if (data.identity == 2) {
                return Container(
                  clipBehavior: Clip.hardEdge,
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ColoredBox(
                    color: const Color(0xFF110018),
                    child: cometParticles.stackBelow(
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Row(
                          children: [
                            Icon(
                              Icons.menu,
                              size: 20,
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                            ),
                            Text(
                              AppConstants.appName,
                              style: TextStyle(
                                fontSize: 9,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                              ),
                            )
                          ],
                        ),
                      ),
                      scale: 1.1,
                    ),
                  ),
                );
              }
              return Container(
                color: AppConstants().constantsToColor(data.backgroundColor),
                child: CircularParticle(
                  isRandomColor: data.isRandomColor,
                  width: width,
                  height: height,
                  awayRadius: data.awayRadius,
                  numberOfParticles: data.numberOfParticles,
                  speedOfParticles: data.speedOfParticles,
                  maxParticleSize: data.maxParticleSize,
                  particleColor: Colors.white.withOpacity(.7),
                  awayAnimationDuration: const Duration(microseconds: 600),
                  awayAnimationCurve: Curves.easeInOutBack,
                  onTapAnimation: true,
                  connectDots: data.connectDots,
                  enableHover: true,
                  hoverColor: Colors.black,
                  hoverRadius: 90,
                ),
              );
            },
          ),
          _ui(chartViewModel, context),
        ],
      ),
    );
  }

  _ui(ChartViewModel chartViewModel, BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int w = 360;
    int h = 150;
    double aspectRatio = w / h;
    double rootAspectRatio = sqrt(aspectRatio);

    double cw = width * rootAspectRatio;
    double ch = cw / aspectRatio;

    if (chartViewModel.loading) {
      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: kToolbarHeight + 13),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Center(
              child: Text(
                "Loading",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Center(
              child: Text(
                "Loading",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Center(
              child: Text(
                "Loading",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Center(
              child: Text(
                "Loading",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Center(
              child: Text(
                "Loading",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Center(
              child: Text(
                "Loading",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      if (chartViewModel.success) {
        int widowsCount = chartViewModel.chartModel.data.widowsCount.count;
        int lgaCount = chartViewModel.chartModel.data.lgaCount;
        List<BaseLocalGovtData> employmentStaList =
            chartViewModel.chartModel.data.employmentStatusData.data;
        List<BaseLocalGovtData> affiliationToNGOList =
            chartViewModel.chartModel.data.nGOAffiliation.data;

        return ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: kToolbarHeight + 13),
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: ValueListenableBuilder(
                    valueListenable: AppNotifier.backgroundPrefDataVn,
                    builder: (_, String value, Widget? child) {
                      return Material(
                        elevation: 10,
                        color: Theme.of(context).cardColor.withOpacity(
                              value != "" ? .5 : 1,
                            ),
                        borderRadius: BorderRadius.circular(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 24, right: 12, left: 12),
                              child: Text(
                                "WIDOWS REGISTERED BY LOCAL GOVERNMENT",
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                ),
                              ),
                            ),
                            FutureBuilder(
                              future: compute(
                                computeLga,
                                context
                                    .watch<ChartViewModel>()
                                    .chartModel
                                    .data
                                    .localGovData
                                    .data,
                              ),
                              builder: (_, AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.hasData) {
                                  var raw = snapshot.data as List<dynamic>;
                                  List<BarChartGroupData> barGroups =
                                      raw.first as List<BarChartGroupData>;
                                  List<String> lgaLegend =
                                      raw.last as List<String>;
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
                                              style: style,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    rightTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 50,
                                        interval: 200,
                                        getTitlesWidget:
                                            (double value, TitleMeta meta) {
                                          const style = TextStyle(
                                              color: Color(0xff939393),
                                              fontSize: 10);
                                          return SideTitleWidget(
                                            angle: 0,
                                            space: 15,
                                            axisSide: meta.axisSide,
                                            child: Column(
                                              children: [
                                                Text(
                                                  " - ${meta.formattedValue}",
                                                  style: style,
                                                ),
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
                                            touchTooltipData:
                                                BarTouchTooltipData(
                                              fitInsideHorizontally: true,
                                              fitInsideVertically: true,
                                              tooltipBgColor: Colors.white,
                                              getTooltipItem: (groupData, int1,
                                                  rodData, int2) {
                                                return BarTooltipItem(
                                                  rodData
                                                      .rodStackItems.first.toY
                                                      .toString(),
                                                  const TextStyle(),
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
                                                  barTouchResponse.spot ==
                                                      null) {
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
                      );
                    },
                  ),
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
              future: compute(
                computeChildrenList,
                context
                    .watch<ChartViewModel>()
                    .chartModel
                    .data
                    .childrenData
                    .data,
              ),
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

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: ValueListenableBuilder(
                        valueListenable: AppNotifier.backgroundPrefDataVn,
                        builder: (_, String value, Widget? child) {
                          return Material(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(12.0),
                            color: Theme.of(context).cardColor.withOpacity(
                                  value != "" ? .5 : 1,
                                ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: "NUMBER OF CHILDREN",
                                    padding: const EdgeInsets.only(
                                      right: 16,
                                      left: 16,
                                      top: 20,
                                    ),
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
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
                                              lineChartBarData
                                                  .indexOf(tooltipsOnBar),
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
                                          touchTooltipData:
                                              LineTouchTooltipData(
                                            tooltipBgColor:
                                                const Color(0xff602bf8),
                                            tooltipRoundedRadius: 5,
                                            tooltipPadding:
                                                const EdgeInsets.all(4),
                                            getTooltipItems: (List<LineBarSpot>
                                                lineBarsSpot) {
                                              return lineBarsSpot
                                                  .map((lineBarSpot) {
                                                return LineTooltipItem(
                                                  lineBarSpot.y
                                                      .toInt()
                                                      .toString(),
                                                  const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                  ),
                                                );
                                              }).toList();
                                            },
                                          ),
                                        ),
                                        titlesData: flTileData,
                                        borderData: FlBorderData(show: false),
                                        minX: 2,
                                        maxX: (childrenDataList.length + 1)
                                            .toDouble(),
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
                        },
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            FutureBuilder(
              future: compute(
                computeYearsInMarriage,
                context
                    .watch<ChartViewModel>()
                    .chartModel
                    .data
                    .yearsInMarriageData
                    .data,
              ),
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: ValueListenableBuilder(
                          valueListenable: AppNotifier.backgroundPrefDataVn,
                          builder: (_, String value, Widget? child) {
                            return Material(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(12.0),
                              color: Theme.of(context).cardColor.withOpacity(
                                    value != "" ? .5 : 1,
                                  ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: "YEARS IN MARRIAGE",
                                    padding: const EdgeInsets.only(
                                        top: 34, right: 16, left: 16),
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 42.0, bottom: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                    map: context
                                        .watch<ChartViewModel>()
                                        .chartModel
                                        .data
                                        .yearsInMarriageData
                                        .data,
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
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            FutureBuilder(
              future: compute(
                computeOccupation,
                context
                    .watch<ChartViewModel>()
                    .chartModel
                    .data
                    .occupationData
                    .data,
              ),
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: ValueListenableBuilder(
                          valueListenable: AppNotifier.backgroundPrefDataVn,
                          builder: (_, String value, Widget? child) {
                            return Material(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(12.0),
                              color: Theme.of(context).cardColor.withOpacity(
                                    value != "" ? .5 : 1,
                                  ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: "WIDOWS TYPE OF OCCUPATION",
                                    padding: const EdgeInsets.only(
                                        top: 34, right: 16, left: 16),
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                                    ),
                                  ),
                                  CustomBarChart(
                                    typeMax: valueMax,
                                    smallWidth: 18,
                                    largeWidth: 18 + 10,
                                    map: context
                                        .watch<ChartViewModel>()
                                        .chartModel
                                        .data
                                        .occupationData
                                        .data,
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
                            );
                          },
                        ),
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

  final ParticleField cometParticles = ParticleField(
    // start out the same:
    spriteSheet: SpriteSheet(
      image: const AssetImage('assets/splash/african_woman.png'),
      frameWidth: 21,
    ),
    blendMode: BlendMode.dstIn,
    origin: Alignment.topCenter,
    // but with a different onTick handler:
    onTick: (controller, elapsed, size) {
      List<Particle> particles = controller.particles;
      // add 10 particles each tick:
      for (int i = 10; i > 0; i--) {
        particles.add(Particle(
          // assign a random blue-ish color:
          color: HSLColor.fromAHSL(1, rnd(10, 90), 1, 0.5).toColor(),
          // set a starting location:
          x: rnd(size.width / 2) * rnd.getSign(),
          y: rnd(-10, size.height),
          // add a tiny bit of initial x & y velocity
          vx: rnd(-2, 2),
          vy: rnd(-1, 1),
          // start on a random frame, with some random rotation:
          frame: rnd.getInt(0, 10000),
          rotation: rnd(pi),
          // give it a random lifespan (in ticks):
          lifespan: rnd(30, 80),
        ));
      }
      for (int i = particles.length - 1; i >= 0; i--) {
        Particle particle = particles[i];
        // calculate ratio of age vs lifespan:
        double ratio = particle.age / particle.lifespan;
        // update the particle (remember, it automatically applies vx/vy):
        particle.update(
          // accelerate, by adding to velocity y each frame:
          vy: particle.vy + 0.15,
          // update x, with some math to move toward the center:
          x: particle.x * sqrt(1 - ratio * 0.15) + particle.vx,
          // scale down as the particle approaches its lifespan:
          scale: sqrt((1 - ratio) * 4),
          // advance the spritesheet frame:
          frame: particle.frame + 1,
        );
        // remove particle if its age exceeds its lifespan:
        if (particle.age > particle.lifespan) particles.removeAt(i);
      }
    },
  );
}
