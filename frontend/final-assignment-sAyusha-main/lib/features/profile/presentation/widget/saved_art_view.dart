import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
import 'package:flutter_final_assignment/core/common/snackbar/my_snackbar.dart';
import 'package:flutter_final_assignment/core/common/widget/semi_big_text.dart';
import 'package:flutter_final_assignment/features/art_details/presentation/view/art_details/art_details_view.dart';
import 'package:flutter_final_assignment/features/home/domain/entity/home_entity.dart';
import 'package:flutter_final_assignment/features/profile/presentation/viewmodel/profile_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/constants/api_endpoint.dart';
import '../../../../core/common/widget/small_text.dart';
import '../../../home/presentation/viewmodel/home_viewmodel.dart';
import '../../domain/entity/profile_entity.dart';

class SavedArt extends ConsumerStatefulWidget {
  const SavedArt({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<SavedArt> createState() => _SavedArtState();
}

class _SavedArtState extends ConsumerState<SavedArt> {
  bool _isArtExpired(DateTime endingDate) {
    return endingDate.isBefore(DateTime.now());
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get the saved arts
      ref.read(homeViewModelProvider.notifier).getSavedArts();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    final gap = SizedBox(height: isTablet ? 15.0 : 8.0);

    var userState = ref.watch(profileViewModelProvider);
    List<ProfileEntity> userData = userState.userData;

    var savedArtsState = ref.watch(homeViewModelProvider);
    List<HomeEntity> savedArts = savedArtsState.savedArts;

    if (userData.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(), // Show loader
      );
    }

    // Filter out the expired arts from the savedArts list
    savedArts =
        savedArts.where((art) => !_isArtExpired(art.endingDate)).toList();

    return Container(
      height: isTablet ? 600 : 300,
      padding: EdgeInsets.only(left: isTablet ? 20 : 10),
      child: SingleChildScrollView(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: isTablet ? 220 / 260 : 90 / 130,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: savedArts.length,
          itemBuilder: (context, index) {
            if (savedArts.isEmpty) {
              return Center(
                child: SmallText(
                  text: 'No saved art post',
                  color: AppColorConstant.errorColor,
                ),
              );
            }

            // Get the current saved art
            final savedArt = savedArts[index];

            return Container(
              width: double.infinity,
              padding: isTablet
                  ? const EdgeInsets.symmetric(horizontal: 20)
                  : const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onDoubleTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArtDetailsView(
                                art: savedArt,
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            savedArt.image == ""
                                ? "https://i.pinimg.com/564x/17/99/92/179992c2d7c70f86bfba2726f9e29afd.jpg"
                                : '${ApiEndpoints.baseUrl}/uploads/${savedArts[index].image}',
                            fit: isTablet ? BoxFit.fill : BoxFit.cover,
                            width: isTablet ? 350 : 250,
                            height: isTablet ? 350 : 190,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          onPressed: () async {
                            bool confirmed = await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const SemiBigText(
                                      text: "Unsave Art Post",
                                      spacing: 0,
                                    ),
                                    content: const SmallText(
                                        text:
                                            "Are you sure you want to unsave this art post?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: SmallText(
                                          text: "Cancel",
                                          color: AppColorConstant.errorColor,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                        child: const SmallText(text: "Unsave"),
                                      ),
                                    ],
                                  );
                                });
                            // Call the unsaveArt function
                            if (confirmed) {
                              ref
                                  .read(homeViewModelProvider.notifier)
                                  .unsaveArt(
                                    savedArt.artId!,
                                  );

                              // Update the state to reflect the changes
                              ref
                                  .watch(homeViewModelProvider.notifier)
                                  .getSavedArts();

                              // Show the snackbar
                              // ignore: use_build_context_synchronously
                              showSnackBar(
                                message: "Art unsaved",
                                context: context,
                                color: AppColorConstant.errorColor,
                              );

                              // Rebuild the widget to reflect the updated list of saved arts
                              setState(() {});
                            }
                          },
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColorConstant.neutralColor
                                  .withOpacity(0.7),
                            ),
                            child: const Icon(Icons.bookmark),
                          ),
                          color: AppColorConstant.whiteTextColor,
                          iconSize: isTablet ? 42 : 22,
                        ),
                      ),
                    ],
                  ),
                  gap,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SmallText(
                          text: savedArt.title,
                        ),
                        SemiBigText(
                          text: "₹${savedArt.startingBid}",
                          spacing: 0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
