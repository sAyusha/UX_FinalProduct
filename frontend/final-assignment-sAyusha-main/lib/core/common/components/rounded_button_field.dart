import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widget/semi_big_text.dart';

class RoundedButton extends ConsumerWidget {
  final String text;
  final void Function() press;
  final Color color, textColor;
  const RoundedButton({
    super.key, 
    required this.text, 
    required this.press, 
    this.color = AppColorConstant.mainSecondaryColor,
      this.textColor = Colors.black,
    });


  @override
  Widget build(BuildContext context, WidgetRef ref) {
        // final screenSize = MediaQuery.of(context).size;
    // final isTablet = screenSize.shortestSide >= 600;
    return SizedBox(
      width: double.infinity,
    child: ElevatedButton(
      onPressed: press, 
      child: SemiBigText(
        text:text,
        color: AppColorConstant.blackTextColor,
      ),
    ),
    );
  }
}

