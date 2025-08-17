import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/cart_management/controller/cart_controller.dart';
import 'package:mrpace/features/orders_management/helpers/orders_helper.dart';
import 'package:mrpace/features/registration_management/helpers/registration_helper.dart';
import 'package:mrpace/models/submit_order.dart';
import 'package:mrpace/widgets/text_fields/custom_text_field.dart';

class OrderDialog extends StatefulWidget {
  final List<CartItem> cartItems;
  const OrderDialog({super.key, required this.cartItems});
  @override
  State<OrderDialog> createState() => _OrderDialogState();
}

class _OrderDialogState extends State<OrderDialog> {
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController =
      TextEditingController();
  final TextEditingController _shippingAddressController =
      TextEditingController();
  String? _selectedPaymentOption;
  bool _needsDelivery = false;
  LatLng? _deliveryCoordinates;

  final OrderHelper orderHelper = OrderHelper();

  final List<String> _paymentOptions = ['PayNow', 'PayLater'];
  @override
  Widget build(BuildContext context) {
    double totalAmount = widget.cartItems.fold(
      0,
      (sum, item) => sum + item.totalPrice,
    );
    int deliveryFee = _needsDelivery ? 5 : 0; // Example delivery fee
    return Dialog(
      alignment: Alignment.bottomCenter,
      insetPadding: EdgeInsets.zero,
      shadowColor: Colors.grey.withOpacity(0.2),
      child: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.9,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Order Summary',
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
              const SizedBox(height: 8),

              // Order Summary Card
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
                      '${widget.cartItems.length} Items in Cart',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...widget.cartItems.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${item.product.name} x${item.quantity}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              '\$${item.totalPrice.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtotal',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${totalAmount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    if (_needsDelivery) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delivery Fee',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            '\$$deliveryFee.00',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.successColor,
                              ),
                        ),
                        Text(
                          '\$${(totalAmount + deliveryFee).toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.successColor,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().slideY(begin: -0.1, duration: 400.ms),

              const SizedBox(height: 24),

              // Customer Information Section
              Text(
                'Customer Information',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 16),

              // Customer Name
              CustomTextField(
                prefixIcon: Icon(Icons.person, color: AppColors.primaryColor),
                controller: _customerNameController,
                labelText: 'Full Name',
              ).animate().slideX(begin: 0.1, duration: 400.ms),

              const SizedBox(height: 16),

              // Phone Number
              CustomTextField(
                prefixIcon: Icon(Icons.phone, color: AppColors.primaryColor),
                controller: _customerPhoneController,
                labelText: 'Phone Number',
                keyboardType: TextInputType.phone,
              ).animate().slideX(begin: 0.1, duration: 450.ms),

              const SizedBox(height: 16),

              // Delivery Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _needsDelivery,
                    onChanged: (value) {
                      setState(() {
                        _needsDelivery = value ?? false;
                      });
                    },
                    activeColor: AppColors.primaryColor,
                  ),
                  Text(
                    'Needs Delivery',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ).animate().slideX(begin: 0.1, duration: 550.ms),

              if (_needsDelivery) ...[
                const SizedBox(height: 16),
                // Shipping Address
                CustomTextField(
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: AppColors.primaryColor,
                  ),
                  controller: _shippingAddressController,
                  labelText: 'Shipping Address',
                ).animate().slideX(begin: 0.1, duration: 600.ms),

                const SizedBox(height: 16),
                // Get Location Button
                GestureDetector(
                  onTap: () async {
                    // TODO: Implement location fetching
                    // This would use geolocator or similar package to get current location
                    setState(() {
                      _deliveryCoordinates = LatLng(
                        1.3521,
                        103.8198,
                      ); // Example coordinates
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Location captured successfully')),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primaryColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_searching,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Use Current Location',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.primaryColor),
                        ),
                      ],
                    ),
                  ),
                ).animate().slideX(begin: 0.1, duration: 650.ms),
              ],

              const SizedBox(height: 16),

              // Payment Option Dropdown
              DropdownButtonFormField<String>(
                value: _selectedPaymentOption,
                decoration: InputDecoration(
                  labelText: 'Payment Option',
                  prefixIcon: Icon(
                    Icons.payment,
                    color: AppColors.primaryColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
                  ),
                ),
                items: _paymentOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPaymentOption = newValue;
                  });
                },
              ).animate().slideX(begin: 0.1, duration: 700.ms),

              const SizedBox(height: 32),

              // Submit Button
              GestureDetector(
                onTap: () async {
                  if (_selectedPaymentOption == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select a payment option')),
                    );
                    return;
                  }

                  final orderModel = SubmitOrderModel(
                    customerName: _customerNameController.text,
                    customerEmail: "zpmakaza@gmail.com",
                    customerPhone: _customerPhoneController.text,
                    shippingAddress: _needsDelivery
                        ? _shippingAddressController.text
                        : null,
                    needsDelivery: _needsDelivery,
                    deliveryFee: _needsDelivery ? deliveryFee : null,
                    deliveryCoordinates:
                        _needsDelivery && _deliveryCoordinates != null
                        ? DeliveryCoordinates(
                            latitude: _deliveryCoordinates!.latitude,
                            longitude: _deliveryCoordinates!.longitude,
                          )
                        : null,
                    products: widget.cartItems
                        .map(
                          (item) => Product(
                            productId: item.product.id,
                            name: item.product.name,
                            price: item.product.price,
                            quantity: item.quantity,
                            size: "Others",
                            color:"Others"
                          ),
                        )
                        .toList(),
                    totalAmount: totalAmount + deliveryFee,
                    paymentOption: _selectedPaymentOption!,
                    paymentStatus: 'Pending',
                    orderStatus: 'Processing',
                    createdAt: DateTime.now(),
                  );
                  await orderHelper.submitOrder(orderModel);
                  // TODO: Implement order submission
                  // await orderService.submitOrder(orderModel);
                  DevLogs.logSuccess(
                    "Order submitted successfully: $orderModel",
                  );
                  // Show success dialog
                  // Get.back(); // Close this dialog
                  // Get.to(() => SuccessOrderScreen(orderModel: orderModel));
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
                      "Place Order",
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
    );
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _shippingAddressController.dispose();
    super.dispose();
  }
}
