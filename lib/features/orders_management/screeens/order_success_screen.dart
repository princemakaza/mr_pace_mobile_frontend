import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrpace/config/routers/router.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../widgets/custom_animations/fade_in_animation.dart';


class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({super.key});

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            color: CupertinoColors.white.withOpacity(0.1),
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
                  'Your order has been placed successfully!',
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

            const SizedBox(height: 40),

            // Go to My Orders Button
            FadeInAnimation(
                  delay: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(RoutesHelper.allOrdersScreen);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(9),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Go to My Orders",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 800.ms, duration: 500.ms)
                .slideY(begin: 20, end: 0, duration: 500.ms),

            const SizedBox(height: 16),

            // Go to Home Button
            Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onTap: () {
                      Get.offAllNamed(RoutesHelper.main_home_page);
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
                          "Go to Home",
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
                .fadeIn(delay: 1000.ms, duration: 500.ms)
                .slideY(begin: 20, end: 0, duration: 500.ms),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
