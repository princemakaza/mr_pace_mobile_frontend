import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/payment_management/helpers/payment_helpers.dart';
import 'package:mrpace/widgets/text_fields/custom_text_field.dart';

class PayOrder extends StatefulWidget {
  final String orderId;
  final String phoneNumber;

  const PayOrder({super.key, required this.orderId, required this.phoneNumber});

  @override
  State<PayOrder> createState() => _PayOrderState();
}

class _PayOrderState extends State<PayOrder> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final PaymentHelper _paymentHelper = PaymentHelper(); // Initialize helper

  @override
  void initState() {
    super.initState();
    // Pre-populate the phone number field
    _phoneNumberController.text = widget.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.bottomCenter,
      insetPadding: EdgeInsets.zero,
      shadowColor: Colors.grey.withOpacity(0.2),
      child: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 10,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Complete Order Payment',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                      ).animate().fadeIn(duration: 300.ms),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close, color: AppColors.textColor),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Order Info Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Payment',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Order ID: ${widget.orderId}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.subtextColor,
                        ),
                      ),
                    ],
                  ),
                ).animate().slideY(begin: -0.1, duration: 400.ms),

                const SizedBox(height: 24),

                // Payment Method Section
                Text(
                  'Payment Method',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 16),

                // EcoCash Logo
                Center(
                  child: Image.asset(
                    'assets/icons/ecocash.png',
                    height: 60,
                    width: 120,
                    fit: BoxFit.contain,
                  ),
                ).animate().fadeIn(duration: 500.ms),

                const SizedBox(height: 24),

                // Phone Number Input
                CustomTextField(
                  prefixIcon: Icon(Icons.phone, color: AppColors.primaryColor),
                  controller: _phoneNumberController,
                  labelText: 'EcoCash Phone Number',
                  keyboardType: TextInputType.phone,
                ).animate().slideX(begin: 0.1, duration: 600.ms),

                const SizedBox(height: 32),

                // Make Payment Button
                GestureDetector(
                  onTap: () async {
                    await _paymentHelper.submitOrderPayment(
                      orderId: widget.orderId,
                      phoneNumber: _phoneNumberController.text,
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Make Payment",
                        style: GoogleFonts.poppins(
                          color: AppColors.backgroundColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ).animate().scale(duration: 300.ms, delay: 850.ms),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }
}
