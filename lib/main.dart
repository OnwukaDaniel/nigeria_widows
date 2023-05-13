import 'package:flutter/material.dart';
import 'package:nigerian_widows/screens/home.dart';
import 'package:nigerian_widows/screens/splash_screen.dart';
import 'package:nigerian_widows/sharednotifiers/app.dart';
import 'package:nigerian_widows/theme/apptheme.dart';
import 'package:nigerian_widows/viewmodel/users_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/WidowProfile.dart';
import 'screens/landing.dart';
import 'screens/settings.dart';
import 'screens/widows_data.dart';
import 'viewmodel/paging_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    getPref();
  }

  Future<void> getPref() async {
    var pref = await SharedPreferences.getInstance();
    bool isDark = pref.getBool("isDark") == null? false : pref.getBool
      ("isDark")!;
    AppNotifier.appTheme.value =
        isDark == true ? AppTheme.darkTheme : AppTheme.lightTheme;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsersViewModel()),
        ChangeNotifierProvider(create: (_) => PagingViewModel()),
      ],
      child: ValueListenableBuilder(
        valueListenable: AppNotifier.appTheme,
        builder: (BuildContext context, ThemeData value, Widget? child) {
          return MaterialApp(
            title: 'Nigerian Widows',
            debugShowCheckedModeBanner: false,
            theme: value,
            home: const SplashScreen(),
            routes: {
              Home.id: (ctx) => const Home(),
              Settings.id: (ctx) => const Settings(),
              Landing.id: (ctx) => const Landing(),
              WidowsData.id: (ctx) => const WidowsData(),
            },
          );
        },
      ),
    );
  }
}
