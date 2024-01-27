import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
import 'package:flutter_final_assignment/config/router/app_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/common/components/already_have_an_account_check.dart';
import '../../../../../../core/common/components/rounded_button_field.dart';
import '../../../../../../core/common/components/rounded_input_field.dart';
import '../../../../../../core/common/components/rounded_password_field.dart';
import '../../../../../../core/common/widget/semi_big_text.dart';
import '../../../viewmodel/auth_view_model.dart';
import '../forgot_password.dart';

class Body extends ConsumerStatefulWidget {
  const Body({
    super.key,
  });

  @override
  ConsumerState<Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {
  final loginKey = GlobalKey<FormState>();

  // List<User>? users;

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();


  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    final gap = SizedBox(height: isTablet ? 25.0 : 20.0);
    return Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Form(
          key: loginKey,
          child: Padding(
            padding: isTablet 
                    ? const EdgeInsets.fromLTRB(40.0, 0, 40, 0)
                    : const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.ce,
      children: <Widget>[
        SvgPicture.asset(
          "assets/images/logo.svg",
          color: AppColorConstant.mainSecondaryColor,
          width: isTablet ? 180.0 : 160.0,
        ),
        gap,
        const SemiBigText(
          text: "Hi there!!",
          // textAlign: TextAlign.center,
          spacing: 0,
          color: AppColorConstant.mainSecondaryColor,
        ),
        Text(
          "Welcome Back",
          // textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: isTablet ? 32.0 : 28.0,
            color: AppColorConstant.mainSecondaryColor,
            fontWeight: FontWeight.w500,
            
          ),
        ),
        gap,
        RoundedInputField(
          // key: const ValueKey('usernameField'),
          controller: userNameController,
          hintText: "Username",
          icon: Icons.person,
          // onChanged: (value) {},
          keyboardType: TextInputType.name,
        ),
        gap,
        RoundedPasswordField(
          // key: const ValueKey('passwordField'),
          controller: passwordController,
          hintText: "Password",
          // onChanged: (value) {},
        ),
        gap,
        Padding(
          padding: EdgeInsets.only(right: AppColorConstant.kDefaultPadding / 4),
          child: Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ForgotPasswordPagae();
                    },
                  ),
                );
              },
              child: Text(
                 'Forgot Password?',
                 style: TextStyle(
                  fontSize: isTablet ? 24.0 : 18.0,
                  color: AppColorConstant.mainSecondaryColor,
                  fontWeight: FontWeight.w400
                 ),
                // spacing: 0,
                // size: 18,
              ),
            ),
          ),
        ),
        gap,
        RoundedButton(
          text: "LOGIN",
          press: () async {
            if (loginKey.currentState!.validate()) {
              await ref.read(authViewModelProvider.notifier).loginUser(
                  context, userNameController.text, passwordController.text);
            }
          },
        ),
        gap,
        AlreadyHaveAnAccountCheck(
          press: () {
            Navigator.pushNamed(context, AppRoute.registerRoute);
          },
        )
      ],
    ),
          ),
        ),
      ),
    );
  }
}