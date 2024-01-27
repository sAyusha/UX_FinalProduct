import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';

import '../../../../config/constants/api_endpoint.dart';
import '../../../../core/common/provider/internet_connectivity.dart';
import '../../../../core/common/widget/semi_big_text.dart';
import '../../../../core/common/widget/small_text.dart';
import '../../../art_details/presentation/view/art_details/art_details_view.dart';
import '../../domain/entity/home_entity.dart';
import '../viewmodel/home_viewmodel.dart';

class ImageItem {
  final String title;
  final String startingBid;
  final String creator;
  final String image;
  final DateTime endingDate;
  final bool isExpired;
  ImageItem(this.title, this.startingBid, this.creator, this.image,
      this.endingDate, this.isExpired);
}

class FeaturedArt extends ConsumerWidget {
  const FeaturedArt({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isArtExpired(DateTime endingDate) {
      return DateTime.now().isAfter(endingDate);
    }

    // Helper method to check if the art has expired
    bool _isArtExpired(DateTime endingDate) {
      return endingDate.isBefore(DateTime.now());
    }

    void _openArtDetailsPage(BuildContext context, HomeEntity art) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArtDetailsView(art: art),
        ),
      );
    }

    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    final gap = SizedBox(height: isTablet ? 5.0 : 10.0);
    var artState = ref.watch(homeViewModelProvider);
    List<HomeEntity> homeList = artState.arts;

    // Filter the homeList to include only items with artType "Recent"
    HomeEntity featuredArt = homeList.firstWhere(
      (art) => art.artType == "Recent" && !_isArtExpired(art.endingDate),
      orElse: () => HomeEntity(
        title: "",
        startingBid: 0,
        creator: "",
        image: "",
        endingDate: DateTime.now(),
        artType: '',
        upcomingDate: DateTime.now(),
        categories: '',
        description: '',
      ),
    );

    final ImageItem imageItem = ImageItem(
      featuredArt.title,
      featuredArt.startingBid.toString(),
      featuredArt.creator,
      featuredArt.image.toString(),
      featuredArt.endingDate,
      _isArtExpired(featuredArt.endingDate),
    );
    final internetStatus = ref.watch(connectivityStatusProvider);

    String formatTimeRemaining(DateTime targetDate) {
      DateTime now = DateTime.now();
      Duration difference = targetDate.difference(now);

      int hours = difference.inHours;
      int minutes = (difference.inMinutes % 60).abs();
      int seconds = (difference.inSeconds % 60).abs();

      return '${hours}h ${minutes}m ${seconds}s';
    }

// Usage
    DateTime endingDate = imageItem.endingDate;
    String formattedTimeRemaining = formatTimeRemaining(endingDate);
    // print(formattedTimeRemaining); // Example output: "12h 10m 00s"

    // final formattedDate = DateFormat(' M/d/y').format(imageItem.endingDate);

    return Padding(
      padding: EdgeInsets.all(AppColorConstant.kDefaultPadding / 2),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: double.infinity,
                height: isTablet ? 500 : 300,
                child: GestureDetector(
                  onDoubleTap: () {
                    if (internetStatus == ConnectivityStatus.isConnected) {
                      _openArtDetailsPage(context, featuredArt);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const SemiBigText(
                              text: 'No Internet Connection',
                              spacing: 0,
                            ),
                            content: const SmallText(
                                text:
                                    'Please check your internet connection and try again.'),
                            actions: <Widget>[
                              TextButton(
                                child: SmallText(
                                  text: 'OK',
                                  color: AppColorConstant.successColor,
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: internetStatus == ConnectivityStatus.isConnected
                        ? (featuredArt.image != null && featuredArt.image != ''
                            ? Image.network(
                                '${ApiEndpoints.baseUrl}/uploads/${imageItem.image}',
                                fit: isTablet ? BoxFit.fill : BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/image_error.jpg',
                                fit: BoxFit.fill,
                              ))
                        : Image.asset(
                            'assets/images/image_error.jpg',
                            fit: BoxFit.fill,
                          ),
                  ),
                ),
              ),
              Positioned(
                bottom: isTablet ? 20 : 10,
                right: isTablet ? 20 : 15,
                child: Container(
                  padding: isTablet
                      ? const EdgeInsets.all(10)
                      : const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: AppColorConstant.primaryAccentColor,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: SmallText(
                    text: formattedTimeRemaining,
                    color: AppColorConstant.whiteTextColor,
                  ),

                  // child: SmallText(text: "1200.99\$".toString()),
                ),
              ),
            ],
          ),
          gap,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SemiBigText(
                    text: isTablet
                        ? imageItem.title
                        : imageItem.title.length <= 16
                            ? imageItem.title
                            : "${imageItem.title.substring(0, 16)}...",
                    // text: "Happily Ever After",
                    spacing: 0,
                    overFlow: TextOverflow.ellipsis,
                  ),
                  Text(
                    imageItem.creator,
                    // 'Jim Warren',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: isTablet ? 26 : 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SmallText(text: "Last Bid"),
                  SemiBigText(
                    text: "${imageItem.startingBid}\$",
                    // text: "1300\$",
                    spacing: 0,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
