import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nigerian_widows/reuseables/pie_indicators.dart';
import 'package:nigerian_widows/reuseables/resuable_text.dart';

class CustomPieGraph extends StatefulWidget {
  final CustomText legendText;
  final CustomText centerText;
  final double centerSpaceRadius;
  final double smallRadius;
  final double largeRadius;
  final Map<String, int> map;
  final List<Color> sectionColor;

  const CustomPieGraph({
    Key? key,
    required this.smallRadius,
    required this.largeRadius,
    required this.sectionColor,
    this.legendText = const CustomText(
      text: '',
    ),
    this.centerText = const CustomText(
      text: '',
    ),
    this.centerSpaceRadius = 0.0,
    this.map = const {},
  }) : super(key: key);

  @override
  State<CustomPieGraph> createState() => _CustomPieGraphState();
}

class _CustomPieGraphState extends State<CustomPieGraph> {
  int touchedIndex = -1;
  double radius = 0;
  bool isTouched = false;
  List<PieChartSectionData> sectionsData = [];
  List<PieIndicators> indicatorList = [];

  final List<Color> empColor = [
    const Color(0xFF723EFF),
    const Color(0xFFDC950A),
    const Color(0xFF3EBFF6),
    const Color(0xFFFDE567),
    const Color(0xFF039CDD),
    const Color(0xFF000000),
  ];

  @override
  void initState() {
    var countEmp = 0;

    for (String x in widget.map.keys) {
      indicatorList.add(
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
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    int width = MediaQuery.of(context).size.width.toInt();
    sectionsData.clear();
    radius = width / 8;

    var countNgo = 0;
    for (String x in widget.map.keys) {
      var sectionValue = (widget.map[x]!.toDouble() / widget.map.length) * 360;
      if (countNgo == touchedIndex) {
        radius = widget.largeRadius;
      } else {
        radius = widget.smallRadius;
      }
      sectionsData.add(PieChartSectionData(
        color: widget.sectionColor[countNgo],
        showTitle: false,
        value: sectionValue,
        radius: radius,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xffffffff),
        ),
      ));
      countNgo++;
    }

    return Material(
      elevation: 10,
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.legendText,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: SizedBox(
                  width: width.toDouble(),
                  height: 350,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(child: widget.centerText),
                      PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          centerSpaceRadius: widget.centerSpaceRadius,
                          startDegreeOffset: 180,
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 1,
                          sections: sectionsData,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: indicatorList,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
