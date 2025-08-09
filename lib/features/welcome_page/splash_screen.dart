import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:mrpace/core/constants/image_asset_constants.dart';
import 'package:mrpace/features/welcome_page/welcome_page.dart' show WelcomeScreen;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
      splash: LocalImageConstants.mrpaceLogo,
      splashIconSize: 100,
      screenFunction: () async {
        return const WelcomeScreen();
      },
      splashTransition: SplashTransition.rotationTransition,
    );
  }
}