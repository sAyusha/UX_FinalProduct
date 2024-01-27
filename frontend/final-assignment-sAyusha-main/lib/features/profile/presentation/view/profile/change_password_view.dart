import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/core/common/snackbar/my_snackbar.dart';
import 'package:flutter_final_assignment/core/common/widget/semi_big_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../config/constants/api_endpoint.dart';
import '../../../../../config/constants/app_color_constant.dart';
import '../../../domain/entity/password_entity.dart';
import '../../../domain/entity/profile_entity.dart';
import '../../viewmodel/password_viewmodel.dart';
import '../../viewmodel/profile_viewmodel.dart';

class ChangePasswordView extends ConsumerStatefulWidget {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  ConsumerState<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends ConsumerState<ChangePasswordView> {
  // Create form key and text editing controllers
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  bool _obscureOldPassword = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _toggleOldPasswordVisibility() {
    setState(() {
      _obscureOldPassword = !_obscureOldPassword;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  @override
  void dispose() {
    // Dispose the text editing controllers
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    final gap = SizedBox(height: isTablet ? 20 : 10);
    var userState = ref.watch(profileViewModelProvider);
    List<ProfileEntity> userData = userState.userData;

    // var passwordState = ref.watch(passwordViewModelProvider);

    if (userData.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(), // Show loader
      );
    }

    return Scaffold(
      backgroundColor: AppColorConstant.mainSecondaryColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      left: 5,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.black,
                        iconSize: isTablet ? 35 : 25,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      margin: isTablet ? 
                        const EdgeInsets.fromLTRB(20, 200.0, 20, 0) 
                        : const EdgeInsets.fromLTRB(20, 130.0, 20, 0),
                      decoration: const BoxDecoration(
                        color: AppColorConstant.primaryAccentColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      // constraints: BoxConstraints(
                      //   minHeight: screenHeight - 180.0,
                      // ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -60,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3.0,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 100,
                                    backgroundImage: userData[0].profileImage != null ?
                                    NetworkImage(
                                      '${ApiEndpoints.baseUrl}/uploads/${userData[0].profileImage}',
                                    )
                                    : const AssetImage(
                                      'assets/images/avatar.jpg',
                                    ) as ImageProvider,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 80.0),
                            child: Center(
                              child: Column(
                                children: [
                                  SemiBigText(
                                    text: userData[0].fullname,
                                    spacing: 0,
                                    color: AppColorConstant.whiteTextColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 160.0,
                              left: 18.0,
                              right: 18.0,
                              bottom: 18.0,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SemiBigText(
                                        text: 'Change Password',
                                        spacing: 0,
                                        color: AppColorConstant.appBarColor,
                                      ),
                                      gap,
                                      TextFormField(
                                        controller: _oldPasswordController,
                                        obscureText: _obscureOldPassword,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Old Password is required';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Old Password',
                                          hintStyle: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: isTablet ? 25 : 18),
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          suffixIcon: IconButton(
                                            icon: _obscureOldPassword
                                                ? const Icon(
                                                    Icons.visibility_off)
                                                : const Icon(Icons.visibility),
                                            onPressed:
                                                _toggleOldPasswordVisibility,
                                          ),
                                        ),
                                      ),
                                      gap,
                                      TextFormField(
                                        controller: _newPasswordController,
                                        obscureText: _obscurePassword,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'New Password is required';
                                          }
                                          if (value.length < 8) {
                                            return 'New Password must be at least 8 characters long';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'New Password',
                                          hintStyle: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: isTablet ? 25 : 18),
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          suffixIcon: IconButton(
                                            icon: _obscurePassword
                                                ? const Icon(
                                                    Icons.visibility_off)
                                                : const Icon(Icons.visibility),
                                            onPressed:
                                                _togglePasswordVisibility,
                                          ),
                                        ),
                                      ),
                                      gap,
                                      TextFormField(
                                        controller:
                                            _confirmNewPasswordController,
                                        obscureText: _obscureConfirmPassword,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Confirm New Password is required';
                                          }
                                          if (value !=
                                              _newPasswordController.text) {
                                            return 'New Password and Confirm New Password must match';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Confirm New Password',
                                          hintStyle: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: isTablet ? 25 : 18),
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          suffixIcon: IconButton(
                                            icon: _obscureConfirmPassword
                                                ? const Icon(
                                                    Icons.visibility_off)
                                                : const Icon(Icons.visibility),
                                            onPressed:
                                                _toggleConfirmPasswordVisibility,
                                          ),
                                        ),
                                      ),
                                      gap,
                                      gap,
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              ref
                                                  .read(
                                                      passwordViewModelProvider
                                                          .notifier)
                                                  .changePassword(
                                                    PasswordEntity(
                                                      oldPassword:
                                                          _oldPasswordController
                                                              .text,
                                                      newPassword:
                                                          _newPasswordController
                                                              .text,
                                                      confirmPassword:
                                                          _confirmNewPasswordController
                                                              .text,
                                                    ),
                                                  );

                                              showSnackBar(
                                                  message:
                                                      "Password Changed Successfully.",
                                                  context: context);

                                              _oldPasswordController.clear();
                                              _newPasswordController.clear();
                                              _confirmNewPasswordController
                                                  .clear();
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColorConstant
                                                .mainSecondaryColor,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16.0,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          child: SemiBigText(
                                            text:
                                                'Confirm'.toUpperCase(),
                                            spacing: 0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
