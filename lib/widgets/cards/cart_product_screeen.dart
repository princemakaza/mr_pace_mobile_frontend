import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/cart_management/controller/cart_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartProductCard extends StatelessWidget {
  final CartItem cartItem;
  final ProductCartController controller;
  final VoidCallback? onTap;

  const CartProductCard({
    Key? key,
    required this.cartItem,
    required this.controller,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = cartItem.product;

    return GestureDetector(
      onTap: onTap,
      child:
          Container(
                height: 110, // Fixed height as requested
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Product Image
                      _buildProductImage(),

                      // Product Details
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12), // Reduced padding
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // Product Name
                              _buildProductName(),

                              const SizedBox(height: 4), // Reduced spacing
                              // Product Price
                              _buildProductPrice(),

                              const Spacer(),

                              // Quantity Controls
                              _buildQuantityControls(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .animate()
              .slideX(begin: 1, duration: 600.ms, curve: Curves.easeOutBack)
              .fadeIn(duration: 400.ms)
              .shimmer(
                delay: 200.ms,
                duration: 800.ms,
                color: AppColors.primaryColor.withOpacity(0.3),
              ),
    );
  }

  Widget _buildProductImage() {
    return Container(
          width: 100, // Reduced width to fit better
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            border: Border(
              right: BorderSide(
                color: AppColors.borderColor.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          child: cartItem.product.images?.isNotEmpty == true
              ? CachedNetworkImage(
                  imageUrl: cartItem.product.images!.first,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => _buildImageShimmer(),
                  errorWidget: (context, url, error) =>
                      _buildImagePlaceholder(),
                )
              : _buildImagePlaceholder(),
        )
        .animate()
        .fadeIn(delay: 100.ms, duration: 500.ms)
        .scale(
          begin: const Offset(0.8, 0.8),
          duration: 500.ms,
          curve: Curves.easeOutBack,
        );
  }

  Widget _buildImageShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.borderColor,
      highlightColor: AppColors.surfaceColor,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.borderColor,
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.cardColor,
          child: Icon(
            Icons.image_outlined,
            size: 32, // Smaller icon
            color: AppColors.subtextColor,
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms)
        .scale(
          begin: const Offset(0.5, 0.5),
          duration: 400.ms,
          curve: Curves.bounceOut,
        );
  }

  Widget _buildProductName() {
    return Text(
          cartItem.product.name ?? 'Unknown Product',
          style: const TextStyle(
            fontSize: 14, // Reduced from 16
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
            height: 1.1, // Reduced line height
          ),
          maxLines: 1, // Reduced to 1 line to prevent overflow
          overflow: TextOverflow.ellipsis,
        )
        .animate()
        .fadeIn(delay: 200.ms, duration: 400.ms)
        .slideY(begin: 0.5, duration: 400.ms, curve: Curves.easeOutCubic)
        .then()
        .shimmer(
          delay: 300.ms,
          duration: 1000.ms,
          color: AppColors.primaryColor.withOpacity(0.2),
        );
  }

  Widget _buildProductPrice() {
    return Row(
          mainAxisSize: MainAxisSize.min, // Prevent overflow
          children: [
            Flexible(
              child: Text(
                '\$ ${(cartItem.product.price ?? 0).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 13, // Reduced from 15
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6), // Reduced spacing
            if (cartItem.product.regularPrice != null &&
                cartItem.product.regularPrice! > (cartItem.product.price ?? 0))
              Flexible(
                child: Text(
                  '\$ ${cartItem.product.regularPrice!.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 11, // Reduced from 13
                    decoration: TextDecoration.lineThrough,
                    color: AppColors.subtextColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        )
        .animate()
        .fadeIn(delay: 300.ms, duration: 400.ms)
        .slideY(begin: 0.5, duration: 400.ms, curve: Curves.easeOutCubic)
        .then()
        .animate(onPlay: (controller) => controller.repeat())
        .tint(color: AppColors.primaryColor, duration: 2000.ms);
  }

  Widget _buildQuantityControls() {
    return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Decrease Button
            _buildQuantityButton(
              icon: Icons.remove,
              onTap: () => controller.decreaseQuantity(cartItem.product),
              color: AppColors.errorColor,
            ),

            // Quantity Display
            Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ), // Reduced margin
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ), // Reduced padding
                  constraints: const BoxConstraints(
                    minWidth: 30,
                  ), // Reduced width
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      6,
                    ), // Smaller border radius
                    border: Border.all(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${cartItem.quantity}',
                    style: const TextStyle(
                      fontSize: 12, // Reduced from 14
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
                .animate()
                .fadeIn(delay: 500.ms, duration: 300.ms)
                .scale(
                  begin: const Offset(0.5, 0.5),
                  duration: 400.ms,
                  curve: Curves.bounceOut,
                )
                .then()
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .scaleXY(end: 1.1, duration: 1500.ms, curve: Curves.easeInOut),

            // Increase Button
            _buildQuantityButton(
              icon: Icons.add,
              onTap: () => controller.increaseQuantity(cartItem.product),
              color: AppColors.successColor,
            ),

            const SizedBox(width: 8), // Reduced spacing
            // Remove Button
            _buildRemoveButton(),
          ],
        )
        .animate()
        .fadeIn(delay: 600.ms, duration: 400.ms)
        .slideX(begin: 0.5, duration: 500.ms, curve: Curves.easeOutBack);
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
          onTap: onTap,
          child: Container(
            width: 28, // Reduced from 32
            height: 28, // Reduced from 32
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6), // Smaller border radius
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 16), // Reduced from 18
          ),
        )
        .animate()
        .fadeIn(delay: 500.ms, duration: 300.ms)
        .scale(
          begin: const Offset(0.6, 0.6),
          duration: 400.ms,
          curve: Curves.elasticOut,
        )
        .then()
        .animate(target: 1)
        .scaleXY(
          begin: 1.0,
          end: 0.95,
          duration: 100.ms,
          curve: Curves.easeInOut,
        )
        .then()
        .scaleXY(
          begin: 0.95,
          end: 1.0,
          duration: 100.ms,
          curve: Curves.easeInOut,
        );
  }

  Widget _buildRemoveButton() {
    return GestureDetector(
          onTap: () => controller.removeFromCart(cartItem.product),
          child: Container(
            padding: const EdgeInsets.all(4), // Reduced padding
            decoration: BoxDecoration(
              color: AppColors.errorColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6), // Smaller border radius
              border: Border.all(
                color: AppColors.errorColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.delete_outline,
              color: AppColors.errorColor,
              size: 16, // Reduced from 18
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 700.ms, duration: 400.ms)
        .scale(
          begin: const Offset(0.5, 0.5),
          duration: 500.ms,
          curve: Curves.elasticOut,
        )
        .then()
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .rotate(begin: 0, end: 0.1, duration: 2000.ms, curve: Curves.easeInOut);
  }
}
