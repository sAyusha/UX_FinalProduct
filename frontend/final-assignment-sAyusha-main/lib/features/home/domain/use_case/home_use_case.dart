import 'package:dartz/dartz.dart';
import 'package:flutter_final_assignment/features/home/domain/repository/home_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../entity/home_entity.dart';

final homeUsecaseProvider = Provider.autoDispose<HomeUseCase>(
  (ref) => HomeUseCase(
    homeRepository: ref.watch(homeRepositoryProvider),
  ),
);

class HomeUseCase{
  final IHomeRepository homeRepository;

  HomeUseCase({
    required this.homeRepository,
  });

  Future<Either<Failure, List<HomeEntity>>> getAllArt() async {
    return homeRepository.getAllArt();
  }

  Future<Either<Failure, bool>> addArt(HomeEntity art) async {
    return homeRepository.addArt(art);
  }

  Future<Either<Failure, List<HomeEntity>>> getSavedArts() async {
    return homeRepository.getSavedArts();
  }

  Future<Either<Failure, bool>> saveArt(String artId) async {
    return homeRepository.saveArt(artId);
  }

  Future<Either<Failure, bool>> unsaveArt(String artId) async {
    return homeRepository.unsaveArt(artId);
  }

  Future<Either<Failure, List<HomeEntity>>> getAlertArts() async {
    return homeRepository.getAlertArts();
  }

  Future<Either<Failure, bool>> alertArt(String artId) async {
    return homeRepository.alertArt(artId);
  }

  Future<Either<Failure, bool>> unAlertArt(String artId) async {
    return homeRepository.unAlertArt(artId);
  }

  Future<Either<Failure, List<HomeEntity>>> getUserArts() async {
    return homeRepository.getUserArts();
  }

  Future<Either<Failure, bool>> deleteArt(String artId) async {
    return homeRepository.deleteArt(artId);
  }

  Future<Either<Failure, bool>> updateArt(String title, String startingBid, String artId) async {
    return homeRepository.updateArt(title, startingBid, artId);
  }

  Future<Either<Failure, List<HomeEntity>>> getArtById(String artId) async {
    return homeRepository.getArtById(artId);
  }
}