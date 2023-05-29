import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:particles_flutter/particles_flutter.dart';

class HomePageBackground extends StatefulWidget {
  static const String id = "HomePageBackground";

  const HomePageBackground({Key? key}) : super(key: key);

  @override
  State<HomePageBackground> createState() => _HomePageBackgroundState();
}

class _HomePageBackgroundState extends State<HomePageBackground> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
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
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: CircularParticle(
                  isRandomColor: false,
                  width: width / 2.5,
                  height: 100,
                  awayRadius: width / 5,
                  numberOfParticles: 10,
                  speedOfParticles: 1.5,
                  maxParticleSize: 7,
                  particleColor: Colors.white.withOpacity(.7),
                  awayAnimationDuration: const Duration(microseconds: 600),
                  awayAnimationCurve: Curves.easeInOutBack,
                  onTapAnimation: true,
                  connectDots: true,
                  enableHover: true,
                  hoverColor: Colors.black,
                  hoverRadius: 90,
                ),
              ),
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: CircularParticle(
                  isRandomColor: false,
                  width: width / 2.5,
                  height: 100,
                  awayRadius: 0,
                  numberOfParticles: 10,
                  speedOfParticles: 1.5,
                  maxParticleSize: 7,
                  particleColor: Colors.white.withOpacity(.6),
                  awayAnimationDuration: const Duration(microseconds: 600),
                  awayAnimationCurve: Curves.easeInOutBack,
                  onTapAnimation: false,
                  connectDots: false,
                  enableHover: false,
                  hoverColor: Colors.black,
                  hoverRadius: 90,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
