import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mrpace/config/api_config/api_keys.dart';
import 'package:mrpace/core/utils/api_response.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/core/utils/shared_pref_methods.dart';

class CourseBookingService {
  static Future<APIResponse<String>> submitCourseBooking(
    String userId,
    String courseId,
    double pricePaid,
  ) async {
    final token = await CacheUtils.checkToken();

    const String url = '${ApiKeys.baseUrl}/course_bookings';
    var client = http.Client();

    final body = json.encode({
      'userId': userId,
      'courseId': courseId,
      'pricePaid': pricePaid,
    });
    DevLogs.logInfo('Submitting course booking with body: $body');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      DevLogs.logInfo('Course booking response: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);

        DevLogs.logInfo(
          'Course booking successful: ${responseData['registration_number']}',
        );
        return APIResponse<String>(
          success: true,
          data: responseData['_id'] ?? 'Course booking successful',
          message: 'Course booking submitted successfully',
        );
      } else if (response.statusCode == 400) {
        // Handle 400 Bad Request specifically
        final responseData = json.decode(response.body);
        final errorMessage = responseData['message'] ?? 'Bad Request';
        
        return APIResponse<String>(
          success: false,
          message: errorMessage, // Return the specific error message from API
        );
      } else {
        return APIResponse<String>(
          success: false,
          message: 'Course booking failed. HTTP Status: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      DevLogs.logError('Course booking error: $e');
      return APIResponse<String>(
        success: false,
        message: 'Error during course booking: $e',
      );
    } finally {
      client.close();
    }
  }
}