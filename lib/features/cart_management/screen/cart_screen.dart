import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:mrpace/config/routers/router.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/cart_management/controller/cart_controller.dart';
import 'package:mrpace/widgets/cards/cart_product_screeen.dart';

class ProductsInCartScreen extends StatelessWidget {
  const ProductsInCartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductCartController cartController =
        Get.find<ProductCartController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(cartController),
      body: GetX<ProductCartController>(
        builder: (controller) {
          if (controller.isEmpty) {
            return _buildEmptyCart();
          }

          return Column(
            children: [
              // Cart Items List
              Expanded(child: _buildCartItemsList(controller)),

              // Cart Summary and Checkout
              _buildCartSummary(controller),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ProductCartController controller) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: GetX<ProductCartController>(
        builder: (controller) => Text(
          'My Cart (${controller.totalQuantity})',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      actions: [
        GetX<ProductCartController>(
          builder: (controller) => controller.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_all, color: Colors.white),
                  onPressed: () => _showClearCartDialog(controller),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child:
          Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 120,
                    color: AppColors.subtextColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Your Cart is Empty',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Add some products to get started!',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.subtextColor,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildActionButton(
                    text: 'Start Shopping',
                    onPressed: () => Get.back(),
                    backgroundColor: AppColors.primaryColor,
                    textColor: Colors.white,
                  ),
                ],
              )
              .animate()
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.3, duration: 600.ms, curve: Curves.easeOutCubic),
    );
  }

  Widget _buildCartItemsList(ProductCartController controller) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: controller.cartItems.length,
      itemBuilder: (context, index) {
        final cartItem = controller.cartItems[index];
        return CartProductCard(
              cartItem: cartItem,
              controller: controller,
              onTap: () {
                Get.toNamed(
                  RoutesHelper.cartItemDetailsScreen,
                  arguments: cartItem,
                );
              },
            )
            .animate(delay: (index * 100).ms)
            .slideX(begin: 1, duration: 400.ms, curve: Curves.easeOutCubic);
      },
    );
  }

  Widget _buildCartSummary(ProductCartController controller) {
    return Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Total
                _buildSummaryRow(
                  'Total (${controller.totalQuantity} items)',
                  controller.formattedTotalPrice,
                  isTotal: true,
                ),

                const SizedBox(height: 24),

                // Checkout Button
                _buildCheckoutButton(controller),
              ],
            ),
          ),
        )
        .animate()
        .slideY(begin: 1, duration: 500.ms, curve: Curves.easeOutCubic)
        .fadeIn(duration: 400.ms);
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isHeader = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : (isHeader ? 16 : 14),
            fontWeight: isTotal
                ? FontWeight.bold
                : (isHeader ? FontWeight.w600 : FontWeight.w400),
            color: isTotal ? AppColors.primaryColor : AppColors.textColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : (isHeader ? 18 : 14),
            fontWeight: isTotal
                ? FontWeight.bold
                : (isHeader ? FontWeight.w600 : FontWeight.w500),
            color: isTotal ? AppColors.primaryColor : AppColors.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton(ProductCartController controller) {
    return Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                AppColors.successColor,
                AppColors.successColor.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.successColor.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _proceedToPayment(controller),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.payment, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    const Text(
                      'Proceed to Payment',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 300.ms, duration: 400.ms)
        .slideY(begin: 0.5, duration: 400.ms)
        .shimmer(
          delay: 1000.ms,
          duration: 2000.ms,
          color: Colors.white.withOpacity(0.3),
        );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color textColor,
    double height = 50,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }

  void _showClearCartDialog(ProductCartController controller) {
    Get.dialog(
      AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Clear Cart',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),
            content: const Text(
              'Are you sure you want to remove all items from your cart?',
              style: TextStyle(color: AppColors.subtextColor),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.subtextColor),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.clearCart();
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.errorColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Clear',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
          .animate()
          .scale(
            begin: const Offset(0.8, 0.8),
            duration: 200.ms,
            curve: Curves.easeOutCubic,
          )
          .fadeIn(duration: 200.ms),
    );
  }

  void _proceedToPayment(ProductCartController controller) {
    // Show a success animation before navigating
    Get.snackbar(
      'Processing',
      'Proceeding to payment...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.successColor,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.payment, color: Colors.white),
    );

    // Here you would navigate to your payment screen
    // Example: Get.toNamed('/payment');

    // For demonstration, let's show a dialog
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.dialog(
        AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 64,
                    color: AppColors.successColor,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ready for Payment!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total: ${controller.formattedTotalPrice}',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.subtextColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildActionButton(
                    text: 'Continue',
                    onPressed: () => Get.back(),
                    backgroundColor: AppColors.primaryColor,
                    textColor: Colors.white,
                  ),
                ],
              ),
            )
            .animate()
            .scale(
              begin: const Offset(0.8, 0.8),
              duration: 300.ms,
              curve: Curves.easeOutBack,
            )
            .fadeIn(duration: 300.ms),
      );
    });
  }
}
