import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'text_field_container.dart';

class RoundedPasswordField extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final String hintText;
  // final ValueChanged<String> onChanged;

  const RoundedPasswordField({
    super.key,
    required this.controller,
    required this.hintText,
    // required this.onChanged,
  });

  @override
  ConsumerState<RoundedPasswordField> createState() =>
      _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends ConsumerState<RoundedPasswordField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    return Column(
      children: [
        TextFormField(
          controller: widget.controller,
          obscureText: obscureText,
          validator: (text) {
            if (text!.isEmpty) {
              return "required";
            }
            return null;
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                vertical: isTablet ? 28 : 18, horizontal: 20),
            hintText: "Password",
            hintStyle: TextStyle(
              fontFamily: "Poppins",
              fontSize: isTablet ? 22 : 20,
              fontWeight: FontWeight.w400,
              color: AppColorConstant.mainSecondaryColor,
            ),
            prefixIcon: Icon(
              Icons.lock,
              size: isTablet ? 24 : 25,
              color: AppColorConstant.mainSecondaryColor,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
              child: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
                size: isTablet ? 28 : 24,
                color: AppColorConstant.mainSecondaryColor,
              ),
            ),
            
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: AppColorConstant.mainSecondaryColor, width: 2.0),
              borderRadius: BorderRadius.circular(8),
              // borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                  color: AppColorConstant.mainSecondaryColor, width: 2.0),
            ),
          ),
          style: TextStyle(
            fontFamily: "Poppins", 
            fontSize: isTablet ? 22 : 20,
            color: AppColorConstant.mainSecondaryColor
          ),
        ),
      ],
    );
  }
}
