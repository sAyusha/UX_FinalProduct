// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_arts_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllArtDTO _$GetAllArtDTOFromJson(Map<String, dynamic> json) => GetAllArtDTO(
      data: (json['data'] as List<dynamic>)
          .map((e) => HomeApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllArtDTOToJson(GetAllArtDTO instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
