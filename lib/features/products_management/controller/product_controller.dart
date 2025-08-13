import 'package:get/get.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/features/products_management/service/products_services.dart';
import 'package:mrpace/models/product_model.dart';

class ProductController extends GetxController {
  var isLoading = false.obs;
  var successMessage = ''.obs;
  var errorMessage = ''.obs;

  // Observable list for fetched products
  var products = <ProductModel>[].obs;
  var product = Rxn<ProductModel>();

  // Method to fetch all products
  Future<void> getAllProducts() async {
    try {
      isLoading(true); // Start loading
      final response = await ProductServices.fetchAllProducts();
      if (response.success) {
        products.value = response.data ?? [];
        successMessage.value =
            response.message ?? 'Products loaded successfully';
      } else {
        errorMessage.value = response.message!;
      }
    } catch (e) {
      DevLogs.logError('Error fetching products: ${e.toString()}');
      errorMessage.value =
          'An error occurred while fetching products: ${e.toString()}';
    } finally {
      isLoading(false); // End loading
    }
  }

  Future<void> refreshProducts() async {
    await getAllProducts();
  }
}
