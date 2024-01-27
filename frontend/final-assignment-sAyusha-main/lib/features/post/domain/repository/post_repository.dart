import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_final_assignment/features/post/domain/entity/post_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../../data/repository/post_remote_repository_impl.dart';

final postRepositoryProvider = Provider<IPostRepository>((ref) {
  return ref.read(postRemoteRepositoryProvider);
});

abstract class IPostRepository {
  Future<Either<Failure, bool>> postArt(PostEntity art);
  Future<Either<Failure, String>> uploadArtPicture(File file);
}
