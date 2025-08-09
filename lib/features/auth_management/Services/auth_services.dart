import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mrpace/config/api_config/api_keys.dart' show ApiKeys;
import 'package:mrpace/core/utils/api_response.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/core/utils/shared_pref_methods.dart';

class AuthServices {
  static Future<APIResponse<String>> login({
    required String emailAddress,
    required String password,
  }) async {
    var headers = {'Content-Type': 'application/json'};

    var request = http.Request(
      'POST',
      Uri.parse('${ApiKeys.baseUrl}/user_route/login'),
    );

    request.body = json.encode({"email": emailAddress, "password": password});

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseData = json.decode(await response.stream.bytesToString());

        final token = responseData['token'];
        final user = responseData['user'];

        // Cache the token
        await CacheUtils.storeToken(token: "$token");

        DevLogs.logSuccess(
          'Login successful. Token: $token, User: ${user['email']}',
        );

        return APIResponse(
          success: true,
          message: 'Login successful',
          data: token,
        );
      } else {
        final errorData = json.decode(await response.stream.bytesToString());
        final errorMessage = errorData['message'] ?? 'Login failed';

        print('Error: $errorMessage');

        return APIResponse(success: false, message: errorMessage, data: null);
      }
    } catch (e) {
      print('An error occurred: $e');

      return APIResponse(
        success: false,
        message: 'An error occurred: $e',
        data: null,
      );
    }
  }
}
