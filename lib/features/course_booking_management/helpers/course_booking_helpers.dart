import 'package:get/get.dart';
import 'package:mrpace/config/routers/router.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/course_booking_management/controller/course_booking_controller.dart';
import 'package:mrpace/features/course_booking_management/screens/course_booking_success_screen.dart';
import 'package:mrpace/widgets/loading_widgets/circular_loader.dart';
import 'package:flutter/material.dart';

class CourseBookingRegister {
  final CourseBookingController _courseBookingController = Get.find();

  Future<bool> submitCourseBooking(
    String userId,
    String courseId,
    double pricePaid, {
    String? courseName,
  }) async {
    Get.dialog(
      const CustomLoader(message: 'Submitting course booking...'),
      barrierDismissible: false,
    );

    try {
      DevLogs("userId: $userId");
      DevLogs("courseId: $courseId");
      DevLogs("pricePaid: $pricePaid");

      final response = await _courseBookingController.submitCourseBooking(
        userId,
        courseId,
        pricePaid,
      );
      Get.back(); // Close loader
      DevLogs.logInfo("Response: ${response.toString()}");

      if (response.success) {
        DevLogs.logInfo(
          "Course booking successful: " + response.data.toString(),
        );
        Get.toNamed(
          RoutesHelper.coachingCourseBookingSuccess,
          arguments: {
            'courseName': courseName,
            'bookingPrice': pricePaid.toString(),
            'courseBookingId': response.data ?? "",
          },
        );
        return true;
      } else {
        // Handle specific error messages from API
        if (response.message?.toLowerCase().contains('already booked') ==
            true) {
          _showInfo('Course Booking', 'You have already booked this course');
        } else {
          _showError(
            'Course Booking Failed',
            response.message ?? 'Unknown error occurred',
          );
        }
        return false;
      }
    } catch (e) {
      Get.back();
      _showError('Error', 'Failed to submit course booking: ${e.toString()}');
      return false;
    }
  }

  bool _showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.red,
    );
    return false;
  }

  bool _showInfo(String title, String message) {
    Get.snackbar(
      title,
      message,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      backgroundColor: AppColors.primaryColor,
    );
    return false;
  }
}
