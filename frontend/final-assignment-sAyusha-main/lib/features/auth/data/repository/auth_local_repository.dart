// import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_final_assignment/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_source/auth_local_data_source.dart';

final authLocalRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthLocalRepository(
    ref.read(authLocalDataSourceProvider),
  );
});

class AuthLocalRepository implements IAuthRepository {
  final AuthLocalDataSource _authLocalDataSource;

  AuthLocalRepository(this._authLocalDataSource);

  @override
  Future<Either<Failure, bool>> loginUser(String username, String password) {
    return _authLocalDataSource.loginUser(username, password);
  }

  // @override
  // Future<Either<Failure, String>> uploadProfilePicture(File file) async {
  //   return const Right("");
  // }

  @override
  Future<Either<Failure, bool>> registerUser(UserEntity user) {
    // TODO: implement registerUser
    throw UnimplementedError();
  }
}
