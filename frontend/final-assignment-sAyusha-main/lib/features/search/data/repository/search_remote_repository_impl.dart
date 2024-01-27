import 'package:dartz/dartz.dart';
import 'package:flutter_final_assignment/features/home/domain/entity/home_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../../domain/repository/search_repository.dart';
import '../data_source/search_remote_data_source.dart';

final searchRemoteRepoProvider = Provider<ISearchRepository>(
  (ref) => SearchRemoteRepositoryImpl(
    searchRemoteDataSource: ref.read(searchRemoteDataSourceProvider),
  ),
);

class SearchRemoteRepositoryImpl implements ISearchRepository {
  final SearchRemoteDataSource searchRemoteDataSource;

  SearchRemoteRepositoryImpl({required this.searchRemoteDataSource});

  @override
  Future<Either<Failure, List<HomeEntity>>> getSearchedArts(
      String searchQuery) {
    return searchRemoteDataSource.getSearchedArts(searchQuery);
  }
}