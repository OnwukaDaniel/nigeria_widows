import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  static const String id = "Settings";
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          "Settings",
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
        ),
      ),
    );
  }
}
