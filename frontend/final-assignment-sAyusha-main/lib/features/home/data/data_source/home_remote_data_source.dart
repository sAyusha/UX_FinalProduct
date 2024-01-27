import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_final_assignment/config/constants/api_endpoint.dart';
import 'package:flutter_final_assignment/core/shared_preferences/user_shared_prefs.dart';
import 'package:flutter_final_assignment/features/auth/data/model/auth_api_model.dart';
import 'package:flutter_final_assignment/features/home/data/data_source/home_local_data_source.dart';
import 'package:flutter_final_assignment/features/home/data/model/home_api_model.dart';
import 'package:flutter_final_assignment/features/home/domain/entity/home_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/network/remote/http_service.dart';
import '../dto/get_alerted_arts_dto.dart';
import '../dto/get_all_arts_dto.dart';
import '../dto/get_art_by_id_dto.dart';
import '../dto/get_saved_arts_dto.dart';
import '../dto/get_user_arts_dto.dart';

// dependency injection for HomeRemoteDataSource using Riverpod
final homeRemoteDataSourceProvider = Provider.autoDispose(
  (ref) => HomeRemoteDataSource(
    dio: ref.read(httpServiceProvider),
    homeApiModel: ref.read(homeApiModelProvider),
    homeLocalDataSource: ref.read(homeLocalDataSourceProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
    authApiModel: ref.read(authApiModelProvider),
  ),
);

class HomeRemoteDataSource {
  final Dio dio;
  final HomeApiModel homeApiModel;
  final HomeLocalDataSource homeLocalDataSource;
  final AuthApiModel authApiModel;
  final UserSharedPrefs userSharedPrefs;

  HomeRemoteDataSource({
    required this.dio,
    required this.homeApiModel,
    required this.homeLocalDataSource,
    required this.authApiModel,
    required this.userSharedPrefs,
  });

  Future<Either<Failure, bool>> addArt(HomeEntity art) async {
    try {
      var response = await dio.post(
        ApiEndpoints.postArt,
        data: homeApiModel.fromEntity(art).toJson(),
      );

      if (response.statusCode == 201) {
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

  Future<Either<Failure, List<HomeEntity>>> getAllArt() async {
    try {
      // get token
      String? token;
      await userSharedPrefs
          .getUserToken()
          .then((value) => value.fold((l) => null, (r) => token = r!));
      var response = await dio.get(ApiEndpoints.getAllArts,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ));
      if (response.statusCode == 200) {
        // OR
        // 2nd way
        GetAllArtDTO getHomeDTO = GetAllArtDTO.fromJson(response.data);
        return Right(homeApiModel.toEntityList(getHomeDTO.data));
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

  Future<Either<Failure, List<HomeEntity>>> getSavedArts() async {
    try {
      String? token;
      await userSharedPrefs.getUserToken().then(
            (value) => value.fold((l) => null, (r) => token = r),
          );

      var response = await dio.get(
        ApiEndpoints.getSavedArts,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.statusCode == 200) {
        GetSavedArtsDTO profileAddDTO = GetSavedArtsDTO.fromJson(response.data);
        return Right(homeApiModel.toEntityList(profileAddDTO.data));
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

  Future<Either<Failure, bool>> saveArt(String artId) async {
    try {
      String? token;
      var data = await userSharedPrefs.getUserToken();
      data.fold(
        (l) => token = null,
        (r) => token = r,
      );

      var response = await dio.post(
        ApiEndpoints.saveArt(artId),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data['message'],
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

  Future<Either<Failure, bool>> unsaveArt(String artId) async {
    try {
      String? token;
      var data = await userSharedPrefs.getUserToken();
      data.fold(
        (l) => token = null,
        (r) => token = r,
      );

      var response = await dio.delete(
        ApiEndpoints.unsaveArt(artId),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data['message'],
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

  Future<Either<Failure, List<HomeEntity>>> getAlertArts() async {
    try {
      String? token;
      await userSharedPrefs.getUserToken().then(
            (value) => value.fold((l) => null, (r) => token = r),
          );

      var response = await dio.get(
        ApiEndpoints.getAlertArts,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.statusCode == 200) {
        GetAlertArtsDTO profileAddDTO = GetAlertArtsDTO.fromJson(response.data);
        return Right(homeApiModel.toEntityList(profileAddDTO.data));
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

  Future<Either<Failure, bool>> alertArt(String artId) async {
    try {
      String? token;
      var data = await userSharedPrefs.getUserToken();
      data.fold(
        (l) => token = null,
        (r) => token = r,
      );

      var response = await dio.post(
        ApiEndpoints.alertArt(artId),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data['message'],
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

  Future<Either<Failure, bool>> unAlertArt(String artId) async {
    try {
      String? token;
      var data = await userSharedPrefs.getUserToken();
      data.fold(
        (l) => token = null,
        (r) => token = r,
      );

      var response = await dio.delete(
        ApiEndpoints.unAlertArt(artId),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data['message'],
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

  Future<Either<Failure, List<HomeEntity>>> getUserArts() async {
    try {
      String? token;
      await userSharedPrefs.getUserToken().then(
            (value) => value.fold((l) => null, (r) => token = r),
          );

      var response = await dio.get(
        ApiEndpoints.getUserArts,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.statusCode == 200) {
        GetUserArtsDTO profileAddDTO = GetUserArtsDTO.fromJson(response.data);
        return Right(homeApiModel.toEntityList(profileAddDTO.data));
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

  Future<Either<Failure, bool>> updateArt(String title, String startingBid, String artId) async {
    try {
      String? token;
      var data = await userSharedPrefs.getUserToken();
      data.fold(
        (l) => token = null,
        (r) => token = r,
      );

      var response = await dio.put(
        ApiEndpoints.updateArt(artId),
        data: {
          'title': title,
          'startingBid': startingBid,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 204) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: 'Failed to update art. Please try again.',
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

  Future<Either<Failure, bool>> deleteArt(String artId) async {
    try {
      String? token;
      var data = await userSharedPrefs.getUserToken();
      data.fold(
        (l) => token = null,
        (r) => token = r,
      );

      var response = await dio.delete(
        ApiEndpoints.deleteArt(artId),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data['message'],
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

    Future<Either<Failure, List<HomeEntity>>> getArtById(String artId) async {
    try {
      String? token;
      await userSharedPrefs.getUserToken().then(
            (value) => value.fold((l) => null, (r) => token = r),
          );

      var response = await dio.get(
        ApiEndpoints.getArtById(artId),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.statusCode == 200) {
        GetArtByIdDTO homeAddDTO = GetArtByIdDTO.fromJson(response.data);
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
