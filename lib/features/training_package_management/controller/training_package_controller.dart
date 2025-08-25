import 'package:get/get.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/features/training_package_management/services/training_package_services.dart';
import 'package:mrpace/models/training_bought_package_model.dart';
import 'package:mrpace/models/training_package_model.dart';
import 'package:mrpace/models/training_package_response.dart';

class TrainingPackageController extends GetxController {
  var isLoading = false.obs;
  var successMessage = ''.obs;
  var errorMessage = ''.obs;

  // Observable list for fetched training packages
  var packages = <TrainingProgramPackage>[].obs;
  var selectedPackage = Rxn<TrainingProgramPackage>();

  // Holds the latest purchase response
  var trainingPurchaseResponse = Rxn<TrainingPackageResponseModel>();

  /// Fetch all training packages
  Future<void> getAllTrainingPackages() async {
    try {
      isLoading(true); // Start loading
      final response = await TrainingPackagesService.fetchAllTrainingPackages();
      if (response.success) {
        packages.value = response.data ?? [];
        successMessage.value =
            response.message ?? 'Training packages loaded successfully';
      } else {
        errorMessage.value = response.message!;
      }
    } catch (e) {
      DevLogs.logError('Error fetching training packages: ${e.toString()}');
      errorMessage.value =
          'An error occurred while fetching training packages: ${e.toString()}';
    } finally {
      isLoading(false); // End loading
    }
  }

  /// Refresh training packages list
  Future<void> refreshTrainingPackages() async {
    await getAllTrainingPackages();
  }

  /// Create training package purchase
  Future<void> createTrainingBought({
    required String userId,
    required String trainingProgramPackageId,
    required double pricePaid,
  }) async {
    try {
      isLoading(true);
      errorMessage.value = '';
      successMessage.value = '';

      final response = await TrainingPackagesService.createTrainingBought(
        userId,
        trainingProgramPackageId,
        pricePaid,
      );

      if (response.success) {
        trainingPurchaseResponse.value = response.data;
        successMessage.value =
            response.message ?? 'Training package purchased successfully';
        DevLogs.logInfo(
          'Training package purchase success: ${trainingPurchaseResponse.value?.id}',
        );
      } else {
        errorMessage.value = response.message ?? 'Failed to purchase package';
        DevLogs.logError('Purchase failed: ${response.message}');
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: ${e.toString()}';
      DevLogs.logError('Error in createTrainingBought: $e');
    } finally {
      isLoading(false);
    }
  }


  /// For fetching bought packages by user
  var isLoadingBoughtPackages = false.obs;
  var successMessageBought = ''.obs;
  var errorMessageBought = ''.obs;

  var boughtPackages = <TrainingPackageBoughtModel>[].obs;


  /// Fetch training packages bought by a user
  Future<void> getTrainingPackagesBoughtByUser(String userId) async {
    try {
      isLoadingBoughtPackages(true);
      final response =
          await TrainingPackagesService.fetchTrainingProgramBoughtByUser(userId);
      if (response.success) {
        boughtPackages.value = response.data ?? [];
        successMessageBought.value =
            response.message ?? 'Bought packages loaded successfully';
      } else {
        errorMessageBought.value = response.message!;
      }
    } catch (e) {
      DevLogs.logError(
          'Error fetching training packages bought by user: ${e.toString()}');
      errorMessageBought.value =
          'An error occurred while fetching bought packages: ${e.toString()}';
    } finally {
      isLoadingBoughtPackages(false);
    }
  }

  /// Refresh both packages and bought packages concurrently
  Future<void> refreshAllData(String userId) async {
    await Future.wait([
      getAllTrainingPackages(),
      getTrainingPackagesBoughtByUser(userId),
    ]);
  }
}
