import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
// import 'package:flutter_final_assignment/model/user.dart';

import 'components/body.dart';

class LoginPageView extends StatelessWidget {
  const LoginPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColorConstant.primaryAccentColor,
      body: SafeArea(
        child: Body(),
      ),
    );
  }
}

