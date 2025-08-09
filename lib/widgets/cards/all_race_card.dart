import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/models/all_races_model.dart';

class AllRacesCard extends StatelessWidget {
  final AllRacesModel race;
  final VoidCallback? onRegisterPressed;

  const AllRacesCard({Key? key, required this.race, this.onRegisterPressed})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              _buildImageSection(),

              // Content Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Status in one row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildTitleSection()),
                        _buildStatusBadge(),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Venue with full width
                    _buildVenueSection(),
                    const SizedBox(height: 12),

                    // Date and Price row
                    _buildBottomInfoRow(),
                    const SizedBox(height: 16),

                    // Register Button
                    _buildRegisterButton(context),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms, curve: Curves.easeOutQuart)
        .slideY(
          begin: 0.3,
          end: 0,
          duration: 600.ms,
          curve: Curves.easeOutQuart,
        )
        .shimmer(delay: 300.ms, duration: 1000.ms);
  }

  Widget _buildImageSection() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryColor.withOpacity(0.8),
            AppColors.primaryColor.withOpacity(0.6),
          ],
        ),
      ),
      child: Stack(
        children: [
          if (race.image != null && race.image!.isNotEmpty)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  race.image!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.directions_run,
                      size: 60,
                      color: AppColors.primaryColor.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),

          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
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

          if (race.raceEvents != null && race.raceEvents!.isNotEmpty)
            Positioned(
              bottom: 12,
              left: 12,
              child:
                  Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.event,
                              size: 14,
                              color: AppColors.primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${race.raceEvents!.length} Events',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 400.ms)
                      .slideX(begin: -0.3, end: 0, duration: 400.ms),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color badgeColor = AppColors.successColor;
    String status = race.registrationStatus ?? 'Unknown';

    if (status.toLowerCase() == 'closed') {
      badgeColor = AppColors.errorColor;
    } else if (status.toLowerCase() == 'opening soon') {
      badgeColor = AppColors.warningColor;
    }

    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: badgeColor.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            status.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 500.ms)
        .scale(begin: const Offset(0.8, 0.8), duration: 300.ms);
  }

  Widget _buildTitleSection() {
    return Text(
          race.name ?? 'Race Name',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        )
        .animate()
        .fadeIn(delay: 200.ms)
        .slideX(begin: -0.2, end: 0, duration: 400.ms);
  }

  Widget _buildVenueSection() {
    return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.location_on,
                size: 16,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VENUE',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.subtextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    race.venue ?? 'To be announced',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(delay: 400.ms)
        .slideY(begin: 0.3, end: 0, duration: 400.ms);
  }

  Widget _buildBottomInfoRow() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoItem(
            icon: Icons.calendar_today,
            label: 'DATE',
            value: race.date != null
                ? DateFormat('MMM dd, yyyy').format(race.date!)
                : 'TBA',
          ),
        ),
        if (race.registrationPrice != null)
          Expanded(
            child: _buildInfoItem(
              icon: Icons.attach_money,
              label: 'PRICE',
              value: '\$${race.registrationPrice}',
            ),
          ),
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: AppColors.primaryColor),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.subtextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    bool isRegistrationOpen = race.registrationStatus?.toLowerCase() == 'open';

    return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isRegistrationOpen ? onRegisterPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isRegistrationOpen
                  ? AppColors.primaryColor
                  : AppColors.subtextColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: isRegistrationOpen ? 4 : 0,
              shadowColor: AppColors.primaryColor.withOpacity(0.3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isRegistrationOpen ? Icons.app_registration : Icons.lock,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  isRegistrationOpen ? 'REGISTER NOW' : 'REGISTRATION CLOSED',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 600.ms)
        .slideY(begin: 0.5, end: 0, duration: 500.ms)
        .shimmer(delay: 1000.ms, duration: 2000.ms);
  }
}
