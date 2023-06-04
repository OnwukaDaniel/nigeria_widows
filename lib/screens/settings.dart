import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nigerian_widows/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../sharednotifiers/app.dart';
import '../theme/apptheme.dart';
import 'settings/homepage_background.dart';

class Settings extends StatefulWidget {
  static const String id = "Settings";

  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      AppNotifier.toolbarTitleVn.value = "Setting";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Text(
              "Change app theme",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () async {
                    var pref = await SharedPreferences.getInstance();
                    pref.setBool("isDark", false);
                    setBackgroundPref("");
                    AppNotifier.appTheme.value = AppTheme.lightTheme;
                  },
                  child: ThemeDummy(
                    width: width,
                    theme: AppTheme.lightTheme,
                    textColor: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    var pref = await SharedPreferences.getInstance();
                    pref.setBool("isDark", true);
                    setBackgroundPref("");
                    AppNotifier.appTheme.value = AppTheme.darkTheme;
                  },
                  child: ThemeDummy(
                    width: width,
                    theme: AppTheme.darkTheme,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              "Change app background",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(),
            BackgroundChangeCard(
              text: "Homepage background",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomePageBackground(),
                  ),
                );
              },
            ),
            /*BackgroundChangeCard(
              text: "Widow's Page",
              onTap: () {},
            ),*/
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  setBackgroundPref(String input) async {
    var pref = await SharedPreferences.getInstance();
    pref.setString("backgroundPrefData", input);
    AppNotifier.backgroundPrefDataVn.value = input;
  }
}

class BackgroundChangeCard extends StatelessWidget {
  final String text;
  final Function() onTap;

  const BackgroundChangeCard({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeDummy extends StatelessWidget {
  final double width;
  final ThemeData theme;
  final Color textColor;

  const ThemeDummy({
    Key? key,
    required this.width,
    required this.theme,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          theme == AppTheme.lightTheme ? "Light" : "Dark",
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(6),
          width: width / 3,
          height: 220,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Row(
                children: [
                  Icon(
                    Icons.menu,
                    size: 20,
                    color: textColor,
                  ),
                  Text(
                    AppConstants.appName,
                    style: TextStyle(fontSize: 9, color: textColor),
                  )
                ],
              ),
              const SizedBox(height: 3),
              Container(
                margin: const EdgeInsets.all(4),
                height: 50,
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(12),
                  color: theme.cardColor,
                ),
              ),
              const SizedBox(height: 3),
              Container(
                margin: const EdgeInsets.all(4),
                height: 50,
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(12),
                  color: theme.cardColor,
                ),
              ),
              const SizedBox(height: 3),
              Container(
                margin: const EdgeInsets.all(4),
                height: 50,
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(12),
                  color: theme.cardColor,
                ),
              ),
              const SizedBox(height: 3),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(6),
          width: width / 3.5,
          height: 10,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }
}
