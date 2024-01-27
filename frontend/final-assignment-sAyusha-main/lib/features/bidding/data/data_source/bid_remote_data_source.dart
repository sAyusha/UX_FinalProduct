import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_final_assignment/core/failure/failure.dart';
import 'package:flutter_final_assignment/core/network/remote/http_service.dart';
import 'package:flutter_final_assignment/core/shared_preferences/user_shared_prefs.dart';
import 'package:flutter_final_assignment/features/bidding/data/dto/get_art_bid_dto.dart';
import 'package:flutter_final_assignment/features/bidding/data/model/bid_api_model.dart';
import 'package:flutter_final_assignment/features/bidding/domain/entity/bidding_entity.dart';
import 'package:flutter_final_assignment/features/home/data/model/home_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/constants/api_endpoint.dart';
import '../dto/get_all_bids_dto.dart';
// import '../dto/get_art_bid_dto.dart';

// dependency injection using riverpod
final bidRemoteDataSourceProvider = Provider.autoDispose<BidRemoteDataSource>(
  (ref) => BidRemoteDataSource(
    dio: ref.read(httpServiceProvider),
    bidApiModel: ref.read(bidApiModelProvider),
    homeApiModel: ref.read(homeApiModelProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
  ),
);

class BidRemoteDataSource {
  final Dio dio;
  final HomeApiModel homeApiModel;
  final BidApiModel bidApiModel;
  final UserSharedPrefs userSharedPrefs;

  BidRemoteDataSource({
    required this.dio,
    required this.bidApiModel,
    required this.homeApiModel,
    required this.userSharedPrefs,
  });

  // place a bid
  Future<Either<Failure, bool>> bidOnArt(BidEntity bid, String artId) async {
    try {
      String? token;
      var data = await userSharedPrefs.getUserToken();
      data.fold(
        (l) => token = null,
        (r) => token = r,
      );
      var response = await dio.post(
        ApiEndpoints.postBid(artId),
        data: bidApiModel.fromEntity(bid).toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(Failure(
          error: response.data['message'],
          statusCode: response.statusCode.toString(),
        ));
      }
    } on DioException catch (e) {
      return Left(Failure(
        error: e.message.toString(),
      ));
    }
  }

  // get all bids
  Future<Either<Failure, List<BidEntity>>> getAllBids() async {
    try {
      // get token
      String? token;
      await userSharedPrefs
          .getUserToken()
          .then((value) => value.fold((l) => null, (r) => token = r!));
      var response = await dio.get(ApiEndpoints.getAllBids,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ));
      if (response.statusCode == 200) {
        // OR
        // 2nd way
        GetAllBidsDTO getAllBidDTO = GetAllBidsDTO.fromJson(response.data);
        return Right(bidApiModel.toEntityList(getAllBidDTO.data));
      } else {
        return Left(
          Failure(
            error: response.statusMessage.toString(),
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
        ),
      );
    }
  }

  // get bid by id
  Future<Either<Failure, List<BidEntity>>> getBid(String bidId) async {
    try {
      // get token
      String? token;
      await userSharedPrefs
          .getUserToken()
          .then((value) => value.fold((l) => null, (r) => token = r!));
      var response = await dio.get(ApiEndpoints.getBid(bidId),
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ));
      if (response.statusCode == 200) {
        // OR
        // 2nd way
        GetBidArtDTO bidGetDTO = GetBidArtDTO.fromJson(response.data);
        return Right(bidApiModel.toEntityList(bidGetDTO.data));
      } else {
        return Left(
          Failure(
            error: response.statusMessage.toString(),
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
        ),
      );
    }
  }
}
