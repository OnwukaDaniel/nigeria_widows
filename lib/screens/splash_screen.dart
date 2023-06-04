import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rnd/rnd.dart';

import 'landing.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<String> images = [];
  Random rand = Random(42);

  @override
  void initState() {

    Timer(
      const Duration(seconds: 3),
      () async {
        Navigator.of(context).pushReplacementNamed(Landing.id);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    for (int x = 1; x <= 5; x++) {
      images.add("assets/widow_images/profile$x.png");
    }
    int randomInteger = rand.getInt(1, 31);
    var img = images[randomInteger];
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(img, width: 150, height: 150),
            const SizedBox(height: 10),
            Text(
              "Nigerian Widows",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
