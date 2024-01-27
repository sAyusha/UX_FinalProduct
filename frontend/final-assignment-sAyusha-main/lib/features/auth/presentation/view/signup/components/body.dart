import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/router/app_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../config/constants/app_color_constant.dart';
import '../../../../../../core/common/components/already_have_an_account_check.dart';
import '../../../../../../core/common/components/rounded_button_field.dart';
import '../../../../../../core/common/components/rounded_input_field.dart';
import '../../../../../../core/common/components/rounded_password_field.dart';
import '../../../../../../core/common/widget/semi_big_text.dart';
import '../../../../domain/entity/user_entity.dart';
import '../../../viewmodel/auth_view_model.dart';

class Body extends ConsumerStatefulWidget {
  const Body({super.key, required Column child});

  @override
  ConsumerState<Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {
  final signUpKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final authState = ref.watch(authViewModelProvider);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    final gap = SizedBox(height: isTablet ? 25.0 : 20.0);
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: SingleChildScrollView(
        child: Form(
          key: signUpKey,
          child: Padding(
            padding: isTablet
                ? const EdgeInsets.fromLTRB(40.0, 0, 40, 0)
                : const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: Column(
              children: <Widget>[
                SvgPicture.asset(
                  "assets/images/logo.svg",
                  color: AppColorConstant.mainSecondaryColor,
                  width: isTablet ? 200.0 : 140.0,
                ),
                // // gap,
                const SemiBigText(
                  text: "Create a new account",
                  color: AppColorConstant.mainSecondaryColor,
                  spacing: 0,
                ),
                gap,
                RoundedInputField(
                  controller: fullNameController,
                  hintText: "Full Name",
                  icon: Icons.person_2_outlined,
                  // onChanged: (value) {},
                  keyboardType: TextInputType.text,
              
                ),
                gap,
                RoundedInputField(
                  controller: userNameController,
                  hintText: "Username",
                  icon: Icons.person,
                  // onChanged: (value) {},
                  keyboardType: TextInputType.text,
                ),
                gap,
                RoundedInputField(
                  controller: emailController,
                  hintText: "Email",
                  icon: Icons.email,
                  // onChanged: (value) {},
                  keyboardType: TextInputType.emailAddress,
                ),
                gap,
                RoundedInputField(
                  controller: phoneController,
                  hintText: "Phone",
                  icon: Icons.phone,
                  // onChanged: (value) {},
                  keyboardType: TextInputType.phone,
                ),
                gap,
                RoundedPasswordField(
                  controller: passwordController,
                  hintText: "Password",
                  // onChanged: (value) {},
                ),
                gap,
                RoundedButton(
                  text: "NEXT",
                  press: () {
                    if (signUpKey.currentState!.validate()) {
                      var user = UserEntity(
                        fullname: fullNameController.text,
                        username: userNameController.text,
                        email: emailController.text,
                        phone: phoneController.text,
                        password: passwordController.text,
                      );
                      ref
                          .read(authViewModelProvider.notifier)
                          .registerUser(context, user);
                    }
                  },
                ),
                gap,
                AlreadyHaveAnAccountCheck(
                  login: false,
                  press: () {
                    Navigator.pushNamed(context, AppRoute.loginRoute);
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
