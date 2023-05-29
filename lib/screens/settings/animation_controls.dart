import 'dart:ui';
import 'package:flutter/material.dart';
import '../../sharednotifiers/app.dart';

class AnimationControls extends StatefulWidget {
  const AnimationControls({Key? key}) : super(key: key);

  @override
  State<AnimationControls> createState() => _AnimationControlsState();
}

class _AnimationControlsState extends State<AnimationControls> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).backgroundColor,
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
              title: ValueListenableBuilder(
                valueListenable: AppNotifier.toolbarTitleVn,
                builder: (_, String value, Widget? child) {
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
    );
  }
}
