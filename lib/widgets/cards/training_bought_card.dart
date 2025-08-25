import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/models/training_bought_package_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class TrainingPackageBoughtCard extends StatefulWidget {
  final TrainingPackageBoughtModel boughtPackage;
  final VoidCallback? onTap;
  final VoidCallback? onRetryPayment;
  final VoidCallback? onViewTraining;
  final VoidCallback? onShare;

  const TrainingPackageBoughtCard({
    Key? key,
    required this.boughtPackage,
    this.onTap,
    this.onRetryPayment,
    this.onViewTraining,
    this.onShare,
  }) : super(key: key);

  @override
  State<TrainingPackageBoughtCard> createState() =>
      _TrainingPackageBoughtCardState();
}

class _TrainingPackageBoughtCardState extends State<TrainingPackageBoughtCard> {


  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
      case 'awaiting_delivery':
      case 'awaiting_confirmation':
        return Colors.orange;
      case 'failed':
      case 'cancelled':
        return Colors.red;
      case 'unpaid':
        return Colors.grey;
      case 'sent':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'paid':
        return Icons.check_circle;
      case 'pending':
        return Icons.schedule;
      case 'awaiting_delivery':
        return Icons.local_shipping;
      case 'awaiting_confirmation':
        return Icons.hourglass_empty;
      case 'failed':
        return Icons.error;
      case 'cancelled':
        return Icons.cancel;
      case 'unpaid':
        return Icons.payment;
      case 'sent':
        return Icons.send;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'paid':
        return 'Paid';
      case 'pending':
        return 'Pending';
      case 'awaiting_delivery':
        return 'Awaiting Delivery';
      case 'awaiting_confirmation':
        return 'Awaiting Confirmation';
      case 'failed':
        return 'Failed';
      case 'cancelled':
        return 'Cancelled';
      case 'unpaid':
        return 'Unpaid';
      case 'sent':
        return 'Sent';
      default:
        return 'Unknown';
    }
  }

  void _showPackageDetailsModal(BuildContext context) {
    final package = widget.boughtPackage.trainingProgramPackageId;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Package Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _getStatusColor(
                        widget.boughtPackage.paymentStatus,
                      ).withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        package?.title ?? 'Premium Training Program',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Status
                      Row(
                        children: [
                          Icon(
                            _getStatusIcon(widget.boughtPackage.paymentStatus),
                            color: _getStatusColor(
                              widget.boughtPackage.paymentStatus,
                            ),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Status: ${_getStatusText(widget.boughtPackage.paymentStatus)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: _getStatusColor(
                                widget.boughtPackage.paymentStatus,
                              ),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Purchase Info
                      if (widget.boughtPackage.pricePaid != null) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.payment,
                              color: AppColors.primaryColor,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Paid: \$${widget.boughtPackage.pricePaid!.toStringAsFixed(2)}',
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

                      // Purchase Date
                      if (widget.boughtPackage.boughtAt != null) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: AppColors.primaryColor,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Purchased: ${DateFormat('MMM dd, yyyy').format(widget.boughtPackage.boughtAt!)}',
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
                      if (package?.durationInWeeks != null) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              color: AppColors.primaryColor,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Duration: ${package!.durationInWeeks} weeks',
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
                const SizedBox(height: 24),

                // Action Buttons
                _buildActionButtons(),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    final status = widget.boughtPackage.paymentStatus?.toLowerCase();

    if (status == 'paid') {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onViewTraining,
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
                'View Training Program',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
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
                'Close',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    } else if (status == 'failed' ||
        status == 'unpaid' ||
        status == 'cancelled') {
      return Row(
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
                'Close',
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
              onPressed: widget.onRetryPayment,
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
                'Retry Payment',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      );
    } else {
      // For pending, sent, awaiting statuses
      return SizedBox(
        width: double.infinity,
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
            'Close',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final package = widget.boughtPackage.trainingProgramPackageId;
    final statusColor = _getStatusColor(widget.boughtPackage.paymentStatus);

    return GestureDetector(
          onTap: widget.onTap ?? () => _showPackageDetailsModal(context),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: AppColors.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: statusColor, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: statusColor.withOpacity(0.08),
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
                                package?.title ?? 'Untitled Training Program',
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

                        // Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: statusColor.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getStatusIcon(
                                  widget.boughtPackage.paymentStatus,
                                ),
                                size: 12,
                                color: statusColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _getStatusText(
                                  widget.boughtPackage.paymentStatus,
                                ),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Coach Name
                        if (package?.coach != null) ...[
                          Text(
                            'Coach: ${package!.coach!}',
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

                        // Duration and Price Row
                        Row(
                          children: [
                            if (package?.durationInWeeks != null) ...[
                              Icon(
                                Icons.schedule,
                                color: AppColors.primaryColor,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${package!.durationInWeeks}w',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                            if (package?.durationInWeeks != null &&
                                widget.boughtPackage.pricePaid != null) ...[
                              const SizedBox(width: 12),
                            ],
                            if (widget.boughtPackage.pricePaid != null) ...[
                              Icon(
                                Icons.payment,
                                color: AppColors.subtextColor,
                                size: 12,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '\$${widget.boughtPackage.pricePaid!.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.subtextColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Bottom Row: Purchase Date and Action Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Purchase Date
                            if (widget.boughtPackage.boughtAt != null) ...[
                              Flexible(
                                flex: 2,
                                child: Text(
                                  'Bought: ${DateFormat('MMM dd').format(widget.boughtPackage.boughtAt!)}',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: AppColors.subtextColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],

                            const SizedBox(width: 12),

                            // Action Button
                            Flexible(
                              flex: 3,
                              child: SizedBox(
                                height: 32,
                                child: _buildActionButton(),
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

  Widget _buildActionButton() {
    final status = widget.boughtPackage.paymentStatus?.toLowerCase();

    if (status == 'paid') {
      return ElevatedButton(
        onPressed: () => _showPackageDetailsModal(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 1,
        ),
        child: const Text(
          'View Details',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: widget.onRetryPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 1,
        ),
        child: const Text(
          'Retry Payment',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
  }

  Widget _buildPackageImage() {
    final package = widget.boughtPackage.trainingProgramPackageId;
    final imageUrl =
        package?.coverImage != null && package!.coverImage!.isNotEmpty
        ? package.coverImage
        : null;
    final statusColor = _getStatusColor(widget.boughtPackage.paymentStatus);

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
              statusColor.withOpacity(0.1),
              statusColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Image or Placeholder
            imageUrl != null
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

            // Status Indicator Overlay
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getStatusIcon(widget.boughtPackage.paymentStatus),
                  color: Colors.white,
                  size: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildPlaceholderIcon() {
    final statusColor = _getStatusColor(widget.boughtPackage.paymentStatus);

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            statusColor.withOpacity(0.15),
            statusColor.withOpacity(0.08),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fitness_center, color: statusColor, size: 24),
          const SizedBox(height: 2),
          Text(
            'Training',
            style: TextStyle(
              color: statusColor,
              fontSize: 8,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
