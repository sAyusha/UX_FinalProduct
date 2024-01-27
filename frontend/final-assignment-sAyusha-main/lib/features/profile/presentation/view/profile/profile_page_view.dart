import 'dart:async';
import 'dart:io';

import 'package:all_sensors2/all_sensors2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
import 'package:flutter_final_assignment/features/post/presentation/view/post/post_art_view.dart';
import 'package:flutter_final_assignment/features/profile/presentation/viewmodel/logout_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/app.dart';
import '../../../../../core/common/widget/small_text.dart';
import '../../viewmodel/profile_viewmodel.dart';
import '../../widget/body.dart';

class ProfilePageView extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ProfilePageView({super.key});

  @override
  ConsumerState<ProfilePageView> createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends ConsumerState<ProfilePageView> {
  double _proximityValue = 0;
  final List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(proximityEvents!.listen((ProximityEvent event) {
      setState(() {
        _proximityValue = event.proximity;
        if (_proximityValue < 0.2) {
          // Change the theme to dark
          ref.read(themeProvider).isDark = true;
        } else {
          // Change the theme to light
          ref.read(themeProvider).isDark = false;
        }
      });
    }));
  }

  @override
  void dispose() {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = ref.watch(themeProvider);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    return Scaffold(
      backgroundColor: AppColorConstant.mainSecondaryColor,
      key: widget.scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
           IconButton(
            icon: Icon(
              Icons.notifications_active_outlined,
              color: AppColorConstant.blackTextColor,
              size: 30,
            ),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const PostArtView(),
              //   ),
              // );
            },
          ),
           IconButton(
            icon: Icon(
              Icons.add_card,
              color: AppColorConstant.blackTextColor,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PostArtView(),
                ),
              );
            },
          ),
          IconButton(
            onPressed: () {
              // ref.read(logoutViewModelProvider.notifier).logout(context);
              // themeNotifier.isDark = !themeNotifier.isDark;

              widget.scaffoldKey.currentState?.openEndDrawer();
            },
            icon: Icon(
              Icons.settings,
              size: isTablet ? 35 : 25,
              color: AppColorConstant.blackTextColor,
            ),
          ),
        ],
      ),
      body: const Body(),
      endDrawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
          child: Column(
            children: <Widget>[
              TextButton(
                  onPressed: () {
                    ref.read(logoutViewModelProvider.notifier).logout(context);
                  },
                  child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SmallText(text: 'Logout'),
                          Icon(
                            Icons.logout,
                            color: AppColorConstant.blackTextColor,
                          ), 
                        ]
                      ),
                    ),
              const Divider(
                height: 1,
                thickness: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SmallText(text: 'Appearance'),
                  IconButton(
                      onPressed: () {
                        themeNotifier.isDark = !themeNotifier.isDark;
                      },
                      icon: const Icon(Icons.brightness_4)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
