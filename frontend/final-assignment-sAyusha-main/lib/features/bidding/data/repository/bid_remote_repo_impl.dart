import 'package:dartz/dartz.dart';
import 'package:flutter_final_assignment/features/bidding/domain/repository/bid_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../../domain/entity/bidding_entity.dart';
import '../data_source/bid_remote_data_source.dart';

//dependency injection using riverpod
final bidRemoteRepoProvider = Provider.autoDispose<IBidRepository>(
  (ref){
    return BidRemoteRepositoryImpl(
      bidRemoteDataSource: ref.read(bidRemoteDataSourceProvider),
    );
  }
);

class BidRemoteRepositoryImpl implements IBidRepository{
  final BidRemoteDataSource bidRemoteDataSource;

  BidRemoteRepositoryImpl({
    required this.bidRemoteDataSource,
  });

  @override
  Future<Either<Failure, bool>> bidOnArt(BidEntity bid, String artId) {
    return bidRemoteDataSource.bidOnArt(bid, artId);
  }

  @override
  Future<Either<Failure, List<BidEntity>>> getAllBids() {
    return bidRemoteDataSource.getAllBids();
  }

  @override
  Future<Either<Failure, List<BidEntity>>> getBid(String bidId) {
    return bidRemoteDataSource.getBid(bidId);
  }

}