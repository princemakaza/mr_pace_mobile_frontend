import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/payment_management/helpers/payment_helpers.dart';
import 'package:mrpace/features/payment_management/screens/training_package_buy_coffee.dart';
import 'package:mrpace/features/training_package_management/helpers/training_package_helper.dart';
import 'package:mrpace/models/training_package_model.dart';
import 'package:url_launcher/url_launcher.dart';

class TrainingPackageCard extends StatefulWidget {
  final TrainingProgramPackage package;
  final String userId;
  final VoidCallback? onTap;
  final VoidCallback? onProceedToPayment;
  final VoidCallback? onShare;

  const TrainingPackageCard({
    Key? key,
    required this.package,
    this.onTap,
    this.onProceedToPayment,
    this.onShare,
    required this.userId,
  }) : super(key: key);

  @override
  State<TrainingPackageCard> createState() => _TrainingPackageCardState();
}

class _TrainingPackageCardState extends State<TrainingPackageCard> {
  final TrainingPackageHelper _trainingPackageHelper = TrainingPackageHelper();
  // Initialize helper
  Future<void> _shareToWhatsApp() async {
    final message = _buildWhatsAppMessage();
    final encodedMessage = Uri.encodeComponent(message);
    final whatsappUrl = 'https://wa.me/?text=$encodedMessage';

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch WhatsApp';
    }
  }

  String _buildWhatsAppMessage() {
    return '''
🏋️‍♂️ *${widget.package.title ?? 'Premium Training Program'}* 💪

${widget.package.description != null && widget.package.description!.isNotEmpty ? '📝 ${widget.package.description}\n' : ''}
👨‍🏫 *Coach:* ${widget.package.coach?.userName ?? 'Expert Coach'}
📅 *Duration:* ${widget.package.durationInWeeks ?? 'N/A'} weeks
🎯 *Level:* ${widget.package.difficultyLevel ?? 'All levels'}
🏃‍♀️ *Target Race:* ${widget.package.targetRaceType ?? 'General Fitness'}

📲 *To view more details and unlock this premium training program, download the MrPace app!*
👉 Play Store: https://play.google.com/store/apps/details?id=com.mrpace.app

🚀 Start your fitness journey today!
''';
  }

  void _showSeeMoreModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceColor,
      isScrollControlled: true, // Added this to make the sheet scrollable
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            // Wrapped with SingleChildScrollView
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Training Package Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primaryColor.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.package.title ?? 'Premium Training Program',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (widget.package.coach?.userName != null) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: AppColors.primaryColor,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Coach: ${widget.package.coach!.userName!}',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.subtextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                      if (widget.package.durationInWeeks != null) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              color: AppColors.primaryColor,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Duration: ${widget.package.durationInWeeks} weeks',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.subtextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Coffee Message
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Text('☕', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Buy Coffee for Coach',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'To view more details and unlock this premium training program, please support our coach!',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.subtextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.primaryColor),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Maybe Later',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () async {
                          await _trainingPackageHelper.submitTrainingPackage(
                            userId: widget.userId,
                            pricePaid: widget.package.price!,
                            trainingPackageId: widget.package.id!,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Proceed to Buy',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onTap: widget.onTap,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: AppColors.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryColor, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Package Image
                  _buildPackageImage(),
                  const SizedBox(width: 12),

                  // Package Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title and Share Button Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.package.title ??
                                    'Untitled Training Program',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textColor,
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildShareButton(),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Description
                        if (widget.package.description != null &&
                            widget.package.description!.isNotEmpty) ...[
                          Text(
                            widget.package.description!,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.subtextColor,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                        ],

                        // Coach Name
                        if (widget.package.coach?.userName != null) ...[
                          Text(
                            'Coach: ${widget.package.coach!.userName!}',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.subtextColor,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                        ],

                        // Duration and Difficulty Row
                        Row(
                          children: [
                            if (widget.package.durationInWeeks != null) ...[
                              Icon(
                                Icons.schedule,
                                color: AppColors.primaryColor,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.package.durationInWeeks}w',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                            if (widget.package.durationInWeeks != null &&
                                widget.package.difficultyLevel != null) ...[
                              const SizedBox(width: 12),
                            ],
                            if (widget.package.difficultyLevel != null) ...[
                              Icon(
                                Icons.fitness_center,
                                color: AppColors.subtextColor,
                                size: 12,
                              ),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  widget.package.difficultyLevel!,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.subtextColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Bottom Row: Price and See More Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Price Display
                            const SizedBox(width: 12),

                            // See More Button
                            Flexible(
                              flex: 3,
                              child: SizedBox(
                                height: 32,
                                child: ElevatedButton(
                                  onPressed: () => _showSeeMoreModal(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 1,
                                  ),
                                  child: const Text(
                                    'See More',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
        .fadeIn(duration: 600.ms, curve: Curves.easeOutQuart)
        .slideX(
          begin: 0.1,
          end: 0,
          duration: 600.ms,
          curve: Curves.easeOutQuart,
        );
  }

  Widget _buildPackageImage() {
    final imageUrl =
        widget.package.coverImage != null &&
            widget.package.coverImage!.isNotEmpty
        ? widget.package.coverImage
        : null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryColor.withOpacity(0.1),
              AppColors.primaryColor.withOpacity(0.05),
            ],
          ),
        ),
        child: imageUrl != null
            ? Image.network(
                imageUrl!,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: LoadingAnimationWidget.threeArchedCircle(
                      color: AppColors.primaryColor,
                      size: 16,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderIcon();
                },
              )
            : _buildPlaceholderIcon(),
      ),
    );
  }

  Widget _buildShareButton() {
    return GestureDetector(
      onTap: _shareToWhatsApp,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(Icons.share, color: AppColors.primaryColor, size: 14),
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor.withOpacity(0.15),
            AppColors.primaryColor.withOpacity(0.08),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fitness_center, color: AppColors.primaryColor, size: 24),
          const SizedBox(height: 2),
          Text(
            'Training',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 8,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
