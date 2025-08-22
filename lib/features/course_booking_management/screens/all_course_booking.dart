import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrpace/config/routers/router.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/course_booking_management/controller/course_booking_controller.dart';
import 'package:mrpace/widgets/cards/course_booking_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AllCourseBookingsScreen extends StatefulWidget {
  const AllCourseBookingsScreen({Key? key}) : super(key: key);

  @override
  State<AllCourseBookingsScreen> createState() =>
      _AllCourseBookingsScreenState();
}

class _AllCourseBookingsScreenState extends State<AllCourseBookingsScreen> {
  final CourseBookingController controller =
      Get.find<CourseBookingController>();

  // You can pass userId as parameter or get from auth controller
  final String userId =
      '688c49c5b93594ab91cb1d1f'; // Replace with actual userId

  bool _isReversed = false;

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getCourseBookingsByUserId(userId);
    });
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
          'My Course Bookings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        centerTitle: true,

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
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
        ),
      ),
      body: Obx(() {
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
        if (controller.courseBookings.isEmpty) {
          return _buildEmptyState();
        }

        // Success State
        return _buildBookingsList();
      }),
    );
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header shimmer
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

            // Booking cards shimmer
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 8,
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
                              // Course Image Shimmer
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.cardColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Course Content Shimmer
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

                                    // Payment Status shimmer
                                    Container(
                                      height: 18,
                                      width: 80,
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

                                    // Bottom Row: Price and Action Button shimmer
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

                                        // Action Button shimmer
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
                  'Unable to Load Bookings',
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

            Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        controller.errorMessage.value = '';
                        controller.getCourseBookingsByUserId(userId);
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
                Icons.book_online_outlined,
                size: 60,
                color: AppColors.primaryColor,
              ),
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),

            const SizedBox(height: 24),

            Text(
                  'No Bookings Found',
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
                'You haven\'t booked any courses yet. Browse available courses and book your first session!',
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
                  onPressed: () => controller.getCourseBookingsByUserId(userId),
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

  Widget _buildBookingsList() {
    return RefreshIndicator(
      color: AppColors.primaryColor,
      backgroundColor: AppColors.surfaceColor,
      onRefresh: () => controller.refreshCourseBookings(userId),
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
                                      'My Bookings',
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
                                    '${controller.courseBookings.length} booking${controller.courseBookings.length != 1 ? 's' : ''} found',
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

                          // Filter/Sort Button
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

                  // Success message display
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

          // Bookings List - Toggle between normal and reversed order
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                // Access bookings in normal or reversed order based on _isReversed
                final bookingIndex = _isReversed
                    ? controller.courseBookings.length - 1 - index
                    : index;

                final booking = controller.courseBookings[bookingIndex];
                return CourseBookingCard(
                      booking: booking,
                      onTap: () {
                        // Handle booking tap - navigate to booking details
                        Get.toNamed(
                          RoutesHelper.viewCourseBookingDetails,
                          arguments: booking,
                        );
                      },
                      onRegister: () {
                        // Handle action based on payment status
                        // This will be handled by the card's internal logic
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
              }, childCount: controller.courseBookings.length),
            ),
          ),
          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
