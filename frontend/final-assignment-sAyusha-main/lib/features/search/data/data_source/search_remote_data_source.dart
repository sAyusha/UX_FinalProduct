import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_final_assignment/features/home/domain/entity/home_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/constants/api_endpoint.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/network/remote/http_service.dart';
import '../../../../core/shared_preferences/user_shared_prefs.dart';
import '../../../home/data/model/home_api_model.dart';
import '../dto/get_searched_arts_dto.dart';


final searchRemoteDataSourceProvider = Provider(
  (ref) => SearchRemoteDataSource(
    dio: ref.read(httpServiceProvider),
    homeApiModel: ref.read(homeApiModelProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
  ),
);

class SearchRemoteDataSource {
  final Dio dio;
  final HomeApiModel homeApiModel;
  final UserSharedPrefs userSharedPrefs;

  SearchRemoteDataSource({
    required this.dio,
    required this.homeApiModel,
    required this.userSharedPrefs,
  });

  Future<Either<Failure, List<HomeEntity>>> getSearchedArts(
      String searchQuery) async {
    try {
      String? token;
      await userSharedPrefs.getUserToken().then(
            (value) => value.fold((l) => null, (r) => token = r),
          );

      var response = await dio.get(
        ApiEndpoints.searchArts,
        queryParameters: {'query': searchQuery},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.statusCode == 200) {
        // OR
        // 2nd way
        GetSearchArtsDTO homeAddDTO =
            GetSearchArtsDTO.fromJson(response.data);
        return Right(homeApiModel.toEntityList(homeAddDTO.data));
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