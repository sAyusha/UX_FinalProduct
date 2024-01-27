import 'package:flutter_final_assignment/features/art_details/presentation/view/art_details/art_details_view.dart';
import 'package:flutter_final_assignment/features/home/presentation/view/home/home_page_view.dart';
import 'package:flutter_final_assignment/features/home/presentation/view/home/update_art_view.dart';
import 'package:flutter_final_assignment/features/profile/presentation/view/profile/change_password_view.dart';
import 'package:flutter_final_assignment/features/profile/presentation/view/profile/profile_page_view.dart';
import 'package:flutter_final_assignment/features/profile/presentation/view/profile/update_profile_view.dart';
import 'package:flutter_final_assignment/features/upcoming/presentation/view/upcoming/upcoming_page_view.dart';

import '../../features/auth/presentation/view/login/login_view.dart';
import '../../features/auth/presentation/view/signup/signup_view.dart';
import '../../features/navbar/presentation/view/bottom_navigation/bottom_navigation_bar.dart';
import '../../features/post/presentation/view/post/post_art_view.dart';
import '../../features/search/presentation/view/search_art_view.dart';
import '../../features/splash/presentation/view/splash_view.dart';

class AppRoute {
  AppRoute._();

  static const String splashRoute = '/splash';
  static const String homeRoute = '/home';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String bottomNavRoute = '/navbar';
  static const String profileRoute = '/profile';
  static const String upcomingRoute = '/upcoming';
  static const String artRoute = '/art';
  static const String postRoute = '/post';
  static const String updateArt = '/updateArt';
  static const String searchArt = '/searchArt';
  static const String editProfile = '/editProfile';
  static const String changePassword= '/changePassword';

  static getApplicationRoute() {
    return {
      splashRoute: (context) => const SplashView(),
      homeRoute: (context) => const HomePageView(),
      loginRoute: (context) => const LoginPageView(),
      registerRoute: (context) => const SignUpPageView(),
      bottomNavRoute: (context) => const ButtomNavView(),
      profileRoute: (context) => ProfilePageView(),
      upcomingRoute: (context) => const UpcomingPageView(),
      artRoute: (context) => const ArtDetailsView(),
      postRoute: (context) => const PostArtView(),
      updateArt: (context) => const UpdateArt(),
      searchArt: (context) => const SearchArtView(),
      editProfile: (context) => const UpdateProfileView(),
      changePassword: (context) => const ChangePasswordView(),
    };
  }
}
