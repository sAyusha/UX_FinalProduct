// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/router/app_route.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common/snackbar/my_snackbar.dart';
import '../../../navbar/presentation/view/bottom_navigation/bottom_navigation_bar.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/use_case/auth_usecase.dart';
import '../state/auth_state.dart';

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  return AuthViewModel(
    ref.read(authUseCaseProvider),
  );
});

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthUseCase _authUseCase;

  AuthViewModel(this._authUseCase) : super(AuthState(isLoading: false));

  Future<void> registerUser(BuildContext context, UserEntity user) async {
    state = state.copyWith(isLoading: true);
    var data = await _authUseCase.registerUser(user);
    data.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.error);
        showSnackBar(
            message: "User already exists", context: context, color: Colors.red);
      },
      (success) {
        state = state.copyWith(isLoading: false, error: null);
        showSnackBar(
          message: "Registered Successfully", 
          context: context
        );
        Navigator.pushNamed(
          context, AppRoute.loginRoute
        );
        
      },
    );
  }

  Future<void> loginUser(
      BuildContext
          context, // yo kaile pani use nagarne but for now we are using it
      String username,
      String password) async {
    state = state.copyWith(isLoading: true);
    // bool isLogin = false;
    var data = await _authUseCase.loginUser(username, password);
    data.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.error);
        showSnackBar(
            message: "Invalid username or password", context: context, color: Colors.red);
      },
      (success) {
        state = state.copyWith(isLoading: false, error: null);
         Navigator.push(context,
          MaterialPageRoute(
            builder: (context) =>
                const ButtomNavView(selectedIndex: 0),
          ),
         );
      },
    );
    // return isLogin;
  }

  // Future<void> uploadImage(File file) async {
  //   state = state.copyWith(isLoading: true);
  //   var data = await _authUseCase.uploadProfilePicture(file);
  //   data.fold(
  //     (failure) => state = state.copyWith(
  //       isLoading: false,
  //       error: failure.error,
  //     ),
  //     (imageName) {
  //       state = state.copyWith(
  //         isLoading: false,
  //         error: null,
  //         imageName: imageName,
  //       );
  //     }
  //   );
  // }
}
