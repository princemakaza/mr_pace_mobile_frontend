import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/course_booking_management/screens/course_booking_dialog.dart';
import 'package:mrpace/models/coaching_course_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewCoachingCourseDetailsScreen extends StatefulWidget {
  final CoachingCourseModel course;

  const ViewCoachingCourseDetailsScreen({Key? key, required this.course})
    : super(key: key);

  @override
  State<ViewCoachingCourseDetailsScreen> createState() =>
      _ViewCoachingCourseDetailsScreenState();
}

class _ViewCoachingCourseDetailsScreenState
    extends State<ViewCoachingCourseDetailsScreen>
    with TickerProviderStateMixin {
  bool _isImageLoaded = false;
  bool _imageHasError = false;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    // Pre-load the image if it exists
    if (widget.course.coverImage != null) {
      _preloadImage();
    }
  }

  void _preloadImage() {
    if (widget.course.coverImage != null) {
      final imageProvider = NetworkImage(widget.course.coverImage!);

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
                  _buildCourseHeader()
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 100.ms)
                      .slideX(begin: -0.3, end: 0),
                  const SizedBox(height: 20),
                  _buildCourseDetails()
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 200.ms)
                      .slideY(begin: 0.3, end: 0),
                  const SizedBox(height: 20),
                  _buildCoachInfo()
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
      actions: [
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: _shareCoachingCourse,
        ).animate().fadeIn(delay: 800.ms).scale(begin: const Offset(0.5, 0.5)),
      ],
    );
  }

  Widget _buildCoverImage() {
    // If no image URL provided
    if (widget.course.coverImage == null || widget.course.coverImage!.isEmpty) {
      return _buildImagePlaceholder();
    }

    // If image has error
    if (_imageHasError) {
      return _buildImagePlaceholder();
    }

    // If image is loaded
    if (_isImageLoaded) {
      return Image.network(
        widget.course.coverImage!,
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
        child: Icon(Icons.school, size: 80, color: Colors.white),
      ),
    );
  }

  Widget _buildCourseHeader() {
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
              widget.course.title ?? 'Course Title',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 12),
            if (widget.course.description != null)
              Text(
                widget.course.description!,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.subtextColor,
                  height: 1.5,
                ),
              ),
            const SizedBox(height: 16),
            _buildPriceRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow() {
    return Row(
      children: [
        if (widget.course.price != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '\$${widget.course.price!.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        if (widget.course.regularPrice != null &&
            widget.course.regularPrice! > (widget.course.price ?? 0))
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              '\$${widget.course.regularPrice!.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.subtextColor,
                decoration: TextDecoration.lineThrough,
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
            if (widget.course.date != null)
              _buildDetailRow(
                Icons.calendar_today,
                'Date',
                _formatDate(widget.course.date!),
              ),
            if (widget.course.durationInHours != null)
              _buildDetailRow(
                Icons.access_time,
                'Duration',
                '${widget.course.durationInHours} hours',
              ),
            if (widget.course.capacity != null)
              _buildDetailRow(
                Icons.people,
                'Capacity',
                '${widget.course.capacity} participants',
              ),
            if (widget.course.difficultyLevel != null)
              _buildDetailRow(
                Icons.trending_up,
                'Difficulty',
                widget.course.difficultyLevel!,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoachInfo() {
    if (widget.course.coach == null) return const SizedBox.shrink();

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
              'Coach Information',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primaryColor,
                  child: Text(
                    widget.course.coach!.userName
                            ?.substring(0, 1)
                            .toUpperCase() ??
                        'C',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.course.coach!.userName ?? 'Coach',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                      if (widget.course.coach!.email != null)
                        Text(
                          widget.course.coach!.email!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.subtextColor,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
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
            if (widget.course.location != null)
              _buildDetailRow(
                Icons.location_on,
                'Location',
                widget.course.location!,
              ),
            if (widget.course.platformLink != null)
              GestureDetector(
                onTap: () => _launchUrl(widget.course.platformLink!),
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
        // Enroll Button
        SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  // Handle enrollment
                  Get.dialog(
                    CourseBookingDialog(
                      course: widget.course,
                      userId: '688c49c5b93594ab91cb1d1f',
                      price: widget.course.price!,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Enroll Now',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            )
            .animate()
            .slideY(begin: 1, end: 0, duration: 400.ms, delay: 600.ms)
            .fadeIn(),
        const SizedBox(height: 12),
        // Share Button
        SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton(
                onPressed: _shareCoachingCourse,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                  side: BorderSide(color: AppColors.primaryColor, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.share),
                    const SizedBox(width: 8),
                    const Text(
                      'Share Course',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .animate()
            .slideY(begin: 1, end: 0, duration: 400.ms, delay: 700.ms)
            .fadeIn(),
      ],
    );
  }

  void _shareCoachingCourse() {
    String shareText = _buildShareText();

    // For WhatsApp sharing
    String whatsappUrl =
        'https://wa.me/?text=${Uri.encodeComponent(shareText)}';

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
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
            ),
            const SizedBox(height: 20),
            const Text(
              'Share Course',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(
                  Icons.message,
                  'WhatsApp',
                  AppColors.secondaryColor,
                  () => _launchUrl(whatsappUrl),
                ),
                _buildShareOption(
                  Icons.share,
                  'Other',
                  AppColors.primaryColor,
                  () => Share.share(shareText),
                ),
                _buildShareOption(
                  Icons.copy,
                  'Copy',
                  AppColors.accentColor,
                  () => _copyToClipboard(shareText),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ).animate().scale(
      begin: const Offset(0.8, 0.8),
      delay:
          (label == 'WhatsApp'
                  ? 100
                  : label == 'Other'
                  ? 200
                  : 300)
              .ms,
    );
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

  void _showEnrollmentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Enroll in Course',
          style: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Ready to enroll in "${widget.course.title ?? "this course"}"?',
          style: const TextStyle(color: AppColors.subtextColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.subtextColor),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackBar('Enrollment request submitted!');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Enroll'),
          ),
        ],
      ),
    );
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

// Loading placeholder widget for when course data is being fetched
class CoachingCourseDetailsLoading extends StatelessWidget {
  const CoachingCourseDetailsLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
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
              4,
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
