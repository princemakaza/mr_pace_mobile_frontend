import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/registration_management/screens/race_registration_dialog.dart';
import 'package:mrpace/models/all_races_model.dart';

class RaceDetailsScreen extends StatefulWidget {
  final AllRacesModel race;

  const RaceDetailsScreen({Key? key, required this.race}) : super(key: key);

  @override
  State<RaceDetailsScreen> createState() => _RaceDetailsScreenState();
}

class _RaceDetailsScreenState extends State<RaceDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController _scrollController;
  late AnimationController _fabController;
  late ScrollController _pageScrollController;

  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _pageScrollController = ScrollController();

    _pageScrollController.addListener(_onScroll);

    // Trigger FAB animation after screen loads
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) _fabController.forward();
    });
  }

  void _onScroll() {
    if (_pageScrollController.offset > 100 && !_isScrolled) {
      setState(() => _isScrolled = true);
      _scrollController.forward();
    } else if (_pageScrollController.offset <= 100 && _isScrolled) {
      setState(() => _isScrolled = false);
      _scrollController.reverse();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fabController.dispose();
    _pageScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        controller: _pageScrollController,
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildRaceOverview(),
                _buildDescriptionSection(),
                _buildRaceEventsSection(),
                _buildVenueSection(),
                _buildRegistrationSection(),

                const SizedBox(height: 100), // Space for FAB
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primaryColor,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ).animate().fadeIn(delay: 500.ms).scale(begin: const Offset(0.8, 0.8)),
      flexibleSpace: FlexibleSpaceBar(
        background: _buildHeroSection(),
        title: AnimatedBuilder(
          animation: _scrollController,
          builder: (context, child) {
            return Opacity(
              opacity: _isScrolled ? 1.0 : 0.0,
              child: Text(
                widget.race.name ?? 'Race Details',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
        titlePadding: const EdgeInsets.only(left: 72, bottom: 16),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.8),
            AppColors.secondaryColor.withOpacity(0.3),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background Image
          if (widget.race.image != null && widget.race.image!.isNotEmpty)
            Positioned.fill(
              child: Opacity(
                opacity: 0.4,
                child: Image.network(
                  widget.race.image!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    DevLogs.logError('Background image error: $error');
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryColor.withOpacity(0.1),
                            AppColors.secondaryColor.withOpacity(0.1),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.primaryColor.withOpacity(0.7),
                ],
              ),
            ),
          ),

          // Content
          Positioned(
            bottom: 80,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusBadge()
                    .animate()
                    .fadeIn(delay: 300.ms)
                    .slideX(begin: -0.3, end: 0),
                const SizedBox(height: 16),
                Text(
                  widget.race.name ?? 'Race Name',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0),
                const SizedBox(height: 8),
                if (widget.race.date != null)
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        color: Colors.white.withOpacity(0.9),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat(
                          'EEEE, MMMM dd, yyyy',
                        ).format(widget.race.date!),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.2, end: 0),
              ],
            ),
          ),

          // Floating Elements
          _buildFloatingElements(),
        ],
      ),
    );
  }

  Widget _buildFloatingElements() {
    return Stack(
      children: [
        Positioned(
          top: 60,
          right: -20,
          child:
              Container(
                    width: 80,
                    height: 80,
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
        Positioned(
          bottom: 200,
          left: -30,
          child:
              Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accentColor.withOpacity(0.2),
                    ),
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .scale(
                    duration: 2500.ms,
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.3, 1.3),
                  ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    Color badgeColor = AppColors.successColor;
    String status = widget.race.registrationStatus ?? 'Unknown';

    if (status.toLowerCase() == 'closed') {
      badgeColor = AppColors.errorColor;
    } else if (status.toLowerCase() == 'opening soon') {
      badgeColor = AppColors.warningColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'REGISTRATION ${status.toUpperCase()}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRaceOverview() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Race Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.3, end: 0),

          const SizedBox(height: 10),

          _buildOverviewGrid(),
        ],
      ),
    );
  }

  Widget _buildOverviewGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildOverviewItem(
                icon: Icons.event_available_rounded,
                label: 'Race Events',
                value: '${widget.race.raceEvents?.length ?? 0} Events',
                delay: 900.ms,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildOverviewItem(
                icon: Icons.attach_money_rounded,
                label: 'Registration',
                value: widget.race.registrationPrice != null
                    ? '\$${widget.race.registrationPrice}'
                    : 'Free',
                delay: 800.ms,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverviewItem({
    required IconData icon,
    required String label,
    required String value,
    required Duration delay,
  }) {
    return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderColor, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: AppColors.primaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.subtextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: delay)
        .slideY(begin: 0.3, end: 0, duration: 500.ms);
  }

  Widget _buildDescriptionSection() {
    if (widget.race.description == null || widget.race.description!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.description_rounded,
                      color: AppColors.secondaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'About This Race',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                widget.race.description!,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textColor,
                  height: 1.6,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 1100.ms)
        .slideY(begin: 0.3, end: 0, duration: 600.ms);
  }

  Widget _buildRaceEventsSection() {
    if (widget.race.raceEvents == null || widget.race.raceEvents!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.sports_score_rounded,
                      color: AppColors.accentColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Race Events',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...widget.race.raceEvents!.asMap().entries.map((entry) {
                int index = entry.key;
                RaceEvent event = entry.value;
                return _buildRaceEventCard(event, index);
              }).toList(),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 1200.ms)
        .slideY(begin: 0.3, end: 0, duration: 600.ms);
  }

  Widget _buildRaceEventCard(RaceEvent event, int index) {
    return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.distanceRace ?? 'Distance Race',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                    if (event.reachLimit != null)
                      Text(
                        'Limit: ${event.reachLimit}',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.subtextColor,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.primaryColor,
                size: 16,
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 1300 + (index * 100)))
        .slideX(begin: 0.3, end: 0, duration: 500.ms);
  }

  Widget _buildVenueSection() {
    if (widget.race.venue == null || widget.race.venue!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.place_rounded,
                      color: AppColors.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Venue Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: AppColors.primaryColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.race.venue!,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.directions_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 1600.ms)
        .slideY(begin: 0.3, end: 0, duration: 600.ms);
  }

  Widget _buildRegistrationSection() {
    return Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryColor.withOpacity(0.1),
                AppColors.secondaryColor.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.app_registration_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Registration',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Registration Fee',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.subtextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.race.registrationPrice != null
                              ? '\$${widget.race.registrationPrice}'
                              : 'Free',
                          style: TextStyle(
                            fontSize: 24,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _getStatusColor(), width: 1.5),
                    ),
                    child: Text(
                      widget.race.registrationStatus?.toUpperCase() ??
                          'UNKNOWN',
                      style: TextStyle(
                        color: _getStatusColor(),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 1700.ms)
        .slideY(begin: 0.3, end: 0, duration: 600.ms);
  }

  Color _getStatusColor() {
    String status = widget.race.registrationStatus?.toLowerCase() ?? '';
    if (status == 'open') return AppColors.successColor;
    if (status == 'closed') return AppColors.errorColor;
    if (status == 'opening soon') return AppColors.warningColor;
    return AppColors.subtextColor;
  }

  Widget _buildFloatingActionButton() {
    bool isRegistrationOpen =
        widget.race.registrationStatus?.toLowerCase() == 'open';

    return AnimatedBuilder(
      animation: _fabController,
      builder: (context, child) {
        return Transform.scale(
          scale: _fabController.value,
          child: Container(
            width: MediaQuery.of(context).size.width - 48,
            height: 45,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isRegistrationOpen
                    ? [
                        AppColors.primaryColor,
                        AppColors.primaryColor.withOpacity(0.8),
                      ]
                    : [
                        AppColors.subtextColor,
                        AppColors.subtextColor.withOpacity(0.8),
                      ],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color:
                      (isRegistrationOpen
                              ? AppColors.primaryColor
                              : AppColors.subtextColor)
                          .withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: isRegistrationOpen
                    ? () {
                        // Handle registration
                        Get.dialog(
                          RaceRegistrationDialog(raceModel: widget.race),
                        );
                      }
                    : null,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isRegistrationOpen
                              ? Icons.app_registration
                              : Icons.lock,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        isRegistrationOpen
                            ? 'REGISTER NOW'
                            : 'REGISTRATION CLOSED',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ).animate().shimmer(delay: 2000.ms, duration: 2000.ms),
        );
      },
    );
  }
}
