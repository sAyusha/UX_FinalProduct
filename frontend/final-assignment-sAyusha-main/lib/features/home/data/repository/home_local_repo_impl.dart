import 'package:dartz/dartz.dart';
import 'package:flutter_final_assignment/core/failure/failure.dart';
import 'package:flutter_final_assignment/features/home/data/data_source/home_local_data_source.dart';
import 'package:flutter_final_assignment/features/home/domain/entity/home_entity.dart';
import 'package:flutter_final_assignment/features/home/domain/repository/home_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// create provider for HomeLocalRepository
final homeLocalRepoProvider = Provider.autoDispose<IHomeRepository>((ref) {
  return HomeLocalRepositoryImpl(
    homeLocalDataSource: ref.read(homeLocalDataSourceProvider),
  );
});

class HomeLocalRepositoryImpl implements IHomeRepository{
  final HomeLocalDataSource homeLocalDataSource;

  HomeLocalRepositoryImpl({required this.homeLocalDataSource});
  @override
  Future<Either<Failure, bool>> addArt(HomeEntity art) {
    return homeLocalDataSource.addArt(art);
  }

  @override
  Future<Either<Failure, List<HomeEntity>>> getAllArt() {
    return homeLocalDataSource.getAllArt();
  }
  
  @override
  Future<Either<Failure, bool>> alertArt(String artId) {
    // TODO: implement alertArt
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, bool>> deleteArt(String artId) {
    // TODO: implement deleteArt
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, List<HomeEntity>>> getAlertArts() {
    // TODO: implement getAlertArts
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, List<HomeEntity>>> getSavedArts() {
    // TODO: implement getSavedArts
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, List<HomeEntity>>> getUserArts() {
    // TODO: implement getUserArts
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, bool>> saveArt(String artId) {
    // TODO: implement saveArt
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, bool>> unAlertArt(String artId) {
    // TODO: implement unAlertArt
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, bool>> unsaveArt(String artId) {
    // TODO: implement unsaveArt
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, bool>> updateArt(String title, String startingBid,String artId) {
    // TODO: implement updateArt
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, List<HomeEntity>>> getArtById(String artId) {
    // TODO: implement getArtById
    throw UnimplementedError();
  }

}