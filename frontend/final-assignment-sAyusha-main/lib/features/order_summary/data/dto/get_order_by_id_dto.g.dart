// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_order_by_id_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetOrderByIdDTO _$GetOrderByIdDTOFromJson(Map<String, dynamic> json) =>
    GetOrderByIdDTO(
      data: (json['data'] as List<dynamic>)
          .map((e) => OrderApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetOrderByIdDTOToJson(GetOrderByIdDTO instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
