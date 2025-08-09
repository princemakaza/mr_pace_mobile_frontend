import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrpace/config/routers/router.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';

import '../../../widgets/custom_animations/fade_in_animation.dart';

class PaymentSuccess extends StatefulWidget {
  final String phoneNumber;

  const PaymentSuccess({super.key, required this.phoneNumber});

  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  int countdown = 45;
  Timer? timer;
  final TextEditingController pinController = TextEditingController();
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
      } else {
        timer.cancel();
        // Show timeout message
        Get.snackbar(
          'Payment Timeout',
          'Payment session has expired. Please try again.',
          backgroundColor: AppColors.warningColor,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    });
  }

  void processPayment() {
    if (pinController.text.length < 4) {
      Get.snackbar(
        'Invalid PIN',
        'Please enter a valid EcoCash PIN',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    setState(() {
      isProcessing = true;
    });

    // Simulate payment processing
    Future.delayed(const Duration(seconds: 3), () {
      timer?.cancel();
      setState(() {
        isProcessing = false;
      });

      Get.snackbar(
        'Payment Successful',
        'Your payment has been processed successfully!',
        backgroundColor: AppColors.successColor,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: Icon(Icons.check_circle, color: Colors.white),
      );

      // Navigate back after showing success message
      Future.delayed(const Duration(seconds: 2), () {
        Get.back();
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            color: CupertinoColors.white.withOpacity(0.1),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.textColor,
                    ),
                  ),
                  Text(
                    'Payment',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),

            // EcoCash Icon
            Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Icon(
                      Icons.payment,
                      size: 60,
                      color: AppColors.primaryColor,
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 200.ms, duration: 600.ms)
                .scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1.0, 1.0),
                ),

            const SizedBox(height: 25),

            // Payment Initiated Message
            Text(
                  'Payment Initiated',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                )
                .animate()
                .fadeIn(delay: 400.ms, duration: 600.ms)
                .slideY(begin: 30, end: 0, duration: 600.ms),

            const SizedBox(height: 10),

            // Phone Number Display
            Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryColor, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Payment initiated to',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppColors.subtextColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.phoneNumber,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Please enter your EcoCash PIN to complete the payment',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColor,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(delay: 600.ms, duration: 600.ms)
                .slideY(begin: 50, end: 0, duration: 600.ms),

            const SizedBox(height: 30),

            // Countdown Timer
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: countdown <= 10
                    ? AppColors.warningColor.withOpacity(0.1)
                    : AppColors.successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: countdown <= 10
                      ? AppColors.warningColor
                      : AppColors.successColor,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timer,
                    color: countdown <= 10
                        ? AppColors.warningColor
                        : AppColors.successColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Session expires in: ${countdown}s',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: countdown <= 10
                          ? AppColors.warningColor
                          : AppColors.successColor,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 800.ms, duration: 400.ms),

            const SizedBox(height: 16),

            // Cancel Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(RoutesHelper.main_home_page);
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.subtextColor, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      "Back to Home",
                      style: GoogleFonts.poppins(
                        color: AppColors.subtextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 1400.ms, duration: 500.ms),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
