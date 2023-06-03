import 'dart:io';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:nigerian_widows/screens/home2.dart';
import 'package:nigerian_widows/screens/settings.dart';
import 'package:nigerian_widows/screens/widows_landing.dart';
import 'package:nigerian_widows/util/app_color.dart';
import 'package:nigerian_widows/util/app_constants.dart';

import '../reuseables/resuable_text.dart';
import '../sharednotifiers/app.dart';

class Landing extends StatefulWidget {
  static const String id = "Landing";

  const Landing({Key? key}) : super(key: key);

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ValueNotifier<int> selectedVN = ValueNotifier(0);
  int backStackCount = 0;

  List<Widget> fragments = [
    const Home(),
    const WidowsLanding(),
    const Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return ValueListenableBuilder(
      valueListenable: AppNotifier.appTheme,
      builder: (_, ThemeData theme, Widget? child) {
        return WillPopScope(
          onWillPop: () {
            if (backStackCount == 0) {
              selectedVN.value = 0;
              return Future<bool>.value(true);
            } else {
              backStackCount = 0;
              selectedVN.value = 0;
              return Future<bool>.value(false);
            }
          },
          child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Theme.of(context).backgroundColor,
            key: _scaffoldKey,
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
                    leading: InkWell(
                      onTap: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      child: Icon(
                        Icons.menu,
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                    ),
                    title: ValueListenableBuilder(
                      valueListenable: AppNotifier.toolbarTitleVn,
                      builder: (_, String value, Widget? child) {
                        if (value == "Loading ...") {
                          Duration speed = const Duration(milliseconds: 100);
                          return Row(
                            children: [
                              Text(
                                "Loading ",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                child: DefaultTextStyle(
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                    fontSize: 20,
                                    fontFamily: 'Agne',
                                  ),
                                  child: AnimatedTextKit(
                                    repeatForever: true,
                                    pause: speed,
                                    animatedTexts: [
                                      TyperAnimatedText('.', speed: speed),
                                      TyperAnimatedText('..', speed: speed),
                                      TyperAnimatedText('...', speed: speed),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return Text(
                          value,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            body: ValueListenableBuilder(
              valueListenable: selectedVN,
              builder: (__, int value, Widget? child) {
                return fragments[value];
              },
            ),
            drawer: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(32),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Drawer(
                  backgroundColor: Theme.of(context).cardColor.withOpacity(0.7),
                  width: width / 1.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: kToolbarHeight / 2),
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
                                  backStackCount = 0;
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
                                  backStackCount = 1;
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
                                  backStackCount = 1;
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
                          backStackCount = 0;
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
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                ),
                              ),
                            ),
                            CustomText(
                              padding: const EdgeInsets.all(16),
                              text: "Exit app",
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
                  color: color == Colors.transparent
                      ? Theme.of(context).textTheme.bodyText1!.color
                      : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
