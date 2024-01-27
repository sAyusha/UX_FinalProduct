import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
import 'package:flutter_final_assignment/core/common/widget/semi_big_text.dart';
import 'package:flutter_final_assignment/features/home/domain/entity/home_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/constants/api_endpoint.dart';
// import '../../../../../../core/common/provider/internet_connectivity.dart';
import '../../../../config/router/app_route.dart';
import '../../../../core/common/provider/internet_connectivity.dart';
import '../../../../core/common/widget/small_text.dart';
import '../../../art_details/presentation/view/art_details/art_details_view.dart';
import '../viewmodel/home_viewmodel.dart';

class ImageItem {
  final String artId;
  final String title;
  final String startingBid;
  final String creator;
  final String image;
  final bool isUserLoggedIn;
  final bool artExpired;
  ImageItem(this.artId, this.title, this.startingBid, this.creator, this.image,
      this.isUserLoggedIn, this.artExpired);
}

class ArtView extends ConsumerStatefulWidget {
  final String category; // Receive the selected category from Categories widget

  const ArtView({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  ConsumerState<ArtView> createState() => _ArtViewState();
}

class _ArtViewState extends ConsumerState<ArtView> {
  bool isArtExpired(DateTime endingDate) {
    return DateTime.now().isAfter(endingDate);
  }

  bool isMouseOverArt = false;

  // Helper method to check if the art has expired
  bool _isArtExpired(DateTime endingDate) {
    return endingDate.isBefore(DateTime.now());
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, String artTitle, String artId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const SemiBigText(
            text: 'Delete Art',
            spacing: 0,
          ),
          content:
              SmallText(
                text: 'Are you sure you want to delete "$artTitle"?',
                textAlign: TextAlign.center,
              ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                  AppColorConstant.blackTextColor,
                ),
              ),
              child: SmallText(
                text: 'Cancel',
                color: AppColorConstant.blackTextColor,
              ),
            ),
            TextButton(
              onPressed: () {
                // Perform the delete action here
                _deleteArtItem(artId);
                Navigator.of(context).pop(); // Close the dialog
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                  AppColorConstant.blackTextColor,
                ),
              ),
              child: SmallText(
                text: 'Delete',
                color: AppColorConstant.errorColor,
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteArtItem(String artId) async {
    // Call the deleteArt() method from the HomeViewModel to delete the art item
    await ref.read(homeViewModelProvider.notifier).deleteArt(artId);

    // After the deletion is successful, reload the data.
    ref.read(homeViewModelProvider.notifier).getAllArt();
    ref.read(homeViewModelProvider.notifier).getUserArts();
  }

  void _openArtDetailsPage(BuildContext context, HomeEntity art) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArtDetailsView(art: art),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var artState = ref.watch(homeViewModelProvider);
    final List<HomeEntity> homeList = artState.arts;

    List<HomeEntity> filteredArts;

    if (widget.category == "Abstract") {
      // Show all recent arts
      filteredArts = homeList.where((art) => art.artType == "Recent").toList();
    } else {
      // Filter the recent arts based on the selected category
      filteredArts = homeList
          .where((art) =>
              art.artType == "Recent" && art.categories == widget.category)
          .toList();
    }

    final List<ImageItem> images = filteredArts.map((art) {
      return ImageItem(
        art.artId ?? "",
        art.title,
        art.startingBid.toString(),
        art.creator,
        art.image.toString(),
        art.isUserLoggedIn ?? false,
        _isArtExpired(art.endingDate),
      );
    }).toList();

    final orientations = MediaQuery.of(context).orientation;
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    final gap = SizedBox(height: isTablet ? 16.0 : 12.0);
    final internetStatus = ref.watch(connectivityStatusProvider);

    // Show message if there are no arts in the given category
    if (filteredArts.isEmpty) {
      return Padding(
        padding: isTablet
            ? const EdgeInsets.fromLTRB(20.0, 0, 20, 0)
            : const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: Text(
          "(Arts not available.)",
          style: TextStyle(
              fontSize: isTablet ? 26 : 20,
              fontWeight: FontWeight.w500,
              color: AppColorConstant.errorColor),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(homeViewModelProvider.notifier).getAllArt();
        await ref.read(homeViewModelProvider.notifier).getUserArts();
      },
      child: SizedBox(
        height: orientations == Orientation.portrait
            ? isTablet
                ? 600
                : 400
            : 400,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          // Set the itemCount to the length of the 'images' list
          itemCount: images.length,
          itemBuilder: (context, index) {
            final imageItem = images[index];
            // final homeViewModel = ref.read(homeViewModelProvider);
            final bool isArtExpired = imageItem.artExpired;

            final bool isCurrentUserPost = imageItem.isUserLoggedIn;

            return MouseRegion(
              onEnter: (_) {
                if (isArtExpired) {
                  setState(() {
                    isMouseOverArt = true;
                  });
                }
              },
              onExit: (_) {
                if (isArtExpired) {
                  setState(() {
                    isMouseOverArt = false;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Container(
                  width: isTablet ? 350 : 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColorConstant.whiteTextColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onDoubleTap: () {
                          if (internetStatus ==
                              ConnectivityStatus.isConnected) {
                            if (!imageItem.artExpired) {
                              _openArtDetailsPage(context, filteredArts[index]);
                            }
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
                          child:
                              internetStatus == ConnectivityStatus.isConnected
                                  ? Image.network(
                                      '${ApiEndpoints.baseUrl}/uploads/${images[index].image}',
                                      fit: BoxFit.fill,
                                      width: isTablet ? 350 : 300,
                                      height: isTablet ? 350 : 250,
                                    )
                                  : Image.asset(
                                      'assets/images/image_error.jpg',
                                      fit: BoxFit.fill,
                                      width: isTablet ? 350 : 300,
                                      height: isTablet ? 350 : 250,
                                    ),
                        ),
                      ),
                      gap,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SemiBigText(
                              text: imageItem.title,
                              // maxLines: 1,
                              spacing: 0,
                              // overflow: TextOverflow.ellipsis,
                              // style: TextStyle(
                              //   fontSize: isTablet ? 30 : 24,
                              //   fontWeight: FontWeight.w600,
                              // ),
                            ),
                            gap,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SmallText(
                                  text: "₹${imageItem.startingBid}",
                                ),
                                isCurrentUserPost 
                                ? gap
                                : Container(
                                  height: isTablet ? 45 : 40,
                                  padding: isTablet
                                      ? const EdgeInsets.only(left: 7, right: 7)
                                      : const EdgeInsets.only(
                                          left: 5, right: 5),
                                  decoration: BoxDecoration(
                                    color: isArtExpired
                                        ? AppColorConstant.neutralColor
                                        : AppColorConstant.primaryAccentColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextButton(
                                    // disable the button if the art is expired
                                    onPressed: isArtExpired
                                        ? null
                                        : () async {
                                            await ref
                                                .watch(homeViewModelProvider
                                                    .notifier)
                                                .getArtById(imageItem.artId);
                                            final art = homeList.firstWhere(
                                                (art) =>
                                                    art.artId ==
                                                    imageItem.artId);
                                            // ignore: use_build_context_synchronously
                                            _openArtDetailsPage(context, art);
                                          },
                                    child: SmallText(
                                      text:
                                          isArtExpired ? 'EXPIRED' : 'BID NOW',
                                      // size: getProportionateScreenWidth(15),
                                      color: AppColorConstant.whiteTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            gap,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width: isTablet ? 200 : 150,
                                    child: SmallText(text: imageItem.creator)),
                                if (isCurrentUserPost) // Show edit and delete icons only if the user is logged in
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColorConstant.primaryAccentColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: IconButton(
                                          icon: const Icon(Icons.edit),
                                          iconSize: isTablet ? 35 : 25,
                                          color: AppColorConstant.whiteTextColor,
                                          onPressed: () {
                                            final String artId =
                                                imageItem.artId;
                                            Navigator.popAndPushNamed(
                                              context,
                                              AppRoute.updateArt,
                                              arguments: artId,
                                            );
                                            ref
                                                .watch(homeViewModelProvider
                                                    .notifier)
                                                .getAllArt();
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: isTablet ? 16 : 10),
                                        decoration: BoxDecoration(
                                          color: AppColorConstant.primaryAccentColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: IconButton(
                                          icon: const Icon(Icons.delete),
                                          iconSize: isTablet ? 35 : 25,
                                          color: AppColorConstant.errorColor,
                                          onPressed: () {
                                            _showDeleteConfirmationDialog(
                                                context,
                                                imageItem.title,
                                                imageItem.artId);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
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
      ),
    );
  }
}
