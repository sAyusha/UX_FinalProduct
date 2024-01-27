// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUserDTO _$GetUserDTOFromJson(Map<String, dynamic> json) => GetUserDTO(
      data: (json['data'] as List<dynamic>)
          .map((e) => ProfileApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetUserDTOToJson(GetUserDTO instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
