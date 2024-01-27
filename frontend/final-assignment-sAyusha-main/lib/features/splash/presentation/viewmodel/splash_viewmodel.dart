import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../../config/router/app_route.dart';
import '../../../../core/shared_preferences/user_shared_prefs.dart';
import '../../../navbar/presentation/view/bottom_navigation/bottom_navigation_bar.dart';

final splashViewModelProvider = StateNotifierProvider<SplashViewModel, void>(
  (ref) {
    return SplashViewModel(
      ref.read(userSharedPrefsProvider),
    );
  },
);

class SplashViewModel extends StateNotifier<void> {
  final UserSharedPrefs _userSharedPrefs;
  SplashViewModel(this._userSharedPrefs) : super(null);

  init(BuildContext context) async {
    final data = await _userSharedPrefs.getUserToken();

    data.fold((l) => null, (token) {
      if (token != null) {
        bool isTokenExpired = isValidToken(token);
        if (isTokenExpired) {
          // We will not do navigation like this,
          // we will use mixin and navigator class for this
          Navigator.popAndPushNamed(context, AppRoute.loginRoute);
        } else {
          Navigator.push(context,
          MaterialPageRoute(
            builder: (context) =>
                const ButtomNavView(selectedIndex: 0),
          ),
        );
        }
      } else {
        Navigator.popAndPushNamed(context, AppRoute.loginRoute);
      }
    });
  }
  bool isValidToken(String token) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    int expirationTimestamp = decodedToken['exp'];

    final currentDate = DateTime.now().millisecondsSinceEpoch;
    // If current date is greater than expiration timestamp then token is expired
    return currentDate > expirationTimestamp * 1000;
  }
}