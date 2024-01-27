import 'package:dartz/dartz.dart';
import 'package:flutter_final_assignment/core/failure/failure.dart';
import 'package:flutter_final_assignment/features/home/data/data_source/home_remote_data_source.dart';
import 'package:flutter_final_assignment/features/home/domain/entity/home_entity.dart';
import 'package:flutter_final_assignment/features/home/domain/repository/home_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//create a provider for HomeRemoteRepositoryImpl
final homeRemoteRepoProvider = Provider.autoDispose<IHomeRepository>(
  (ref) => HomeRemoteRepositoryImpl(
    homeRemoteDataSource: ref.read(homeRemoteDataSourceProvider),
  ),
);

class HomeRemoteRepositoryImpl implements IHomeRepository{
  final HomeRemoteDataSource homeRemoteDataSource;

  HomeRemoteRepositoryImpl({
    required this.homeRemoteDataSource,
  });

  @override
  Future<Either<Failure, bool>> addArt(HomeEntity art) {
    return homeRemoteDataSource.addArt(art);
  }

  @override
  Future<Either<Failure, List<HomeEntity>>> getAllArt() {
    return homeRemoteDataSource.getAllArt();
  }

   @override
  Future<Either<Failure, List<HomeEntity>>> getSavedArts() {
    return homeRemoteDataSource.getSavedArts();
  }

  @override
  Future<Either<Failure, bool>> saveArt(String artId) {
    return homeRemoteDataSource.saveArt(artId);
  }

  @override
  Future<Either<Failure, bool>> unsaveArt(String artId) {
    return homeRemoteDataSource.unsaveArt(artId);
  }

   @override
  Future<Either<Failure, List<HomeEntity>>> getAlertArts() {
    return homeRemoteDataSource.getAlertArts();
  }

  @override
  Future<Either<Failure, bool>> alertArt(String artId) {
    return homeRemoteDataSource.alertArt(artId);
  }

  @override
  Future<Either<Failure, bool>> unAlertArt(String artId) {
    return homeRemoteDataSource.unAlertArt(artId);
  }

  @override
  Future<Either<Failure, List<HomeEntity>>> getUserArts() {
    return homeRemoteDataSource.getUserArts();
  }

  @override
  Future<Either<Failure, bool>> updateArt(String title, String startingBid, String artId) {
    return homeRemoteDataSource.updateArt(title, startingBid, artId);
  }

  @override
  Future<Either<Failure, bool>> deleteArt(String artId) {
    return homeRemoteDataSource.deleteArt(artId);
  }

  @override
  Future<Either<Failure, List<HomeEntity>>> getArtById(String artId) {
    return homeRemoteDataSource.getArtById(artId);
  }


}