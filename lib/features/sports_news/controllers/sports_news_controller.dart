import 'package:get/get.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/features/sports_news/services/sports_news_services.dart';
import 'package:mrpace/models/sports_news_model.dart';

class SportNewsController extends GetxController {
  var isLoading = false.obs;
  var successMessage = ''.obs;
  var errorMessage = ''.obs;

  // Observable list for fetched sports news
  var sportsNews = <SportNewsModel>[].obs;
  var selectedNews = Rxn<SportNewsModel>();

  // Method to fetch all sports news
  Future<void> getAllSportsNews() async {
    try {
      isLoading(true); // Start loading
      final response = await SportNewsService.fetchAllSportsNews();
      if (response.success) {
        sportsNews.value = response.data ?? [];
        successMessage.value =
            response.message ?? 'Sports news loaded successfully';
      } else {
        errorMessage.value = response.message!;
      }
    } catch (e) {
      DevLogs.logError('Error fetching sports news: ${e.toString()}');
      errorMessage.value =
          'An error occurred while fetching sports news: ${e.toString()}';
    } finally {
      isLoading(false); // End loading
    }
  }

  Future<void> refreshSportsNews() async {
    await getAllSportsNews();
  }
}
