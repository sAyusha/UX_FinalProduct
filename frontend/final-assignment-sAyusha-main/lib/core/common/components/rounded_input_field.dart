import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoundedInputField extends ConsumerWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final int? maxLines;
  final TextInputType keyboardType;

  const RoundedInputField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.icon,
    this.maxLines = 1,
    required this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    return Column(
      children: [
        TextFormField(
          cursorColor: AppColorConstant.mainSecondaryColor,
          cursorHeight: isTablet ? 30 : 25,
          maxLines: maxLines,
          controller: controller,
          validator: (text) {
            if (text == null || text.isEmpty) {
              return "required";
            }
            return null;
          },
          keyboardType: keyboardType,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                vertical: isTablet ? 28 : 18, horizontal: 20),
            prefixIcon: icon != null
                ? Icon(
                    icon,
                    size: isTablet ? 28 : 25,
                    color: AppColorConstant.mainSecondaryColor,
                  )
                : null,
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: "Poppins",
              fontSize: isTablet ? 22 : 20,
              fontWeight: FontWeight.w400,
              color: AppColorConstant.mainSecondaryColor,
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColorConstant.mainSecondaryColor,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColorConstant.mainSecondaryColor,
                width: 2.0,
              ),
            ),
          ),
          style: TextStyle(
              fontFamily: "Poppins",
              fontSize: isTablet ? 22 : 20,
              color: AppColorConstant.mainSecondaryColor),
        ),
      ],
    );
  }
}
