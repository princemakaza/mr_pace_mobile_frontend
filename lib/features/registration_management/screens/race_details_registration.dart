import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/payment_management/helpers/payment_helpers.dart';
import 'package:mrpace/features/payment_management/screens/payment_registration.dart';
import 'package:mrpace/models/registration_model.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ViewRegistrationDetails extends StatefulWidget {
  final RegistrationModel registration;

  const ViewRegistrationDetails({Key? key, required this.registration})
    : super(key: key);

  @override
  State<ViewRegistrationDetails> createState() =>
      _ViewRegistrationDetailsState();
}

class _ViewRegistrationDetailsState extends State<ViewRegistrationDetails> {
  bool _isLoadingPaymentStatus = false;
  bool _isProcessingPayment = false;
  String _paymentStatus = '';
  final paymentHelper = PaymentHelper();

  @override
  void initState() {
    super.initState();
    _paymentStatus = widget.registration.paymentStatus;
    _checkPaymentStatus();
  }

  Future<void> _checkPaymentStatus() async {
    if (widget.registration.pollUrl.isEmpty) return;
    setState(() => _isLoadingPaymentStatus = true);

    try {
      final result = await paymentHelper.checkPaymentStatus(
        widget.registration.pollUrl,
        widget.registration.id,
      );

      if (mounted) {
        setState(() {
          _paymentStatus = result
              ? 'paid'
              : widget.registration.paymentStatus; // fallback if failed
        });
      }
    } catch (e) {
      debugPrint('Error checking payment status: $e');
    } finally {
      if (mounted) setState(() => _isLoadingPaymentStatus = false);
    }
  }

 void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Make Payment'),
          content: Text(
            'You are about to make a payment of \$${widget.registration.racePrice} for ${widget.registration.raceName}.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add your actual payment processing logic here
                // This is where you would integrate with your payment gateway
                Get.snackbar(
                  'Payment',
                  'Redirecting to payment gateway...',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.primaryColor,
                  colorText: Colors.white,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Proceed to Payment'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final registration = widget.registration;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildHeaderCard(
                    registration,
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.3),
                  const SizedBox(height: 16),
                  _buildPersonalInfoCard(
                    registration,
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),
                  const SizedBox(height: 16),
                  _buildRaceInfoCard(
                    registration,
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),
                  const SizedBox(height: 16),
                  _buildPaymentStatusCard()
                      .animate()
                      .fadeIn(delay: 400.ms)
                      .slideY(begin: 0.3),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ).animate().fadeIn(delay: 50.ms),
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Registration Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryColor,
                AppColors.primaryColor.withOpacity(0.8),
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.assignment_ind_rounded,
              size: 60,
              color: Colors.white.withOpacity(0.2),
            ).animate().scale(delay: 200.ms),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(RegistrationModel registration) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Text(
              '${registration.firstName.isNotEmpty ? registration.firstName[0] : ''}${registration.lastName.isNotEmpty ? registration.lastName[0] : ''}',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ).animate().scale(delay: 300.ms),
          const SizedBox(height: 16),
          Text(
            '${registration.firstName} ${registration.lastName}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ).animate().fadeIn(delay: 400.ms),

          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Registration #${registration.registrationNumber}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ).animate().fadeIn(delay: 500.ms),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard(RegistrationModel registration) {
    return _buildInfoCard(
      title: 'Personal Information',
      icon: Icons.person_rounded,
      children: [
        _buildInfoRow('Gender', registration.gender, Icons.person_outline),
        _buildInfoRow(
          'Date of Birth',
          _formatDate(registration.dateOfBirth),
          Icons.cake_rounded,
        ),
        _buildInfoRow(
          'Phone Number',
          registration.phoneNumber,
          Icons.phone_rounded,
        ),
        _buildInfoRow('Email', registration.email, Icons.email_rounded),
        _buildInfoRow(
          'T-Shirt Size',
          registration.tShirtSize,
          Icons.shopping_bag_rounded,
        ),
      ],
    );
  }

  Widget _buildRaceInfoCard(RegistrationModel registration) {
    return _buildInfoCard(
      title: 'Race Information',
      icon: Icons.directions_run_rounded,
      children: [
        _buildInfoRow('Race Name', registration.raceName, Icons.flag_rounded),
        _buildInfoRow(
          'Race Event',
          registration.raceEvent,
          Icons.event_rounded,
        ),
        _buildInfoRow(
          'Price',
          '\$${registration.racePrice}',
          Icons.attach_money_rounded,
        ),
        if (registration.race is RaceModel) ...[
          _buildInfoRow(
            'Venue',
            (registration.race as RaceModel).venue,
            Icons.location_on_rounded,
          ),
          _buildInfoRow(
            'Date',
            (registration.race as RaceModel).date,
            Icons.calendar_today_rounded,
          ),
          _buildInfoRow(
            'Status',
            (registration.race as RaceModel).registrationStatus,
            Icons.info_rounded,
          ),
        ],
      ],
    );
  }

  Widget _buildPaymentStatusCard() {
    if (_isLoadingPaymentStatus) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Center(
          child: LoadingAnimationWidget.hexagonDots(
            color: AppColors.primaryColor,
            size: 45,
          ),
        ),
      );
    }

    final isUnpaid = _paymentStatus.toLowerCase() == 'unpaid';
    final isPaid = _paymentStatus.toLowerCase() == 'paid';
    final isPending = _paymentStatus.toLowerCase() == 'pending';
    final isFailed = _paymentStatus.toLowerCase() == 'failed';
    final isCancelled = _paymentStatus.toLowerCase() == 'cancelled';

    Color statusColor;
    IconData statusIcon;

    if (isPaid) {
      statusColor = AppColors.successColor;
      statusIcon = Icons.check_circle_rounded;
    } else if (isPending ||
        _paymentStatus.toLowerCase() == 'send' ||
        _paymentStatus.toLowerCase() == 'awaiting_delivery' ||
        _paymentStatus.toLowerCase() == 'awaiting_confirmation') {
      statusColor = AppColors.warningColor;
      statusIcon = Icons.pending_rounded;
    } else if (isFailed || isCancelled) {
      statusColor = AppColors.errorColor;
      statusIcon = Icons.error_rounded;
    } else {
      statusColor = AppColors.subtextColor;
      statusIcon = Icons.payment_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.payment_rounded,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Payment Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(statusIcon, size: 40, color: statusColor),
                ).animate().scale(delay: 100.ms),
                const SizedBox(height: 12),
                Text(
                  _paymentStatus.toUpperCase(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ).animate().fadeIn(delay: 200.ms),
                if (isUnpaid) ...[
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.dialog(
                          PayRegistration(
                            registrationPrice: widget.registration.racePrice
                                .toString(),
                            registration_number:
                                widget.registration.registrationNumber,
                            raceName: widget.registration.raceName,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: _isProcessingPayment
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.payment_rounded, size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  'Make Payment',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.subtextColor),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.subtextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.2);
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
}
