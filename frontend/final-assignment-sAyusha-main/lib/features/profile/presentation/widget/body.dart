import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/features/home/presentation/viewmodel/home_viewmodel.dart';
import 'package:flutter_final_assignment/features/profile/presentation/widget/categories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/constants/api_endpoint.dart';
import '../../../../config/constants/app_color_constant.dart';
import '../../../../config/router/app_route.dart';
import '../../../../core/common/widget/semi_big_text.dart';
import '../../../../core/common/widget/small_text.dart';
// import '../../domain/entity/profile_entity.dart';
import '../viewmodel/profile_viewmodel.dart';

// class ProfileItem {
//   final String title;
//   final String creator;
//   final String image;
//   final String startingBid;
//   // final String uploadedDate;

//   ProfileItem(
//     this.title,
//     this.creator,
//     this.image,
//     this.startingBid,
//   );
// }

class Body extends ConsumerStatefulWidget {
  const Body({super.key});

  @override
  ConsumerState<Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {
  checkCameraPermission() async {
    if (await Permission.camera.request().isRestricted ||
        await Permission.camera.request().isDenied) {
      await Permission.camera.request();
    }
  }

  File? _img;
  Future _browseImage(WidgetRef ref, ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image != null) {
        setState(() {
          _img = File(image.path);
          ref
              .read(profileViewModelProvider.notifier)
              .uploadProfilePicture(_img!);
        });
      } else {
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Function to reload the data when the user triggers a refresh.
  Future<void> _handleRefresh() async {
    // Implement the logic to reload the data here.
    ref.watch(profileViewModelProvider.notifier).getUserProfile();
    ref.watch(homeViewModelProvider.notifier).getAlertArts();
  }

  String loggedInFullname = '';
  String loggedInUsername = '';
  String loggedInBio = '';
  XFile? profileImageFile;

  @override
  void initState() {
    super.initState();
    fetchLoggedInUsername();
    fetchLoggedInFullname();
    fetchLoggedInBio();
    fetchLoggedInProfileImage();
  }

  Future<void> fetchLoggedInUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    if (username != null) {
      setState(() {
        loggedInUsername = username;
      });
    }
  }

  Future<void> fetchLoggedInFullname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fullname = prefs.getString('fullname');
    if (fullname != null) {
      setState(() {
        loggedInFullname = fullname;
      });
    }
  }

  Future<void> fetchLoggedInBio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? bio = prefs.getString('bio');
    if (bio != null) {
      setState(() {
        loggedInBio = bio;
      });
    }
  }

  Future fetchLoggedInProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? profileImagePath = prefs.getString('profile_image');
    // ignore: unnecessary_null_comparison
    if (profileImagePath != null) {
      setState(() {
        profileImageFile = XFile(profileImagePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var userArtState = ref.watch(homeViewModelProvider);
    // var userState = ref.watch(profileViewModelProvider);
    // List<ProfileEntity> userData = userState.userData;

    var profileState = ref.watch(profileViewModelProvider);

    // if (userData.isEmpty) {
    //   return const Center(child: CircularProgressIndicator()); //show loader
    // }

    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    final gap = SizedBox(height: isTablet ? 18.0 : 16.0);

     if (profileState.isLoading) {
      return Scaffold(
        body: Center(
          child: RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: const AlwaysStoppedAnimation(0.0),
                curve: Curves.linear,
              ),
            ),
            child: CircularProgressIndicator(
              color: AppColorConstant.blackTextColor,
              backgroundColor: Colors.grey,
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: Padding(
          padding: isTablet
              ? EdgeInsets.only(
                  top: AppColorConstant.kDefaultPadding,
                  bottom: AppColorConstant.kDefaultPadding)
              : EdgeInsets.only(
                  top: AppColorConstant.kDefaultPadding / 2,
                  bottom: AppColorConstant.kDefaultPadding / 2),
          child: Column(
                  children: [
                    InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            constraints: const BoxConstraints(
                              maxWidth: double.infinity,
                            ),
                            backgroundColor: AppColorConstant.lightNeutralColor4,
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (context) => Padding(
                              padding: isTablet
                                  ? const EdgeInsets.all(18)
                                  : const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton.icon(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              AppColorConstant
                                                  .primaryAccentColor),
                                    
                                    ),
                                    onPressed: () {
                                      checkCameraPermission();
                                      _browseImage(ref, ImageSource.camera);
                                      Navigator.pop(context);
                                      // Upload image it is not null
                                    },
                                    icon: const Icon(Icons.camera),
                                    label: SmallText(
                                      text: 'Camera',
                                      color: AppColorConstant.whiteTextColor,
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              AppColorConstant
                                                  .primaryAccentColor),
                                    ),  
                                    onPressed: () {
                                      _browseImage(ref, ImageSource.gallery);
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.image),
                                    label: SmallText(
                                      text: 'Gallery',
                                      color: AppColorConstant.whiteTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: isTablet ? 300 : 250,
                          width: isTablet ? 300 : 250,
                          child: CircleAvatar(
                            radius: isTablet ? 70 : 60,
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.transparent,
                            child: ClipOval(
                              child: _img != null
                                ? Image.file(
                                  _img!,
                                  fit: BoxFit.cover,
                                  height: isTablet ? 300 : 250,
                                  width: isTablet ? 300 : 250,
                                )
                                : profileState.userData[0].profileImage != null
                                ? Image.network(
                                    '${ApiEndpoints.baseUrl}/uploads/${profileState.userData[0].profileImage ?? ''}',
                                  fit: BoxFit.cover,
                                  height: isTablet ? 300 : 250,
                                  width: isTablet ? 300 : 250,
                                )
                                : Image.asset(
                                  'assets/images/avatar.jpg',
                                  fit: BoxFit.cover,
                                  height: isTablet ? 300 : 250,
                                  width: isTablet ? 300 : 250,
                                ),
                            ),
                          ),
                        )),
                    gap,
                    SemiBigText(
                      text: profileState.userData[0].fullname,
                      spacing: 0,
                    ),
                    SizedBox(height: isTablet ? 15.0 : 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SmallText(
                          text: '@${profileState.userData[0].username}',
                        ),
                        SizedBox(width: AppColorConstant.kDefaultPadding),
                        SmallText(
                          text:
                              "${userArtState.userArts.length.toString()} Artworks",
                        )
                      ],
                    ),
                    SizedBox(height: isTablet ? 15.0 : 10.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColorConstant.mainTeritaryColor),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoute.editProfile,
                        );
                      },
                      child: const SmallText(
                        text: "Edit Profile",
                      ),
                    ),
                    gap,
                    Container(
                      padding: isTablet
                          ? const EdgeInsets.fromLTRB(20.0, 0, 20, 9)
                          : const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                      width: isTablet ? 700 : double.infinity,
                      child: Text(
                        profileState.userData[0].bio ?? 'No Bio',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isTablet ? 26 : 22,
                          height: isTablet ? 2 : 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    gap,
                    const ProfileCategories(),
                    // SizedBox(height: size.height * 0.01),
                    // const CollectedArt(),
                  ],
                ),
        ),
      ),
    );
  }
}
