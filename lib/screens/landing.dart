import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nigerian_widows/screens/home.dart';
import 'package:nigerian_widows/screens/home2.dart';
import 'package:nigerian_widows/screens/settings.dart';
import 'package:nigerian_widows/util/app_color.dart';
import 'package:nigerian_widows/util/app_constants.dart';

import '../reuseables/resuable_text.dart';
import '../sharednotifiers/app.dart';
import 'widows_data.dart';

class Landing extends StatefulWidget {
  static const String id = "Landing";

  const Landing({Key? key}) : super(key: key);

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ValueNotifier<int> selectedVN = ValueNotifier(0);

  List<Widget> fragments = [
    const HomeTest(),
    const WidowsData(),
    const Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return ValueListenableBuilder(
      valueListenable: AppNotifier.appTheme,
      builder: (_, ThemeData value, Widget? child) {
        return MaterialApp(
          color: Theme.of(context).backgroundColor,
          debugShowCheckedModeBanner: false,
          theme: value,
          home: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              elevation: 0,
              leading: InkWell(
                onTap: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
                child: Icon(
                  Icons.menu,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
              title: Text(
                AppConstants.appName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
            ),
            body: ValueListenableBuilder(
              valueListenable: selectedVN,
              builder: (__, int value, Widget? child) {
                return fragments[value];
              },
            ),
            drawer: Drawer(
              backgroundColor: Theme.of(context).cardColor,
              width: width / 1.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircleAvatar(
                      radius: 40,
                      child: Icon(Icons.person, size: 40),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      AppConstants.appName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                    ),
                  ),
                  const Divider(),
                  ValueListenableBuilder(
                    valueListenable: selectedVN,
                    builder: (_, int value, Widget? child) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _scaffoldKey.currentState!.closeDrawer();
                              selectedVN.value = 0;
                            },
                            child: DrawerItem(
                              text: "Home",
                              color: value == 0
                                  ? AppColor.appColor
                                  : Colors.transparent,
                              icon: Icons.home,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _scaffoldKey.currentState!.closeDrawer();
                              selectedVN.value = 1;
                              //Navigator.pushNamed(context, WidowsData.id);
                            },
                            child: DrawerItem(
                              text: "Widows Data",
                              color: value == 1
                                  ? AppColor.appColor
                                  : Colors.transparent,
                              icon: Icons.person,
                            ),
                          ),
                          const Divider(),
                          GestureDetector(
                            onTap: () {
                              _scaffoldKey.currentState!.closeDrawer();
                              selectedVN.value = 2;
                            },
                            child: DrawerItem(
                              text: "Settings",
                              color: value == 2
                                  ? AppColor.appColor
                                  : Colors.transparent,
                              icon: Icons.settings_sharp,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      _scaffoldKey.currentState!.closeDrawer();
                      exit(0);
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: RotatedBox(
                            quarterTurns: 2,
                            child: Icon(
                              Icons.exit_to_app,
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                            ),
                          ),
                        ),
                        CustomText(
                          padding: const EdgeInsets.all(16),
                          text: "Exit app",
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DrawerItem extends StatelessWidget {
  final Color color;
  final String text;
  final IconData icon;

  const DrawerItem({
    Key? key,
    required this.color,
    required this.text,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      color: color,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
              const SizedBox(width: 32),
              CustomText(
                text: text,
                style: TextStyle(
                  fontSize: 14,
                  color: color == Colors.transparent ? Theme.of(context).textTheme.bodyText1!.color : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
