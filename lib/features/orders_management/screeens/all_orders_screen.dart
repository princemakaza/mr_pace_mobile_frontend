import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mrpace/config/routers/router.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/orders_management/controller/orders_controller.dart';
import 'package:mrpace/features/payment_management/screens/pay_order_dialog.dart';
import 'package:mrpace/models/all_order_model.dart';
import 'package:mrpace/widgets/cards/all_order_card.dart';
import 'package:shimmer/shimmer.dart';

class AllOrderScreen extends StatefulWidget {
  const AllOrderScreen({Key? key}) : super(key: key);

  @override
  State<AllOrderScreen> createState() => _AllOrderScreenState();
}

class _AllOrderScreenState extends State<AllOrderScreen>
    with SingleTickerProviderStateMixin {
  final OrderController controller = Get.put(OrderController());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    controller.fetchOrdersByCustomerId('zpmakaza@gmail.com');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'My Orders',
          style: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textColor),
        actions: [
          IconButton(
            onPressed: () => controller.refreshOrders('zpmakaza@gmail.com'),
            icon: const Icon(Icons.search_rounded),
            color: AppColors.textColor,
          ),
          IconButton(
            onPressed: () => controller.refreshOrders('zpmakaza@gmail.com'),
            icon: const Icon(Icons.more_vert_rounded),
            color: AppColors.textColor,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(45), // shorter height
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.borderColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: List.generate(3, (index) {
                final isSelected = _tabController.index == index;
                final titles = ["Active", "Completed", "Cancelled"];

                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _tabController.index = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          titles[index],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected
                                ? AppColors.surfaceColor
                                : AppColors.subtextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.orders.isEmpty) {
          return _buildShimmerLoading();
        }

        if (controller.orders.isEmpty && !controller.isLoading.value) {
          return _buildEmptyState();
        }

        return TabBarView(
          controller: _tabController,
          children: [
            _buildOrderList(_getOrdersByStatus('active')),
            _buildOrderList(_getOrdersByStatus('completed')),
            _buildOrderList(_getOrdersByStatus('cancelled')),
          ],
        );
      }),
    );
  }

  List<AllOrderModel> _getOrdersByStatus(String status) {
    switch (status) {
      case 'active':
        return controller.orders
            .where(
              (order) =>
                  order.paymentStatus?.toLowerCase() == 'pending' ||
                  order.paymentStatus?.toLowerCase() == 'paid' ||
                  order.paymentStatus?.toLowerCase() == 'sent' ||
                  order.paymentStatus?.toLowerCase() == 'awaiting_delivery',
            )
            .toList();
      case 'completed':
        return controller.orders
            .where(
              (order) =>
                  order.paymentStatus?.toLowerCase() == 'delivered' ||
                  order.orderStatus?.toLowerCase() == 'completed',
            )
            .toList();
      case 'cancelled':
        return controller.orders
            .where(
              (order) =>
                  order.paymentStatus?.toLowerCase() == 'cancelled' ||
                  order.paymentStatus?.toLowerCase() == 'failed',
            )
            .toList();
      default:
        return controller.orders;
    }
  }

  Widget _buildOrderList(List<AllOrderModel> orders) {
    if (orders.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () => controller.refreshOrders('zpmakaza@gmail.com'),
      color: AppColors.primaryColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return OrderCard(
                order: orders[index],
                index: index,
                onTapToViewOrderDetails: () => Get.toNamed(
                  RoutesHelper.orderDetailScreen,
                  arguments: orders[index],
                ),
                onTapToCheckoutOrder: () {
                  Get.dialog(PayOrder(orderId: orders[index].id!, phoneNumber: orders[index].customerPhone!,));
                },
              )
              .animate()
              .slideX(
                begin: 1,
                duration: Duration(milliseconds: 300 + (index * 100)),
                curve: Curves.easeOutCubic,
              )
              .fadeIn(duration: Duration(milliseconds: 400 + (index * 100)));
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.borderColor,
          highlightColor: AppColors.surfaceColor,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const SizedBox(height: 120, width: double.infinity),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child:
          Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      size: 64,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No Orders Found',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You haven\'t placed any orders yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.subtextColor,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.surfaceColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Start Shopping',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              )
              .animate()
              .scale(
                begin: const Offset(0.8, 0.8),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
              )
              .fadeIn(),
    );
  }
}
