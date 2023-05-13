import 'package:flutter/material.dart';
import 'package:nigerian_widows/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../sharednotifiers/app.dart';
import '../theme/apptheme.dart';

class Settings extends StatefulWidget {
  static const String id = "Settings";

  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          "Settings",
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
        ),
      ),
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
