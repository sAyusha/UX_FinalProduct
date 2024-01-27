import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AlreadyHaveAnAccountCheck extends ConsumerWidget {
  final bool login;
  final void Function() press;
  const AlreadyHaveAnAccountCheck({
    super.key,
    this.login = true,
    required this.press,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          overflow: TextOverflow.ellipsis,
          login ? "Don't have an Account?  " : "Already have an Account?  ",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: isTablet ? 22.0 : 18.0,
            fontWeight: FontWeight.w400,
            color: AppColorConstant.mainSecondaryColor
          ),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "Sign Up" : "Sign In",
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              fontSize: isTablet ? 24.0 : 20.0,
              color: AppColorConstant.mainSecondaryColor
            ),
          ),
        ),
      ],
    );
  }
}
