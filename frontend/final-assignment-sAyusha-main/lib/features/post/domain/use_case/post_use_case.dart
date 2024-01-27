import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_final_assignment/features/post/domain/entity/post_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../repository/post_repository.dart';

final postUseCaseProvider = Provider(
  (ref) => PostUseCase(
    postRepository: ref.watch(postRepositoryProvider)
  ),
);

class PostUseCase {
  final IPostRepository postRepository;

  PostUseCase({ required this.postRepository});

  Future<Either<Failure, String>> uploadArtPicture(File file) async {
    return await postRepository.uploadArtPicture(file);
  }

  Future<Either<Failure, bool>> postArt(PostEntity art) async {
    return await postRepository.postArt(art);
  }
}
