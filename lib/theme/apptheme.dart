import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      color: Colors.transparent,
      iconTheme: IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
    ),
    dividerColor: Colors.grey,
    shadowColor: Colors.grey.shade300,
    backgroundColor: const Color(0xfff8fcfa),
    cardColor: Colors.white,
    fontFamily: 'Rubik',
    cardTheme: const CardTheme(color: Colors.white60),
    primaryColor: const Color.fromARGB(255, 255, 255, 255),
    textTheme: const TextTheme(bodyText1: TextStyle(color: Colors.black)),
  );

  static final ThemeData darkTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      color: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    shadowColor: Colors.black87,
    dividerColor: Colors.white,
    fontFamily: 'Rubik',
    backgroundColor: Colors.black87,
    cardColor: const Color(0xff444343),
    cardTheme: const CardTheme(color: Color(0xff2f2f2f)),
    primaryColor: const Color.fromARGB(255, 255, 255, 255),
    textTheme: const TextTheme(bodyText1: TextStyle(color: Colors.white)),
  );
}
