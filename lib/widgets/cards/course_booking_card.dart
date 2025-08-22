import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/payment_management/screens/course_booking_payment_screen.dart';
import '../../models/course_booking_model.dart';

class CourseBookingCard extends StatelessWidget {
  final CourseBookingModel booking;
  final VoidCallback? onTap;
  final VoidCallback? onRegister;

  const CourseBookingCard({
    Key? key,
    required this.booking,
    this.onTap,
    this.onRegister,
  }) : super(key: key);

  void _makePayment(BuildContext context) {
    Get.dialog(
      CourseBookingPayment(
        courseBookingPrice: booking.courseId!.price!.toString(),
        courseBookingId: booking.id!,
        courseName: booking.courseId!.title!,
      ),
    );
  }

  void _trackOrder(BuildContext context) {
    Get.snackbar(
      'Track Order',
      'Opening order tracking...',
      backgroundColor: AppColors.primaryColor,
      colorText: AppColors.surfaceColor,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  Color _getPaymentStatusColor() {
    switch (booking.paymentStatus?.toLowerCase()) {
      case 'completed':
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.subtextColor;
    }
  }

  String _getActionButtonText() {
    switch (booking.paymentStatus?.toLowerCase()) {
      case 'completed':
      case 'paid':
        return 'Track Order';
      case 'pending':
        return 'Make Payment';
      case 'failed':
        return 'Retry Payment';
      default:
        return 'View Details';
    }
  }

  void _handleActionButton(BuildContext context) {
    switch (booking.paymentStatus?.toLowerCase()) {
      case 'completed':
      case 'paid':
        _trackOrder(context);
        break;
      case 'pending':
      case 'failed':
        _makePayment(context);
        break;
      default:
        if (onRegister != null) onRegister!();
    }
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
                                booking.courseId?.title ?? 'Untitled Course',
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
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Payment Status
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getPaymentStatusColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _getPaymentStatusColor().withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            booking.paymentStatus ?? 'Unknown',
                            style: TextStyle(
                              fontSize: 10,
                              color: _getPaymentStatusColor(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

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
                                booking.courseId?.date != null
                                    ? DateFormat(
                                        'MMM dd, yyyy',
                                      ).format(booking.courseId!.date!)
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
                            if (booking.courseId?.durationInHours != null) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.access_time,
                                color: AppColors.subtextColor,
                                size: 12,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${booking.courseId!.durationInHours}h',
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

                        // Bottom Row: Price and Action Button
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
                                  booking.pricePaid != null
                                      ? '\$${booking.pricePaid!.toStringAsFixed(0)}'
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

                            // Action Button
                            Flexible(
                              flex: 3,
                              child: SizedBox(
                                height: 32,
                                child: ElevatedButton(
                                  onPressed: () => _handleActionButton(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _getActionButtonColor(),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 1,
                                  ),
                                  child: Text(
                                    _getActionButtonText(),
                                    style: const TextStyle(
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

  Color _getActionButtonColor() {
    switch (booking.paymentStatus?.toLowerCase()) {
      case 'completed':
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return AppColors.primaryColor;
    }
  }

  Widget _buildCourseImage() {
    final imageUrl =
        booking.courseId?.coverImage != null &&
            booking.courseId!.coverImage!.isNotEmpty
        ? booking.courseId!.coverImage
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
          Icon(Icons.book_online, color: AppColors.primaryColor, size: 24),
          const SizedBox(height: 2),
          Text(
            'Booking',
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
