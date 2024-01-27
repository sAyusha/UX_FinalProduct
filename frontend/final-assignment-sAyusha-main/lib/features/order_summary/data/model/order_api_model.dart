import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/order_entity.dart';

part 'order_api_model.g.dart';

// dependency injection using riverpod
final orderApiModelProvider = Provider.autoDispose<OrderApiModel>(
  (ref) => OrderApiModel.empty(),
);

@JsonSerializable()
class OrderApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? orderId;
  final String? artId;
  final List<OrderItem> orderItems;
  final ShippingAddress shippingAddress;
  final String paymentMethod;
  // final PaymentResult paymentResult;
  final double bidAmount;
  final double shippingPrice;
  final double totalAmount;
  final String? bidStatus;
  // final bool? isPaid;
  // final DateTime paidAt;
  // final bool? isDelivered;
  // final DateTime deliveredAt;

  const OrderApiModel({
    this.orderId,
    this.artId,
    required this.orderItems,
    required this.shippingAddress,
    required this.paymentMethod,
    // required this.paymentResult,
    required this.bidAmount,
    required this.shippingPrice,
    required this.totalAmount,
    this.bidStatus,
    // this.isPaid,
    // required this.paidAt,
    // this.isDelivered,
    // required this.deliveredAt,
  });

  //empty constructor
  OrderApiModel.empty()
      : orderId = '',
        artId = '',
        orderItems = [],
        shippingAddress = ShippingAddress.empty(),
        paymentMethod = '',
        // paymentResult = PaymentResult.empty(),
        bidAmount = 0.0,
        shippingPrice = 0.0,
        totalAmount = 0.0,
        bidStatus = '';
        // isPaid = false,
        // paidAt = DateTime.now(),
        // isDelivered = false,
        // deliveredAt = DateTime.now();

  // from JSON
  factory OrderApiModel.fromJson(Map<String, dynamic> json) =>
      _$OrderApiModelFromJson(json);

  //To JSON
  Map<String, dynamic> toJson() => _$OrderApiModelToJson(this);

  // convert API object to entity
  OrderEntity toEntity() {
    return OrderEntity(
      orderId: orderId,
      artId: artId,
      orderItems: orderItems,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      // paymentResult: paymentResult,
      bidAmount: bidAmount,
      shippingPrice: shippingPrice,
      totalAmount: totalAmount,
      bidStatus: bidStatus,
      // isPaid: isPaid ?? false,
      // paidAt: paidAt,
      // isDelivered: isDelivered ?? false,
      // deliveredAt: deliveredAt,
    );
  }

  // convert entity to API object
  OrderEntity fromEntity(OrderEntity entity) => OrderEntity(
        orderId: entity.orderId ?? "",
        artId: entity.artId,
        orderItems: entity.orderItems,
        shippingAddress: entity.shippingAddress,
        paymentMethod: entity.paymentMethod,
        // paymentResult: entity.paymentResult,
        bidAmount: entity.bidAmount,
        shippingPrice: entity.shippingPrice,
        totalAmount: entity.totalAmount,
        bidStatus: entity.bidStatus,
        // isPaid: entity.isPaid ?? false,
        // paidAt: entity.paidAt,
        // isDelivered: entity.isDelivered ?? false,
        // deliveredAt: entity.deliveredAt,
      );

  // convert API list to entity list
  List<OrderEntity> toEntityList(List<OrderApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  // to string
  @override
  String toString() {
    return 'OrderApiModel(orderId: $orderId, artId: $artId, orderItems: $orderItems, shippingAddress: $shippingAddress, paymentMethod: $paymentMethod, bidAmount: $bidAmount, shippingPrice: $shippingPrice, totalAmount: $totalAmount, bidStatus: $bidStatus)';
  }

  @override
  List<Object?> get props => [
        orderId,
        artId,
        orderItems,
        shippingAddress,
        paymentMethod,
        // paymentResult,
        bidAmount,
        shippingPrice,
        totalAmount,
        bidStatus,
        // isPaid,
        // paidAt,
        // isDelivered,
        // deliveredAt,
      ];
}
