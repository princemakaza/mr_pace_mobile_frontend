import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mrpace/config/api_config/api_keys.dart';
import 'package:mrpace/models/create_profile_model.dart';
import 'package:mrpace/core/utils/api_response.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/core/utils/shared_pref_methods.dart';
import 'package:mrpace/models/profile_model.dart'; // Ensure this includes CacheUtils

class ProfileService {
  static Future<APIResponse<String>> createProfile(
    CreateProfileModel profileModel,
  ) async {
    final token = await CacheUtils.checkToken();

    const String url = '${ApiKeys.baseUrl}/profile_route';
    var client = http.Client();

    final body = json.encode(profileModel.toMap());
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

      DevLogs.logInfo('Create profile response: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);

        DevLogs.logInfo(
          'Profile created successfully: ${responseData['profile_id']}',
        );
        return APIResponse<String>(
          success: true,
          data: 'Profile created successfully',
          message: 'Profile created successfully',
        );
      } else {
        return APIResponse<String>(
          success: false,
          message:
              'Profile creation failed. HTTP Status: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      DevLogs.logError('Profile creation error: $e');
      return APIResponse<String>(
        success: false,
        message: 'Error during profile creation: $e',
      );
    } finally {
      client.close();
    }
  }


  static Future<APIResponse<String>> updateProfile(
    ProfileModel profileModel,
  ) async {
    final token = await CacheUtils.checkToken();

    final String url = '${ApiKeys.baseUrl}/profile_route/${profileModel.id}';
    var client = http.Client();

    final body = json.encode(profileModel.toMap());
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await client.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      DevLogs.logInfo('update profile response: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);

        DevLogs.logInfo(
          'Profile updated successfully',
        );
        return APIResponse<String>(
          success: true,
          data: 'Profile updated successfully',
          message: 'Profile updated successfully',
        );
      } else {
        return APIResponse<String>(
          success: false,
          message:
              'Profile updating failed. HTTP Status: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      DevLogs.logError('Profile updating error: $e');
      return APIResponse<String>(
        success: false,
        message: 'Error during profile updating: $e',
      );
    } finally {
      client.close();
    }
  }




  static Future<APIResponse<ProfileModel>> fetchProfileByUserId(String userId) async {
  final token = await CacheUtils.checkToken();
  final String url = "${ApiKeys.baseUrl}/profile_route/user/$userId";
  final headers = {'Authorization': 'Bearer $token'};

  try {
    final response = await http.get(Uri.parse(url), headers: headers);
    DevLogs.logInfo('Profile response: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      final profile = ProfileModel.fromMap(jsonResponse);

      return APIResponse<ProfileModel>(
        data: profile,
        success: true,
        message: 'Profile retrieved successfully',
      );
    } else {
      return APIResponse<ProfileModel>(
        success: false,
        message: 'Failed to load profile. HTTP Status: ${response.statusCode}',
      );
    }
  } catch (e) {
    DevLogs.logError('Error fetching profile: $e');
    return APIResponse<ProfileModel>(
      success: false,
      message: 'Error: $e',
    );
  }
}

}
