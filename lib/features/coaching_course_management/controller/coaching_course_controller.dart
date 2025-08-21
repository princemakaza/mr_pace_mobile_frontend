import 'package:get/get.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/features/coaching_course_management/service/coaching_course_service.dart';
import 'package:mrpace/models/coaching_course_model.dart';

class CoachingCourseController extends GetxController {
  var isLoading = false.obs;
  var successMessage = ''.obs;
  var errorMessage = ''.obs;

  // Observable list for fetched coaching courses
  var coachingCourses = <CoachingCourseModel>[].obs;
  var coachingCourse = Rxn<CoachingCourseModel>();

  // Method to fetch all coaching courses
  Future<void> getAllCoachingCourses() async {
    try {
      isLoading(true); // Start loading
      final response = await CoachingCourseServices.fetchAllCoachingCourses();
      if (response.success) {
        coachingCourses.value = response.data ?? [];
        successMessage.value = response.message ?? 'Coaching courses loaded successfully';
      } else {
        errorMessage.value = response.message!;
      }
    } catch (e) {
      DevLogs.logError('Error fetching coaching courses: ${e.toString()}');
      errorMessage.value =
          'An error occurred while fetching coaching courses: ${e.toString()}';
    } finally {
      isLoading(false); // End loading
    }
  }

  Future<void> refreshCoachingCourses() async {
    await getAllCoachingCourses();
  }
}
