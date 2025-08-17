import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mrpace/config/api_config/api_keys.dart';
import 'package:mrpace/models/all_order_model.dart';
import 'package:mrpace/models/submit_order.dart';
import 'package:mrpace/core/utils/api_response.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/core/utils/shared_pref_methods.dart'; // Ensure this includes CacheUtils

class OrderService {
  static Future<APIResponse<String>> submitOrder(
    SubmitOrderModel orderModel,
  ) async {
    final token = await CacheUtils.checkToken();

    const String url = '${ApiKeys.baseUrl}/order_product_route';
    var client = http.Client();

    final body = json.encode(orderModel.toMap());
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

      DevLogs.logInfo('Order response: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);

        DevLogs.logInfo('Order successful');
        return APIResponse<String>(
          success: true,
          data: 'Order submitted successfully',
          message: 'Order submitted successfully',
        );
      } else {
        return APIResponse<String>(
          success: false,
          message:
              'Order failed. HTTP Status: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      DevLogs.logError('Order error: $e');
      return APIResponse<String>(
        success: false,
        message: 'Error during order submission: $e',
      );
    } finally {
      client.close();
    }
  }

  static Future<APIResponse<List<AllOrderModel>>> fetchOrdersByCustomerId(
    String customerEmail,
  ) async {
    final token = await CacheUtils.checkToken();
    final String url =
        "${ApiKeys.baseUrl}/order_product_route/customer/$customerEmail";
    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      DevLogs.logInfo('Orders response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true &&
            jsonResponse.containsKey('orders')) {
          final List<dynamic> ordersList = jsonResponse['orders'] ?? [];

          final List<AllOrderModel> orders = ordersList
              .map(
                (item) => AllOrderModel.fromMap(item as Map<String, dynamic>),
              )
              .toList();

          return APIResponse<List<AllOrderModel>>(
            data: orders,
            success: true,
            message: 'Orders retrieved successfully',
          );
        } else {
          return APIResponse<List<AllOrderModel>>(
            success: false,
            message: 'No orders found for this customer.',
          );
        }
      } else {
        return APIResponse<List<AllOrderModel>>(
          success: false,
          message: 'Failed to load orders. HTTP Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      DevLogs.logError('Error fetching orders: $e');
      return APIResponse<List<AllOrderModel>>(
        success: false,
        message: 'Error: $e',
      );
    }
  }
}
