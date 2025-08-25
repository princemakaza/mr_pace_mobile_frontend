import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrpace/config/routers/router.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/payment_management/controllers/payment_controller.dart';
import 'package:mrpace/features/payment_management/screens/training_package_buy_coffee.dart';
import 'package:mrpace/features/training_package_management/controller/training_package_controller.dart';
import 'package:mrpace/widgets/cards/training_package_card.dart';
import 'package:mrpace/widgets/loading_widgets/circular_loader.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../widgets/cards/training_bought_card.dart';

class AllTrainingPackagesScreen extends StatefulWidget {
  const AllTrainingPackagesScreen({Key? key}) : super(key: key);

  @override
  State<AllTrainingPackagesScreen> createState() =>
      _AllTrainingPackagesScreenState();
}

class _AllTrainingPackagesScreenState extends State<AllTrainingPackagesScreen>
    with SingleTickerProviderStateMixin {
  final TrainingPackageController controller =
      Get.find<TrainingPackageController>();

  late TabController _tabController;
  bool _isReversed = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load both available and bought packages
      controller.getAllTrainingPackages();
      controller.getTrainingPackagesBoughtByUser('688c49c5b93594ab91cb1d1f');
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleListOrder() {
    setState(() {
      _isReversed = !_isReversed;
    });

    // Show toast message
    Fluttertoast.showToast(
      msg: _isReversed
          ? 'List sorted in reverse order'
          : 'List sorted in original order',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppColors.primaryColor.withOpacity(0.8),
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.surfaceColor,
        foregroundColor: AppColors.textColor,
        title: Text(
          'Training Programs',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      25,
                    ), // Changed from 12 to 25
                    color: AppColors.primaryColor,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.subtextColor,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                  tabs: const [
                    Tab(text: 'Available Programs'),
                    Tab(text: 'My Programs'),
                  ],
                  // Add these properties to remove the bottom line
                  dividerColor: Colors.transparent, // Removes the divider line
                  indicatorWeight: 0, // Removes the default indicator line
                  overlayColor: MaterialStateProperty.all(
                    Colors.transparent,
                  ), // Removes splash effect
                ),
              ),

              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor.withOpacity(0.3),
                      AppColors.primaryColor.withOpacity(0.1),
                      AppColors.primaryColor.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          if (_tabController.index == 0)
            IconButton(
              icon: const Icon(
                Icons.more_vert,
                color: AppColors.primaryColor,
                size: 18,
              ),
              onPressed: () {
                // Show simple dropdown menu
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(
                              Icons.bookmark,
                              color: AppColors.primaryColor,
                            ),
                            title: const Text('My Package Bookings'),
                            onTap: () {
                              Get.toNamed(RoutesHelper.allCourseBookingsScreen);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Available Programs Tab
          _buildAvailableProgramsTab(),

          // My Programs Tab
          _buildMyProgramsTab(),
        ],
      ),
    );
  }

  Widget _buildAvailableProgramsTab() {
    return Obx(() {
      // Error State
      if (controller.errorMessage.value.isNotEmpty &&
          !controller.isLoading.value) {
        return _buildErrorState();
      }

      // Loading State
      if (controller.isLoading.value) {
        return _buildShimmerLoading();
      }

      // Empty State
      if (controller.packages.isEmpty) {
        return _buildEmptyState();
      }

      // Success State
      return _buildPackagesList();
    });
  }

  Widget _buildMyProgramsTab() {
    return Obx(() {
      // Error State
      if (controller.errorMessageBought.value.isNotEmpty &&
          !controller.isLoadingBoughtPackages.value) {
        return _buildBoughtErrorState();
      }

      // Loading State
      if (controller.isLoadingBoughtPackages.value) {
        return _buildBoughtShimmerLoading();
      }

      // Empty State
      if (controller.boughtPackages.isEmpty) {
        return _buildBoughtEmptyState();
      }

      // Success State
      return _buildBoughtPackagesList();
    });
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header shimmer - Fixed overflow issues
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Shimmer.fromColors(
                baseColor: AppColors.cardColor,
                highlightColor: AppColors.primaryColor.withOpacity(0.1),
                child: Row(
                  children: [
                    // Use Flexible instead of Expanded to prevent overflow
                    Flexible(
                      flex: 3,
                      child: Container(
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.cardColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Fixed width for count text
                    Container(
                      height: 20,
                      width: 80,
                      decoration: BoxDecoration(
                        color: AppColors.cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Package cards shimmer - Updated for list layout
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 8, // Show more items for list view
              itemBuilder: (context, index) {
                return Container(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      child: Shimmer.fromColors(
                        baseColor: AppColors.cardColor,
                        highlightColor: AppColors.primaryColor.withOpacity(0.1),
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.borderColor,
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Package Image Shimmer
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.cardColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Package Content Shimmer
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Title and Share Button Row
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Title shimmer
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 16,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: AppColors.cardColor,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Container(
                                                height: 16,
                                                width:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.4,
                                                decoration: BoxDecoration(
                                                  color: AppColors.cardColor,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Share button shimmer
                                        Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            color: AppColors.cardColor,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    // Coach Name shimmer
                                    Container(
                                      height: 12,
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.35,
                                      decoration: BoxDecoration(
                                        color: AppColors.cardColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    // Date and Duration Row shimmer
                                    Row(
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: AppColors.cardColor,
                                            borderRadius: BorderRadius.circular(
                                              2,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Container(
                                          height: 10,
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.25,
                                          decoration: BoxDecoration(
                                            color: AppColors.cardColor,
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: AppColors.cardColor,
                                            borderRadius: BorderRadius.circular(
                                              2,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Container(
                                          height: 10,
                                          width: 25,
                                          decoration: BoxDecoration(
                                            color: AppColors.cardColor,
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    // Bottom Row: Price and Register Button shimmer
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Price shimmer
                                        Flexible(
                                          flex: 2,
                                          child: Container(
                                            height: 24,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              color: AppColors.cardColor,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // Register Button shimmer
                                        Flexible(
                                          flex: 3,
                                          child: Container(
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: AppColors.cardColor,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(delay: (index * 80).ms, duration: 500.ms)
                    .slideX(begin: 0.1, end: 0, duration: 500.ms);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoughtShimmerLoading() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header shimmer for bought packages
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Shimmer.fromColors(
                baseColor: AppColors.cardColor,
                highlightColor: AppColors.primaryColor.withOpacity(0.1),
                child: Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: Container(
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.cardColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      height: 20,
                      width: 80,
                      decoration: BoxDecoration(
                        color: AppColors.cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bought package cards shimmer
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      child: Shimmer.fromColors(
                        baseColor: AppColors.cardColor,
                        highlightColor: AppColors.primaryColor.withOpacity(0.1),
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.borderColor,
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Package Image Shimmer
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.cardColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Package Content Shimmer
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Title shimmer
                                    Container(
                                      height: 16,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: AppColors.cardColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Status shimmer
                                    Container(
                                      height: 12,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: AppColors.cardColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    // Progress bar shimmer
                                    Container(
                                      height: 8,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: AppColors.cardColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Progress text shimmer
                                    Container(
                                      height: 10,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        color: AppColors.cardColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(delay: (index * 80).ms, duration: 500.ms)
                    .slideX(begin: 0.1, end: 0, duration: 500.ms);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: AppColors.errorColor.withOpacity(0.3),
                ),
              ),
              child: Icon(
                Icons.error_outline,
                size: 60,
                color: AppColors.errorColor,
              ),
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(height: 24),
            Text(
                  'Unable to Load Packages',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(delay: 200.ms, duration: 600.ms)
                .slideY(begin: 0.1, end: 0, duration: 600.ms),
            const SizedBox(height: 12),
            // Fixed text overflow with proper constraints
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                controller.errorMessage.value,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.subtextColor,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
            const SizedBox(height: 32),
            // Fixed button layout to prevent overflow
            Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        controller.errorMessage.value = '';
                        controller.getAllTrainingPackages();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Go Back'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryColor,
                        side: BorderSide(color: AppColors.primaryColor),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                )
                .animate()
                .fadeIn(delay: 600.ms, duration: 600.ms)
                .slideY(begin: 0.1, end: 0, duration: 600.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildBoughtErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: AppColors.errorColor.withOpacity(0.3),
                ),
              ),
              child: Icon(
                Icons.error_outline,
                size: 60,
                color: AppColors.errorColor,
              ),
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(height: 24),
            Text(
                  'Unable to Load Your Programs',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(delay: 200.ms, duration: 600.ms)
                .slideY(begin: 0.1, end: 0, duration: 600.ms),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                controller.errorMessageBought.value,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.subtextColor,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
            const SizedBox(height: 32),
            Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        controller.errorMessageBought.value = '';
                        controller.getTrainingPackagesBoughtByUser(
                          '688c49c5b93594ab91cb1d1f',
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _tabController.animateTo(0),
                      icon: const Icon(Icons.list),
                      label: const Text('View Available'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryColor,
                        side: BorderSide(color: AppColors.primaryColor),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                )
                .animate()
                .fadeIn(delay: 600.ms, duration: 600.ms)
                .slideY(begin: 0.1, end: 0, duration: 600.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.fitness_center_outlined,
                size: 60,
                color: AppColors.primaryColor,
              ),
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(height: 24),
            Text(
                  'No Programs Available',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(delay: 200.ms, duration: 600.ms)
                .slideY(begin: 0.1, end: 0, duration: 600.ms),
            const SizedBox(height: 12),
            // Fixed text with proper constraints
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'There are no training programs available at the moment. Check back later for new programs!',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.subtextColor,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
            const SizedBox(height: 32),
            ElevatedButton.icon(
                  onPressed: () => controller.getAllTrainingPackages(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 600.ms, duration: 600.ms)
                .slideY(begin: 0.1, end: 0, duration: 600.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildBoughtEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.lock_open_outlined,
                size: 60,
                color: AppColors.primaryColor,
              ),
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(height: 24),
            Text(
                  'No Programs Unlocked Yet',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(delay: 200.ms, duration: 600.ms)
                .slideY(begin: 0.1, end: 0, duration: 600.ms),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'You haven\'t unlocked any training programs yet. Explore our available programs to get started!',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.subtextColor,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
            const SizedBox(height: 32),
            ElevatedButton.icon(
                  onPressed: () => _tabController.animateTo(0),
                  icon: const Icon(Icons.explore),
                  label: const Text('Explore Programs'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 600.ms, duration: 600.ms)
                .slideY(begin: 0.1, end: 0, duration: 600.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildPackagesList() {
    return RefreshIndicator(
      color: AppColors.primaryColor,
      backgroundColor: AppColors.surfaceColor,
      onRefresh: controller.refreshTrainingPackages,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Header Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fixed header row to prevent overflow
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                      'Available Programs',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textColor,
                                      ),
                                    )
                                    .animate()
                                    .fadeIn(duration: 600.ms)
                                    .slideX(
                                      begin: -0.1,
                                      end: 0,
                                      duration: 600.ms,
                                    ),
                                const SizedBox(height: 4),
                                Obx(
                                  () => Text(
                                    '${controller.packages.length} program${controller.packages.length != 1 ? 's' : ''} available',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.subtextColor,
                                    ),
                                  ),
                                ).animate().fadeIn(
                                  delay: 200.ms,
                                  duration: 600.ms,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Filter/Sort Button - Updated with toggle functionality
                          GestureDetector(
                            onTap: _toggleListOrder,
                            child:
                                Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor
                                            .withOpacity(
                                              _isReversed ? 0.3 : 0.1,
                                            ),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.primaryColor
                                              .withOpacity(
                                                _isReversed ? 0.5 : 0.3,
                                              ),
                                          width: _isReversed ? 1.5 : 1.0,
                                        ),
                                      ),
                                      child: Icon(
                                        _isReversed
                                            ? Icons.swap_vert
                                            : Icons.tune,
                                        color: AppColors.primaryColor,
                                        size: 20,
                                      ),
                                    )
                                    .animate()
                                    .fadeIn(delay: 400.ms, duration: 600.ms)
                                    .scale(
                                      begin: const Offset(0.8, 0.8),
                                      duration: 600.ms,
                                    ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  // Success message display - Fixed overflow
                  Obx(() {
                    if (controller.successMessage.value.isNotEmpty) {
                      return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.successColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.successColor.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: AppColors.successColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    controller.successMessage.value,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.successColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () =>
                                      controller.successMessage.value = '',
                                  child: Icon(
                                    Icons.close,
                                    color: AppColors.successColor,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: -0.1, end: 0, duration: 400.ms);
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),
          // Packages List - Toggle between normal and reversed order
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                // Access packages in normal or reversed order based on _isReversed
                final packageIndex = _isReversed
                    ? controller.packages.length - 1 - index
                    : index;

                final package = controller.packages[packageIndex];
                return TrainingPackageCard(
                      userId: '688c49c5b93594ab91cb1d1f',
                      package: package,
                      onTap: () {},
                    )
                    .animate()
                    .fadeIn(
                      delay: (index * 50).ms,
                      duration: 400.ms,
                      curve: Curves.easeOutQuart,
                    )
                    .slideX(
                      begin: 0.1,
                      end: 0,
                      delay: (index * 50).ms,
                      duration: 400.ms,
                      curve: Curves.easeOutQuart,
                    );
              }, childCount: controller.packages.length),
            ),
          ),
          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildBoughtPackagesList() {
    return RefreshIndicator(
      color: AppColors.primaryColor,
      backgroundColor: AppColors.surfaceColor,
      onRefresh: () => controller.getTrainingPackagesBoughtByUser(
        '688c49c5b93594ab91cb1d1f',
      ),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Header Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                  'My Training Programs',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textColor,
                                  ),
                                )
                                .animate()
                                .fadeIn(duration: 600.ms)
                                .slideX(begin: -0.1, end: 0, duration: 600.ms),
                            const SizedBox(height: 4),
                            Obx(
                              () => Text(
                                '${controller.boughtPackages.length} program${controller.boughtPackages.length != 1 ? 's' : ''} unlocked',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.subtextColor,
                                ),
                              ),
                            ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Success message display
                  Obx(() {
                    if (controller.successMessageBought.value.isNotEmpty) {
                      return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.successColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.successColor.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: AppColors.successColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    controller.successMessageBought.value,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.successColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () =>
                                      controller.successMessageBought.value =
                                          '',
                                  child: Icon(
                                    Icons.close,
                                    color: AppColors.successColor,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: -0.1, end: 0, duration: 400.ms);
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),
          // Bought Packages List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final boughtPackage = controller.boughtPackages[index];
                return TrainingPackageBoughtCard(
                      boughtPackage: boughtPackage,
                      onTap: () {
                        // Handle tap on bought package
                      },
                      onRetryPayment: () async {
                        // Get the PaymentController instance
                        final paymentController = Get.find<PaymentController>();

                        // Show loading dialog
                        Get.dialog(
                          const CustomLoader(
                            message: 'Checking payment status...',
                          ),
                          barrierDismissible: true,
                        );

                        try {
                          // Call the payment status check
                          await paymentController
                              .checkTrainingPackagePaymentStatus(
                                pollUrl:
                                    boughtPackage.pollUrl ??
                                    '', // Make sure your boughtPackage has pollUrl
                                trainingPackageBoughtId: boughtPackage.id!,
                              );

                          // Close the loading dialog
                          Get.back();

                          // Check the response status
                          final response =
                              paymentController.paymentStatusResponse.value;

                          if (response != null) {
                            if (response.status == 'paid' ||
                                response.status == 'completed') {
                              // Payment successful - navigate to training program detail
                              Get.toNamed(
                                RoutesHelper.trainingProgramDetailScreen,
                                arguments: boughtPackage,
                              );
                            } else {
                              // Payment still pending or failed - show coffee dialog
                              Get.dialog(
                                TrainingPackageBuyCoachCoffeeDialog(
                                  userId: boughtPackage.userId!,
                                  trainingProgramPackageId: boughtPackage.id!,
                                  pricePaid: boughtPackage.pricePaid.toString(),
                                ),
                              );
                            }
                          } else {
                            // No response received - show error and coffee dialog
                            Get.dialog(
                              TrainingPackageBuyCoachCoffeeDialog(
                                userId: boughtPackage.userId!,
                                trainingProgramPackageId: boughtPackage.id!,
                                pricePaid: boughtPackage.pricePaid.toString(),
                              ),
                            );
                          }
                        } catch (e) {
                          // Close loading dialog and show error
                          Get.back();
                          Get.dialog(
                            TrainingPackageBuyCoachCoffeeDialog(
                              userId: boughtPackage.userId!,
                              trainingProgramPackageId: boughtPackage.id!,
                              pricePaid: boughtPackage.pricePaid.toString(),
                            ),
                          );

                          // Optional: Show error message
                          Get.snackbar(
                            'Error',
                            'Failed to check payment status: ${e.toString()}',
                            backgroundColor: AppColors.errorColor,
                            colorText: Colors.white,
                          );
                        }
                      },
                      onViewTraining: () {
                        Get.toNamed(
                          RoutesHelper.trainingProgramDetailScreen,
                          arguments: boughtPackage,
                        );
                      },
                    )
                    .animate()
                    .fadeIn(
                      delay: (index * 50).ms,
                      duration: 400.ms,
                      curve: Curves.easeOutQuart,
                    )
                    .slideX(
                      begin: 0.1,
                      end: 0,
                      delay: (index * 50).ms,
                      duration: 400.ms,
                      curve: Curves.easeOutQuart,
                    );
              }, childCount: controller.boughtPackages.length),
            ),
          ),
          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
