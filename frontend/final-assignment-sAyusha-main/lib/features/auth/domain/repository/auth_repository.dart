// import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common/provider/internet_connectivity.dart';
import '../../../../core/failure/failure.dart';
import '../../data/data_source/auth_local_data_source.dart';
import '../../data/repository/auth_remote_repository.dart';
import '../entity/user_entity.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
    final internetStatus = ref.watch(connectivityStatusProvider);

    if (ConnectivityStatus.isConnected == internetStatus) {
      return ref.read(authRemoteRepoProvider);
    } else {
      return ref.read(
          authLocalDataSourceProvider as ProviderListenable<IAuthRepository>);
    }
});

abstract class IAuthRepository {
  Future<Either<Failure, bool>> registerUser(UserEntity user);
  Future<Either<Failure, bool>> loginUser(String username, String password);
  // Future<Either<Failure, String>> uploadProfilePicture(File file);
}


