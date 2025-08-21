import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mrpace/core/utils/pallete.dart';

import '../../models/coaching_course_model.dart';

class CoachingCourseCard extends StatelessWidget {
  final CoachingCourseModel course;
  final VoidCallback? onTap;
  final VoidCallback? onRegister;
  final VoidCallback? onShare;

  const CoachingCourseCard({
    Key? key,
    required this.course,
    this.onTap,
    this.onRegister,
    this.onShare,
  }) : super(key: key);

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
🏃‍♂️ *${course.title ?? 'Coaching Course'}* 🏃‍♀️

${course.description != null && course.description!.isNotEmpty ? '📝 ${course.description}\n' : ''}
👨‍🏫 *Coach:* ${course.coach?.userName ?? 'Expert Coach'}
📅 *Date:* ${course.date != null ? DateFormat('MMM dd, yyyy').format(course.date!) : 'To be announced'}
⏰ *Duration:* ${course.durationInHours ?? 'N/A'} hours
📍 *Location:* ${course.location ?? 'Online'}
💰 *Price:* \$${course.price?.toStringAsFixed(0) ?? 'Free'}
🎯 *Level:* ${course.difficultyLevel ?? 'All levels'}

📲 *Download the MrPace app to register!*
👉 Play Store: https://play.google.com/store/apps/details?id=com.mrpace.app

${course.platformLink != null ? '🔗 Join here: ${course.platformLink}' : ''}
''';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onTap: onTap,
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
                  // Course Image
                  _buildCourseImage(),
                  const SizedBox(width: 12),

                  // Course Content
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
                                course.title ?? 'Untitled Course',
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

                        // Coach Name
                        if (course.coach?.userName != null) ...[
                          Text(
                            'Coach: ${course.coach!.userName!}',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.subtextColor,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                        ],

                        // Date and Duration Row
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: AppColors.primaryColor,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                course.date != null
                                    ? DateFormat(
                                        'MMM dd, yyyy',
                                      ).format(course.date!)
                                    : 'Date TBA',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (course.durationInHours != null) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.access_time,
                                color: AppColors.subtextColor,
                                size: 12,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${course.durationInHours}h',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.subtextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Bottom Row: Price and Register Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Price Display
                            Flexible(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  course.price != null
                                      ? '\$${course.price!.toStringAsFixed(0)}'
                                      : 'Free',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Register Button
                            Flexible(
                              flex: 3,
                              child: SizedBox(
                                height: 32,
                                child: ElevatedButton(
                                  onPressed: onRegister,
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
                                    'Register',
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

  Widget _buildCourseImage() {
    final imageUrl = course.coverImage != null && course.coverImage!.isNotEmpty
        ? course.coverImage
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
          Icon(Icons.school, color: AppColors.primaryColor, size: 24),
          const SizedBox(height: 2),
          Text(
            'Course',
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

  Widget _buildShareButton() {
    return GestureDetector(
      onTap: onShare ?? _shareToWhatsApp,
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
}
