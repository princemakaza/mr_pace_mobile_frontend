import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mrpace/config/api_config/api_keys.dart';
import 'package:mrpace/models/all_races_model.dart';
import 'package:mrpace/models/registration_model.dart';
import 'package:mrpace/models/submit_registration_model.dart';
import 'package:mrpace/core/utils/api_response.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/core/utils/shared_pref_methods.dart'; // Ensure this includes CacheUtils

class RegistrationService {
  static Future<APIResponse<String>> submitRaceRegistration(
    SubmitRegistrationModel registrationModel,
  ) async {
    final token = await CacheUtils.checkToken();

    const String url = '${ApiKeys.baseUrl}/register/register';
    var client = http.Client();

    final body = json.encode(registrationModel.toMap());
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

      DevLogs.logInfo('Registration response: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);

        DevLogs.logInfo(
          'Registration successful: ${responseData['registration_number']}',
        );
        return APIResponse<String>(
          success: true,
          data:
              responseData['registration_number'] ?? 'Registration successful',
          message: 'Registration submitted successfully',
        );
      } else {
        return APIResponse<String>(
          success: false,
          message:
              'Registration failed. HTTP Status: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      DevLogs.logError('Registration error: $e');
      return APIResponse<String>(
        success: false,
        message: 'Error during registration: $e',
      );
    } finally {
      client.close();
    }
  }

  static Future<APIResponse<List<RegistrationModel>>>
  fetchRegisteredRacesByUserId(String userId) async {
    final token = await CacheUtils.checkToken();
    final String url = "${ApiKeys.baseUrl}/register/athletes/user/$userId";
    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      DevLogs.logInfo('Registered races response: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);

        final List<RegistrationModel> registrations = jsonResponse
            .map(
              (item) => RegistrationModel.fromMap(item as Map<String, dynamic>),
            )
            .toList();

        return APIResponse<List<RegistrationModel>>(
          data: registrations,
          success: true,
          message: 'Registered races retrieved successfully',
        );
      } else {
        return APIResponse<List<RegistrationModel>>(
          success: false,
          message:
              'Failed to load registered races. HTTP Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      DevLogs.logError('Error fetching registered races: $e');
      return APIResponse<List<RegistrationModel>>(
        success: false,
        message: 'Error: $e',
      );
    }
  }
}
