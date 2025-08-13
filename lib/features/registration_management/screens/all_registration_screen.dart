import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrpace/config/routers/router.dart';
import 'package:mrpace/core/constants/icon_asset_constants.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/widgets/cards/registration_card.dart';
import 'package:mrpace/widgets/empty_widget/empty_state_empty.dart';
import 'package:mrpace/widgets/error_widgets/error.dart';
import 'package:mrpace/widgets/loading_widgets/vehicle_loader.dart';
import 'package:mrpace/widgets/text_fields/custom_text_field.dart';

import '../controller/registration_controller.dart';

enum SearchType { fullName, raceName }

class RegisteredRacesScreen extends StatefulWidget {
  const RegisteredRacesScreen({super.key});

  @override
  State<RegisteredRacesScreen> createState() => _RegisteredRacesScreenState();
}

class _RegisteredRacesScreenState extends State<RegisteredRacesScreen>
    with TickerProviderStateMixin {
  final RegistrationController controller = Get.put(RegistrationController());
  late AnimationController _headerAnimationController;
  final TextEditingController _searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final Rx<SearchType> currentSearchType = SearchType.fullName.obs;

  @override
  void initState() {
    super.initState();
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Listen to search query changes
    _searchController.addListener(() {
      searchQuery.value = _searchController.text;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchRegisteredRacesByUserId('688c49c5b93594ab91cb1d1f');
      _headerAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Filter registrations based on search query and type
  List<dynamic> get filteredRegistrations {
    List<dynamic> baseList = controller.registeredRaces.reversed
        .toList(); // Reverse the original list

    if (searchQuery.value.isEmpty) {
      return baseList;
    }

    return baseList.where((registration) {
      final query = searchQuery.value.toLowerCase();

      switch (currentSearchType.value) {
        case SearchType.fullName:
          final fullName = '${registration.firstName} ${registration.lastName}'
              .toLowerCase();
          return fullName.contains(query);
        case SearchType.raceName:
          return registration.raceName.toLowerCase().contains(query);
      }
    }).toList();
  }

  void _clearSearch() {
    _searchController.clear();
    searchQuery.value = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // Modern Header
          SliverToBoxAdapter(child: _buildModernHeader()),
          // Search Section
          SliverToBoxAdapter(child: _buildSearchCard()),

          _buildSliverContent(),
        ],
      ),
    );
  }

  Widget _buildModernHeader() {
    return Container(
      height: 130,
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
          // Animated background elements
          Positioned(
            top: -50,
            right: -50,
            child:
                Container(
                      width: 200,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.08),
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
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
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .scale(
                      duration: 3500.ms,
                      begin: const Offset(1.2, 1.2),
                      end: const Offset(0.9, 0.9),
                    ),
          ),

          // Header content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row with title and refresh button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                                'My Races',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                ),
                              )
                              .animate()
                              .fadeIn(delay: 200.ms)
                              .slideX(begin: -0.3, end: 0, duration: 600.ms),
                          const SizedBox(height: 4),
                          Text(
                                'Track your registrations',
                                style: GoogleFonts.poppins(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                              .animate()
                              .fadeIn(delay: 400.ms)
                              .slideX(begin: -0.3, end: 0, duration: 600.ms),
                        ],
                      ),
                      Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.refresh_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                              onPressed: () =>
                                  controller.refreshRegisteredRaces(''),
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 600.ms)
                          .scale(
                            begin: const Offset(0.8, 0.8),
                            duration: 400.ms,
                          ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
          // Search header
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
                  Text(
                    'Search Registrations',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              )
              .animate()
              .fadeIn(delay: 200.ms)
              .slideX(begin: -0.2, end: 0, duration: 500.ms),

          const SizedBox(height: 10),

          // Search type toggle
          Obx(
            () =>
                Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  currentSearchType.value = SearchType.fullName,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      currentSearchType.value ==
                                          SearchType.fullName
                                      ? AppColors.primaryColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow:
                                      currentSearchType.value ==
                                          SearchType.fullName
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primaryColor
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person_outline_rounded,
                                      size: 16,
                                      color:
                                          currentSearchType.value ==
                                              SearchType.fullName
                                          ? Colors.white
                                          : Colors.grey[600],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Full Name',
                                      style: GoogleFonts.poppins(
                                        color:
                                            currentSearchType.value ==
                                                SearchType.fullName
                                            ? Colors.white
                                            : Colors.grey[600],
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  currentSearchType.value = SearchType.raceName,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      currentSearchType.value ==
                                          SearchType.raceName
                                      ? AppColors.primaryColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow:
                                      currentSearchType.value ==
                                          SearchType.raceName
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primaryColor
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.emoji_events_outlined,
                                      size: 16,
                                      color:
                                          currentSearchType.value ==
                                              SearchType.raceName
                                          ? Colors.white
                                          : Colors.grey[600],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Race Name',
                                      style: GoogleFonts.poppins(
                                        color:
                                            currentSearchType.value ==
                                                SearchType.raceName
                                            ? Colors.white
                                            : Colors.grey[600],
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 400.ms)
                    .slideY(begin: 0.2, end: 0, duration: 500.ms),
          ),

          const SizedBox(height: 16),

          // Search input
          Obx(
            () =>
                CustomTextField(
                      controller: _searchController,
                      labelText: currentSearchType.value == SearchType.fullName
                          ? 'Type participant name...'
                          : 'Type race name...',
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

          // Results count
          if (searchQuery.value.isNotEmpty)
            Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${filteredRegistrations.length} result${filteredRegistrations.length != 1 ? 's' : ''}',
                          style: GoogleFonts.poppins(
                            color: AppColors.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(delay: 200.ms)
                .slideX(begin: -0.2, end: 0, duration: 400.ms),
        ],
      ),
    ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.2, end: 0, duration: 800.ms);
  }

  Widget _buildSliverContent() {
    return SliverToBoxAdapter(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Padding(padding: EdgeInsets.all(24), child: CardLoad());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child:
                ApiFailureWidget(
                      onRetry: () {
                        controller.errorMessage.value = "";
                        controller.fetchRegisteredRacesByUserId(
                          '688c49c5b93594ab91cb1d1f',
                        );
                      },
                    )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .scale(begin: const Offset(0.9, 0.9), duration: 400.ms),
          );
        }

        final filteredRaces = filteredRegistrations;

        if (controller.registeredRaces.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child:
                EmptyStateWidget(
                      icon: CustomIcons.searchNotFound,
                      title: 'No Registered Races',
                      description: 'You haven\'t registered for any races yet.',
                    )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scale(begin: const Offset(0.8, 0.8), duration: 600.ms),
          );
        }

        if (filteredRaces.isEmpty && searchQuery.value.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child:
                EmptyStateWidget(
                      icon: CustomIcons.searchNotFound,
                      title: 'No Results Found',
                      description:
                          currentSearchType.value == SearchType.fullName
                          ? 'No registrations found for "${searchQuery.value}"'
                          : 'No races found matching "${searchQuery.value}"',
                    )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .scale(begin: const Offset(0.8, 0.8), duration: 400.ms),
          );
        }

        return RefreshIndicator(
          color: AppColors.primaryColor,
          backgroundColor: Colors.white,
          strokeWidth: 3,
          onRefresh: () =>
              controller.refreshRegisteredRaces('688c49c5b93594ab91cb1d1f'),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            itemCount: filteredRaces.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final registration = filteredRaces[index];
              return RegistrationCard(
                    registration: registration,
                    onTap: () {
                      DevLogs(
                        "Tapped on registration: ${registration.registrationNumber}",
                      );
                      Get.toNamed(
                        RoutesHelper.registrationDetailsPage,
                        arguments: registration,
                      );
                      // Handle card tap if needed
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
            },
          ),
        );
      }),
    );
  }
}
