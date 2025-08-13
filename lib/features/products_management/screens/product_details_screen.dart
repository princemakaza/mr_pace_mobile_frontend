import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:mrpace/config/routers/router.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/cart_management/controller/cart_controller.dart';
import 'package:mrpace/models/product_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({Key? key, required this.product})
    : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  int selectedImageIndex = 0;
  String? selectedSize;
  String? selectedColor;
  PageController imageController = PageController();
  bool isImageLoading = true;
  final ProductCartController cartController =
      Get.find<ProductCartController>();

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

    // Set default selections
    if (widget.product.sizeOptions?.isNotEmpty == true) {
      selectedSize = widget.product.sizeOptions!.first;
    }
    if (widget.product.colorOptions?.isNotEmpty == true) {
      selectedColor = widget.product.colorOptions!.first;
    }
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
            actions: [
          
              _buildCartIcon(),
          
            ],
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
                      _buildRatingSection(),
                      SizedBox(height: 24),
                      _buildOptionsSection(),
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
      floatingActionButton: _buildAddToCartButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildCartIcon() {
    return Obx(
      () {
        try {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: Icon(
                  Icons.shopping_cart_rounded,
                  color: AppColors.surfaceColor,
                  size: 24,
                ),
                onPressed: () {
                 Get.toNamed(RoutesHelper.cartScreen);
                },
              ),
              Positioned(
                right: 1,
                top: 3,
                child: cartController == null
                    ? SizedBox.shrink()
                    : _buildCartBadge(cartController.totalQuantity),
              ),
            ],
          );
        } catch (e) {
          return Text(
            'Error: $e',
            style: TextStyle(color: Colors.red),
          );
        }
      },
    );
  }

  Widget _buildCartBadge(int itemCount) {
    if (itemCount <= 0) return SizedBox.shrink();

    return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.bounceOut,
          padding: const EdgeInsets.all(4),
          constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
          decoration: BoxDecoration(
            color: AppColors.errorColor,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.errorColor.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            itemCount > 99 ? '99+' : itemCount.toString(),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        )
        .animate()
        .scale(delay: 100.ms, duration: 300.ms, curve: Curves.bounceOut)
        .then()
        .shimmer(
          delay: 500.ms,
          duration: 800.ms,
          color: Colors.white.withOpacity(0.5),
        );
  }

  Widget _buildImageCarousel() {
    final images = widget.product.images ?? [];
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
        if (widget.product.brand != null)
          Text(
            widget.product.brand!,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.subtextColor,
              fontWeight: FontWeight.w500,
            ),
          ).animate().slideX(begin: -0.3, duration: 500.ms, delay: 100.ms),
        SizedBox(height: 4),
        Text(
          widget.product.name ?? 'Product Name',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ).animate().slideX(begin: -0.3, duration: 500.ms, delay: 200.ms),
        if (widget.product.category != null) ...[
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              widget.product.category!,
              style: GoogleFonts.poppins(
                fontSize: 12,
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
          '\$${widget.product.price?.toStringAsFixed(2) ?? '0.00'}',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
          ),
        ),
        if (widget.product.regularPrice != null &&
            widget.product.regularPrice! > (widget.product.price ?? 0)) ...[
          SizedBox(width: 12),
          Text(
            '\$${widget.product.regularPrice!.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: 18,
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
              '${(((widget.product.regularPrice! - (widget.product.price ?? 0)) / widget.product.regularPrice!) * 100).toInt()}% OFF',
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

  Widget _buildRatingSection() {
    if (widget.product.rating == null) return SizedBox.shrink();

    return Row(
      children: [
        ...List.generate(5, (index) {
          return Icon(
            index < (widget.product.rating ?? 0).floor()
                ? Icons.star
                : Icons.star_border,
            color: AppColors.warningColor,
            size: 20,
          );
        }),
        SizedBox(width: 8),
        Text(
          '${widget.product.rating!.toStringAsFixed(1)}',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        if (widget.product.stockQuantity != null) ...[
          SizedBox(width: 16),
          Text(
            '${widget.product.stockQuantity} in stock',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: widget.product.stockQuantity! > 0
                  ? AppColors.successColor
                  : AppColors.errorColor,
            ),
          ),
        ],
      ],
    ).animate().slideX(begin: -0.3, duration: 500.ms, delay: 500.ms);
  }

  Widget _buildOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.product.sizeOptions?.isNotEmpty == true) ...[
          _buildSizeOptions(),
          SizedBox(height: 16),
        ],
        if (widget.product.colorOptions?.isNotEmpty == true) ...[
          _buildColorOptions(),
          SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildSizeOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Size',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: widget.product.sizeOptions!.map((size) {
            bool isSelected = size == selectedSize;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedSize = size;
                });
              },
              child:
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryColor
                            : AppColors.borderColor,
                      ),
                    ),
                    child: Text(
                      size,
                      style: GoogleFonts.poppins(
                        color: isSelected
                            ? AppColors.surfaceColor
                            : AppColors.textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ).animate().scale(
                    duration: 300.ms,
                    delay: (widget.product.sizeOptions!.indexOf(size) * 50).ms,
                  ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: widget.product.colorOptions!.map((color) {
            bool isSelected = color == selectedColor;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedColor = color;
                });
              },
              child:
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryColor
                            : AppColors.borderColor,
                      ),
                    ),
                    child: Text(
                      color,
                      style: GoogleFonts.poppins(
                        color: isSelected
                            ? AppColors.surfaceColor
                            : AppColors.textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ).animate().scale(
                    duration: 300.ms,
                    delay:
                        (widget.product.colorOptions!.indexOf(color) * 50).ms,
                  ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    if (widget.product.description == null) return SizedBox.shrink();

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
          widget.product.description!,
          style: GoogleFonts.poppins(
            fontSize: 14,
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
        if (widget.product.tags?.isNotEmpty == true) ...[
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
            children: widget.product.tags!.map((tag) {
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

  Widget _buildAddToCartButton() {
    return Obx(() {
      final isInCart = cartController.cartItems.any(
        (item) => item.product.id == widget.product.id,
      );

      if (widget.product.price == null) {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(
            'Price not available',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.errorColor,
            ),
          ),
        );
      }

      return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: ElevatedButton(
          onPressed: () {
            if (isInCart) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Product is already in your cart!',
                    style: GoogleFonts.poppins(),
                  ),
                  backgroundColor: AppColors.warningColor,
                ),
              );
            } else {
              try {
                cartController.addToCart(widget.product, quantity: 1);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added to cart!',
                      style: GoogleFonts.poppins(),
                    ),
                    backgroundColor: AppColors.successColor,
                  ),
                );
              } on Exception catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Error adding product to cart: ${e.toString()}',
                      style: GoogleFonts.poppins(),
                    ),
                    backgroundColor: AppColors.errorColor,
                  ),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isInCart
                ? AppColors.warningColor
                : AppColors.primaryColor,
            foregroundColor: AppColors.surfaceColor,
            padding: EdgeInsets.symmetric(vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 8,
          ),
          child: Text(
            isInCart
                ? 'Already in Cart'
                : 'Add to Cart - \$${widget.product.price!.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      )
          .animate()
          .slideY(begin: 1, duration: 600.ms, delay: 800.ms)
          .then()
          .shimmer(duration: 2000.ms, delay: 1500.ms);
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    imageController.dispose();
    super.dispose();
  }
}
