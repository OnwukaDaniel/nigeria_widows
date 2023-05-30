import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nigerian_widows/reuseables/pie_indicators.dart';
import 'package:nigerian_widows/reuseables/resuable_text.dart';

import '../models/HomePageData.dart';
import '../sharednotifiers/app.dart';

class CustomPieGraph extends StatefulWidget {
  final CustomText legendText;
  final CustomText centerText;
  final double centerSpaceRadius;
  final double smallRadius;
  final double largeRadius;
  final List<BaseLocalGovtData> map;
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
    this.map = const [],
  }) : super(key: key);

  @override
  State<CustomPieGraph> createState() => _CustomPieGraphState();
}

class _CustomPieGraphState extends State<CustomPieGraph> {
  ValueNotifier<List<PieIndicators>> indicatorListVn = ValueNotifier([]);
  int touchedIndex = -1;
  double radius = 0;
  bool isTouched = false;
  List<PieChartSectionData> sectionsData = [];
  List<PieIndicators> indicatorList = [];

  @override
  void dispose() {
    indicatorListVn.dispose();
    super.dispose();
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) => _getIndicators(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int width = MediaQuery.of(context).size.width.toInt();
    sectionsData.clear();
    radius = width / 8;

    var countNgo = 0;
    for (BaseLocalGovtData x in widget.map) {
      var sectionValue = (x.value.toDouble() / widget.map.length) * 360;
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
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyText1!.color,
        ),
      ));
      countNgo++;
    }

    return ValueListenableBuilder(
      valueListenable: AppNotifier.backgroundPrefDataVn,
      builder: (BuildContext context, String value, Widget? child) {
        return Container(
          decoration:   BoxDecoration(
            boxShadow: [
              value == "" ? BoxShadow(
                offset: const Offset(1, 1),
                color: Theme.of(context).shadowColor,
                spreadRadius:1,
                blurRadius: 35,
              ): const BoxShadow(color: Colors.transparent),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Material(
                elevation: 50,
                color: Theme.of(context).cardColor.withOpacity(
                  value != "" ? .5 : 1,
                ),
                borderRadius: BorderRadius.circular(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.legendText.text == ""
                        ? const SizedBox()
                        : widget.legendText,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 4,
                          child: SizedBox(
                            height: 220,
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
                                          if (!event
                                              .isInterestedForInteractions ||
                                              pieTouchResponse == null ||
                                              pieTouchResponse.touchedSection ==
                                                  null) {
                                            touchedIndex = -1;
                                            return;
                                          }
                                          touchedIndex = pieTouchResponse
                                              .touchedSection!
                                              .touchedSectionIndex;
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
                        ValueListenableBuilder(
                          valueListenable: indicatorListVn,
                          builder: (_, List<PieIndicators> indicatorList, __) {
                            if (indicatorList.isEmpty) {
                              return const SizedBox();
                            }
                            return Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: indicatorList,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ),
          ),
        );
      },
    );
  }

  _getIndicators() {
    var countEmp = 0;
    for (BaseLocalGovtData x in widget.map) {
      indicatorList.add(
        PieIndicators(
          textWidget: Text(
            x.title,
            style: TextStyle(
              fontSize: 12,
              overflow: TextOverflow.clip,
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
          ),
          color: widget.sectionColor[countEmp],
        ),
      );
      countEmp++;
    }
    indicatorListVn.value = indicatorList;
  }
}
