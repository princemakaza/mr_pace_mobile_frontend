import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mrpace/config/api_config/api_keys.dart';
import 'package:mrpace/core/utils/api_response.dart' show APIResponse;
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/models/product_model.dart';
import '../../../core/utils/shared_pref_methods.dart';

class ProductServices {
  static Future<APIResponse<List<ProductModel>>> fetchAllProducts() async {
    final token = await CacheUtils.checkToken();

    final String url = '${ApiKeys.baseUrl}/product_route';
    final headers = {'Authorization': 'Bearer $token'};
    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      DevLogs.logInfo('Product data response: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);

        // Convert each item to ProductModel
        final List<ProductModel> products = jsonResponse
            .map((item) => ProductModel.fromMap(item as Map<String, dynamic>))
            .toList();

        return APIResponse<List<ProductModel>>(
          data: products,
          success: true,
          message: 'Products retrieved successfully',
        );
      } else {
        return APIResponse<List<ProductModel>>(
          success: false,
          message:
              'Failed to load products. HTTP Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      DevLogs.logError('Error fetching products: $e');
      return APIResponse<List<ProductModel>>(
        success: false,
        message: 'Error: $e',
      );
    }
  }
}
