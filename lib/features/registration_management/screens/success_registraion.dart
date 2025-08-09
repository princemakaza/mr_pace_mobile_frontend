import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mrpace/features/payment_management/screens/payment_registration.dart';

import '../../../widgets/custom_animations/fade_in_animation.dart';

class RaceRegistrationSuccess extends StatefulWidget {
  final String raceName;
  final String raceEvent;
  final String registrationPrice;
  final String registration_number;
  const RaceRegistrationSuccess({
    super.key,
    required this.raceName,
    required this.raceEvent,
    required this.registrationPrice,
    required this.registration_number,
  });

  @override
  State<RaceRegistrationSuccess> createState() =>
      _RaceRegistrationSuccessState();
}

class _RaceRegistrationSuccessState extends State<RaceRegistrationSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            color: CupertinoColors.white.withOpacity(0.1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),

            // Success Icon
            Center(
              child: Container(
                height: 170,
                width: 170,
                child: Image.asset(
                  'assets/icons/succes.png',
                  color: AppColors.primaryColor,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Success Message
            Text(
                  'Your Race Registration has been \n submitted successfully!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                    height: 1.21,
                    color: AppColors.textColor,
                  ),
                )
                .animate()
                .fadeIn(delay: 400.ms, duration: 600.ms)
                .slideY(
                  begin: 30,
                  end: 0,
                  duration: 600.ms,
                  curve: Curves.easeOutBack,
                ),

            const SizedBox(height: 10),

            // Race Details Card
            Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Registration Details',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.7),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 1.21,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Race Name
                        Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.cardColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.3,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Race Name',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.subtextColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.raceName,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      color: AppColors.primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 1000.ms, duration: 400.ms)
                            .slideX(begin: -50, end: 0, duration: 400.ms),

                        const SizedBox(height: 12),

                        // Race Event
                        Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.cardColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.3,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Race Event',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.subtextColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.raceEvent,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      color: AppColors.primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 1200.ms, duration: 400.ms)
                            .slideX(begin: 50, end: 0, duration: 400.ms),

                        const SizedBox(height: 12),

                        // Registration Price
                        Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.cardColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.3,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Registration Price',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.subtextColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$ ${widget.registrationPrice}',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      color: AppColors.primaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 1400.ms, duration: 400.ms)
                            .slideX(begin: -50, end: 0, duration: 400.ms)
                            .then()
                            .animate(
                              onComplete: (controller) => controller.repeat(),
                            )
                            .shimmer(
                              duration: 2000.ms,
                              color: AppColors.primaryColor.withOpacity(0.2),
                            ),
                      ],
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 800.ms, duration: 600.ms)
                .slideY(
                  begin: 50,
                  end: 0,
                  duration: 600.ms,
                  curve: Curves.easeOutBack,
                ),

            const SizedBox(height: 20),

            // Payment Instructions
            Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.warningColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.warningColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                            Icons.payment,
                            color: AppColors.warningColor,
                            size: 40,
                          )
                          .animate(onPlay: (controller) => controller.repeat())
                          .shake(duration: 1000.ms, hz: 2)
                          .then()
                          .animate()
                          .scale(
                            begin: const Offset(1.0, 1.0),
                            end: const Offset(1.1, 1.1),
                            duration: 1000.ms,
                          )
                          .then()
                          .scale(
                            begin: const Offset(1.1, 1.1),
                            end: const Offset(1.0, 1.0),
                            duration: 1000.ms,
                          ),

                      const SizedBox(height: 12),

                      Text(
                        'Complete Your Payment',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Please proceed to payment using EcoCash to \n complete your race registration',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.subtextColor,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(delay: 1600.ms, duration: 500.ms)
                .slideY(begin: 30, end: 0, duration: 500.ms)
                .then()
                .animate(onComplete: (controller) => controller.repeat())
                .shimmer(
                  duration: 3000.ms,
                  color: AppColors.warningColor.withOpacity(0.1),
                ),

            const SizedBox(height: 30),

            // Process Payment Button
            FadeInAnimation(
                  delay: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16, left: 16),
                    child: GestureDetector(
                      onTap: () {
                        // Add payment processing logic here
                        Get.dialog(
                          PayRegistration(
                            registrationPrice: widget.registrationPrice,
                            registration_number: widget.registration_number,
                            raceName: widget.raceName,
                          ),
                        );

                        // You can navigate to payment screen or show payment options
                        // For now, just show a snackbar
                        Get.snackbar(
                          'Payment',
                          'Redirecting to EcoCash payment...',
                          backgroundColor: AppColors.primaryColor,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.successColor,
                          borderRadius: BorderRadius.circular(9),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.successColor.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.credit_card,
                                color: Colors.white,
                                size: 20,
                              ),

                              const SizedBox(width: 8),

                              Text(
                                "Process Payment",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 1800.ms, duration: 600.ms)
                .slideY(begin: 30, end: 0, duration: 600.ms)
                .then()
                .animate(onComplete: (controller) => controller.repeat())
                .shimmer(
                  duration: 2500.ms,
                  color: Colors.white.withOpacity(0.3),
                ),

            const SizedBox(height: 16),

            // Back to Home Button
            Padding(
                  padding: const EdgeInsets.only(right: 16, left: 16),
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      print("Back to home button tapped");
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Back to Home",
                          style: GoogleFonts.poppins(
                            color: AppColors.primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 2000.ms, duration: 500.ms)
                .slideY(begin: 20, end: 0, duration: 500.ms),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
