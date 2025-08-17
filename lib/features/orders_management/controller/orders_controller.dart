import 'package:get/get.dart';
import 'package:mrpace/core/utils/api_response.dart';
import 'package:mrpace/features/orders_management/service/order_service.dart';
import 'package:mrpace/models/all_order_model.dart';
import 'package:mrpace/models/submit_order.dart';
import '../../../core/utils/logs.dart';

class OrderController extends GetxController {
  var isLoading = false.obs;
  var successMessage = ''.obs;
  var errorMessage = ''.obs;

  Future<APIResponse<String>> submitOrder(SubmitOrderModel model) async {
    try {
      isLoading(true);
      final response = await OrderService.submitOrder(model);
      if (response.success) {
        successMessage.value = response.message!;
        return response; // Return the full response
      } else {
        errorMessage.value = response.message!;
        DevLogs.logError(errorMessage.value);
        return response;
      }
    } catch (e) {
      DevLogs.logError('Error submitting order: ${e.toString()}');
      errorMessage.value =
          'An error occurred while submitting order: ${e.toString()}';
      return APIResponse<String>(success: false, message: errorMessage.value);
    } finally {
      isLoading(false);
    }
  }

  // Observable list for fetched orders
  var orders = <AllOrderModel>[].obs;
  var order = Rxn<AllOrderModel>();

  // Method to fetch orders by customer email
  Future<void> fetchOrdersByCustomerId(String customerEmail) async {
    try {
      isLoading(true); // Start loading
      final response = await OrderService.fetchOrdersByCustomerId(
        customerEmail,
      );
      if (response.success) {
        orders.value = response.data ?? [];
        successMessage.value = response.message ?? 'Orders loaded successfully';
      } else {
        errorMessage.value = response.message ?? 'Failed to fetch orders';
      }
    } catch (e) {
      DevLogs.logError('Error fetching orders: ${e.toString()}');
      errorMessage.value =
          'An error occurred while fetching orders: ${e.toString()}';
    } finally {
      isLoading(false); // End loading
    }
  }

  Future<void> refreshOrders(String customerEmail) async {
    await fetchOrdersByCustomerId(customerEmail);
  }
}
