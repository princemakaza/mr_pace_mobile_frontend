import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrpace/config/routers/router.dart';
import 'package:mrpace/core/constants/icon_asset_constants.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/products_management/controller/product_controller.dart';
import 'package:mrpace/features/cart_management/controller/cart_controller.dart';
import 'package:mrpace/models/product_model.dart';
import 'package:mrpace/widgets/cards/product_card.dart';
import 'package:mrpace/widgets/empty_widget/empty_state_empty.dart';
import 'package:mrpace/widgets/error_widgets/error.dart';
import 'package:mrpace/widgets/loading_widgets/vehicle_loader.dart';
import 'package:mrpace/widgets/text_fields/custom_text_field.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen>
    with TickerProviderStateMixin {
  final ProductController controller = Get.put(ProductController());
  final ProductCartController cartController =
      Get.find<ProductCartController>();
  late AnimationController _headerAnimationController;
  final TextEditingController _searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;

  final List<String> categories = [
    "All",
    "Clothing",
    "Supplements",
    "Footwear",
    "Equipment",
    "Accessories",
    "Nutrition",
    "Other",
  ];

  late AnimationController _cartShakeController;
  late Animation<double> _cartShakeAnimation;

  @override
  void initState() {
    super.initState();
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cartShakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _cartShakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _cartShakeController, curve: Curves.elasticOut),
    );

    _searchController.addListener(() {
      searchQuery.value = _searchController.text;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAllProducts();
      _headerAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _cartShakeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<ProductModel> get filteredProducts {
    List<ProductModel> baseList = controller.products;

    // Filter by category
    if (selectedCategory.value != 'All') {
      baseList = baseList
          .where((product) => product.category == selectedCategory.value)
          .toList();
    }

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      baseList = baseList.where((product) {
        return product.name!.toLowerCase().contains(query) ||
            product.description!.toLowerCase().contains(query) ||
            product.category!.toLowerCase().contains(query);
      }).toList();
    }

    return baseList;
  }

  Map<String, List<ProductModel>> get productsByCategory {
    final Map<String, List<ProductModel>> categorized = {};

    for (var category in categories) {
      if (category == 'All') continue;

      final productsInCategory = controller.products
          .where((product) => product.category == category)
          .toList();

      if (productsInCategory.isNotEmpty) {
        categorized[category] = productsInCategory;
      }
    }

    return categorized;
  }

  void _clearSearch() {
    _searchController.clear();
    searchQuery.value = '';
  }

  void _triggerCartShake() {
    _cartShakeController.reset();
    _cartShakeController.forward();
  }

  Widget _buildCartIcon() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: const Icon(
            Icons.shopping_cart_rounded,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            Get.toNamed(RoutesHelper.cartScreen);
          },
        ),
        Obx(() {
          if (cartController.itemCount > 0) {
            return Positioned(
              right: 1,
              top: 1,
              child:
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.bounceOut,
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.errorColor,
                      borderRadius: BorderRadius.circular(10),
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
                      cartController.itemCount > 99
                          ? '99+'
                          : cartController.itemCount.toString(),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ).animate().scale(
                    delay: 100.ms,
                    duration: 300.ms,
                    curve: Curves.bounceOut,
                  ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Our Products',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
                height: 1.1,
              ),
            ),
            Text(
              'Shop the best running gear',
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.2,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryColor,
                AppColors.primaryColor.withOpacity(0.9),
                AppColors.secondaryColor.withOpacity(0.3),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -50,
                right: -50,
                child:
                    Container(
                          width: 200,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.08),
                          ),
                        )
                        .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true),
                        )
                        .scale(
                          duration: 4000.ms,
                          begin: const Offset(0.8, 0.8),
                          end: const Offset(1.1, 1.1),
                        ),
              ),
              Positioned(
                bottom: -30,
                left: -30,
                child:
                    Container(
                          width: 120,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.05),
                          ),
                        )
                        .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true),
                        )
                        .scale(
                          duration: 3500.ms,
                          begin: const Offset(1.2, 1.2),
                          end: const Offset(0.9, 0.9),
                        ),
              ),
            ],
          ),
        ),
        actions: [_buildCartIcon(), const SizedBox(width: 8)],
        elevation: 0,
        toolbarHeight: 80,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildSearchCard()),
          SliverToBoxAdapter(child: _buildCategoryFilter()),
          _buildSliverContent(),
        ],
      ),
    );
  }

  Widget _buildSearchCard() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.search_rounded,
                      color: AppColors.primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Find Products',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  Obx(() {
                    if (cartController.itemCount > 0) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.shopping_cart_rounded,
                              size: 14,
                              color: AppColors.primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${cartController.itemCount}',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              )
              .animate()
              .fadeIn(delay: 200.ms)
              .slideX(begin: -0.2, end: 0, duration: 500.ms),
          const SizedBox(height: 16),
          Obx(
            () =>
                CustomTextField(
                      controller: _searchController,
                      labelText: 'Search by name, description or category...',
                      fillColor: Colors.grey[50],
                      filled: true,
                      borderRadius: 16,
                      defaultBorderColor: Colors.grey[200],
                      focusedBorderColor: AppColors.primaryColor,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.search_rounded,
                          color: AppColors.primaryColor,
                          size: 16,
                        ),
                      ),
                      suffixIconButton: searchQuery.value.isNotEmpty
                          ? IconButton(
                              icon: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.close_rounded,
                                  color: Colors.grey[600],
                                  size: 16,
                                ),
                              ),
                              onPressed: _clearSearch,
                            )
                          : null,
                      labelStyle: GoogleFonts.poppins(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                      inputTextStyle: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[800],
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 600.ms)
                    .slideY(begin: 0.3, end: 0, duration: 600.ms),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                if (searchQuery.value.isNotEmpty) {
                  return Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${filteredProducts.length} product${filteredProducts.length != 1 ? 's' : ''} found',
                            style: GoogleFonts.poppins(
                              color: AppColors.primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 200.ms)
                      .slideX(begin: -0.2, end: 0, duration: 400.ms);
                }
                return const SizedBox.shrink();
              }),
              Obx(() {
                if (cartController.cartItems.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.successColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Cart: ${cartController.formattedTotalPrice}',
                        style: GoogleFonts.poppins(
                          color: AppColors.successColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.2, end: 0, duration: 800.ms);
  }

  Widget _buildCategoryFilter() {
    return Obx(
      () => Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((category) {
              final isSelected = selectedCategory.value == category;
              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    selectedCategory.value = category;
                  },
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.grey[700],
                  ),
                  backgroundColor: Colors.grey[100],
                  selectedColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverContent() {
    return Obx(() {
      if (controller.isLoading.value) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: const CardLoad(),
          ),
        );
      }

      if (controller.errorMessage.isNotEmpty) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child:
                ApiFailureWidget(
                      onRetry: () {
                        controller.errorMessage.value = "";
                        controller.getAllProducts();
                      },
                    )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .scale(begin: const Offset(0.9, 0.9), duration: 400.ms),
          ),
        );
      }

      if (controller.products.isEmpty) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child:
                EmptyStateWidget(
                      icon: CustomIcons.searchNotFound,
                      title: 'No Products Available',
                      description:
                          'We couldn\'t find any products at the moment.',
                    )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scale(begin: const Offset(0.8, 0.8), duration: 600.ms),
          ),
        );
      }

      if (selectedCategory.value == 'All') {
        return _buildProductsByCategory();
      }

      return _buildFilteredProducts();
    });
  }

  Widget _buildProductsByCategory() {
    final categorizedProducts = productsByCategory;

    if (categorizedProducts.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child:
              EmptyStateWidget(
                    icon: CustomIcons.searchNotFound,
                    title: 'No Products Found',
                    description: 'No products available in any category.',
                  )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .scale(begin: const Offset(0.8, 0.8), duration: 400.ms),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final category = categorizedProducts.keys.elementAt(index);
        final products = categorizedProducts[category]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      selectedCategory.value = category;
                      Get.snackbar(
                        'View All',
                        'Showing all $category products',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.primaryColor,
                        colorText: Colors.white,
                      );
                    },
                    child: Text(
                      'View All',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 240,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: products.length,
                itemBuilder: (context, productIndex) {
                  return Container(
                    width: 180,
                    margin: const EdgeInsets.only(right: 16),
                    child: ProductCard(
                      product: products[productIndex],
                      onTapNavigateToProductDetail: () {
                        Get.toNamed(
                          RoutesHelper.productDetailsScreen,
                          arguments: products[productIndex],
                        );
                      },
                      onAddToCart: () {
                        cartController.addToCart(
                          products[productIndex],
                          quantity: 1,
                        );
                        _triggerCartShake();
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      }, childCount: categorizedProducts.length),
    );
  }

  Widget _buildFilteredProducts() {
    final products = filteredProducts;

    if (products.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child:
              EmptyStateWidget(
                    icon: CustomIcons.searchNotFound,
                    title: 'No Products Found',
                    description: selectedCategory.value != 'All'
                        ? 'No products found in ${selectedCategory.value} category'
                        : 'No products match your search',
                  )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .scale(begin: const Offset(0.8, 0.8), duration: 400.ms),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(10, 1, 1, 1),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          return ProductCard(
                product: products[index],
                onTapNavigateToProductDetail: () {
                  DevLogs("Tapped on product: ${products[index].name}");
                  Get.toNamed(
                    RoutesHelper.productDetailsScreen,
                    arguments: products[index],
                  );
                },
                onAddToCart: () {
                  cartController.addToCart(products[index], quantity: 1);
                  _triggerCartShake();
                },
              )
              .animate()
              .fadeIn(
                delay: Duration(milliseconds: 100 * index),
                duration: 600.ms,
              )
              .slideY(
                begin: 0.3,
                end: 0,
                delay: Duration(milliseconds: 100 * index),
                duration: 600.ms,
              );
        }, childCount: products.length),
      ),
    );
  }
}
