import 'package:get/get.dart';
import 'package:mrpace/models/product_model.dart';

class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => (product.price ?? 0) * quantity;
}

class ProductCartController extends GetxController {
  // Observable list of cart items
  final RxList<CartItem> _cartItems = <CartItem>[].obs;
    RxList<CartItem> get observableCartItems => _cartItems;

  // Getters
  List<CartItem> get cartItems => _cartItems;

  int get itemCount => _cartItems.length;

  int get totalQuantity =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  // Check if product is in cart
  bool isInCart(ProductModel product) {
    return _cartItems.any((item) => item.product.id == product.id);
  }

  // Get cart item by product
  CartItem? getCartItem(ProductModel product) {
    try {
      return _cartItems.firstWhere((item) => item.product.id == product.id);
    } catch (e) {
      return null;
    }
  }

  // Add product to cart
  void addToCart(ProductModel product, {int quantity = 1}) {
    if (product.id == null) {
      Get.snackbar(
        'Error',
        'Invalid product',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }

    // Check stock availability
    if (product.stockQuantity != null && product.stockQuantity! < quantity) {
      Get.snackbar(
        'Out of Stock',
        'Only ${product.stockQuantity} items available',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }

    final existingItemIndex = _cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex >= 0) {
      // Product already in cart, update quantity
      final existingItem = _cartItems[existingItemIndex];
      final newQuantity = existingItem.quantity + quantity;

      // Check stock for new quantity
      if (product.stockQuantity != null &&
          product.stockQuantity! < newQuantity) {
        Get.snackbar(
          'Stock Limit',
          'Cannot add more. Only ${product.stockQuantity} items available',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        return;
      }

      existingItem.quantity = newQuantity;
      _cartItems.refresh();
    } else {
      // Add new item to cart
      _cartItems.add(CartItem(product: product, quantity: quantity));
    }

    Get.snackbar(
      'Added to Cart',
      '${product.name ?? 'Product'} added successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
      duration: const Duration(seconds: 2),
    );
  }

  // Remove product from cart completely
  void removeFromCart(ProductModel product) {
    _cartItems.removeWhere((item) => item.product.id == product.id);

    Get.snackbar(
      'Removed from Cart',
      '${product.name ?? 'Product'} removed from cart',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.secondary,
      colorText: Get.theme.colorScheme.onSecondary,
      duration: const Duration(seconds: 2),
    );
  }

  // Update quantity of a product in cart
  void updateQuantity(ProductModel product, int quantity) {
    if (quantity <= 0) {
      removeFromCart(product);
      return;
    }

    // Check stock availability
    if (product.stockQuantity != null && product.stockQuantity! < quantity) {
      Get.snackbar(
        'Stock Limit',
        'Only ${product.stockQuantity} items available',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }

    final itemIndex = _cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (itemIndex >= 0) {
      _cartItems[itemIndex].quantity = quantity;
      _cartItems.refresh();
    }
  }

  // Increase quantity by 1
  void increaseQuantity(ProductModel product) {
    final cartItem = getCartItem(product);
    if (cartItem != null) {
      updateQuantity(product, cartItem.quantity + 1);
    }
  }

  // Decrease quantity by 1
  void decreaseQuantity(ProductModel product) {
    final cartItem = getCartItem(product);
    if (cartItem != null) {
      updateQuantity(product, cartItem.quantity - 1);
    }
  }

  // Clear entire cart
  void clearCart() {
    _cartItems.clear();

    Get.snackbar(
      'Cart Cleared',
      'All items removed from cart',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.secondary,
      colorText: Get.theme.colorScheme.onSecondary,
      duration: const Duration(seconds: 2),
    );
  }

  // Get formatted total price
  String get formattedTotalPrice => '\$${totalPrice.toStringAsFixed(2)}';

  // Check if cart is empty
  bool get isEmpty => _cartItems.isEmpty;
  bool get isNotEmpty => _cartItems.isNotEmpty;
}
