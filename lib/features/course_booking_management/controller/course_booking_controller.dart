import 'package:get/get.dart';
import 'package:mrpace/core/utils/api_response.dart';
import 'package:mrpace/features/course_booking_management/services/course_booking_services.dart';
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
}
