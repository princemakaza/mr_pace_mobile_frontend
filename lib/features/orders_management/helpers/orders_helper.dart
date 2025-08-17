import 'package:get/get.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:mrpace/config/routers/router.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/orders_management/controller/orders_controller.dart';
import 'package:mrpace/features/orders_management/screeens/order_success_screen.dart';
import 'package:mrpace/models/submit_order.dart';
import 'package:mrpace/widgets/loading_widgets/circular_loader.dart';
import 'package:flutter/material.dart';

class OrderHelper {
  final OrderController _orderController = Get.find();

  Future<bool> submitOrder(SubmitOrderModel model) async {
    final data = model.toMap();

    // Validation based on backend schema
    if (data['customerName'].toString().trim().isEmpty) {
      return _showError('Customer name is required');
    }
    if (data['customerEmail'].toString().trim().isEmpty) {
      return _showError('Customer email is required');
    }
    if (!GetUtils.isEmail(data['customerEmail'])) {
      return _showError('Please enter a valid email');
    }
    if (data['customerPhone'].toString().trim().isEmpty) {
      return _showError('Customer phone is required');
    }
    if (data['shippingAddress'].toString().trim().isEmpty) {
      return _showError('Shipping address is required');
    }
    if (data['products'] == null || (data['products'] as List).isEmpty) {
      return _showError('At least one product is required');
    }
    for (var product in data['products']) {
      if (product['productId'] == null ||
          product['productId'].toString().trim().isEmpty) {
        return _showError('Product ID is required for each product');
      }
      if (product['quantity'] == null || product['quantity'] < 1) {
        return _showError('Quantity must be at least 1 for each product');
      }
    }
    if (data['totalAmount'] == null || data['totalAmount'] <= 0) {
      return _showError('Total amount must be greater than 0');
    }
    if (data['paymentOption'].toString().trim().isEmpty) {
      return _showError('Payment option is required');
    }

    Get.dialog(
      const CustomLoader(message: 'Submitting order...'),
      barrierDismissible: false,
    );

    try {
      DevLogs.logInfo("Order Data: $data");

      final response = await _orderController.submitOrder(model);
      Get.back(); // Close loader

      if (response.success) {
        DevLogs.logInfo("Order: ${response.data}");
        Get.toNamed(RoutesHelper.orderSuccessScreen);
        return true;
      }
      return false;
    } catch (e) {
      Get.back();
      DevLogs.logInfo('Failed to submit order: ${e.toString()}');

      return _showError('Failed to submit order: ${e.toString()}');
    }
  }

  bool _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      backgroundColor: AppColors.primaryColor,
    );
    return false;
  }
}
