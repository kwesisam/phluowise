import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:phluowise/contants/app_image.dart';
import 'package:phluowise/screens/onboarding.dart';
import 'package:phluowise/services/wrapper.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.fadeIn(
      animationDuration: Duration(milliseconds: 3000),
      onInit: () {
        debugPrint("On Init");
      },
      onEnd: () {
        debugPrint("On End");
      },
      childWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Image.asset(AppImages.logo)],
      ),
      onAnimationEnd: () => debugPrint("On Fade In End"),
      nextScreen: const Wrapper(),
    );
  }
}