import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mrpace/config/routers/router.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/sports_news/controllers/sports_news_controller.dart';
import 'package:mrpace/models/sports_news_model.dart';
import 'package:mrpace/widgets/cards/sport_news_model.dart';
import 'package:shimmer/shimmer.dart';

class AllSportNewsScreen extends StatefulWidget {
  const AllSportNewsScreen({Key? key}) : super(key: key);

  @override
  State<AllSportNewsScreen> createState() => _AllSportNewsScreenState();
}

class _AllSportNewsScreenState extends State<AllSportNewsScreen>
    with SingleTickerProviderStateMixin {
  final SportNewsController controller = Get.put(SportNewsController());
  late TabController _tabController;
  
  bool _isReversed = true; // Start with newest first
  String _selectedCategory = 'All';
  
  // Categories in alphabetical order
  final List<String> _categories = [
    'All',
    'Athletics',
    'Basketball',
    'Boxing',
    'Cricket',
    'Football',
    'Formula 1',
    'Golf',
    'Other',
    'Rugby',
    'Tennis',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    controller.getAllSportsNews();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Sports News',
          style: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textColor),
        actions: [
          // Sort toggle button
          IconButton(
            onPressed: _toggleSortOrder,
            icon: AnimatedRotation(
              turns: _isReversed ? 0 : 0.5,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                _isReversed ? Icons.sort_rounded : Icons.sort_rounded,
                color: AppColors.primaryColor,
              ),
            ),
            tooltip: _isReversed ? 'Oldest First' : 'Newest First',
          ),
          // Filter button
          IconButton(
            onPressed: _showCategoryFilter,
            icon: Icon(
              Icons.filter_list_rounded,
              color: _selectedCategory != 'All' 
                  ? AppColors.primaryColor 
                  : AppColors.textColor,
            ),
            tooltip: 'Filter by Category',
          ),
          // Refresh button
          IconButton(
            onPressed: () => controller.refreshSportsNews(),
            icon: const Icon(Icons.refresh_rounded),
            color: AppColors.textColor,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                // Category filter display
                if (_selectedCategory != 'All') 
                  _buildSelectedCategoryChip(),
                
                // Sort indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.borderColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isReversed ? Icons.arrow_downward : Icons.arrow_upward,
                        size: 16,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isReversed ? 'Newest First' : 'Oldest First',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.sportsNews.isEmpty) {
          return _buildShimmerLoading();
        }

        if (controller.sportsNews.isEmpty && !controller.isLoading.value) {
          return _buildEmptyState();
        }

        final filteredNews = _getFilteredNews();
        
        if (filteredNews.isEmpty) {
          return _buildNoResultsState();
        }

        return RefreshIndicator(
          onRefresh: () => controller.refreshSportsNews(),
          color: AppColors.primaryColor,
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: filteredNews.length,
            itemBuilder: (context, index) {
              return SportNewsCard(
                newsModel: filteredNews[index],
                onTapToRead: () => Get.toNamed(
                  RoutesHelper.newsDetailScreen, // Adjust route name as needed
                  arguments: filteredNews[index],
                ),
              )
              .animate()
              .slideX(
                begin: 1,
                duration: Duration(milliseconds: 300 + (index * 50)),
                curve: Curves.easeOutCubic,
              )
              .fadeIn(duration: Duration(milliseconds: 400 + (index * 50)));
            },
          ),
        );
      }),
      floatingActionButton: Obx(() {
        if (controller.sportsNews.isEmpty) return const SizedBox.shrink();
        
        return FloatingActionButton(
          onPressed: _scrollToTop,
          backgroundColor: AppColors.primaryColor,
          child: const Icon(
            Icons.keyboard_arrow_up,
            color: AppColors.surfaceColor,
          ),
        ).animate()
          .scale(begin: const Offset(0, 0), duration: 400.ms, curve: Curves.elasticOut)
          .fadeIn();
      }),
    );
  }

  Widget _buildSelectedCategoryChip() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getCategoryIcon(_selectedCategory),
                  size: 16,
                  color: AppColors.surfaceColor,
                ),
                const SizedBox(width: 6),
                Text(
                  _selectedCategory,
                  style: const TextStyle(
                    color: AppColors.surfaceColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => setState(() => _selectedCategory = 'All'),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: AppColors.surfaceColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate()
      .slideY(begin: -0.5, duration: 300.ms, curve: Curves.easeOutBack)
      .fadeIn();
  }

  List<SportNewsModel> _getFilteredNews() {
    List<SportNewsModel> filtered = controller.sportsNews.toList();
    
    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((news) => news.category == _selectedCategory)
          .toList();
    }
    
    // Sort by date
    filtered.sort((a, b) {
      final dateA = a.publishedAt ?? a.createdAt ?? DateTime.now();
      final dateB = b.publishedAt ?? b.createdAt ?? DateTime.now();
      
      return _isReversed 
          ? dateB.compareTo(dateA) // Newest first
          : dateA.compareTo(dateB); // Oldest first
    });
    
    return filtered;
  }

  void _toggleSortOrder() {
    setState(() {
      _isReversed = !_isReversed;
    });
  }

  void _showCategoryFilter() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter by Category',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                  if (_selectedCategory != 'All')
                    TextButton(
                      onPressed: () {
                        setState(() => _selectedCategory = 'All');
                        Get.back();
                      },
                      child: const Text('Clear'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;
                  final count = category == 'All' 
                      ? controller.sportsNews.length
                      : controller.sportsNews
                          .where((news) => news.category == category)
                          .length;
                  
                  return ListTile(
                    leading: Icon(
                      _getCategoryIcon(category),
                      color: isSelected 
                          ? AppColors.primaryColor 
                          : AppColors.subtextColor,
                    ),
                    title: Text(
                      category,
                      style: TextStyle(
                        fontWeight: isSelected 
                            ? FontWeight.bold 
                            : FontWeight.normal,
                        color: isSelected 
                            ? AppColors.primaryColor 
                            : AppColors.textColor,
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8, 
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppColors.primaryColor.withOpacity(0.1)
                            : AppColors.borderColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        count.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected 
                              ? AppColors.primaryColor 
                              : AppColors.subtextColor,
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() => _selectedCategory = category);
                      Get.back();
                    },
                  ).animate()
                    .slideX(
                      begin: 1,
                      duration: Duration(milliseconds: 200 + (index * 50)),
                      curve: Curves.easeOutCubic,
                    )
                    .fadeIn(duration: Duration(milliseconds: 300 + (index * 50)));
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'all':
        return Icons.apps_rounded;
      case 'football':
        return Icons.sports_soccer;
      case 'cricket':
        return Icons.sports_cricket;
      case 'basketball':
        return Icons.sports_basketball;
      case 'rugby':
        return Icons.sports_rugby;
      case 'tennis':
        return Icons.sports_tennis;
      case 'athletics':
        return Icons.directions_run;
      case 'boxing':
        return Icons.sports_mma;
      case 'formula 1':
        return Icons.directions_car;
      case 'golf':
        return Icons.sports_golf;
      default:
        return Icons.sports;
    }
  }

  void _scrollToTop() {
    // Implementation depends on your scroll controller setup
    // You might want to add a ScrollController for this
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.borderColor,
          highlightColor: AppColors.surfaceColor,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const SizedBox(height: 280, width: double.infinity),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.sports_rounded,
              size: 64,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Sports News Found',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for the latest sports updates',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.subtextColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => controller.refreshSportsNews(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.surfaceColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Refresh News',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      )
      .animate()
      .scale(
        begin: const Offset(0.8, 0.8),
        duration: const Duration(milliseconds: 600),
        curve: Curves.elasticOut,
      )
      .fadeIn(),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 64,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Results Found',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No news found for "$_selectedCategory" category',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.subtextColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => setState(() => _selectedCategory = 'All'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.surfaceColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Show All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: _showCategoryFilter,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primaryColor),
                  foregroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Change Filter',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      )
      .animate()
      .scale(
        begin: const Offset(0.8, 0.8),
        duration: const Duration(milliseconds: 600),
        curve: Curves.elasticOut,
      )
      .fadeIn(),
    );
  }
}