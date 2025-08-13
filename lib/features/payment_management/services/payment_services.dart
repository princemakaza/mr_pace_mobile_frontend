import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mrpace/config/api_config/api_keys.dart';
import 'package:mrpace/core/utils/api_response.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/core/utils/shared_pref_methods.dart';

class PaymentService {
  static Future<APIResponse<String>> submitPayment({
    required String registrationNumber,
    required String phoneNumber,
  }) async {
    final token = await CacheUtils.checkToken();

    const String url =
        '${ApiKeys.baseUrl}/register/pay/ecocash'; // Adjust endpoint as needed
    var client = http.Client();

    final body = json.encode({
      "registration_number": registrationNumber,
      "phoneNumber": phoneNumber,
    });

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

      DevLogs.logInfo('Payment response: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);

        DevLogs.logInfo(
          'Payment submission successful: ${responseData['message'] ?? 'Success'}',
        );
        return APIResponse<String>(
          success: true,
          data: responseData['message'] ?? 'Payment submitted successfully',
          message: 'Payment submitted successfully',
        );
      } else {
        return APIResponse<String>(
          success: false,
          message:
              'Payment failed. HTTP Status: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      DevLogs.logError('Payment submission error: $e');
      return APIResponse<String>(
        success: false,
        message: 'Error during payment submission: $e',
      );
    } finally {
      client.close();
    }
  }

  static Future<APIResponse<Map<String, dynamic>>> checkPaymentStatus({
    required String pollUrl,
    required String id,
  }) async {
    final token = await CacheUtils.checkToken();

    const String url = '${ApiKeys.baseUrl}/register/check-payment-status';
    var client = http.Client();

    final body = json.encode({"pollUrl": pollUrl,"id":id});

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

      DevLogs.logInfo('Payment response: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);

        return APIResponse<Map<String, dynamic>>(
          success: true,
          data: {
            'status': responseData['status'] ?? '',
            'registration_number': responseData['registration_number'] ?? '',
          },
          message: responseData['message'] ?? 'Payment submitted successfully',
        );
      } else {
        return APIResponse<Map<String, dynamic>>(
          success: false,
          message:
              'Payment failed. HTTP Status: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      DevLogs.logError('Payment submission error: $e');
      return APIResponse<Map<String, dynamic>>(
        success: false,
        message: 'Error during payment submission: $e',
      );
    } finally {
      client.close();
    }
  }
}
