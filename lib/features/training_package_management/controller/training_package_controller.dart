import 'package:get/get.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/features/training_package_management/services/training_package_services.dart';
import 'package:mrpace/models/training_package_model.dart';

class TrainingPackageController extends GetxController {
  var isLoading = false.obs;
  var successMessage = ''.obs;
  var errorMessage = ''.obs;
  // Observable list for fetched training packages
  var packages = <TrainingProgramPackage>[].obs;
  var selectedPackage = Rxn<TrainingProgramPackage>();
  // Method to fetch all training packages
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

  Future<void> refreshTrainingPackages() async {
    await getAllTrainingPackages();
  }
}
