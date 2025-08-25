import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mrpace/config/api_config/api_keys.dart';
import 'package:mrpace/core/utils/api_response.dart' show APIResponse;
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/models/training_bought_package_model.dart';
import 'package:mrpace/models/training_package_model.dart';
import 'package:mrpace/models/training_package_response.dart';
import '../../../core/utils/shared_pref_methods.dart';

class TrainingPackagesService {
  static Future<APIResponse<List<TrainingProgramPackage>>>
  fetchAllTrainingPackages() async {
    final token = await CacheUtils.checkToken();

    final String url =
        '${ApiKeys.baseUrl}/training_program_packages'; // Updated URL
    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      DevLogs.logInfo('Training program packages response: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);

        // Convert each item to TrainingProgramPackage model
        final List<TrainingProgramPackage> packages = jsonResponse
            .map(
              (item) =>
                  TrainingProgramPackage.fromMap(item as Map<String, dynamic>),
            )
            .toList();

        return APIResponse<List<TrainingProgramPackage>>(
          data: packages,
          success: true,
          message: 'Training packages retrieved successfully',
        );
      } else {
        return APIResponse<List<TrainingProgramPackage>>(
          success: false,
          message:
              'Failed to load training packages. HTTP Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      DevLogs.logError('Error fetching training packages: $e');
      return APIResponse<List<TrainingProgramPackage>>(
        success: false,
        message: 'Error: $e',
      );
    }
  }
  static Future<APIResponse<TrainingPackageResponseModel>> createTrainingBought(
    String userId,
    String trainingProgramPackageId,
    double pricePaid,
  ) async {
    final token = await CacheUtils.checkToken();

    const String url = '${ApiKeys.baseUrl}/training_packages_bought';
    var client = http.Client();

    final body = json.encode({
      'userId': userId,
      'training_program_package_id': trainingProgramPackageId,
      'pricePaid': pricePaid,
    });
    DevLogs.logInfo('Submitting training package purchase with body: $body');

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

      DevLogs.logInfo('Training package response: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = TrainingPackageResponseModel.fromJson(
          response.body,
        );

        DevLogs.logInfo(
          'Training package purchase successful: ${responseData.id}',
        );
        return APIResponse<TrainingPackageResponseModel>(
          success: true,
          data: responseData,
          message: 'Training package bought successfully',
        );
      } else if (response.statusCode == 400) {
        // Handle 400 Bad Request specifically
        final responseData = json.decode(response.body);
        final errorMessage = responseData['message'] ?? 'Bad Request';

        return APIResponse<TrainingPackageResponseModel>(
          success: false,
          message: errorMessage,
        );
      } else {
        return APIResponse<TrainingPackageResponseModel>(
          success: false,
          message:
              'Training package purchase failed. HTTP Status: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      DevLogs.logError('Training package purchase error: $e');
      return APIResponse<TrainingPackageResponseModel>(
        success: false,
        message: 'Error during training package purchase: $e',
      );
    } finally {
      client.close();
    }
  }


  /// ✅ Fetch training packages bought by a specific user
  static Future<APIResponse<List<TrainingPackageBoughtModel>>>
      fetchTrainingProgramBoughtByUser(String userId) async {
    final token = await CacheUtils.checkToken();

    final String url =
        '${ApiKeys.baseUrl}/training_packages_bought/user/$userId'; // Your API endpoint
    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      DevLogs.logInfo('Training packages bought response: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);

        final List<TrainingPackageBoughtModel> boughtPackages = jsonResponse
            .map((item) =>
                TrainingPackageBoughtModel.fromMap(item as Map<String, dynamic>))
            .toList();

        return APIResponse<List<TrainingPackageBoughtModel>>(
          data: boughtPackages,
          success: true,
          message: 'Training packages bought retrieved successfully',
        );
      } else {
        return APIResponse<List<TrainingPackageBoughtModel>>(
          success: false,
          message:
              'Failed to load training packages bought. HTTP Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      DevLogs.logError('Error fetching training packages bought: $e');
      return APIResponse<List<TrainingPackageBoughtModel>>(
        success: false,
        message: 'Error: $e',
      );
    }
  }
}
