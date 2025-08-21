import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrpace/features/course_booking_management/helpers/course_booking_helpers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/models/coaching_course_model.dart';

class CourseBookingDialog extends StatefulWidget {
  final CoachingCourseModel course;
  final String userId;
  final double price;

  const CourseBookingDialog({
    super.key,
    required this.course,
    required this.userId,
    required this.price,
  });

  @override
  State<CourseBookingDialog> createState() => _CourseBookingDialogState();
}

class _CourseBookingDialogState extends State<CourseBookingDialog>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _shareController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _shareController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shareController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _buildShareText() {
    String text = '🎓 Check out this coaching course!\n\n';
    text += '📚 ${widget.course.title ?? "Amazing Course"}\n\n';

    if (widget.course.description != null) {
      text += '📝 ${widget.course.description!}\n\n';
    }

    if (widget.course.coach?.userName != null) {
      text += '👨‍🏫 Coach: ${widget.course.coach!.userName!}\n';
    }

    if (widget.course.date != null) {
      text += '📅 Date: ${_formatDate(widget.course.date!)}\n';
    }

    if (widget.course.durationInHours != null) {
      text += '⏱️ Duration: ${widget.course.durationInHours} hours\n';
    }

    if (widget.course.location != null) {
      text += '📍 Location: ${widget.course.location!}\n';
    }

    if (widget.course.price != null) {
      text += '💰 Price: \$${widget.course.price!.toStringAsFixed(2)}\n';
    }

    text += '\n📱 Download MrPace app for more courses:\n';
    text += 'https://mrpace.app/download';

    return text;
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Course details copied to clipboard!'),
        backgroundColor: AppColors.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    Navigator.pop(context);
  }

  void _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        Navigator.pop(context);
      } else {
        _showErrorSnackBar('Could not launch URL');
      }
    } catch (e) {
      _showErrorSnackBar('Error launching URL');
    }
  }

  void _showErrorSnackBar(String message) {
    Get.snackbar(
      'Error',
      message,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      backgroundColor: AppColors.primaryColor,
    );
  }

  void _handleBooking() async {
    // Initialize the controller if not already done

    final courseBookingRegister = CourseBookingRegister();

    try {
      final success = await courseBookingRegister.submitCourseBooking(
        widget.userId,
        widget.course.id ??
            '', // Make sure your CoachingCourseModel has an id field
        widget.price,
        courseName: widget.course.title,
      );

      if (!success) {
        _showErrorSnackBar(
          'Failed to submit course booking. Please try again.',
        );
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred while booking the course.');
    }
  }

  void _showShareOptions() {
    _shareController.forward();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ).animate().scale(delay: 100.ms),
            const SizedBox(height: 20),
            Text(
              'Share Course',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(
                  icon: Icons.copy,
                  label: 'Copy',
                  onTap: () => _copyToClipboard(_buildShareText()),
                  delay: 300,
                ),
                _buildShareOption(
                  icon: Icons.share,
                  label: 'Share',
                  onTap: () {
                    // Implement native sharing if needed
                    _copyToClipboard(_buildShareText());
                  },
                  delay: 400,
                ),
                _buildShareOption(
                  icon: Icons.link,
                  label: 'Open Link',
                  onTap: () => _launchUrl('https://mrpace.app/download'),
                  delay: 500,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required int delay,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.3),
              ),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    ).animate().scale(delay: Duration(milliseconds: delay));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.bottomCenter,
      insetPadding: EdgeInsets.zero,
      shadowColor: Colors.grey.withOpacity(0.2),
      child: Container(
        width: double.maxFinite,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar at the top
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ).animate().scale(delay: 100.ms),

            // Header with close button
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Course Booking',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.borderColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.close,
                        color: AppColors.textColor,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().slideY(begin: -0.5, duration: 600.ms),

            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Course Info Card with Gradient
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primaryColor.withOpacity(0.1),
                            AppColors.primaryColor.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primaryColor.withOpacity(0.2),
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
                                child: Icon(
                                  Icons.school,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.course.title ?? 'Course Title',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Price with animation
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.successColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.successColor.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Course Price:',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColor,
                                  ),
                                ),
                                AnimatedBuilder(
                                  animation: _pulseController,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale:
                                          1.0 + (_pulseController.value * 0.1),
                                      child: Text(
                                        '\$${widget.price.toStringAsFixed(2)}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.successColor,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().slideX(begin: 0.3, duration: 800.ms),

                    const SizedBox(height: 24),

                    // Registration Message
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.person_add,
                            size: 48,
                            color: AppColors.primaryColor,
                          ).animate().scale(delay: 600.ms, duration: 500.ms),
                          const SizedBox(height: 16),
                          Text(
                            'Ready to Register?',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColor,
                            ),
                          ).animate().fadeIn(delay: 700.ms),
                          const SizedBox(height: 8),
                          Text(
                            'Would you like to register for this course at a price of \$${widget.price.toStringAsFixed(2)}?',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors.subtextColor,
                              height: 1.5,
                            ),
                          ).animate().fadeIn(delay: 800.ms),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child:
                              GestureDetector(
                                onTap: _showShareOptions,
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.cardColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.share,
                                        color: AppColors.primaryColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Share Course',
                                        style: GoogleFonts.poppins(
                                          color: AppColors.primaryColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ).animate().slideX(
                                begin: -0.3,
                                delay: 900.ms,
                                duration: 600.ms,
                              ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child:
                              GestureDetector(
                                    onTap: _handleBooking,
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.primaryColor,
                                            AppColors.primaryColor.withOpacity(
                                              0.8,
                                            ),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primaryColor
                                                .withOpacity(0.4),
                                            spreadRadius: 1,
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Book Now',
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .animate()
                                  .slideX(
                                    begin: 0.3,
                                    delay: 1000.ms,
                                    duration: 600.ms,
                                  )
                                  .then()
                                  .shimmer(
                                    duration: 2000.ms,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: AppColors.primaryColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.subtextColor,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
