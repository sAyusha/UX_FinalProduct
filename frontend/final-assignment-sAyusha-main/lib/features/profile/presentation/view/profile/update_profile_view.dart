import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
import 'package:flutter_final_assignment/config/router/app_route.dart';
import 'package:flutter_final_assignment/core/common/snackbar/my_snackbar.dart';
import 'package:flutter_final_assignment/features/navbar/presentation/view/bottom_navigation/bottom_navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/common/components/rounded_button_field.dart';
import '../../../../../../core/common/components/rounded_input_field.dart';
import '../../../../../../core/common/widget/semi_big_text.dart';
import '../../../domain/entity/profile_entity.dart';
import '../../viewmodel/profile_viewmodel.dart';

class UpdateProfileView extends ConsumerStatefulWidget {
  const UpdateProfileView({Key? key}) : super(key: key);

  @override
  ConsumerState<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends ConsumerState<UpdateProfileView> {
  final _updateProfileKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    var userState = ref.read(profileViewModelProvider);
    List<ProfileEntity> userData = userState.userData;
    if (userData.isNotEmpty) {
      _fullNameController.text = userData[0].fullname;
      _usernameController.text = userData[0].username;
      _emailController.text = userData[0].email;
      _bioController.text = userData[0].bio ?? "";
      _contactController.text = userData[0].phone ?? "";
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userState = ref.watch(profileViewModelProvider);
    List<ProfileEntity> userData = userState.userData;

    var profileState = ref.watch(profileViewModelProvider.notifier);

    if (userData.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(), // Show loader
      );
    }

    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    final gap = SizedBox(height: isTablet ? 18.0 : 16.0);

    return Scaffold(
      backgroundColor: AppColorConstant.mainSecondaryColor,
      appBar: AppBar(
        title: const SemiBigText(
          text: 'Update Profile',
          spacing: 0,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, AppRoute.changePassword);
            },
            icon: Icon(
              Icons.lock,
              size: isTablet ? 35 : 25,
              color: AppColorConstant.neutralColor,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _updateProfileKey,
              child: Padding(
                padding: isTablet
                    ? EdgeInsets.all(AppColorConstant.kDefaultPadding)
                    : EdgeInsets.all(AppColorConstant.kDefaultPadding / 2),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SemiBigText(
                      text: "Full Name",
                      spacing: 0,
                    ),
                    TextFormField(
                      // cursorColor: Colors.black,
                      controller: _fullNameController,
                      keyboardType: TextInputType.name,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: '',
                        // hintStyle: TextStyle(
                        //   color: AppColorConstant.blackTextColor,
                        // ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColorConstant.blackTextColor, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColorConstant.blackTextColor, width: 2),
                        ),
                      ),
                    ),
                    gap,
                    const SemiBigText(
                      text: "Username",
                      spacing: 0,
                    ),
                    TextFormField(
                      // cursorColor: Colors.black,
                      controller: _usernameController,
                      keyboardType: TextInputType.name,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: '',
                        // hintStyle: TextStyle(
                        //   color: AppColorConstant.blackTextColor,
                        // ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColorConstant.blackTextColor, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColorConstant.blackTextColor, width: 2),
                        ),
                      ),
                    ),
                    gap,
                    const SemiBigText(
                      text: "Email",
                      spacing: 0,
                    ),
                    // gap,
                    TextFormField(
                      // cursorColor: Colors.black,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: '',
                        // hintStyle: TextStyle(
                        //   color: AppColorConstant.blackTextColor,
                        // ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColorConstant.blackTextColor, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColorConstant.blackTextColor, width: 2),
                        ),
                      ),
                    ),
                    gap,
                    const SemiBigText(
                      text: "Contact No.",
                      spacing: 0,
                    ),
                    // gap,
                    TextFormField(
                      // cursorColor: Colors.black,
                      controller: _contactController,
                      keyboardType: TextInputType.number,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: '',
                        // hintStyle: TextStyle(
                        //   color: AppColorConstant.blackTextColor,
                        // ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColorConstant.blackTextColor, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColorConstant.blackTextColor, width: 2),
                        ),
                      ),
                    ),
                    gap,
                    const SemiBigText(
                      text: "Bio",
                      spacing: 0,
                    ),
                    // gap,
                    TextFormField(
                      // cursorColor: Colors.black,
                      controller: _bioController,
                      keyboardType: TextInputType.text,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: '',
                        // hintStyle: TextStyle(
                        //   color: AppColorConstant.blackTextColor,
                        // ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColorConstant.blackTextColor, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColorConstant.blackTextColor, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: isTablet ? 0 : 16,
                    )
                  ],
                ),
              ),
            ),
            // gap,
            SizedBox(
              width: isTablet ? 700 : 375,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      AppColorConstant.primaryAccentColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                child: SemiBigText(
                  text: "SAVE CHANGES",
                  spacing: 0,
                  color: AppColorConstant.whiteTextColor,
                ),
                onPressed: () async {
                  if (_updateProfileKey.currentState!.validate()) {
                    //create a new profile entity
                    ProfileEntity profile = ProfileEntity(
                      fullname: _fullNameController.text,
                      username: _usernameController.text,
                      email: _emailController.text,
                      phone: _contactController.text,
                      bio: _bioController.text,
                    );

                    //call the edit profile method
                    await profileState.editProfile(profile);

                    await ref
                        .read(profileViewModelProvider.notifier)
                        .getUserProfile();

                    // ignore: use_build_context_synchronously
                    showSnackBar(
                      message: 'Profile Updated Successfully',
                      context: context,
                      color: AppColorConstant.successColor,
                    );
                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ButtomNavView(
                            selectedIndex: 4,
                          ),
                        ),
                      );
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
