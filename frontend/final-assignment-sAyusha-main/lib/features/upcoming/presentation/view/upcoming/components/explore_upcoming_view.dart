import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
import 'package:flutter_final_assignment/core/common/components/show_alert_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../config/constants/api_endpoint.dart';
import '../../../../../../core/common/provider/internet_connectivity.dart';
import '../../../../../../core/common/widget/semi_big_text.dart';
import '../../../../../../core/common/widget/small_text.dart';
import '../../../../../home/domain/entity/home_entity.dart';
import '../../../../../home/presentation/viewmodel/home_viewmodel.dart';
import '../../../../../profile/presentation/viewmodel/profile_viewmodel.dart';

class ImageItem {
  final String artId;
  final String title;
  final String startingBid;
  final String creator;
  final String image;
  final bool isUserLoggedIn;
  ImageItem(this.artId, this.title, this.startingBid, this.creator, this.image,
      this.isUserLoggedIn);
}

class ExploreUpcoming extends ConsumerStatefulWidget {
  const ExploreUpcoming({
    super.key,
  });

  @override
  ConsumerState<ExploreUpcoming> createState() => _ExploreUpcomingState();
}

class _ExploreUpcomingState extends ConsumerState<ExploreUpcoming> {
  late Map<String, bool> _alertStaus;

  // Add a reference to the HomeViewModel
  late HomeViewModel homeViewModel; // Declare the variable

  @override
  void initState() {
    super.initState();
    // Access the HomeViewModel instance from the homeViewModelProvider
    homeViewModel = ref.read(homeViewModelProvider.notifier);
    _alertStaus = {};
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
    saveAlertStatusToSharedPreferences();
    super.dispose();
  }

  void retrieveAlertStatusFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<dynamic, dynamic> retrievedFavorites =
        jsonDecode(prefs.getString('alerts') ?? '{}');
    setState(() {
      _alertStaus = Map<String, bool>.from(retrievedFavorites);
    });
  }

  void saveAlertStatusToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> alertStausList = _alertStaus.entries
        .map((entry) => '${entry.key}:${entry.value}')
        .toList();
    await prefs.setStringList('alertStaus', alertStausList);
  }

  @override
  Widget build(BuildContext context) {
    var artState = ref.watch(homeViewModelProvider);
    final List<HomeEntity> homeList = artState.arts;
    final internetStatus = ref.watch(connectivityStatusProvider);
    List<HomeEntity> filteredArts =
        homeList.where((art) => art.artType == "Upcoming").toList();

    final List<ImageItem> imageList = filteredArts
        .map((art) => ImageItem(
            art.artId ?? "",
            art.title,
            art.startingBid.toString(),
            art.creator,
            art.image.toString(),
            art.isUserLoggedIn ?? false))
        .toList();

    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    final gap = SizedBox(height: isTablet ? 15.0 : 5.0);
    // Show message if there are no arts in the given category
    if (filteredArts.isEmpty) {
      return Padding(
        padding: isTablet
            ? const EdgeInsets.fromLTRB(20.0, 0, 20, 0)
            : const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: Text(
          "(Upcoming arts not available.)",
          style: TextStyle(
              fontSize: isTablet ? 22 : 20,
              fontWeight: FontWeight.w500,
              color: AppColorConstant.errorColor),
        ),
      );
    }
    return SingleChildScrollView(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: imageList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final imageItem = imageList[index];
          final bool isCurrentUserPost = imageItem.isUserLoggedIn;
          final DateTime upcomingDate =
              DateTime.parse(filteredArts[index].upcomingDate.toString());
          // final formattedDate = DateFormat('d MMM').format(upcomingDate);

          final isAlert = _alertStaus.containsKey(imageList[index].title)
              ? _alertStaus[imageList[index].title]!
              : false;

          return SizedBox(
            width: double.infinity,
            child: Card(
              color: AppColorConstant.mainSecondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: AppColorConstant.neutralColor.withOpacity(0.4),
                  width: 2,
                ),
              ),
              elevation: 4,
              shadowColor: AppColorConstant.neutralColor.withOpacity(0.5),
              child: Padding(
                padding: isTablet
                    ? const EdgeInsets.all(16.0)
                    : const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Text(
                            DateFormat('d').format(upcomingDate),
                            style: TextStyle(
                              fontSize: isTablet ? 58 : 44,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            DateFormat('MMM').format(upcomingDate),
                            style: TextStyle(
                              fontSize: isTablet ? 32 : 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    gap,
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: isTablet ? 450 : 250,
                            // width: getProportionateScreenWidth(500),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: internetStatus ==
                                      ConnectivityStatus.isConnected
                                  ? DecorationImage(
                                      image: NetworkImage(
                                        '${ApiEndpoints.baseUrl}/uploads/${imageList[index].image}',

                                        // "https://i.pinimg.com/550x/fe/37/32/fe37325df5487b9cf83671c3a7f91c81.jpg",
                                      ),
                                      fit:
                                          isTablet ? BoxFit.fill : BoxFit.cover,
                                    )
                                  : DecorationImage(
                                      image: const AssetImage(
                                        'assets/images/image_error.jpg',
                                      ),
                                      fit:
                                          isTablet ? BoxFit.fill : BoxFit.cover,
                                    ),
                            ),
                          ),
                          gap,
                          SemiBigText(
                            text: imageItem.title,
                            spacing: 0,
                          ),
                          gap,
                          SmallText(text: "₹${imageItem.startingBid}"),
                          gap,
                          SmallText(text: imageItem.creator),
                          gap,
                          Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                              onPressed: () {
                                final ImageItem currentImage =
                                    imageList[index];
                                final String artId = currentImage.artId;
                                if (isCurrentUserPost) {
                                  showNotification(
                                    context,
                                    "You cannot alert your own post",
                                  );
                                } else {
                                  if (isAlert) {
                                    homeViewModel.unAlertArt(artId);
                                    showNotification(
                                        context, 'Removed from Alerts',
                                        icon: Icons.notifications_none);
                                  } else {
                                    homeViewModel.alertArt(artId);
                                    showNotification(
                                        context, 'Added to Alerts',
                                        icon: Icons.notifications_active);
                                  }
                                  homeViewModel.getAlertArts();
                                  setState(() {
                                    if (_alertStaus.containsKey(
                                        imageList[index].title)) {
                                      _alertStaus
                                          .remove(imageList[index].title);
                                    } else {
                                      _alertStaus[imageList[index].title] =
                                          true;
                                    }
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.notifications_none_outlined,
                                size: isTablet ? 36 : 40,
                                color: AppColorConstant.blackTextColor,
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
          );
        },
      ),
    );
  }
}
