import 'package:flutter/material.dart';
import 'package:nigerian_widows/screens/home.dart';
import 'package:nigerian_widows/screens/splash_screen.dart';
import 'package:nigerian_widows/sharednotifiers/app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppNotifier.appTheme,
      builder: (BuildContext context, ThemeData value, Widget? child) {
        return MaterialApp(
          title: 'Nigerian Widows',
          debugShowCheckedModeBanner: false,
          theme: value,
          home: const SplashScreen(),
          routes: {
            Home.id: (ctx) => const Home(),
          },
        );
      },
    );
  }
}