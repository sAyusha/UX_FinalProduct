import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/home_entity.dart';
import '../../domain/use_case/home_use_case.dart';
import '../state/home_state.dart';

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, HomeState>(
  (ref) {
    return HomeViewModel(ref.read(homeUsecaseProvider));
  },
);

class HomeViewModel extends StateNotifier<HomeState> {
  final HomeUseCase homeUseCase;

  HomeViewModel(this.homeUseCase) : super(HomeState.initial()) {
    // getAllArt();
    // getSavedArts();
    // getAlertArts();
    // getUserArts();
  }

  addArt(HomeEntity art) async {
    state.copyWith(isLoading: true);
    var data = await homeUseCase.addArt(art);

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, error: null),
    );
  }

  getAllArt() async {
    state = state.copyWith(isLoading: true);
    var data = await homeUseCase.getAllArt();
    state = state.copyWith(arts: []);

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, arts: r, error: null),
    );
  }

  getSavedArts() async {
    state = state.copyWith(isLoading: true);
    var data = await homeUseCase.getSavedArts();

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, savedArts: r, error: null),
    );
  }

  saveArt(String artId) async {
    state = state.copyWith(isLoading: true);
    var data = await homeUseCase.saveArt(artId);

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, error: null),
    );
  }

  unsaveArt(String artId) async {
    state = state.copyWith(isLoading: true);
    var data = await homeUseCase.unsaveArt(artId);

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, error: null),
    );
  }

  getAlertArts() async {
    state = state.copyWith(isLoading: true);
    var data = await homeUseCase.getAlertArts();

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, alertArts: r, error: null),
    );
  }

  alertArt(String artId) async {
    state = state.copyWith(isLoading: true);
    var data = await homeUseCase.alertArt(artId);

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, error: null),
    );
  }

  unAlertArt(String artId) async {
    state = state.copyWith(isLoading: true);
    var data = await homeUseCase.unAlertArt(artId);

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, error: null),
    );
  }

  getUserArts() async {
    state = state.copyWith(isLoading: true);
    var data = await homeUseCase.getUserArts();
    state = state.copyWith(userArts: []);

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, userArts: r, error: null),
    );
  }

  deleteArt(String artId) async {
    state = state.copyWith(isLoading: true);
    var data = await homeUseCase.deleteArt(artId);

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, error: null),
    );
  }

  updateArt(String title, String startingBid, String artId) async {
    state = state.copyWith(isLoading: true);
    var data = await homeUseCase.updateArt(title, startingBid, artId);

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, error: null),
    );
  }

   getArtById(String artId) async {
    state = state.copyWith(isLoading: true);
    var data = await homeUseCase.getArtById(artId);
    state = state.copyWith(artById: []);

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, artById: r, error: null),
    );
  }
}
