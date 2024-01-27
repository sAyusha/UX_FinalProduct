import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
import 'package:flutter_final_assignment/core/common/widget/semi_big_text.dart';
import 'package:flutter_final_assignment/core/common/widget/small_text.dart';
import 'package:flutter_final_assignment/features/art_details/presentation/view/art_details/art_details_view.dart';
import 'package:flutter_final_assignment/features/order_summary/domain/entity/order_entity.dart';
import 'package:flutter_final_assignment/features/updates/presentation/view/updates/delivery.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../config/constants/api_endpoint.dart';
import '../../../../../home/domain/entity/home_entity.dart';
import '../../../../../order_summary/presentation/viewmodel/order_viewmodel.dart';

class OrderItems {
  final String orderId;
  final String image;
  final String title;
  final num bidAmount;

  OrderItems(
    this.orderId,
    this.image,
    this.title,
    this.bidAmount,
  );
}

class UpdatesView extends ConsumerStatefulWidget {
  final HomeEntity art;
  final OrderEntity? order;
  const UpdatesView({
    Key? key,
    required this.art,
    this.order,
  }) : super(key: key);

  @override
  ConsumerState<UpdatesView> createState() => _UpdatesViewState();
}

class _UpdatesViewState extends ConsumerState<UpdatesView> {
  String? bidStatus;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(orderViewModelProvider.notifier).getYourOrder();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final art = widget.art;
    final orderState = ref.watch(orderViewModelProvider);
    List<OrderEntity> orderData = orderState.yourOrders;

    final List<OrderItems> orders = orderData.map((order) {
      return OrderItems(
        order.orderId ?? "",
        order.orderItems[0].image,
        order.orderItems[0].title,
        order.bidAmount,
      );
    }).toList();

    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    final gap = SizedBox(height: isTablet ? 18.0 : 16.0);

    if (orders.isEmpty) {
      return Padding(
        padding: isTablet
            ? const EdgeInsets.fromLTRB(20.0, 0, 20, 0)
            : const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: Text(
          "(Your bought arts are not available.)",
          style: TextStyle(
              fontSize: isTablet ? 22 : 18,
              fontWeight: FontWeight.w500,
              color: AppColorConstant.errorColor),
        ),
      );
    }

    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final orderList = orders[index];
          return SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Card(
                color: AppColorConstant.mainSecondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: AppColorConstant.lightNeutralColor4.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                elevation: 4,
                shadowColor: AppColorConstant.blackTextColor.withOpacity(0.4),
                child: Padding(
                  padding: EdgeInsets.all(AppColorConstant.kDefaultPadding / 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Add a widget to display the bid status
                      SemiBigText(
                        text: orderData[index].bidStatus ?? "",
                        spacing: 0,
                        
                      ),
                  
                      // Text(
                      //   orderList.title,
                      //   style: TextStyle(
                      //       fontFamily: "Radio Canada",
                      //       fontSize: isTablet ? 32 : 28,
                      //       fontWeight: FontWeight.w600,
                      //       color: Colors.green[900]),
                      // ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColorConstant.lightNeutralColor4,
                            ),
                          ),
                        ),
                      ),
                      gap,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                '${ApiEndpoints.baseUrl}/uploads/${orderList.image}',
                                fit: BoxFit.cover,
                                height: isTablet ? 300 : 180,
                              ),
                            ),
                          ),
                          gap,
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: isTablet ? 20.0 : 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SemiBigText(
                                    text: orderList.title,
                                    spacing: 0,
                                  ),
                                  SizedBox(height: isTablet ? 5 : 5),
                                  SmallText(
                                    text: orderList.bidAmount.toString(),
                                  ),
                                  SizedBox(height: isTablet ? 8 : 5),
                                  // if (orderList..isNotEmpty)
                                  if (orderData[index].bidStatus == "Winner")
                                    SizedBox(
                                      width: isTablet ? 220 : 160,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            AppColorConstant.primaryAccentColor,
                                          ),
                                        
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context, 
                                            MaterialPageRoute(
                                              builder: (context) => 
                                              DeliveryView(
                                                homeEntity: widget.art,
                                              ),
                                            ),
                                            
                                          );
                                        },
                                        child: SemiBigText(
                                         text:  "Get Delivery",
                                          spacing: 0,
                                          color: AppColorConstant.whiteTextColor,
                                        ),
                                      ),
                                    ),
                                  if (orderData[index].bidStatus == "Loser")
                                    SizedBox(
                                      width: isTablet ? 220 : 160,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            AppColorConstant.primaryAccentColor,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ArtDetailsView(
                                                  art: widget.art,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: SemiBigText(
                                          text: "Rebid",
                                          spacing: 0,
                                          color: AppColorConstant.whiteTextColor,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
