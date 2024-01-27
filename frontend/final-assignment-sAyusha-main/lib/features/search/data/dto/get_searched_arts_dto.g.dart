// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_searched_arts_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetSearchArtsDTO _$GetSearchArtsDTOFromJson(Map<String, dynamic> json) =>
    GetSearchArtsDTO(
      data: (json['data'] as List<dynamic>)
          .map((e) => HomeApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetSearchArtsDTOToJson(GetSearchArtsDTO instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
