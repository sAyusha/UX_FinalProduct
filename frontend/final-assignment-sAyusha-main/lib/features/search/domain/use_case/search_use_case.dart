import 'package:dartz/dartz.dart';
import 'package:flutter_final_assignment/features/home/domain/entity/home_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../repository/search_repository.dart';

final searchUsecaseProvider = Provider.autoDispose<SearchUseCase>(
  (ref) => SearchUseCase(
    searchRepository: ref.watch(searchRepositoryProvider),
  ),
);

class SearchUseCase {
  final ISearchRepository searchRepository;

  SearchUseCase({required this.searchRepository});

  Future<Either<Failure, List<HomeEntity>>> getSearchedArts(
      String searchQuery) {
    return searchRepository.getSearchedArts(searchQuery);
  }
}