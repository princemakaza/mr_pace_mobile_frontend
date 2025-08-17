import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mrpace/config/api_config/api_keys.dart';
import 'package:mrpace/core/utils/api_response.dart' show APIResponse;
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/models/sports_news_model.dart';
import '../../../core/utils/shared_pref_methods.dart';

class SportNewsService {
  static Future<APIResponse<List<SportNewsModel>>> fetchAllSportsNews() async {
    final token = await CacheUtils.checkToken();

    final String url = '${ApiKeys.baseUrl}/sports_news_route';
    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      DevLogs.logInfo('Sports news response: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);

        // Convert each item to SportNewsModel (update model later if you have a SportsNewsModel)
        final List<SportNewsModel> sportsNews = jsonResponse
            .map((item) => SportNewsModel.fromMap(item as Map<String, dynamic>))
            .toList();

        return APIResponse<List<SportNewsModel>>(
          data: sportsNews,
          success: true,
          message: 'Sports news retrieved successfully',
        );
      } else {
        return APIResponse<List<SportNewsModel>>(
          success: false,
          message:
              'Failed to load sports news. HTTP Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      DevLogs.logError('Error fetching sports news: $e');
      return APIResponse<List<SportNewsModel>>(
        success: false,
        message: 'Error: $e',
      );
    }
  }
}
