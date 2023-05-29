import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:particle_field/particle_field.dart';
import 'package:particles_flutter/particles_flutter.dart';
import 'package:rnd/rnd.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/DataModel.dart';
import '../../sharednotifiers/app.dart';
import '../../util/app_constants.dart';

class HomePageBackground extends StatefulWidget {
  static const String id = "HomePageBackground";

  const HomePageBackground({Key? key}) : super(key: key);

  @override
  State<HomePageBackground> createState() => _HomePageBackgroundState();
}

class _HomePageBackgroundState extends State<HomePageBackground> {
  double sliderValue = 8;
  bool connectDots = true;

  getBackgroundPref() async {
    var pref = await SharedPreferences.getInstance();
    var value = pref.getString("backgroundPrefData") ?? "";
    AppNotifier.backgroundPrefDataVn.value = value;
    var decoded = decodeBackgroundFromString(value);
    if (value == "") {
      sliderValue = 8;
      connectDots = false;
    } else {
      sliderValue = decoded.backgroundColor.toDouble();
      connectDots = decoded.connectDots;
    }
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      getBackgroundPref();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, kToolbarHeight),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(32),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              backgroundColor:
                  Theme.of(context).backgroundColor.withOpacity(0.1),
              elevation: 0,
              title: Text(
                "Homepage background",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: kToolbarHeight + 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () async {
                  setBackgroundPref("");
                },
                child: ValueListenableBuilder(
                  valueListenable: AppNotifier.backgroundPrefDataVn,
                  builder: (_, String value, Widget? child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(6),
                          width: width / 3,
                          height: 220,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.menu,
                                    size: 20,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
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
                            ],
                          ),
                        ),
                        value == ""
                            ? const CircleAvatar(
                                backgroundColor: Colors.green,
                                child: Icon(Icons.check, color: Colors.white),
                              )
                            : const SizedBox(),
                      ],
                    );
                  },
                ),
              ),
              GestureDetector(
                onTap: () async {
                  showDialog(
                    barrierColor: Colors.black26.withOpacity(.5),
                    context: context,
                    builder: (BuildContext context) {
                      return BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: connectedDotsDialog(context, 1),
                      );
                    },
                  );
                },
                child: ValueListenableBuilder(
                  valueListenable: AppNotifier.backgroundPrefDataVn,
                  builder: (_, String value, Widget? child) {
                    if (value == "") {
                      return Container(
                        decoration: BoxDecoration(
                          color: AppConstants().constantsToColor(8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          children: [
                            CircularParticle(
                              isRandomColor: false,
                              width: width / 3,
                              height: 220,
                              awayRadius: width / 5,
                              numberOfParticles: 10,
                              speedOfParticles: 1.5,
                              maxParticleSize: 7,
                              particleColor: Colors.white.withOpacity(.7),
                              awayAnimationDuration: const Duration(
                                microseconds: 600,
                              ),
                              awayAnimationCurve: Curves.easeInOutBack,
                              onTapAnimation: false,
                              connectDots: true,
                              enableHover: false,
                              hoverColor: Colors.black,
                              hoverRadius: 90,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.menu,
                                    size: 20,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
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
                            Container(
                              color: Colors.transparent,
                              width: width / 3,
                              height: 220,
                            ),
                          ],
                        ),
                      );
                    }
                    BackgroundPrefData data = decodeBackgroundFromString(
                      value,
                      connectDots: true,
                    );
                    Widget tick = const SizedBox();
                    if (data.identity == 1) {
                      tick = const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.check, color: Colors.white),
                      );
                    }
                    return Container(
                      decoration: BoxDecoration(
                        color: AppConstants()
                            .constantsToColor(data.backgroundColor),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ParticleScreen(data: data, width: width / 3),
                          Positioned(
                            top: 1,
                            left: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.menu,
                                    size: 20,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
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
                          ),
                          Container(
                            color: Colors.transparent,
                            width: width / 3,
                            height: 220,
                          ),
                          tick,
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  var data = BackgroundPrefData(identity: 2);
                  setBackgroundPref(jsonEncode(data.toJson()));
                },
                child: ValueListenableBuilder(
                  valueListenable: AppNotifier.backgroundPrefDataVn,
                  builder: (_, String value, __) {
                    Widget tick = const SizedBox();
                    if (value != "") {
                      if (decodeBackgroundFromString(value).identity == 2) {
                        tick = const CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(Icons.check, color: Colors.white),
                        );
                      }
                    }
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          width: width / 3,
                          height: 220,
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
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
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
                        ),
                        tick,
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ],
      ),
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

  setBackgroundPref(String input) async {
    var pref = await SharedPreferences.getInstance();
    pref.setString("backgroundPrefData", input);
    AppNotifier.backgroundPrefDataVn.value = input;
  }

  BackgroundPrefData decodeBackgroundFromString(String input,
      {bool connectDots = true}) {
    var data = BackgroundPrefData();
    data.connectDots = connectDots;
    if (input != "") {
      data = BackgroundPrefData.fromJson(
        jsonDecode(input) as Map<String, dynamic>,
      );
    }
    return data;
  }

  connectedDotsDialog(BuildContext context, int identity) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(12),
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 130),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Material(
        color: Theme.of(context).cardColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Color Palette",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyText1!.color,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.close,
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                    ),
                  )
                ],
              ),
            ),
            ValueListenableBuilder(
              valueListenable: AppNotifier.backgroundPrefDataVn,
              builder: (_, String value, __) {
                setBackgroundPref(value);
                if (value == "") {
                  return Container(
                    padding: const EdgeInsets.all(6),
                    width: width / 3,
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        CircularParticle(
                          isRandomColor: false,
                          width: width / 3,
                          height: 220,
                          awayRadius: width / 5,
                          numberOfParticles: 100,
                          speedOfParticles: 1.5,
                          maxParticleSize: 4,
                          particleColor: Colors.white.withOpacity(.7),
                          awayAnimationDuration:
                              const Duration(microseconds: 600),
                          awayAnimationCurve: Curves.easeInOutBack,
                          onTapAnimation: false,
                          connectDots: connectDots,
                          enableHover: false,
                          hoverColor: Colors.black,
                          hoverRadius: 90,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Row(
                            children: [
                              Icon(
                                Icons.menu,
                                size: 20,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                              ),
                              Expanded(
                                child: Text(
                                  AppConstants.appName,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 9,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.transparent,
                          width: width / 3,
                          height: 220,
                        ),
                      ],
                    ),
                  );
                }

                BackgroundPrefData data = decodeBackgroundFromString(
                  value,
                  connectDots: connectDots,
                );
                return Container(
                  width: width / 3,
                  decoration: BoxDecoration(
                    color:
                        AppConstants().constantsToColor(data.backgroundColor),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      ParticleScreen(data: data, width: width / 3),
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Row(
                          children: [
                            Icon(
                              Icons.menu,
                              size: 20,
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                            ),
                            Expanded(
                              child: Text(
                                AppConstants.appName,
                                style: TextStyle(
                                  fontSize: 9,
                                  overflow: TextOverflow.ellipsis,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.transparent,
                        width: width / 3,
                        height: 220,
                      ),
                    ],
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Connect dots",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
                StatefulBuilder(
                  builder: (_, void Function(void Function()) setState) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoSwitch(
                        value: connectDots,
                        onChanged: (bool value) {
                          BackgroundPrefData data = decodeBackgroundFromString(
                            AppNotifier.backgroundPrefDataVn.value,
                          );
                          data.identity = 1;
                          data.connectDots = value;
                          setBackgroundPref(jsonEncode(data.toJson()));
                          setState(() {
                            connectDots = value;
                          });
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            ValueListenableBuilder(
              valueListenable: AppNotifier.backgroundPrefDataVn,
              builder: (_, String value, __) {
                BackgroundPrefData data = decodeBackgroundFromString(
                  value,
                );
                return GridView.builder(
                  itemCount: 8,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    var actualColorIndex = index + 1;
                    return GestureDetector(
                      onTap: () {
                        var val = AppNotifier.backgroundPrefDataVn.value;
                        if (val == "") {
                          val = jsonEncode(
                            BackgroundPrefData(
                              backgroundColor: index + 1,
                            ).toJson(),
                          );
                        } else {
                          BackgroundPrefData data = decodeBackgroundFromString(
                            val,
                          );
                          data.identity = 1;
                          data.backgroundColor = index + 1;
                          val = jsonEncode(data.toJson());
                        }
                        setBackgroundPref(val);
                      },
                      child: Container(
                        width: 5,
                        height: 5,
                        margin: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: AppConstants().constantsToColor(index + 1),
                        ),
                        child: actualColorIndex == data.backgroundColor
                            ? const Icon(Icons.check, color: Colors.white)
                            : const SizedBox(),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ParticleScreen extends StatelessWidget {
  const ParticleScreen({
    Key? key,
    required this.data,
    required this.width,
  }) : super(key: key);

  final BackgroundPrefData data;
  final double width;

  @override
  Widget build(BuildContext context) {
    return CircularParticle(
      isRandomColor: data.isRandomColor,
      width: width,
      height: 220,
      awayRadius: data.awayRadius,
      numberOfParticles: 30,
      speedOfParticles: data.speedOfParticles,
      maxParticleSize: data.maxParticleSize,
      particleColor: Colors.white.withOpacity(.7),
      awayAnimationDuration: const Duration(microseconds: 600),
      awayAnimationCurve: Curves.easeInOutBack,
      onTapAnimation: false,
      connectDots: data.connectDots,
      enableHover: false,
      hoverColor: Colors.black,
      hoverRadius: 90,
    );
  }
}
