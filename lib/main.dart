import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nigerian_widows/screens/home2.dart';
import 'package:nigerian_widows/screens/settings/homepage_background.dart';
import 'package:nigerian_widows/screens/splash_screen.dart';
import 'package:nigerian_widows/sharednotifiers/app.dart';
import 'package:nigerian_widows/theme/apptheme.dart';
import 'package:nigerian_widows/viewmodel/chart_view_model.dart';
import 'package:nigerian_widows/viewmodel/users_view_model.dart';
import 'package:nigerian_widows/viewmodel/widows_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/DataModel.dart';
import 'screens/landing.dart';
import 'screens/settings.dart';
import 'screens/widows_data.dart';
import 'viewmodel/paging_view_model.dart';
import 'viewmodel/widow_json_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  execute() async {
    final String response = await rootBundle.loadString("assets/data.json");
    List<dynamic> j = json.decode(response);
    var data = j.map((e) => DataModel.fromJson(e as Map<String, dynamic>))
        .toList();
    data.sort((a, b) {
      var bList = b.husbandBereavementDate!
          .toLowerCase()
          .replaceAll(",", "")
          .split(" ");
      var aList = a.husbandBereavementDate!
          .toLowerCase()
          .replaceAll(",", "")
          .split(" ");
      return bList.last.compareTo(aList.last);
    });
    AppNotifier.jsonDataModelVN.value = data;
  }

  @override
  void initState() {
    //execute();
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
        ChangeNotifierProvider(create: (_) => WidowJsonViewModel()),
        ChangeNotifierProvider(create: (_) => ChartViewModel()),
        ChangeNotifierProvider(create: (_) => WidowsViewModel()),
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
              HomePageBackground.id: (ctx) => const HomePageBackground(),
            },
          );
        },
      ),
    );
  }
}
