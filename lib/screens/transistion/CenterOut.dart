import 'package:flutter/material.dart';

class CenterOut extends PageRouteBuilder {
  final Widget page;

  CenterOut({required this.page}) : super(
      pageBuilder: (context, animation, anotherAnimation) => page,
      transitionDuration: const Duration(milliseconds: 700),
      reverseTransitionDuration: const Duration(milliseconds: 700),
      transitionsBuilder: (context, animation, anotherAnimation, child) {
        animation = CurvedAnimation(parent: animation,
            curve: Curves.fastOutSlowIn,
            reverseCurve: Curves.fastOutSlowIn);
        return Align(
          alignment: Alignment.center,
          child: SizeTransition(
            axis: Axis.horizontal,
            sizeFactor: animation,
            axisAlignment: 0,
            child: page,
          ),
        );
      }
  );
}
