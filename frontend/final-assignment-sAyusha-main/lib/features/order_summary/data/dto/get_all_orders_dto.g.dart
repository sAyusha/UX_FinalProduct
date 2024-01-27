// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_orders_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllOrderDTO _$GetAllOrderDTOFromJson(Map<String, dynamic> json) =>
    GetAllOrderDTO(
      data: (json['data'] as List<dynamic>)
          .map((e) => OrderApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllOrderDTOToJson(GetAllOrderDTO instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
