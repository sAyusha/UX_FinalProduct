import 'package:equatable/equatable.dart';

class BidEntity extends Equatable {
  final String? bidId;
  final String? artId;
  final num bidAmount;

  const BidEntity({
    this.bidId,
    this.artId,
    required this.bidAmount,
  });

  // from JSON
  factory BidEntity.fromJson(Map<String, dynamic> json) {
    return BidEntity(
      bidId: json['_id'] ?? '',
      artId: json['artId'],
      bidAmount: json['bidAmount'],
    );
  }

  // to JSON
  Map<String, dynamic> toJson() {
    return {
      'bidId': bidId ?? '',
      'artId': artId,
      'bidAmount': bidAmount
    };
  }

  @override
  List<Object?> get props => [
        bidId,
        artId,
        bidAmount,
      ];

  // to string
  @override
  String toString() =>
      'BidEntity { bidId: $bidId, artId: $artId, bidAmount: $bidAmount }';
}
