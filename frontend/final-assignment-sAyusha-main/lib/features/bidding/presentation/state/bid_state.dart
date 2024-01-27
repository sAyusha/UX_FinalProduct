import 'package:flutter_final_assignment/features/profile/domain/entity/profile_entity.dart';

import '../../../home/domain/entity/home_entity.dart';
import '../../domain/entity/bidding_entity.dart';

class BidState{
  final bool isLoading;
  final List<BidEntity> bids;
  final List<BidEntity> bidById;
  final List<ProfileEntity> users;
  final List<HomeEntity> arts;
  final List<HomeEntity> userArts;
  final List<HomeEntity> artById;
  final String? error;

  BidState({
    required this.isLoading,
    required this.bids,
    required this.bidById,
    required this.users,
    required this.arts,
    required this.userArts,
    required this.artById,
    this.error,
  });

  factory BidState.initial() => BidState(
    isLoading: false,
    bids: [],
    bidById: [],
    users: [],
    arts: [],
    userArts: [],
    artById: [],
  );

  //copywith
  BidState copyWith({
    bool? isLoading,
    List<BidEntity>? bids,
    List<BidEntity>? bidById,
    List<ProfileEntity>? users,
    List<HomeEntity>? arts,
    List<HomeEntity>? userArts,
    List<HomeEntity>? artById,
    String? error,
  }) {
    return BidState(
      isLoading: isLoading ?? this.isLoading,
      bids: bids ?? this.bids,
      bidById: bidById ?? this.bidById,
      users: users ?? this.users,
      arts: arts ?? this.arts,
      userArts: userArts ?? this.userArts,
      artById: artById ?? this.artById,
      error: error ?? this.error,
    );
  }
}