// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
import 'package:flutter_final_assignment/core/common/widget/semi_big_text.dart';
import 'package:flutter_final_assignment/core/common/widget/small_text.dart';
import 'package:flutter_final_assignment/features/home/domain/entity/home_entity.dart';
import 'package:flutter_final_assignment/features/navbar/presentation/view/bottom_navigation/bottom_navigation_bar.dart';
import 'package:flutter_final_assignment/features/order_summary/presentation/viewmodel/order_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderItems {
  final String orderId;

  OrderItems(
    this.orderId, 
  );
}

class DeliveryView extends ConsumerStatefulWidget {
  final HomeEntity homeEntity;
  const DeliveryView({
    Key? key,
    required this.homeEntity,
  }) : super(key: key);

  @override
  ConsumerState<DeliveryView> createState() => _DeliveryViewState();
}

class _DeliveryViewState extends ConsumerState<DeliveryView> {

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;

    // final orderId = widget.orderId;
    // var orderState = ref.watch(orderViewModelProvider);
    // final List<OrderEntity> orderData = orderState.orders;
    // final List<OrderItems> orders = orderData.map((order) {
    //   return OrderItems(
    //     order.orderId ?? "",
    //   );
    // }).toList();

    // final gap = SizedBox(height: isTablet ? 10 : 20);
    return Scaffold(
      backgroundColor: AppColorConstant.mainSecondaryColor,
      // appBar: AppBar(
      //   title: const Text(
      //     'Delivery',
      //   ),
      // ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/delivery.png',
                      height: isTablet ? 500 : 300,
                      width: isTablet ? 500 : 300,
                    ),
                    const SizedBox(height: 20),
                    const SemiBigText(
                      text: 'Order Placed Successfully!!!',
                      spacing: 0,
                    ),
                    const SizedBox(height: 5),
                    const SmallText(
                      text: 'Your order will be delivered within 2 days',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
      
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColorConstant.primaryAccentColor,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ButtomNavView(
                                      selectedIndex: 0,
                                    ),
                                  ),
                                );
                              },
                              child: SemiBigText(
                                text: "Explore More",
                                spacing: 0,
                                color: AppColorConstant.whiteTextColor,
                              )),
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
    );
  }
}
