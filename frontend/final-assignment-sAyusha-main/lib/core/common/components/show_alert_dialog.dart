import 'dart:async';

import 'package:flutter/material.dart';

import '../../../config/constants/app_color_constant.dart';
// import '../widget/small_text.dart';

void showNotification(BuildContext context, String message, {IconData? icon}) {
  final screenSize = MediaQuery.of(context).size;
  final isTablet = screenSize.width > 600;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: AppColorConstant.kDefaultPadding, vertical: 15),
            decoration: BoxDecoration(
              color: AppColorConstant.mainTeritaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: AppColorConstant.successColor,
                    size: 40,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
                Text( 
                  message,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: isTablet ? 22 : 16,
                    fontWeight: FontWeight.w500,
                    color: AppColorConstant.blackTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  // Close the dialog after 2 seconds
  Timer(const Duration(seconds: 2), () {
    Navigator.of(context).pop();
  });
}
