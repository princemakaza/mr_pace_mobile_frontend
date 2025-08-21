import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mrpace/config/api_config/api_keys.dart';
import 'package:mrpace/core/utils/api_response.dart' show APIResponse;
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/models/coaching_course_model.dart';
import '../../../core/utils/shared_pref_methods.dart';

class CoachingCourseServices {
  static Future<APIResponse<List<CoachingCourseModel>>>
  fetchAllCoachingCourses() async {
    final token = await CacheUtils.checkToken();

    final String url = '${ApiKeys.baseUrl}/coaching_courses';
    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      DevLogs.logInfo('Coaching courses data response: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);

        // Convert each item to CoachingCourseModel
        final List<CoachingCourseModel> courses = jsonResponse
            .map(
              (item) =>
                  CoachingCourseModel.fromMap(item as Map<String, dynamic>),
            )
            .toList();

        return APIResponse<List<CoachingCourseModel>>(
          data: courses,
          success: true,
          message: 'Coaching courses retrieved successfully',
        );
      } else {
        return APIResponse<List<CoachingCourseModel>>(
          success: false,
          message:
              'Failed to load coaching courses. HTTP Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      DevLogs.logError('Error fetching coaching courses: $e');
      return APIResponse<List<CoachingCourseModel>>(
        success: false,
        message: 'Error: $e',
      );
    }
  }
}
