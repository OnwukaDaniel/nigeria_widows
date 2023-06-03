import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:particle_field/particle_field.dart';
import 'package:particles_flutter/particles_flutter.dart';
import 'package:rnd/rnd.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/DataModel.dart';
import '../sharednotifiers/app.dart';
import '../util/app_constants.dart';
import 'home/home_consumer.dart';

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
      body: Stack(
        children: [
          ValueListenableBuilder(
            valueListenable: AppNotifier.backgroundPrefDataVn,
            builder: (_, String value, Widget? child) {
              if (value == "") return const SizedBox();
              BackgroundPrefData data = decodeBackgroundFromString(value);

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
          HomeConsumer(),
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
}
