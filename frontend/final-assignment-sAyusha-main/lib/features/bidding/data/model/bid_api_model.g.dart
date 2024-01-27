// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bid_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BidApiModel _$BidApiModelFromJson(Map<String, dynamic> json) => BidApiModel(
      bidId: json['_id'] as String?,
      artId: json['artId'] as String?,
      bidAmount: json['bidAmount'] as num,
    );

Map<String, dynamic> _$BidApiModelToJson(BidApiModel instance) =>
    <String, dynamic>{
      '_id': instance.bidId,
      'artId': instance.artId,
      'bidAmount': instance.bidAmount,
    };
