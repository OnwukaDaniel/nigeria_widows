import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nigerian_widows/screens/wodows_page/widow_landing_top.dart';
import 'package:nigerian_widows/screens/wodows_page/widows_landing_bottom_navigation.dart';

class WidowsLanding extends ConsumerWidget {
  const WidowsLanding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: const [WidowLandingTop(), WidowLandingBottomNavigation()],
      ),
    );
  }
}