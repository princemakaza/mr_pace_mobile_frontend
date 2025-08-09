import 'package:get/get.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/features/race_management/services/race_services.dart';
import 'package:mrpace/models/all_races_model.dart';

class RaceController extends GetxController {
  var isLoading = false.obs;
  var successMessage = ''.obs;
  var errorMessage = ''.obs;

  // Observable list for fetched trips
  var races = <AllRacesModel>[].obs;
  var race = Rxn<AllRacesModel>();
  // Method to fetch all trips
  Future<void> getAllRaces() async {
    try {
      isLoading(true); // Start loading
      final response = await RaceServices.fetchAllRaces();
      if (response.success) {
        races.value = response.data ?? [];
        successMessage.value = response.message ?? 'Races loaded successfully';
      } else {
        errorMessage.value = response.message!;
      }
    } catch (e) {
      DevLogs.logError('Error fetching races: ${e.toString()}');
      errorMessage.value =
          'An error occurred while fetching races: ${e.toString()}';
    } finally {
      isLoading(false); // End loading
    }
  }

  Future<void> refreshRaces() async {
    await getAllRaces();
  }
}
