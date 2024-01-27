import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/features/post/domain/entity/post_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common/snackbar/my_snackbar.dart';
import '../../../navbar/presentation/view/bottom_navigation/bottom_navigation_bar.dart';
import '../../domain/use_case/post_use_case.dart';
import '../state/post_state.dart';

final postViewModelProvider =
    StateNotifierProvider<PostViewModel, PostState>((ref) {
  return PostViewModel(
    ref.read(postUseCaseProvider),
  );
});

class PostViewModel extends StateNotifier<PostState> {
  final PostUseCase postUseCase;

  PostViewModel(this.postUseCase) : super(PostState.initial()){
    // getPosts();
  }

  Future<void> uploadArtPicture(File? file) async {
    state = state.copyWith(isLoading: true);
    var data = await postUseCase.uploadArtPicture(file!);
    data.fold(
      (l) {
        state = state.copyWith(isLoading: false, error: l.error);
      },
      (imageName) {
        state =
            state.copyWith(isLoading: false, error: null, imageName: imageName);
      },
    );
  }

  postArt(BuildContext context, PostEntity art) async {
    state = state.copyWith(isLoading: true);
    var data = await postUseCase.postArt(art);
    data.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.error,
        );
        showSnackBar(message: failure.error, context: context, color: Colors.red);
      },
      (success) {
        state = state.copyWith(isLoading: false, error: null);
        showSnackBar(message: "Successfully posted", context: context);
        Navigator.push(context,
          MaterialPageRoute(
            builder: (context) =>
                const ButtomNavView(selectedIndex: 0),
          ),
         );
      },
    );
  }
}
