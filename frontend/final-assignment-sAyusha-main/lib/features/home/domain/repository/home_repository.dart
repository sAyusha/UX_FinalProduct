import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../../core/common/provider/internet_connectivity.dart';
import '../../../../core/common/provider/internet_connectivity.dart';
import '../../../../core/failure/failure.dart';
import '../../data/repository/home_local_repo_impl.dart';
import '../../data/repository/home_remote_repo_impl.dart';
import '../entity/home_entity.dart';

// create constructor for IBatchRespository
final homeRepositoryProvider = Provider.autoDispose<IHomeRepository>(
  (ref) {
    // return ref.watch(batchLocalRepoProvider);
    // // Check for the internet
    final internetStatus = ref.watch(connectivityStatusProvider);

    if (ConnectivityStatus.isConnected == internetStatus) {
      // If internet is available then return remote repo
      return ref.watch(homeRemoteRepoProvider);
    } else {
      // If internet is not available then return local repo
      return ref.watch(homeLocalRepoProvider);
    }
  },
);

abstract class IHomeRepository{
  Future<Either<Failure, List<HomeEntity>>> getAllArt();
  Future<Either<Failure, bool>> addArt(HomeEntity art);
  Future<Either<Failure, List<HomeEntity>>> getSavedArts();
  Future<Either<Failure, bool>> saveArt(String artId);
  Future<Either<Failure, bool>> unsaveArt(String artId);
  Future<Either<Failure, List<HomeEntity>>> getAlertArts();
  Future<Either<Failure, bool>> alertArt(String artId);
  Future<Either<Failure, bool>> unAlertArt(String artId);
  Future<Either<Failure, List<HomeEntity>>> getUserArts();
  Future<Either<Failure, bool>> deleteArt(String artId);
  Future<Either<Failure, bool>> updateArt(String title, String startingBid, String artId);
  Future<Either<Failure, List<HomeEntity>>> getArtById(String artId);


}