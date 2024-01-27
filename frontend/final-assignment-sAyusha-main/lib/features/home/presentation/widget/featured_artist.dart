import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common/components/show_alert_dialog.dart';
import '../../../../core/common/provider/internet_connectivity.dart';
import '../../../../core/common/widget/small_text.dart';
import '../../domain/entity/home_entity.dart';
import '../viewmodel/home_viewmodel.dart';

class FeaturedArtistItem {
  final String creator;
  FeaturedArtistItem(this.creator);
}

class FeaturedArtist extends ConsumerStatefulWidget {
  const FeaturedArtist({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<FeaturedArtist> createState() => _FeaturedArtistState();
}

class _FeaturedArtistState extends ConsumerState<FeaturedArtist> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    final gap = SizedBox(height: isTablet ? 5.0 : 20.0);
    final internetStatus = ref.watch(connectivityStatusProvider);

    var artistState = ref.watch(homeViewModelProvider);

    List<HomeEntity> users = artistState.arts;

    List<FeaturedArtistItem> featuredArtists = [];

    // Use a Set to keep track of unique creator names
    Set<String> uniqueCreators = {};

    for (var user in users) {
      if (!uniqueCreators.contains(user.creator)) {
        uniqueCreators.add(user.creator);

        // Count the number of arts posted by the user
        int artsCount = users.where((u) => u.creator == user.creator).length;

        if (artsCount > 4) {
          featuredArtists.add(FeaturedArtistItem(user.creator));
        }
      }
    }
    // Show message if there are no featured artists
    if (featuredArtists.isEmpty) {
      return Padding(
        padding: isTablet
            ? const EdgeInsets.fromLTRB(20.0, 0, 20, 0)
            : const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: Text(
          "(No featured artists.)",
          style: TextStyle(
              fontSize: isTablet ? 22 : 20,
              fontWeight: FontWeight.w500,
              color: AppColorConstant.errorColor),
        ),
      );
    }

    // Show the ListView.builder if there are featured artists
    return SizedBox(
      width: double.infinity,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: featuredArtists.length,
        itemBuilder: (context, index) {
          var featuredArtist = featuredArtists[index];
          return Padding(
            padding: isTablet
                ? const EdgeInsets.fromLTRB(20.0, 0, 20, 0)
                : const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: Card(
              color: AppColorConstant.whiteTextColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColorConstant.mainTeritaryColor,
                          radius: isTablet ? 30 : 20,
                          backgroundImage:
                              internetStatus == ConnectivityStatus.isConnected
                                  ? const NetworkImage(
                                      "https://flyclipart.com/thumb2/person-137537.png",
                                    )
                                  : const AssetImage(
                                      "assets/images/image_error.jpg",
                                    ) as ImageProvider,
                        ),
                        gap,
                        Padding(
                          padding:
                              EdgeInsets.only(left: isTablet ? 20.0 : 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // title
                              Text(
                                featuredArtist.creator,
                                // "John Doe",
                                style: TextStyle(
                                  fontSize: isTablet ? 22 : 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              // subtitle
                              Text(
                                "Artist",
                                style: TextStyle(
                                  fontSize: isTablet ? 19 : 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showNotification(context, "Following",
                            icon: Icons.check_circle_outline_rounded);
                      },
                      child: SmallText(
                        text: "Follow",
                        color: AppColorConstant.whiteTextColor,
                        // size: 14,
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
