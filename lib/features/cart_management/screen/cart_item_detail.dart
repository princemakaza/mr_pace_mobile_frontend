import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/cart_management/controller/cart_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';


class CartItemDetailsScreen extends StatefulWidget {
  final CartItem cartItem;

  const CartItemDetailsScreen({Key? key, required this.cartItem})
      : super(key: key);

  @override
  State<CartItemDetailsScreen> createState() => _CartItemDetailsScreenState();
}

class _CartItemDetailsScreenState extends State<CartItemDetailsScreen>
    with TickerProviderStateMixin {
  int selectedImageIndex = 0;
  PageController imageController = PageController();
  bool isImageLoading = true;

  // Animation controller for the slide effect
  late AnimationController _slideController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    // Start the animation
    _slideController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar with fade animation
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: AppColors.primaryColor,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios, color: AppColors.surfaceColor),
            ),
            flexibleSpace: FadeTransition(
              opacity: _opacityAnimation,
              child: FlexibleSpaceBar(background: _buildImageCarousel()),
            ),
          ),

          // Product Info with fade animation
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProductHeader(),
                      SizedBox(height: 20),
                      _buildPriceSection(),
                      SizedBox(height: 24),
                      _buildQuantitySection(),
                      SizedBox(height: 24),
                      _buildRatingSection(),
                      SizedBox(height: 24),
                      _buildSelectedOptionsSection(),
                      SizedBox(height: 24),
                      _buildDescriptionSection(),
                      SizedBox(height: 24),
                      _buildAdditionalInfo(),
                      SizedBox(height: 100), // Space for floating button
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildBackToCartButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildImageCarousel() {
    final images = widget.cartItem.product.images ?? [];
    if (images.isEmpty) {
      return Container(
        color: AppColors.cardColor,
        child: Icon(Icons.image, size: 80, color: AppColors.subtextColor),
      );
    }

    return Stack(
      children: [
        PageView.builder(
          controller: imageController,
          onPageChanged: (index) {
            setState(() {
              selectedImageIndex = index;
            });
          },
          itemCount: images.length,
          itemBuilder: (context, index) {
            return _buildImageWithShimmer(images[index]);
          },
        ),
        if (images.length > 1)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: selectedImageIndex == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: selectedImageIndex == index
                        ? AppColors.surfaceColor
                        : AppColors.surfaceColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ).animate().scale(duration: 300.ms, curve: Curves.easeInOut),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImageWithShimmer(String imageUrl) {
    return Stack(
      children: [
        Shimmer.fromColors(
          baseColor: AppColors.cardColor,
          highlightColor: AppColors.borderColor,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.cardColor,
          ),
        ),
        Image.network(
          imageUrl,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child.animate().fadeIn(duration: 500.ms);
            }
            return SizedBox.shrink();
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppColors.cardColor,
              child: Icon(
                Icons.broken_image,
                size: 80,
                color: AppColors.subtextColor,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProductHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.cartItem.product.brand != null)
          Text(
            widget.cartItem.product.brand!,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.subtextColor,
              fontWeight: FontWeight.w500,
            ),
          ).animate().slideX(begin: -0.3, duration: 500.ms, delay: 100.ms),
        SizedBox(height: 4),
        Text(
          widget.cartItem.product.name ?? 'Product Name',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ).animate().slideX(begin: -0.3, duration: 500.ms, delay: 200.ms),
        if (widget.cartItem.product.category != null) ...[
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              widget.cartItem.product.category!,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ).animate().scale(duration: 500.ms, delay: 300.ms),
        ],
      ],
    );
  }

  Widget _buildPriceSection() {
    return Row(
      children: [
        Text(
          '\$${widget.cartItem.product.price?.toStringAsFixed(2) ?? '0.00'}',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
          ),
        ),
        if (widget.cartItem.product.regularPrice != null &&
            widget.cartItem.product.regularPrice! > (widget.cartItem.product.price ?? 0)) ...[
          SizedBox(width: 12),
          Text(
            '\$${widget.cartItem.product.regularPrice!.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.subtextColor,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.errorColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${(((widget.cartItem.product.regularPrice! - (widget.cartItem.product.price ?? 0)) / widget.cartItem.product.regularPrice!) * 100).toInt()}% OFF',
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: AppColors.surfaceColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    ).animate().slideX(begin: -0.3, duration: 500.ms, delay: 400.ms);
  }

  Widget _buildQuantitySection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Icon(
            Icons.shopping_cart,
            color: AppColors.primaryColor,
            size: 20,
          ),
          SizedBox(width: 12),
          Text(
            'Quantity in Cart:',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor,
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${widget.cartItem.quantity}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.surfaceColor,
              ),
            ),
          ),
        ],
      ),
    ).animate().slideX(begin: -0.3, duration: 500.ms, delay: 450.ms);
  }

  Widget _buildRatingSection() {
    if (widget.cartItem.product.rating == null) return SizedBox.shrink();

    return Row(
      children: [
        ...List.generate(5, (index) {
          return Icon(
            index < (widget.cartItem.product.rating ?? 0).floor()
                ? Icons.star
                : Icons.star_border,
            color: AppColors.warningColor,
            size: 20,
          );
        }),
        SizedBox(width: 8),
        Text(
          '${widget.cartItem.product.rating!.toStringAsFixed(1)}',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        if (widget.cartItem.product.stockQuantity != null) ...[
          SizedBox(width: 16),
          Text(
            '${widget.cartItem.product.stockQuantity} in stock',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: widget.cartItem.product.stockQuantity! > 0
                  ? AppColors.successColor
                  : AppColors.errorColor,
            ),
          ),
        ],
      ],
    ).animate().slideX(begin: -0.3, duration: 500.ms, delay: 500.ms);
  }

/*************  ✨ Windsurf Command ⭐  *************/
  /// Builds the section displaying the selected options like size and color for a cart item.
  /// If the selected size and color are available in the cart item, they will be shown.
  /// Otherwise, available size and color options are displayed.

/*******  f3db45fb-809c-44ce-a2f0-837f7d526423  *******/
  Widget _buildSelectedOptionsSection() {
    // This would show the selected size/color if you store that information in CartItem
    // For now, it shows available options
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.cartItem.product.sizeOptions?.isNotEmpty == true) ...[
          _buildAvailableSizes(),
          SizedBox(height: 16),
        ],
        if (widget.cartItem.product.colorOptions?.isNotEmpty == true) ...[
          _buildAvailableColors(),
          SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildAvailableSizes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Sizes',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: widget.cartItem.product.sizeOptions!.map((size) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Text(
                size,
                style: GoogleFonts.poppins(
                  color: AppColors.textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ).animate().scale(
              duration: 300.ms,
              delay: (widget.cartItem.product.sizeOptions!.indexOf(size) * 50).ms,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAvailableColors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Colors',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: widget.cartItem.product.colorOptions!.map((color) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Text(
                color,
                style: GoogleFonts.poppins(
                  color: AppColors.textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ).animate().scale(
              duration: 300.ms,
              delay: (widget.cartItem.product.colorOptions!.indexOf(color) * 50).ms,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    if (widget.cartItem.product.description == null) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        SizedBox(height: 8),
        Text(
          widget.cartItem.product.description!,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.subtextColor,
            height: 1.5,
          ),
        ),
      ],
    ).animate().slideY(begin: 0.3, duration: 500.ms, delay: 600.ms);
  }

  Widget _buildAdditionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.cartItem.product.tags?.isNotEmpty == true) ...[
          Text(
            'Tags',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.cartItem.product.tags!.map((tag) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textColor,
                  ),
                ),
              );
            }).toList(),
          ).animate().slideY(begin: 0.3, duration: 500.ms, delay: 700.ms),
        ],
      ],
    );
  }

  Widget _buildBackToCartButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.surfaceColor,
          padding: EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Back to Cart',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .slideY(begin: 1, duration: 600.ms, delay: 800.ms)
        .then()
        .shimmer(duration: 2000.ms, delay: 1500.ms);
  }

  @override
  void dispose() {
    _slideController.dispose();
    imageController.dispose();
    super.dispose();
  }
}