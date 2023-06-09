import 'package:flutter/material.dart';

class HeroImageDetailScreen extends StatelessWidget {
  final String image;

  const HeroImageDetailScreen({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'heroImage',
          child: Image.asset(
            image,
            width: width,
            height: height,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
