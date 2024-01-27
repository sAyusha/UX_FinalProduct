import 'package:dartz/dartz.dart';
import 'package:flutter_final_assignment/core/failure/failure.dart';
import 'package:flutter_final_assignment/features/bidding/domain/repository/bid_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/bidding_entity.dart';

// dependency injection using riverpod
final bidUsecaseProvider = Provider.autoDispose<BidUseCase>(
  (ref){
    return BidUseCase(
      bidRepository: ref.watch(bidRepositoryProvider),
    );
  }
);

class BidUseCase{
  final IBidRepository bidRepository;

  BidUseCase({
    required this.bidRepository,
  });

  Future<Either<Failure, bool>> bidOnArt(BidEntity bid, String artId) async {
    return bidRepository.bidOnArt(bid, artId);
  }

  Future<Either<Failure, List<BidEntity>>> getAllBids() async {
    return bidRepository.getAllBids();
  }

  Future<Either<Failure, List<BidEntity>>> getBid(String bidId) async {
    return bidRepository.getBid(bidId);
  }
}