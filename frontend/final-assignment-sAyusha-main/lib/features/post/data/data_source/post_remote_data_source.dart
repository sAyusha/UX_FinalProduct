import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_final_assignment/config/constants/api_endpoint.dart';
import 'package:flutter_final_assignment/core/network/remote/http_service.dart';
import 'package:flutter_final_assignment/core/shared_preferences/user_shared_prefs.dart';
import 'package:flutter_final_assignment/features/post/domain/entity/post_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../../../auth/data/model/auth_api_model.dart';
import '../model/post_api_model.dart';

// create provider for PostRemoteDataSource
final postRemoteDataSourceProvider =
    Provider.autoDispose<PostRemoteDataSource>((ref) {
  return PostRemoteDataSource(
    dio: ref.read(httpServiceProvider),
    postApiModel: ref.read(postApiModelProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
    authApiModel: ref.read(authApiModelProvider),
  );
});

class PostRemoteDataSource {
  final Dio dio;
  final PostApiModel postApiModel;
  final UserSharedPrefs userSharedPrefs;
  final AuthApiModel authApiModel;

  PostRemoteDataSource({
    required this.dio,
    required this.postApiModel,
    required this.authApiModel,
    required this.userSharedPrefs,
  });

  Future<Either<Failure, bool>> postArt(PostEntity art) async {
    try {
      //get token
      String? token;
      await userSharedPrefs
          .getUserToken()
          .then((value) => value.fold((l) => null, (r) => token = r!));
      var response = await dio.post(
        ApiEndpoints.postArt,
        options: Options(headers: {
          'Authorization': 'Bearer $token'
        }), // Include the authentication token in the request headers
        data: postApiModel.fromEntity(art).toJson(),
        // data: {
        //   "image": art.image,
        //   "title": art.title,
        //   "creator": art.creator,
        //   "description": art.description,
        //   "startingBid": art.startingBid,
        //   "endingDate": art.endingDate,
        //   "artType": art.artType,
        //   "categories": art.categories,
        // },
      );
      if (response.statusCode == 201) {
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

  // Upload image using multipart
  Future<Either<Failure, String>> uploadArtPicture(
    File image,
  ) async {
    try {
      //get token
      String? token;
      await userSharedPrefs
          .getUserToken()
          .then((value) => value.fold((l) => null, (r) => token = r!));
      String fileName = image.path.split('/').last;
      FormData formData = FormData.fromMap(
        {
          'uploadPictures': await MultipartFile.fromFile(
            image.path,
            filename: fileName,
          ),
        },
      );

      Response response = await dio.post(
        ApiEndpoints.artPicture,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: formData,
      );

      return Right(response.data["data"]);
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }
}
