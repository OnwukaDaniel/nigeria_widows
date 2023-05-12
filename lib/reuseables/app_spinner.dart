import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../util/app_color.dart';

class Spinner extends StatelessWidget {
  final double size;
  const Spinner({Key? key, this.size = 30}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCube(color: AppColor.appColor, size: size);
  }
}
