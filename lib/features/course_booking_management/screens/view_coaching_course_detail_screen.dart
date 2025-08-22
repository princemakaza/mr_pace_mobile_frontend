import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/payment_management/screens/course_booking_payment_screen.dart';
import 'package:mrpace/features/payment_management/services/payment_services.dart';
import 'package:mrpace/models/course_booking_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewCourseBookingDetailsScreen extends StatefulWidget {
  final CourseBookingModel booking;

  const ViewCourseBookingDetailsScreen({Key? key, required this.booking})
    : super(key: key);

  @override
  State<ViewCourseBookingDetailsScreen> createState() =>
      _ViewCourseBookingDetailsScreenState();
}

class _ViewCourseBookingDetailsScreenState
    extends State<ViewCourseBookingDetailsScreen>
    with TickerProviderStateMixin {
  bool _isImageLoaded = false;
  bool _imageHasError = false;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _checkPaymentStatusCourseId();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    // Pre-load the image if it exists
    if (widget.booking.courseId?.coverImage != null) {
      _preloadImage();
    }
  }

  void _checkPaymentStatusCourseId() {
    if (widget.booking.pollUrl != null && widget.booking.id != null) {
      // We don't await this call and don't care about the response
      PaymentService.checkCoursePaymentStatus(
        pollUrl: widget.booking.pollUrl!,
        courseBookingId: widget.booking.id!,
      ).catchError((e) {
        // Ignore any errors
        DevLogs.logError('Payment status check error (ignored): $e');
      });
    }
  }

  void _preloadImage() {
    if (widget.booking.courseId?.coverImage != null) {
      final imageProvider = NetworkImage(widget.booking.courseId!.coverImage!);

      imageProvider
          .resolve(const ImageConfiguration())
          .addListener(
            ImageStreamListener(
              (ImageInfo info, bool synchronousCall) {
                if (mounted) {
                  setState(() {
                    _isImageLoaded = true;
                    _imageHasError = false;
                  });
                }
              },
              onError: (dynamic exception, StackTrace? stackTrace) {
                if (mounted) {
                  setState(() {
                    _isImageLoaded = false;
                    _imageHasError = true;
                  });
                }
              },
            ),
          );
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  Color _getPaymentStatusColor() {
    switch (widget.booking.paymentStatus?.toLowerCase()) {
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
    switch (widget.booking.paymentStatus?.toLowerCase()) {
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

  Color _getActionButtonColor() {
    switch (widget.booking.paymentStatus?.toLowerCase()) {
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

  void _handleActionButton() {
    switch (widget.booking.paymentStatus?.toLowerCase()) {
      case 'completed':
      case 'paid':
        _trackOrder();
        break;
      case 'pending':
      case 'failed':
        _makePayment();
        break;
      default:
        _showBookingDetails();
    }
  }

  void _makePayment() {
    Get.dialog(
      CourseBookingPayment(
        courseBookingPrice: widget.booking.courseId!.price!.toString(),
        courseBookingId: widget.booking.id!,
        courseName: widget.booking.courseId!.title!,
      ),
    );
  }

  void _trackOrder() {
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

  void _showBookingDetails() {
    _showSuccessSnackBar('Viewing booking details...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBookingHeader()
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 100.ms)
                      .slideX(begin: -0.3, end: 0),
                  const SizedBox(height: 20),
                  _buildCourseDetails()
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 200.ms)
                      .slideY(begin: 0.3, end: 0),
                  const SizedBox(height: 20),
                  _buildBookingInfo()
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 300.ms)
                      .slideX(begin: 0.3, end: 0),
                  const SizedBox(height: 20),
                  _buildLocationAndPlatform()
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 400.ms)
                      .slideY(begin: 0.3, end: 0),
                  const SizedBox(height: 30),
                  _buildActionButtons()
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 500.ms)
                      .scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1, 1),
                      ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: AppColors.primaryColor,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        'Booking Details',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            _buildCoverImage(),
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
          ],
        ),
      ),
    );
  }

  Widget _buildCoverImage() {
    // If no image URL provided
    if (widget.booking.courseId?.coverImage == null ||
        widget.booking.courseId!.coverImage!.isEmpty) {
      return _buildImagePlaceholder();
    }

    // If image has error
    if (_imageHasError) {
      return _buildImagePlaceholder();
    }

    // If image is loaded
    if (_isImageLoaded) {
      return Image.network(
        widget.booking.courseId!.coverImage!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return _buildImageShimmer();
        },
        errorBuilder: (context, error, stackTrace) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _imageHasError = true;
              });
            }
          });
          return _buildImagePlaceholder();
        },
      );
    }

    // Show shimmer while loading
    return _buildImageShimmer();
  }

  Widget _buildImageShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.cardColor,
      highlightColor: Colors.white.withOpacity(0.3),
      child: Container(
        color: AppColors.cardColor,
        child: const Center(
          child: Icon(Icons.image, size: 60, color: Colors.white38),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.primaryColor,
      child: const Center(
        child: Icon(Icons.book_online, size: 80, color: Colors.white),
      ),
    );
  }

  Widget _buildBookingHeader() {
    return Card(
      elevation: 4,
      color: AppColors.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.booking.courseId?.title ?? 'Course Booking',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 12),
            if (widget.booking.courseId?.description != null)
              Text(
                widget.booking.courseId!.description!,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.subtextColor,
                  height: 1.5,
                ),
              ),
            const SizedBox(height: 16),
            _buildPriceAndStatusRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceAndStatusRow() {
    return Row(
      children: [
        if (widget.booking.pricePaid != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '\$${widget.booking.pricePaid!.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getPaymentStatusColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _getPaymentStatusColor().withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            widget.booking.paymentStatus ?? 'Unknown',
            style: TextStyle(
              fontSize: 12,
              color: _getPaymentStatusColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseDetails() {
    return Card(
      elevation: 4,
      color: AppColors.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Course Details',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 16),
            if (widget.booking.courseId?.date != null)
              _buildDetailRow(
                Icons.calendar_today,
                'Date',
                _formatDate(widget.booking.courseId!.date!),
              ),
            if (widget.booking.courseId?.durationInHours != null)
              _buildDetailRow(
                Icons.access_time,
                'Duration',
                '${widget.booking.courseId!.durationInHours} hours',
              ),
            if (widget.booking.courseId?.capacity != null)
              _buildDetailRow(
                Icons.people,
                'Capacity',
                '${widget.booking.courseId!.capacity} participants',
              ),
            if (widget.booking.courseId?.difficultyLevel != null)
              _buildDetailRow(
                Icons.trending_up,
                'Difficulty',
                widget.booking.courseId!.difficultyLevel!,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingInfo() {
    return Card(
      elevation: 4,
      color: AppColors.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Booking Information',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 16),
            if (widget.booking.bookedAt != null)
              _buildDetailRow(
                Icons.bookmark_added,
                'Booked On',
                _formatDate(widget.booking.bookedAt!),
              ),
            if (widget.booking.attendanceStatus != null)
              _buildDetailRow(
                Icons.check_circle,
                'Attendance',
                widget.booking.attendanceStatus!,
              ),
            if (widget.booking.pricePaid != null)
              _buildDetailRow(
                Icons.payment,
                'Amount Paid',
                '\$${widget.booking.pricePaid!.toStringAsFixed(2)}',
              ),
            _buildDetailRow(
              Icons.receipt,
              'Payment Status',
              widget.booking.paymentStatus ?? 'Unknown',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationAndPlatform() {
    return Card(
      elevation: 4,
      color: AppColors.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Location & Platform',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 16),
            if (widget.booking.courseId?.location != null)
              _buildDetailRow(
                Icons.location_on,
                'Location',
                widget.booking.courseId!.location!,
              ),
            if (widget.booking.courseId?.platformLink != null)
              GestureDetector(
                onTap: () => _launchUrl(widget.booking.courseId!.platformLink!),
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primaryColor),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.link, color: AppColors.primaryColor, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Join Platform',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.primaryColor,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ).animate().shimmer(
                color: AppColors.primaryColor.withOpacity(0.3),
              ),
            if (widget.booking.pollUrl != null)
              GestureDetector(
                onTap: () => _launchUrl(widget.booking.pollUrl!),
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.accentColor),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.poll, color: AppColors.accentColor, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Course Poll',
                        style: TextStyle(
                          color: AppColors.accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.accentColor,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ).animate().shimmer(
                color: AppColors.accentColor.withOpacity(0.3),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.subtextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Action Button (Payment/Track Order)
        SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: _handleActionButton,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getActionButtonColor(),
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  _getActionButtonText(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
            .animate()
            .slideY(begin: 1, end: 0, duration: 400.ms, delay: 600.ms)
            .fadeIn(),
      ],
    );
  }

  void _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar('Could not launch URL');
      }
    } catch (e) {
      _showErrorSnackBar('Error launching URL');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Loading placeholder widget for when booking data is being fetched
class CourseBookingDetailsLoading extends StatelessWidget {
  const CourseBookingDetailsLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        title: const Text(
          'Booking Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Image placeholder
            Shimmer.fromColors(
              baseColor: AppColors.cardColor,
              highlightColor: Colors.white,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Title placeholder
            Shimmer.fromColors(
              baseColor: AppColors.cardColor,
              highlightColor: Colors.white,
              child: Container(
                width: double.infinity,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Description placeholder
            Shimmer.fromColors(
              baseColor: AppColors.cardColor,
              highlightColor: Colors.white,
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Details placeholder
            ...List.generate(
              6,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Shimmer.fromColors(
                  baseColor: AppColors.cardColor,
                  highlightColor: Colors.white,
                  child: Container(
                    width: double.infinity,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
