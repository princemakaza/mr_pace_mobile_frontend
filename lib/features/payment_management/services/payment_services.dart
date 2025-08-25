import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mrpace/config/api_config/api_keys.dart';
import 'package:mrpace/core/utils/api_response.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/core/utils/shared_pref_methods.dart';
import 'package:mrpace/models/check_status_training_payment.dart';

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

    final body = json.encode({"pollUrl": pollUrl, "id": id});

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

  static Future<APIResponse<String>> submitOrderPayment({
    required String orderId,
    required String phoneNumber,
  }) async {
    final token = await CacheUtils.checkToken();

    const String url =
        '${ApiKeys.baseUrl}/order_product_route/pay/ecocash'; // Adjust endpoint as needed
    var client = http.Client();

    final body = json.encode({"orderId": orderId, "phoneNumber": phoneNumber});

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

  /// Checks the status of a payment order
  ///
  /// Returns the payment order status and registration number if the payment is successful.
  /// Returns an error message otherwise.
  ///
  /// The [pollUrl] parameter is the URL to poll for payment order status.
  /// The [orderId] parameter is the ID of the order.
  static Future<String> checkPaymentOrderStatus({
    required String pollUrl,
    required String orderId,
  }) async {
    // Get the user token
    final token = await CacheUtils.checkToken();

    // Define the URL to check payment order status
    const String url = '${ApiKeys.baseUrl}/order_product_route/check-payment';
    var client = http.Client();

    // Construct the request body
    final body = json.encode({"pollUrl": pollUrl, "orderId": orderId});

    // Define the request headers
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      // Send the request and get the response
      final response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      // Log the response body
      DevLogs.logInfo('Payment response: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);

        // Return the payment order status and registration number
        return 'Payment submitted successfully';
      } else {
        // Return an error message if the payment failed
        DevLogs.logError(
          'Payment failed. HTTP Status: ${response.statusCode} - ${response.reasonPhrase}',
        );
        return 'Payment failed. HTTP Status: ${response.statusCode} - ${response.reasonPhrase}';
      }
    } catch (e) {
      // Return an error message if there was an error during the payment submission
      DevLogs.logError('Payment submission error: $e');
      return 'Error during payment submission: $e';
    } finally {
      // Close the HTTP client
      client.close();
    }
  }

  static Future<String> checkCoursePaymentStatus({
    required String pollUrl,
    required String courseBookingId,
  }) async {
    // Get the user token
    final token = await CacheUtils.checkToken();

    // Define the URL to check payment order status
    const String url = '${ApiKeys.baseUrl}/course_bookings/payment/status';
    var client = http.Client();

    // Construct the request body
    final body = json.encode({
      "pollUrl": pollUrl,
      "bookingId": courseBookingId,
    });

    // Define the request headers
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      // Send the request and get the response
      final response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      // Log the response body
      DevLogs.logInfo('Payment response: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);

        // Return the payment order status and registration number
        return 'Payment submitted successfully';
      } else {
        // Return an error message if the payment failed
        DevLogs.logError(
          'Payment failed. HTTP Status: ${response.statusCode} - ${response.reasonPhrase}',
        );
        return 'Payment failed. HTTP Status: ${response.statusCode} - ${response.reasonPhrase}';
      }
    } catch (e) {
      // Return an error message if there was an error during the payment submission
      DevLogs.logError('Payment submission error: $e');
      return 'Error during payment submission: $e';
    } finally {
      // Close the HTTP client
      client.close();
    }
  }

  static Future<APIResponse<String>> submitCoursebookingPayment({
    required String courseBookingId,
    required String phoneNumber,
  }) async {
    final token = await CacheUtils.checkToken();

    const String url =
        '${ApiKeys.baseUrl}/course_bookings/payment/ecocash'; // Adjust endpoint as needed
    var client = http.Client();

    final body = json.encode({
      "bookingId": courseBookingId,
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

      DevLogs.logInfo('Course booking payment response: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);

        DevLogs.logInfo(
          'Course booking payment submission successful: ${responseData['message'] ?? 'Success'}',
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
      DevLogs.logError('Course booking payment submission error: $e');
      return APIResponse<String>(
        success: false,
        message: 'Error during payment submission: $e',
      );
    } finally {
      client.close();
    }
  }

  static Future<APIResponse<String>> submitTrainingPacakagePayment({
    required String purchaseId,
    required String phoneNumber,
  }) async {
    final token = await CacheUtils.checkToken();

    const String url =
        '${ApiKeys.baseUrl}/training_packages_bought/pay/ecocash'; // Adjust endpoint as needed
    var client = http.Client();

    final body = json.encode({
      "purchaseId": purchaseId,
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

      DevLogs.logInfo('Course booking payment response: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);

        DevLogs.logInfo(
          'Course booking payment submission successful: ${responseData['message'] ?? 'Success'}',
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
      DevLogs.logError('Course booking payment submission error: $e');
      return APIResponse<String>(
        success: false,
        message: 'Error during payment submission: $e',
      );
    } finally {
      client.close();
    }
  }

  static Future<CheckStatusTrainingPaymentModel>
  checkTrainingPackageModelPaymentStatus({
    required String pollUrl,
    required String training_package_bought,
  }) async {
    // Get the user token
    final token = await CacheUtils.checkToken();

    // Define the URL to check payment order status
    const String url =
        '${ApiKeys.baseUrl}/training_packages_bought/check-payment';
    var client = http.Client();

    // Construct the request body
    final body = json.encode({
      "pollUrl": pollUrl,
      "id": training_package_bought,
    });

    // Define the request headers
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      // Send the request and get the response
      final response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      DevLogs.logInfo('Payment response: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Parse response body into the model
        return CheckStatusTrainingPaymentModel.fromJson(response.body);
      } else {
        DevLogs.logError(
          'Payment failed. HTTP Status: ${response.statusCode} - ${response.reasonPhrase}',
        );
        // Return a model with failure details
        return CheckStatusTrainingPaymentModel(
          status: 'error',
          message:
              'Payment failed. HTTP Status: ${response.statusCode} - ${response.reasonPhrase}',
          purchaseId: null,
          pollUrl: null,
        );
      }
    } catch (e) {
      DevLogs.logError('Payment submission error: $e');
      // Return a model indicating an error occurred
      return CheckStatusTrainingPaymentModel(
        status: 'error',
        message: 'Error during payment submission: $e',
        purchaseId: null,
        pollUrl: null,
      );
    } finally {
      client.close();
    }
  }
}
