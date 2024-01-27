import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
import 'package:flutter_final_assignment/config/constants/size_config.dart';
import 'package:flutter_final_assignment/core/common/components/show_alert_dialog.dart';
import 'package:flutter_final_assignment/core/common/widget/semi_big_text.dart';
import 'package:flutter_final_assignment/core/common/widget/small_text.dart';
import 'package:flutter_final_assignment/features/navbar/presentation/view/bottom_navigation/bottom_navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../../../../../../core/common/provider/internet_connectivity.dart';
import '../../../../config/constants/api_endpoint.dart';
import '../../../../core/common/provider/internet_connectivity.dart';
import '../../../profile/presentation/viewmodel/profile_viewmodel.dart';
import '../../domain/entity/home_entity.dart';
import '../viewmodel/home_viewmodel.dart';

class ImageItem {
  final String artId;
  final String title;
  final String image;
  final String creator;
  final DateTime upcomingDate;
  final bool isUserLoggedIn;
  ImageItem(this.artId, this.title, this.image, this.creator, this.upcomingDate,
      this.isUserLoggedIn);
}

class UpcomingArt extends ConsumerStatefulWidget {
  const UpcomingArt({
    super.key,
  });

  @override
  ConsumerState<UpcomingArt> createState() => _UpcomingArtState();
}

class _UpcomingArtState extends ConsumerState<UpcomingArt> {
  late Map<String, bool> _alertStatus;

  // Add a reference to the HomeViewModel
  late HomeViewModel homeViewModel; // Declare the variable

  @override
  void initState() {
    super.initState();
    // Access the HomeViewModel instance from the homeViewModelProvider
    homeViewModel = ref.read(homeViewModelProvider.notifier);
    _alertStatus = {};
    retrieveAlertStatusFromSharedPreferences();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeViewModel.getAllArt();
      homeViewModel.getAlertArts();
      homeViewModel.getUserArts();
      ref.watch(profileViewModelProvider.notifier).getUserProfile();
    });
  }

  @override
  void dispose() {
    saveAlertStatusToSharedPreferences(
        _alertStatus // Save the alert status to shared preferences
        );
    super.dispose();
  }

  void saveAlertStatusToSharedPreferences(Map<String, bool> alertStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonEncodedAlerts = jsonEncode(alertStatus);
    prefs.setString('alertStatus', jsonEncodedAlerts);
  }

  void retrieveAlertStatusFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> retrievedAlerts =
        jsonDecode(prefs.getString('alertStatus') ?? '{}');
    setState(() {
      _alertStatus = Map<String, bool>.from(retrievedAlerts);
    });
  }

  @override
  Widget build(BuildContext context) {
    var artState = ref.watch(homeViewModelProvider);
    List<HomeEntity> homeList = artState.arts;

    // filter the homeList to include only items with artType "Recent"
    List<HomeEntity> upcomingArts = homeList
        .where((art) => art.artType == "Upcoming" && art.artId != null)
        .toList();
    final List<ImageItem> images = upcomingArts.map((art) {
      return ImageItem(
        art.artId!,
        art.title,
        art.image.toString(),
        art.creator,
        art.upcomingDate,
        art.isUserLoggedIn ?? false,
      );
    }).toList();
    final orientations = MediaQuery.of(context).orientation;
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    final internetStatus = ref.watch(connectivityStatusProvider);

// Show message if there are no arts in the given category
    if (upcomingArts.isEmpty) {
      return Padding(
        padding: isTablet
            ? const EdgeInsets.fromLTRB(20.0, 0, 20, 0)
            : const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: Text(
          "(Upcoming Arts not available.)",
          style: TextStyle(
              fontSize: isTablet ? 22 : 20,
              fontWeight: FontWeight.w500,
              color: AppColorConstant.errorColor),
        ),
      );
    }
    return SizedBox(
      height: orientations == Orientation.portrait
          ? isTablet
              ? 400
              : 350
          : SizeConfig.screenHeight * 0.8,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          final formattedDate =
              DateFormat(' M/d/y').format(images[index].upcomingDate);

          final imageItem = images[index];
          final bool isCurrentUserPost = imageItem.isUserLoggedIn;

          final isAlert = _alertStatus.containsKey(images[index].title)
              ? _alertStatus[images[index].title]!
              : false;

          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ButtomNavView(
                          selectedIndex: 1,
                        ),
                      ),
                    );
                  },
                  onDoubleTap: () {
                    final ImageItem currentImage = images[index];
                    final String artId = currentImage.artId;
                    if (isCurrentUserPost) {
                      showNotification(
                        context,
                        "You cannot alert your own post",
                      );
                    } else {
                      if (isAlert) {
                        homeViewModel.unAlertArt(artId);
                        showNotification(context, 'Removed from Alerts',
                            icon: Icons.notifications_none);
                      } else {
                        homeViewModel.alertArt(artId);
                        showNotification(context, 'Added to Alerts',
                            icon: Icons.notifications_active);
                      }
                      homeViewModel.getAlertArts();
                      setState(() {
                        if (_alertStatus.containsKey(images[index].title)) {
                          _alertStatus.remove(images[index].title);
                        } else {
                          _alertStatus[images[index].title] = true;
                        }
                      });
                    }
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        // clipBehavior: Clip.none,
                        borderRadius: BorderRadius.circular(10),
                        child: internetStatus == ConnectivityStatus.isConnected
                            ? Image.network(
                                '${ApiEndpoints.baseUrl}/uploads/${images[index].image}',
                                fit: BoxFit.fill,
                                width: isTablet ? 350 : 250,
                                height: isTablet ? 380 : 250,
                              )
                            : Image.asset(
                                'assets/images/image_error.jpg',
                                fit: BoxFit.fill,
                                width: isTablet ? 350 : 280,
                                height: isTablet ? 380 : 280,
                              ),
                      ),
                      Positioned(
                        top: isTablet ? 8 : 5,
                        right: isTablet ? 8 : 5,
                        child: CircleAvatar(
                          radius: isTablet ? 30 : 24,
                          backgroundColor: AppColorConstant.neutralColor.withOpacity(0.5),
                          child: isAlert ? 
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.notifications,
                              size: isTablet ? 30 : 28,
                            ),
                            color: AppColorConstant.whiteTextColor,
                          )
                          : IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.notifications_none_outlined,
                              size: isTablet ? 30 : 28,
                            ),
                            color: AppColorConstant.blackTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: isTablet ? 10 : 5,
                // ),
                Container(
                  width: isTablet ? 250 : 250,
                  // height: isTablet ? 250 : 400,
                  padding: isTablet
                      ? EdgeInsets.all(AppColorConstant.kDefaultPadding / 4)
                      : EdgeInsets.all(AppColorConstant.kDefaultPadding / 3),
                  decoration: BoxDecoration(
                    color: AppColorConstant.mainSecondaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SemiBigText(
                        text: images[index].title,
                      spacing: 0,   
                      ),
                      SmallText(
                        text: images[index].creator, // Replace with the actual creator info  
                      ),
                      SmallText(
                        text: 'Date: $formattedDate', // Replace with the actual date info
                        
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
