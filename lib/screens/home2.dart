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

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SizedBox(),
    );
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
