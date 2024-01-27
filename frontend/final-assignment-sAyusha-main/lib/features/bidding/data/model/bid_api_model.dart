import 'package:equatable/equatable.dart';
import 'package:flutter_final_assignment/features/bidding/domain/entity/bidding_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bid_api_model.g.dart';

// dependency injection using riverpod
final bidApiModelProvider = Provider.autoDispose<BidApiModel>(
  (ref) => const BidApiModel.empty(),
);

@JsonSerializable()
class BidApiModel extends Equatable{
  @JsonKey(name: '_id')
  final String? bidId;
  final String? artId;
  final num bidAmount;

  const BidApiModel({
    this.bidId,
    this.artId,
    required this.bidAmount,
  });

  // empty constructor
  const BidApiModel.empty()
      : bidId = '',
        artId = '',
        bidAmount = 0;

  // from JSON
  factory BidApiModel.fromJson(Map<String, dynamic> json) =>
    _$BidApiModelFromJson(json);
  
  // to JSON
  Map<String, dynamic> toJson() => _$BidApiModelToJson(this);

  // convert API Object to Entity
  BidEntity toEntity() => BidEntity(
      bidId: bidId ?? '',
      artId: artId,
      bidAmount: bidAmount,
  );

  // convert Entity to API Object
  BidApiModel fromEntity(BidEntity entity) => BidApiModel(
      bidId: entity.bidId ?? '',
      artId: entity.artId,
      bidAmount: entity.bidAmount,
  );

  // convert API list to Entity list
  List<BidEntity> toEntityList(List<BidApiModel> models) => 
    models.map((model) => model.toEntity()).toList();

  @override
  List<Object?> get props => [
    bidId,
    artId,
    bidAmount,
  ];

  // to string
  @override
  String toString() =>
      'BidApiModel { id: $bidId, artId: $artId, bidAmount: $bidAmount}';
}
