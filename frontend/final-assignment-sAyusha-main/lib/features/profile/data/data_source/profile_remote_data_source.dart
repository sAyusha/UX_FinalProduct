import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/constants/api_endpoint.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/network/remote/http_service.dart';
import '../../../../core/shared_preferences/user_shared_prefs.dart';
import '../../../home/data/model/home_api_model.dart';
import '../../domain/entity/password_entity.dart';
import '../../domain/entity/profile_entity.dart';
import '../dto/get_user_dto.dart';
import '../model/password_api_model.dart';
import '../model/profile_api_model.dart';

final profileRemoteDataSourceProvider = Provider(
  (ref) => ProfileRemoteDataSource(
    dio: ref.read(httpServiceProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
    profileApiModel: ref.read(profileApiModelProvider),
    passwordApiModel: ref.read(passwordApiModelProvider),
    homeApiModel: ref.read(homeApiModelProvider),
  ),
);

class ProfileRemoteDataSource {
  final Dio dio;
  final UserSharedPrefs userSharedPrefs;
  final ProfileApiModel profileApiModel;
  final PasswordApiModel passwordApiModel;
  final HomeApiModel homeApiModel;

  ProfileRemoteDataSource({
    required this.userSharedPrefs,
    required this.dio,
    required this.profileApiModel,
    required this.passwordApiModel,
    required this.homeApiModel,
  });

  Future<Either<Failure, List<ProfileEntity>>> getUserProfile() async {
    try {
      String? token;
      await userSharedPrefs.getUserToken().then(
            (value) => value.fold((l) => null, (r) => token = r),
          );

      var response = await dio.get(
        ApiEndpoints.getUser,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        GetUserDTO profileAddDto = GetUserDTO.fromJson(response.data);
        return Right(profileApiModel.toEntityList(profileAddDto.data));
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

  // Upload image using multipart
  Future<Either<Failure, String>> uploadProfilePicture(
    File image,
  ) async {
    try {
      String? token;
      await userSharedPrefs.getUserToken().then(
            (value) => value.fold((l) => null, (r) => token = r),
          );
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
        ApiEndpoints.profilePicture,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
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

  Future<Either<Failure, bool>> changePassword(PasswordEntity password) async {
    try {
      String? token;
      var data = await userSharedPrefs.getUserToken();
      data.fold(
        (l) => token = null,
        (r) => token = r!,
      );

      var response = await dio.put(
        ApiEndpoints.changePassword,
        data: {
          'currentPassword': password.oldPassword,
          'newPassword': password.newPassword,
          'confirmPassword': password.confirmPassword,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 204) {
        // Password changed successfully
        return const Right(true);
      } else if (response.statusCode == 401) {
        // Incorrect current password
        return Left(
          Failure(
            error: response.data['error'] ?? 'Incorrect current password',
          ),
        );
      } else {
        return Left(
          Failure(
            error: 'Failed to change password. Please try again.',
          ),
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse && e.response?.data != null) {
        // Incorrect current password
        return Left(
          Failure(
            error: e.response!.data['error'] ?? 'Incorrect current password',
          ),
        );
      } else {
        return Left(
          Failure(
            error: e.error.toString(),
          ),
        );
      }
    }
  }

  Future<Either<Failure, bool>> editProfile(ProfileEntity profile) async {
    try {
      String? token;
      var data = await userSharedPrefs.getUserToken();
      data.fold(
        (l) => token = null,
        (r) => token = r!,
      );

      var response = await dio.put(
        ApiEndpoints.editProfile,
        data: {
          "profileImage": profile.profileImage,
          "username": profile.username,
          "fullname": profile.fullname,
          "email": profile.email,
          "bio": profile.bio,
          "phone": profile.phone,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 204) {
        // Profile edited successfully
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: 'Failed to edit profile. Please try again.',
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