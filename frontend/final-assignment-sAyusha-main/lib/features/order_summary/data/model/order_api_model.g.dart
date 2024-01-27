// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderApiModel _$OrderApiModelFromJson(Map<String, dynamic> json) =>
    OrderApiModel(
      orderId: json['_id'] as String?,
      artId: json['artId'] as String?,
      orderItems: (json['orderItems'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      shippingAddress: ShippingAddress.fromJson(
          json['shippingAddress'] as Map<String, dynamic>),
      paymentMethod: json['paymentMethod'] as String,
      bidAmount: (json['bidAmount'] as num).toDouble(),
      shippingPrice: (json['shippingPrice'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      bidStatus: json['bidStatus'] as String?,
    );

Map<String, dynamic> _$OrderApiModelToJson(OrderApiModel instance) =>
    <String, dynamic>{
      '_id': instance.orderId,
      'artId': instance.artId,
      'orderItems': instance.orderItems,
      'shippingAddress': instance.shippingAddress,
      'paymentMethod': instance.paymentMethod,
      'bidAmount': instance.bidAmount,
      'shippingPrice': instance.shippingPrice,
      'totalAmount': instance.totalAmount,
      'bidStatus': instance.bidStatus,
    };
