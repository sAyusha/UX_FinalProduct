import 'package:dartz/dartz.dart';
import 'package:flutter_final_assignment/core/network/local/hive_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../../domain/entity/home_entity.dart';
import '../model/home_hive_model.dart';

// Dependency Injection using Riverpod
final homeLocalDataSourceProvider = Provider<HomeLocalDataSource>((ref) {
  return HomeLocalDataSource(
      hiveService: ref.read(hiveServiceProvider),
      homeHiveModel: ref.read(homeHiveModelProvider));
});

class HomeLocalDataSource{
  final HiveService hiveService;
  final HomeHiveModel homeHiveModel;

  HomeLocalDataSource(
    {required this.hiveService, 
    required this.homeHiveModel}
  );

  //add art
  Future<Either<Failure, bool>> addArt(HomeEntity art) async {
    try {
      // Convert Entity to Hive Object
      final hiveArt = homeHiveModel.toHiveModel(art);
      // Add to Hive
      await hiveService.addArt(hiveArt);
      return const Right(true);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

    Future<Either<Failure, List<HomeEntity>>> getAllArt() async {
    try {
      // Get all arts from Hive
      final arts = await hiveService.getAllArt();
      // Convert Hive Object to Entity
      final artEntities = homeHiveModel.toEntityList(arts);
      return Right(artEntities);


    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }
}