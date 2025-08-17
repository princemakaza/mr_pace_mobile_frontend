import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/models/sports_news_model.dart';
import 'package:shimmer/shimmer.dart';

class SportNewsCard extends StatelessWidget {
  final SportNewsModel newsModel;
  final VoidCallback onTapToRead;

  const SportNewsCard({
    Key? key,
    required this.newsModel,
    required this.onTapToRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTapToRead,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              _buildImageSection(),
              
              // Content section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category chip
                    _buildCategoryChip(),
                    
                    const SizedBox(height: 12),
                    
                    // Title
                    _buildTitle(),
                    
                    const SizedBox(height: 16),
                    
                    // Read more button
                    _buildReadMoreButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate()
      .fadeIn(duration: 600.ms, curve: Curves.easeOutQuart)
      .slideY(begin: 0.3, end: 0, duration: 600.ms, curve: Curves.easeOutQuart)
      .scale(begin: const Offset(0.95, 0.95), duration: 400.ms, curve: Curves.easeOutBack);
  }

  Widget _buildImageSection() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(14),
        topRight: Radius.circular(14),
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: newsModel.imageUrl != null && newsModel.imageUrl!.isNotEmpty
            ? Image.network(
                newsModel.imageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child.animate()
                      .fadeIn(duration: 300.ms)
                      .scale(begin: const Offset(1.1, 1.1), duration: 300.ms);
                  }
                  return _buildShimmerPlaceholder();
                },
                errorBuilder: (context, error, stackTrace) {
                  return _buildErrorPlaceholder();
                },
              )
            : _buildErrorPlaceholder(),
      ),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: AppColors.borderColor,
      highlightColor: AppColors.surfaceColor,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.borderColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.borderColor.withOpacity(0.3),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getCategoryIcon(),
            size: 48,
            color: AppColors.primaryColor.withOpacity(0.6),
          ).animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 2000.ms, color: AppColors.primaryColor),
          const SizedBox(height: 8),
          Text(
            'Sport News',
            style: TextStyle(
              color: AppColors.subtextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip() {
    final categoryData = _getCategoryData();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: categoryData['color'],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            categoryData['icon'],
            size: 14,
            color: AppColors.surfaceColor,
          ),
          const SizedBox(width: 6),
          Text(
            newsModel.category ?? 'Other',
            style: const TextStyle(
              color: AppColors.surfaceColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(delay: 200.ms, duration: 400.ms)
      .slideX(begin: -0.3, end: 0, duration: 400.ms, curve: Curves.easeOutBack);
  }

  Widget _buildTitle() {
    return Text(
      newsModel.title ?? 'Untitled News',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textColor,
        height: 1.3,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    ).animate()
      .fadeIn(delay: 300.ms, duration: 500.ms)
      .slideY(begin: 0.5, end: 0, duration: 500.ms, curve: Curves.easeOutQuart);
  }

  Widget _buildReadMoreButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTapToRead,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.surfaceColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Read More',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_rounded,
              size: 18,
            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
              .moveX(begin: 0, end: 4, duration: 1000.ms, curve: Curves.easeInOut),
          ],
        ),
      ),
    ).animate()
      .fadeIn(delay: 400.ms, duration: 500.ms)
      .slideY(begin: 0.5, end: 0, duration: 500.ms, curve: Curves.easeOutBack)
      .then()
      .shimmer(delay: 2000.ms, duration: 1500.ms, color: AppColors.accentColor.withOpacity(0.3));
  }

  Map<String, dynamic> _getCategoryData() {
    final category = newsModel.category?.toLowerCase() ?? 'other';
    
    switch (category) {
      case 'football':
        return {
          'icon': Icons.sports_soccer,
          'color': AppColors.primaryColor,
        };
      case 'cricket':
        return {
          'icon': Icons.sports_cricket,
          'color': AppColors.successColor,
        };
      case 'basketball':
        return {
          'icon': Icons.sports_basketball,
          'color': AppColors.warningColor,
        };
      case 'rugby':
        return {
          'icon': Icons.sports_rugby,
          'color': AppColors.secondaryColor,
        };
      case 'tennis':
        return {
          'icon': Icons.sports_tennis,
          'color': AppColors.accentColor,
        };
      case 'athletics':
        return {
          'icon': Icons.directions_run,
          'color': AppColors.primaryColor.withOpacity(0.8),
        };
      case 'boxing':
        return {
          'icon': Icons.sports_mma,
          'color': AppColors.errorColor,
        };
      case 'formula 1':
        return {
          'icon': Icons.directions_car,
          'color': AppColors.textColor,
        };
      case 'golf':
        return {
          'icon': Icons.sports_golf,
          'color': AppColors.successColor.withOpacity(0.8),
        };
      default:
        return {
          'icon': Icons.sports,
          'color': AppColors.subtextColor,
        };
    }
  }

  IconData _getCategoryIcon() {
    final category = newsModel.category?.toLowerCase() ?? 'other';
    
    switch (category) {
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
}