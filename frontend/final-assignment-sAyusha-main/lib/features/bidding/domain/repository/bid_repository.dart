import 'package:dartz/dartz.dart';
import 'package:flutter_final_assignment/features/bidding/domain/entity/bidding_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../../data/repository/bid_remote_repo_impl.dart';

// dependency injection using riverpod
final bidRepositoryProvider = Provider.autoDispose<IBidRepository>(
  (ref){
    return ref.watch(bidRemoteRepoProvider);
  }
);

abstract class IBidRepository{
    Future<Either<Failure, bool>> bidOnArt(BidEntity bid, String artId);
    Future<Either<Failure, List<BidEntity>>> getAllBids();
    Future<Either<Failure, List<BidEntity>>> getBid(String bidId);
}