// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_users_order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUsersOrderDTO _$GetUsersOrderDTOFromJson(Map<String, dynamic> json) =>
    GetUsersOrderDTO(
      data: (json['data'] as List<dynamic>)
          .map((e) => OrderApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetUsersOrderDTOToJson(GetUsersOrderDTO instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
