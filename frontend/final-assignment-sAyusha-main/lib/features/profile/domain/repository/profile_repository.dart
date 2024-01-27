import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../../data/repository/profile_remote_repo_impl.dart';
import '../entity/password_entity.dart';
import '../entity/profile_entity.dart';

final profileRepositoryProvider = Provider.autoDispose<IProfileRepository>(
  (ref) => ref.watch(profileRemoteRepoProvider),
);

abstract class IProfileRepository {
  Future<Either<Failure, String>> uploadProfilePicture(File file);

  Future<Either<Failure, List<ProfileEntity>>> getUserProfile();
   Future<Either<Failure, bool>> changePassword(PasswordEntity password);
  Future<Either<Failure, bool>> editProfile(ProfileEntity profile);
}