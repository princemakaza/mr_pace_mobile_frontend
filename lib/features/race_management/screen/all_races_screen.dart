import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrpace/config/routers/router.dart';
import 'package:mrpace/core/constants/icon_asset_constants.dart';
import 'package:mrpace/core/constants/image_asset_constants.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/models/all_races_model.dart';
import 'package:mrpace/widgets/cards/all_race_card.dart';
import 'package:mrpace/widgets/empty_widget/empty_state_empty.dart';
import 'package:mrpace/widgets/error_widgets/error.dart';
import 'package:mrpace/widgets/loading_widgets/vehicle_loader.dart';
import 'package:mrpace/widgets/text_fields/custom_text_field.dart';

import '../controller/race_controller.dart';

class AllRacesScreen extends StatefulWidget {
  const AllRacesScreen({super.key});

  @override
  State<AllRacesScreen> createState() => _AllRacesScreenState();
}

class _AllRacesScreenState extends State<AllRacesScreen>
    with TickerProviderStateMixin {
  final raceController = Get.find<RaceController>();
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _headerAnimationController;
  late AnimationController _searchAnimationController;

  bool _isSearchFocused = false;
  bool _searchByLocation = false; // Toggle between name and location search

  @override
  void initState() {
    super.initState();
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      raceController.getAllRaces();
      _headerAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _headerAnimationController.dispose();
    _searchAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primaryColor,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeaderBackground(),
              titlePadding: EdgeInsets.zero,
              title: null,
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(140),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    _buildTitleSection(),
                    _buildSearchSection(),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: _buildBody(),
      ),
    );
  }

  Widget _buildHeaderBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.8),
            AppColors.secondaryColor.withOpacity(0.1),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 20,
            right: -30,
            child:
                Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .scale(
                      duration: 3000.ms,
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1.2, 1.2),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Text(
                'All Races',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              )
              .animate()
              .fadeIn(delay: 200.ms)
              .slideX(begin: -0.3, end: 0, duration: 600.ms),
          const Spacer(),
          Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              )
              .animate()
              .fadeIn(delay: 600.ms)
              .scale(begin: const Offset(0.8, 0.8), duration: 400.ms),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child:
          Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Search input field
                    TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      onTap: () {
                        setState(() {
                          _isSearchFocused = true;
                        });
                        _searchAnimationController.forward();
                      },
                      onSubmitted: (_) {
                        setState(() {
                          _isSearchFocused = false;
                        });
                        _searchAnimationController.reverse();
                      },
                      decoration: InputDecoration(
                        hintText: _searchByLocation
                            ? 'Search races by location...'
                            : 'Search races by name...',
                        hintStyle: GoogleFonts.poppins(
                          color: AppColors.subtextColor,
                          fontSize: 14,
                        ),
                        prefixIcon: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            _searchByLocation
                                ? Icons.location_on_rounded
                                : Icons.search_rounded,
                            color: _isSearchFocused
                                ? AppColors.primaryColor
                                : AppColors.subtextColor,
                            size: 22,
                          ),
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear_rounded,
                                  color: AppColors.subtextColor,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        color: AppColors.textColor,
                        fontSize: 14,
                      ),
                    ),
                    // Search toggle section
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor.withOpacity(0.5),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Search by:',
                            style: GoogleFonts.poppins(
                              color: AppColors.subtextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _searchByLocation = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: !_searchByLocation
                                    ? AppColors.primaryColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: !_searchByLocation
                                      ? AppColors.primaryColor
                                      : AppColors.subtextColor.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                'Name',
                                style: GoogleFonts.poppins(
                                  color: !_searchByLocation
                                      ? Colors.white
                                      : AppColors.subtextColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _searchByLocation = true;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _searchByLocation
                                    ? AppColors.primaryColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _searchByLocation
                                      ? AppColors.primaryColor
                                      : AppColors.subtextColor.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                'Location',
                                style: GoogleFonts.poppins(
                                  color: _searchByLocation
                                      ? Colors.white
                                      : AppColors.subtextColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(delay: 400.ms)
              .slideY(begin: 0.3, end: 0, duration: 500.ms),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Obx(() {
        if (raceController.isLoading.value) {
          return const CardLoad();
        }

        if (raceController.errorMessage.isNotEmpty) {
          return ApiFailureWidget(
                onRetry: () {
                  raceController.errorMessage.value = "";
                  raceController.getAllRaces();
                },
              )
              .animate()
              .fadeIn(duration: 400.ms)
              .scale(begin: const Offset(0.9, 0.9), duration: 400.ms);
        }

        // Filter and sort races
        final filteredRaces = _filterAndSortRaces(raceController.races);

        return filteredRaces.isEmpty
            ? EmptyStateWidget(
                    icon: CustomIcons.searchNotFound,
                    title: 'No Races Found',
                    description:
                        'There are no races matching your search criteria.',
                  )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(begin: const Offset(0.8, 0.8), duration: 600.ms)
            : RefreshIndicator(
                color: AppColors.primaryColor,
                backgroundColor: AppColors.surfaceColor,
                strokeWidth: 3,
                onRefresh: () => raceController.refreshRaces(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: filteredRaces.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final race = filteredRaces[index];
                    return AllRacesCard(
                          race: race,
                          onRegisterPressed: () {
                            Get.toNamed(
                              RoutesHelper.raceDetailsPage,
                              arguments: race,
                            );
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

  List<AllRacesModel> _filterAndSortRaces(List<AllRacesModel> races) {
    // First filter by search text
    final searchText = _searchController.text.toLowerCase();
    List<AllRacesModel> filtered = races.where((race) {
      if (searchText.isEmpty) return true;

      if (_searchByLocation) {
        return race.venue?.toLowerCase().contains(searchText) ?? false;
      } else {
        return race.name!.toLowerCase().contains(searchText);
      }
    }).toList();

    // Then sort with "Open" status first
    filtered.sort((a, b) {
      if (a.registrationStatus == 'Open' && b.registrationStatus != 'Open')
        return -1;
      if (a.registrationPrice != 'Open' && b.registrationStatus == 'Open')
        return 1;
      return 0;
    });

    return filtered;
  }
}
