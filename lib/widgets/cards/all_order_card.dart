import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/models/all_order_model.dart';

class OrderCard extends StatelessWidget {
  final AllOrderModel order;
  final int index;
  final VoidCallback? onTapToViewOrderDetails;
  final VoidCallback? onTapToCheckoutOrder;

  const OrderCard({
    Key? key,
    required this.order,
    required this.index,
    this.onTapToViewOrderDetails,
    this.onTapToCheckoutOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.primaryColor,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTapToViewOrderDetails ?? () => _showOrderDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImage(),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductInfo(),
                    const SizedBox(height: 10),
                    _buildOrderDetails(),
                    const Divider(height: 20, thickness: 0.6, color: AppColors.borderColor),
                    _buildBottomRow(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate()
        .fadeIn(duration: 300.ms, delay: Duration(milliseconds: index * 100))
        .scale(begin: const Offset(0.98, 0.98), end: const Offset(1, 1));
  }

  Widget _buildProductImage() {
    final imageUrl = order.products?.isNotEmpty == true &&
            order.products!.first.productId?.images?.isNotEmpty == true
        ? order.products!.first.productId!.images!.first
        : null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 70,
        height: 70,
        color: AppColors.borderColor.withOpacity(0.2),
        child: imageUrl != null
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryColor,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image_not_supported,
                    color: AppColors.subtextColor,
                    size: 28,
                  );
                },
              )
            : const Icon(
                Icons.shopping_bag_outlined,
                color: AppColors.subtextColor,
                size: 28,
              ),
      ),
    );
  }

  Widget _buildProductInfo() {
    final productName = order.products?.isNotEmpty == true
        ? order.products!.first.name ?? 'Product Name'
        : 'Product Name';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          productName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 3),
        Text(
          'Order ID: ${order.id?.substring(0, 10) ?? 'Unknown'}',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.subtextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '\$${order.totalAmount?.toStringAsFixed(2) ?? '0.00'}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        Text(
          _formatDate(order.createdAt),
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.subtextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildOutlinedButton(
            "Details", 
            onTapToViewOrderDetails ?? () => _showOrderDetails(context)
          )
        ),
        const SizedBox(width: 10),
        Expanded(child: _buildFilledButton(context)),
      ],
    );
  }

  Widget _buildOutlinedButton(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryColor, width: 1.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildFilledButton(BuildContext context) {
    String buttonText;
    VoidCallback? onPressed;

    switch (order.paymentStatus?.toLowerCase()) {
      case 'delivered':
      case 'completed':
        buttonText = 'Complete';
        onPressed = () => _leaveReview(context);
        break;
      case 'pending':
        if (order.pollUrl == "not available") {
          buttonText = 'Checkout';
          onPressed = onTapToCheckoutOrder ?? () => _makePayment(context);
        } else {
          buttonText = 'Track Order';
          onPressed = () => _trackOrder(context);
        }
        break;
      case 'sent':
      case 'awaiting_delivery':
        buttonText = 'Track Order';
        onPressed = () => _trackOrder(context);
        break;
      default:
        buttonText = 'View Order';
        onPressed = onTapToViewOrderDetails ?? () => _showOrderDetails(context);
    }

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.surfaceColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown date';
    final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final day = date.day;
    final month = months[date.month];
    final hour = date.hour;
    final minute = date.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$day $month, $displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  void _makePayment(BuildContext context) {
    Get.snackbar('Payment', 'Redirecting to payment gateway...',
        backgroundColor: AppColors.primaryColor,
        colorText: AppColors.surfaceColor,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8);
  }

  void _trackOrder(BuildContext context) {
    Get.snackbar('Track Order', 'Opening order tracking...',
        backgroundColor: AppColors.primaryColor,
        colorText: AppColors.surfaceColor,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8);
  }

  void _leaveReview(BuildContext context) {
    Get.snackbar('Review', 'Opening review page...',
        backgroundColor: AppColors.secondaryColor,
        colorText: AppColors.surfaceColor,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8);
  }

  void _showOrderDetails(BuildContext context) {
    Get.snackbar('Order Details', 'Opening order details...',
        backgroundColor: AppColors.primaryColor,
        colorText: AppColors.surfaceColor,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8);
  }
}

extension StringExtension on String {
  String get capitalize => '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
}