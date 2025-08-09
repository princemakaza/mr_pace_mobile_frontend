import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mrpace/config/routers/router.dart';
import 'package:mrpace/core/utils/pallete.dart'; // Import your updated palette file
import 'package:mrpace/features/welcome_page/main_screen.dart';

/// Welcome screen with introduction_screen package using AppColors
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: _buildPages(),
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: Text(
        'Skip',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.primaryColor,
        ),
      ),
      next: Icon(Icons.arrow_forward, color: AppColors.primaryColor),
      done: Text(
        'Done',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.primaryColor,
        ),
      ),
      // Dots styling
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: AppColors.borderColor,
        activeSize: const Size(22.0, 10.0),
        activeColor: AppColors.primaryColor,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      // Global styling
      globalBackgroundColor: AppColors.backgroundColor,
      skipStyle: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(AppColors.primaryColor),
      ),
      doneStyle: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(AppColors.primaryColor),
        backgroundColor: MaterialStateProperty.all(
          AppColors.primaryColor.withOpacity(0.1),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
      ),
      nextStyle: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(AppColors.primaryColor),
        backgroundColor: MaterialStateProperty.all(
          AppColors.primaryColor.withOpacity(0.1),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
      ),
    );
  }

  List<PageViewModel> _buildPages() {
    return [
      PageViewModel(
        title: "Welcome to Mr Pace!",
        body:
            "Your ultimate athletics companion! Get latest athletics news, register for races, and connect with running community.",
        image: _buildImage('assets/images/collee.png'),
        decoration: _getPageDecoration(),
      ),
      PageViewModel(
        title: "Athletics News & Updates",
        body:
            "Stay informed with latest athletics news, race results, and updates from world of running and track.",
        image: _buildImage('assets/images/wayne.png'),
        decoration: _getPageDecoration(),
      ),
      PageViewModel(
        title: "Race Registration & Training",
        body:
            "Register for upcoming races with few taps. Get personalized training programs for all levels to reach your goals.",
        image: _buildImage('assets/images/race_registration.png'),
        decoration: _getPageDecoration(),
      ),
      PageViewModel(
        title: "Sports Products Store",
        body:
            "Shop for quality sports products, running gear, and athletics equipment directly through app. Gear up for success!",
        image: _buildImage('assets/images/sport.png'),
        decoration: _getPageDecoration(),
      ),
    ];
  }

  Widget _buildImage(String assetName) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          assetName,
          height: 300.0,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  PageDecoration _getPageDecoration() {
    return PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        color: AppColors.textColor,
      ),
      bodyTextStyle: TextStyle(
        fontSize: 16.0,
        color: AppColors.subtextColor,
        height: 1.5,
      ),
      imagePadding: const EdgeInsets.all(24),
      pageColor: AppColors.backgroundColor,
      bodyPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      titlePadding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 16.0),
      contentMargin: const EdgeInsets.symmetric(horizontal: 16.0),
      imageFlex: 3,
      bodyFlex: 2,
    );
  }

  void _onIntroEnd(BuildContext context) {
    Get.offAllNamed(RoutesHelper.loginScreen);

  }
}
