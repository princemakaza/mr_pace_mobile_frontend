
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mrpace/config/api_config/api_keys.dart';
import 'package:mrpace/core/utils/api_response.dart' show APIResponse;
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/models/all_races_model.dart';
import '../../../core/utils/shared_pref_methods.dart';
class RaceServices {
  static Future<APIResponse<List<AllRacesModel>>> fetchAllRaces() async {
    final token = await CacheUtils.checkToken();

    final String url = '${ApiKeys.baseUrl}/races';
    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      DevLogs.logInfo('Race data response: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);

        // Convert each item to AllRacesModel
        final List<AllRacesModel> races = jsonResponse
            .map((item) => AllRacesModel.fromMap(item as Map<String, dynamic>))
            .toList();

        return APIResponse<List<AllRacesModel>>(
          data: races,
          success: true,
          message: 'Races retrieved successfully',
        );
      } else {
        return APIResponse<List<AllRacesModel>>(
          success: false,
          message:
              'Failed to load races. HTTP Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      DevLogs.logError('Error fetching races: $e');
      return APIResponse<List<AllRacesModel>>(
        success: false,
        message: 'Error: $e',
      );
    }
  }

}
