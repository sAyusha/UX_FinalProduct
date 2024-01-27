import '../../../home/domain/entity/home_entity.dart';

class SearchState {
  final bool isLoading;
  final List<HomeEntity> searchedArts;
  final String? error;

  SearchState({
    required this.isLoading,
    required this.searchedArts,
    this.error,
  });

  factory SearchState.initial() {
    return SearchState(isLoading: false, searchedArts: []);
  }

  SearchState copyWith({
    bool? isLoading,
    List<HomeEntity>? searchedArts,
    String? error,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      searchedArts: searchedArts ?? this.searchedArts,
      error: error ?? this.error,
    );
  }
}