import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/cart_management/controller/cart_controller.dart'
    show ProductCartController;
import 'package:mrpace/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final double width;
  final VoidCallback? onTapNavigateToProductDetail;
  final VoidCallback? onAddToCart;  // New callback for add to cart action

  const ProductCard({
    Key? key,
    required this.product,
    this.width = 200,
    this.onTapNavigateToProductDetail,
    this.onAddToCart,  // Add this parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductCartController cartController =
        Get.find<ProductCartController>();

    return GestureDetector(
      onTap: onTapNavigateToProductDetail,
      child:
          Container(
                width: width,
                height: 280, // Fixed height to prevent overflow
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.borderColor.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: AppColors.borderColor.withOpacity(0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product Image with Hero Animation
                    Hero(
                      tag: 'product_${product.id}',
                      child: Container(
                        height: 95,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          color: AppColors.surfaceColor,
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              child:
                                  product.images != null &&
                                      product.images!.isNotEmpty
                                  ? Image.network(
                                      product.images!.first,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              color: AppColors.borderColor
                                                  .withOpacity(0.1),
                                              child: const Icon(
                                                Icons
                                                    .image_not_supported_rounded,
                                                color: AppColors.subtextColor,
                                                size: 32,
                                              ),
                                            );
                                          },
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Shimmer.fromColors(
                                              baseColor: AppColors.borderColor
                                                  .withOpacity(0.1),
                                              highlightColor: AppColors
                                                  .borderColor
                                                  .withOpacity(0.05),
                                              child: Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: AppColors.borderColor
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(16),
                                                        topRight:
                                                            Radius.circular(16),
                                                      ),
                                                ),
                                              ),
                                            );
                                          },
                                    )
                                  : Container(
                                      color: AppColors.borderColor.withOpacity(
                                        0.1,
                                      ),
                                      child: const Icon(
                                        Icons.image_rounded,
                                        color: AppColors.subtextColor,
                                        size: 32,
                                      ),
                                    ),
                            ),

                            // Discount Badge
                            if (product.regularPrice != null &&
                                product.regularPrice! > (product.price ?? 0))
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.errorColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${(((product.regularPrice! - (product.price ?? 0)) / product.regularPrice!) * 100).round()}% OFF',
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ).animate().scale(
                                delay: 200.ms,
                                duration: 300.ms,
                              ),
                          ],
                        ),
                      ),
                    ),

                    // Product Details - Using Flexible to prevent overflow
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Brand
                            if (product.brand != null)
                              Text(
                                product.brand!.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.subtextColor.withOpacity(
                                    0.8,
                                  ),
                                  letterSpacing: 0.5,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ).animate().slideX(
                                delay: 100.ms,
                                duration: 400.ms,
                              ),

                            if (product.brand != null)
                              const SizedBox(height: 2),

                            // Product Name
                            Text(
                              product.name ?? 'Unknown Product',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textColor,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ).animate().slideY(delay: 150.ms, duration: 400.ms),

                            const SizedBox(height: 4),

                            // Rating and Reviews
                            if (product.rating != null)
                              Row(
                                children: [
                                  ...List.generate(5, (index) {
                                    return Icon(
                                      index < (product.rating ?? 0).floor()
                                          ? Icons.star_rounded
                                          : Icons.star_outline_rounded,
                                      color: AppColors.warningColor,
                                      size: 12,
                                    );
                                  }),
                                  const SizedBox(width: 4),
                                  Text(
                                    product.rating!.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.subtextColor,
                                    ),
                                  ),
                                ],
                              ).animate().slideX(
                                delay: 200.ms,
                                duration: 400.ms,
                              ),

                            const SizedBox(height: 6),

                            // Price Section
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                if (product.regularPrice != null &&
                                    product.regularPrice! >
                                        (product.price ?? 0))
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 4,
                                      bottom: 1,
                                    ),
                                    child: Text(
                                      '\$${product.regularPrice!.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        decoration: TextDecoration.lineThrough,
                                        color: AppColors.subtextColor
                                            .withOpacity(0.6),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                              ],
                            ).animate().slideY(delay: 250.ms, duration: 400.ms),

                            const SizedBox(height: 8),

                            // Add to Cart Button
                            SizedBox(
                                  width: double.infinity,
                                  height: 32,
                                  child: ElevatedButton(
                                    onPressed: onAddToCart,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryColor,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_shopping_cart_rounded,
                                          size: 14,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Add to Cart',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .animate()
                                .slideY(delay: 300.ms, duration: 400.ms)
                                .then()
                                .shimmer(delay: 1000.ms, duration: 800.ms),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .scale(
                delay: (50 * (product.id?.hashCode.abs() ?? 0) % 300).ms,
                duration: 600.ms,
                curve: Curves.elasticOut,
              )
              .fadeIn(delay: (50 * (product.id?.hashCode.abs() ?? 0) % 200).ms),
    );
  }
}
