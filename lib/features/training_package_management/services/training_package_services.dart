import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mrpace/config/api_config/api_keys.dart';
import 'package:mrpace/core/utils/api_response.dart' show APIResponse;
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/models/training_package_model.dart';
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
}
