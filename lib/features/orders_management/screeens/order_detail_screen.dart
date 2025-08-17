import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/payment_management/services/payment_services.dart';
import 'package:mrpace/models/all_order_model.dart';
import 'package:shimmer/shimmer.dart';

class AllOrderModelDetailScreen extends StatefulWidget {
  final AllOrderModel order;
  const AllOrderModelDetailScreen({Key? key, required this.order})
    : super(key: key);

  @override
  State<AllOrderModelDetailScreen> createState() =>
      _AllOrderModelDetailScreenState();
}

class _AllOrderModelDetailScreenState extends State<AllOrderModelDetailScreen> {
  @override
  void initState() {
    super.initState();
    _checkPaymentStatus();
  }

  void _checkPaymentStatus() {
    if (widget.order.pollUrl != null && widget.order.id != null) {
      // We don't await this call and don't care about the response
      PaymentService.checkPaymentOrderStatus(
        pollUrl: widget.order.pollUrl!,
        orderId: widget.order.id!,
      ).catchError((e) {
        // Ignore any errors
        DevLogs.logError('Payment status check error (ignored): $e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPendingPayment =
        widget.order.paymentStatus?.toLowerCase() == 'pending';
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isPendingPayment ? 100 : 20, // Extra padding for button
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderHeader(),
                  const SizedBox(height: 20),
                  _buildCustomerInfoCard(),
                  const SizedBox(height: 20),
                  _buildProductsList(),
                  const SizedBox(height: 20),
                  _buildPaymentSummary(),
                  const SizedBox(height: 20),
                  _buildDeliveryInfo(),
                  const SizedBox(height: 20),
                  _buildAdminComment(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          if (isPendingPayment) _buildCheckoutButton(context),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child:
            ElevatedButton(
              onPressed: () {
                // Handle checkout logic here
                _handleCheckout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Complete Payment',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ).animate().slideY(
              begin: 1,
              end: 0,
              duration: 500.ms,
              curve: Curves.easeOut,
            ),
      ),
    );
  }

  void _handleCheckout(BuildContext context) {
    // Show a confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Complete Payment',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        content: Text(
          'Are you sure you want to proceed with payment for this order?',
          style: GoogleFonts.inter(color: AppColors.subtextColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: AppColors.subtextColor),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Here you would typically:
              // 1. Process the payment
              // 2. Update the order status
              // 3. Show a success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Payment processed successfully!',
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: AppColors.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            child: Text(
              'Confirm',
              style: GoogleFonts.inter(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Order Details',
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildOrderHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${widget.order.id?.substring(widget.order.id!.length - 8) ?? 'N/A'}',
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              _buildStatusChip(widget.order.orderStatus ?? 'Unknown'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: AppColors.subtextColor,
              ),
              const SizedBox(width: 8),
              Text(
                widget.order.createdAt != null
                    ? '${widget.order.createdAt!.day}/${widget.order.createdAt!.month}/${widget.order.createdAt!.year}'
                    : 'N/A',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.subtextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.2);
  }

  Widget _buildStatusChip(String status) {
    Color statusColor;
    Color textColor = Colors.white;

    switch (status.toLowerCase()) {
      case 'completed':
      case 'delivered':
        statusColor = AppColors.successColor;
        break;
      case 'pending':
      case 'processing':
        statusColor = AppColors.warningColor;
        textColor = AppColors.textColor;
        break;
      case 'cancelled':
        statusColor = AppColors.errorColor;
        break;
      default:
        statusColor = AppColors.primaryColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    ).animate().scale(delay: 400.ms, duration: 300.ms);
  }

  Widget _buildCustomerInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(16),
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
                  Icons.person,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Customer Information',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.person_outline,
            'Name',
            widget.order.customerName ?? 'N/A',
          ),
          _buildInfoRow(
            Icons.email_outlined,
            'Email',
            widget.order.customerEmail ?? 'N/A',
          ),
          _buildInfoRow(
            Icons.phone_outlined,
            'Phone',
            widget.order.customerPhone ?? 'N/A',
          ),
          _buildInfoRow(
            Icons.location_on_outlined,
            'Address',
            widget.order.shippingAddress ?? 'N/A',
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 200.ms).slideX(begin: 0.2);
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.subtextColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.subtextColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(16),
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: AppColors.secondaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Products (${widget.order.products?.length ?? 0})',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
          ),
          if (widget.order.products != null &&
              widget.order.products!.isNotEmpty)
            ...widget.order.products!.asMap().entries.map((entry) {
              int index = entry.key;
              Product product = entry.value;
              return _buildProductItem(product, index);
            }).toList()
          else
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'No products found',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.subtextColor,
                ),
              ),
            ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 400.ms).slideY(begin: 0.2);
  }

  Widget _buildProductItem(Product product, int index) {
    return Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductImage(product),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name ??
                              product.productId?.name ??
                              'Unknown Product',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        if (product.size != null || product.color != null)
                          Row(
                            children: [
                              if (product.size != null)
                                _buildProductTag('Size: ${product.size}'),
                              if (product.size != null && product.color != null)
                                const SizedBox(width: 8),
                              if (product.color != null)
                                _buildProductTag('Color: ${product.color}'),
                            ],
                          ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Qty: ${product.quantity ?? 0}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.subtextColor,
                              ),
                            ),
                            Text(
                              '\$${(product.price ?? product.productId?.price ?? 0).toStringAsFixed(2)}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
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
            if (product.productId != null)
              _buildProductIdDetails(product.productId!),
          ],
        )
        .animate(delay: Duration(milliseconds: 100 * index))
        .slideX(begin: 0.3, duration: 400.ms, curve: Curves.easeOut);
  }

  Widget _buildProductIdDetails(ProductId productId) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Details',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          if (productId.description != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                productId.description!,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textColor,
                ),
              ),
            ),
          if (productId.brand != null)
            _buildProductDetailRow('Brand', productId.brand!),
          if (productId.category != null)
            _buildProductDetailRow('Category', productId.category!),
          if (productId.stockQuantity != null)
            _buildProductDetailRow(
              'Stock',
              productId.stockQuantity!.toString(),
            ),
          if (productId.rating != null)
            _buildProductDetailRow(
              'Rating',
              productId.rating!.toStringAsFixed(1),
            ),
          if (productId.sizeOptions != null &&
              productId.sizeOptions!.isNotEmpty)
            _buildProductDetailRow(
              'Available Sizes',
              productId.sizeOptions!.join(', '),
            ),
          if (productId.colorOptions != null &&
              productId.colorOptions!.isNotEmpty)
            _buildProductDetailRow(
              'Available Colors',
              productId.colorOptions!.join(', '),
            ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1);
  }

  Widget _buildProductDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.subtextColor,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(Product product) {
    final imageUrl = product.productId?.images?.isNotEmpty == true
        ? product.productId!.images!.first
        : null;

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.cardColor,
      ),
      child: imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Shimmer.fromColors(
                    baseColor: AppColors.cardColor,
                    highlightColor: Colors.white,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.cardColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderImage();
                },
              ),
            )
          : _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.image_outlined,
        color: AppColors.subtextColor,
        size: 24,
      ),
    );
  }

  Widget _buildProductTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(16),
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
                  color: AppColors.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.payment,
                  color: AppColors.accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Payment Summary',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSummaryRow(
            'Subtotal',
            '\$${((widget.order.totalAmount ?? 0) - (widget.order.deliveryFee ?? 0)).toStringAsFixed(2)}',
          ),
          _buildSummaryRow(
            'Delivery Fee',
            '\$${(widget.order.deliveryFee ?? 0).toStringAsFixed(2)}',
          ),
          const Divider(color: AppColors.borderColor),
          _buildSummaryRow(
            'Total Amount',
            '\$${(widget.order.totalAmount ?? 0).toStringAsFixed(2)}',
            isTotal: true,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment Method',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.subtextColor,
                ),
              ),
              Text(
                widget.order.paymentOption ?? 'N/A',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment Status',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.subtextColor,
                ),
              ),
              _buildPaymentStatusChip(widget.order.paymentStatus ?? 'Unknown'),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 600.ms).slideX(begin: -0.2);
  }

  Widget _buildSummaryRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? AppColors.textColor : AppColors.subtextColor,
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.inter(
              fontSize: isTotal ? 18 : 14,
              fontWeight: FontWeight.bold,
              color: isTotal ? AppColors.primaryColor : AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStatusChip(String status) {
    Color statusColor = status.toLowerCase() == 'paid'
        ? AppColors.successColor
        : AppColors.warningColor;
    Color textColor = status.toLowerCase() == 'paid'
        ? Colors.white
        : AppColors.textColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    if (widget.order.needsDelivery != true) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(16),
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
                  Icons.local_shipping,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Delivery Information',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (widget.order.deliveryCoordinates != null)
            _buildInfoRow(
              Icons.location_on_outlined,
              'Coordinates',
              'Lat: ${widget.order.deliveryCoordinates!.latitude}, Lng: ${widget.order.deliveryCoordinates!.longitude}',
            ),
          _buildInfoRow(
            Icons.monetization_on_outlined,
            'Delivery Fee',
            '\$${(widget.order.deliveryFee ?? 0).toStringAsFixed(2)}',
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 800.ms).slideY(begin: 0.2);
  }

  Widget _buildAdminComment() {
    if (widget.order.adminComment == null ||
        widget.order.adminComment!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
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
                  Icons.admin_panel_settings,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Admin Comment',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.order.adminComment!,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 1000.ms).slideX(begin: 0.2);
  }
}
