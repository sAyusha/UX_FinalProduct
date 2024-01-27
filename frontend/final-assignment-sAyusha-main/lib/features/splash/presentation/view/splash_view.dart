import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
// import 'package:flutter_final_assignment/features/splash/presentation/view/welcome/welcome_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../viewmodel/splash_viewmodel.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      // Navigator.pushNamed(context, AppRoute.welcomeRoute);
      ref.read(splashViewModelProvider.notifier).init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColorConstant.mainSecondaryColor,
      body: SizedBox(
        width: double.infinity,
        // height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/images/logo1.svg", 
            width: 200,
            height: 200,
            color: AppColorConstant.primaryAccentColor,)
          ],
        ),
        ),
    ); 
  }
}