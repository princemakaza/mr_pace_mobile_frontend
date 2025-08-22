import 'package:get/get.dart';
import 'package:mrpace/core/utils/api_response.dart';
import 'package:mrpace/features/course_booking_management/services/course_booking_services.dart';
import 'package:mrpace/models/course_booking_model.dart';
import '../../../core/utils/logs.dart';

class CourseBookingController extends GetxController {
  var isLoading = false.obs;
  var successMessage = ''.obs;
  var errorMessage = ''.obs;

  // Add these new properties for search functionality
  final RxString searchQuery = ''.obs;
  final RxString searchType = 'fullName'.obs; // 'fullName' or 'courseName'

  Future<APIResponse<String>> submitCourseBooking(
    String userId,
    String courseId,
    double pricePaid,
  ) async {
    try {
      isLoading(true);
      final response = await CourseBookingService.submitCourseBooking(
        userId,
        courseId,
        pricePaid,
      );

      if (response.success) {
        successMessage.value = response.message!;
        return response;
      } else {
        // Use the specific error message from the API response
        errorMessage.value = response.message!;
        DevLogs.logError('Course booking failed: ${response.message}');
        return response;
      }
    } catch (e) {
      DevLogs.logError('Error submitting course booking: ${e.toString()}');
      errorMessage.value =
          'An error occurred while submitting course booking: ${e.toString()}';
      return APIResponse<String>(success: false, message: errorMessage.value);
    } finally {
      isLoading(false);
    }
  }

  // Observable list for fetched course bookings
  var courseBookings = <CourseBookingModel>[].obs;
  var courseBooking = Rxn<CourseBookingModel>();

  // Method to fetch course bookings by userId
  Future<void> getCourseBookingsByUserId(String userId) async {
    try {
      isLoading(true); // Start loading
      final response = await CourseBookingService.fetchCourseBookingByUserId(
        userId,
      );
      if (response.success) {
        courseBookings.value = response.data ?? [];
        successMessage.value =
            response.message ?? 'Course bookings loaded successfully';
      } else {
        errorMessage.value = response.message!;
      }
    } catch (e) {
      DevLogs.logError('Error fetching course bookings: ${e.toString()}');
      errorMessage.value =
          'An error occurred while fetching course bookings: ${e.toString()}';
    } finally {
      isLoading(false); // End loading
    }
  }

  Future<void> refreshCourseBookings(String userId) async {
    await getCourseBookingsByUserId(userId);
  }
}
