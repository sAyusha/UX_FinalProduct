import 'dart:async';
import 'dart:io';

import 'package:all_sensors2/all_sensors2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
import 'package:flutter_final_assignment/config/router/app_route.dart';
import 'package:flutter_final_assignment/core/shared_preferences/user_shared_prefs.dart';
import 'package:flutter_final_assignment/features/home/presentation/widget/body.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../config/constants/api_endpoint.dart';
import '../../../../profile/presentation/viewmodel/logout_view_model.dart';
import '../../../../profile/presentation/viewmodel/profile_viewmodel.dart';
import '../../../../search/presentation/view/search_art_view.dart';

class HomePageView extends ConsumerStatefulWidget {
  const HomePageView({super.key});

  @override
  ConsumerState<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends ConsumerState<HomePageView> {
  double _proximityValue = 0;
  final List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

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

  XFile? profileImageFile;

  @override
  void initState() {
    super.initState();
    fetchLoggedInProfileImage();
    _streamSubscriptions.add(proximityEvents!.listen((ProximityEvent event) {
      setState(() {
        _proximityValue = event.proximity;
        if (_proximityValue < 0.2) {
          UserSharedPrefs.clearSharedPrefs();
          ref.read(logoutViewModelProvider.notifier).logout(context);

          Navigator.pushReplacementNamed(context, AppRoute.loginRoute);
          // ignore: avoid_print
          print('logout');
        }
      });
    }));
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
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    var profileState = ref.watch(profileViewModelProvider);

    return Scaffold(
      backgroundColor: AppColorConstant.mainSecondaryColor,
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // Set to false to hide the default back button
        title: Row(
          children: [
            // Logo in the left corner
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.asset(
                "assets/images/logo.png",
                width: 40.0, // Adjust the width as needed
                height: 40.0, // Adjust the height as needed
              ),
            ),
            // const Text(
            //   'AUCTIONS',
            // ),
          ],
        ),
        actions: [
          // Search icon in the right corner
          IconButton(
            icon: Icon(
              Icons.search,
              color: AppColorConstant.blackTextColor,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchArtView(),
                ),
              );
            },
          ),
          // User logo in the right corner
          // User profile image in the right corner
          CircleAvatar(
            radius: isTablet ? 70 : 30,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            child: ClipOval(
              child: _img != null
                  ? Image.file(
                      _img!,
                      fit: BoxFit.cover,
                      height: isTablet ? 300 : 40,
                      width: isTablet ? 300 : 40,
                    )
                  : (profileState.userData.isNotEmpty &&
                          profileState.userData[0].profileImage != null)
                      ? Image.network(
                          '${ApiEndpoints.baseUrl}/uploads/${profileState.userData[0].profileImage ?? ''}',
                          fit: BoxFit.cover,
                          height: isTablet ? 300 : 40,
                          width: isTablet ? 300 : 40,
                        )
                      : Image.asset(
                          'assets/images/avatar.jpg',
                          fit: BoxFit.cover,
                          height: isTablet ? 300 : 40,
                          width: isTablet ? 300 : 40,
                        ),
            ),
          ),
        ],
      ),
      body: const Body(),
    );
  }
}
