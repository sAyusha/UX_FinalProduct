import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
import 'package:flutter_final_assignment/core/common/snackbar/my_snackbar.dart';
import 'package:flutter_final_assignment/core/common/widget/semi_big_text.dart';
import 'package:flutter_final_assignment/features/art_details/presentation/view/art_details/art_details_view.dart';
import 'package:flutter_final_assignment/features/home/domain/entity/home_entity.dart';
import 'package:flutter_final_assignment/features/profile/presentation/viewmodel/profile_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../config/constants/api_endpoint.dart';
import '../../../../core/common/widget/small_text.dart';
import '../../../home/presentation/viewmodel/home_viewmodel.dart';
import '../../domain/entity/profile_entity.dart';

class AlertedArt extends ConsumerStatefulWidget {
  const AlertedArt({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<AlertedArt> createState() => _AlertedArtState();
}

class _AlertedArtState extends ConsumerState<AlertedArt> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Function to reload the data when the user triggers a refresh.
  Future<void> _handleRefresh() async {
    // Implement the logic to reload the data here.
    ref.watch(profileViewModelProvider.notifier).getUserProfile();
    ref.watch(homeViewModelProvider.notifier).getAlertArts();
  }

  bool _isArtExpired(DateTime upcomingDate) {
    return upcomingDate.isBefore(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    final gap = SizedBox(height: isTablet ? 15.0 : 8.0);

    var userState = ref.watch(profileViewModelProvider);
    List<ProfileEntity> userData = userState.userData;

    var alertArtsState = ref.watch(homeViewModelProvider);
    List<HomeEntity> alertArts = alertArtsState.alertArts;

    if (userData.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(), // Show loader
      );
    }

    if (userState.isLoading) {
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

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _handleRefresh,
      child: Container(
        height: isTablet ? 600 : 300,
        padding: EdgeInsets.only(left: isTablet ? 20 : 10),
        child: SingleChildScrollView(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: isTablet ? 220 / 260 : 95 / 130,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: alertArts.length,
            itemBuilder: (context, index) {
              if (alertArts.isEmpty) {
                return Center(
                  child: SmallText(
                    text: 'No alert art post',
                    color: AppColorConstant.errorColor,
                  ),
                );
              }

              // Get the current saved art
              final alertArt = alertArts[index];

              final DateTime upcomingDate =
                  DateTime.parse(alertArt.upcomingDate.toString());

              // Check if the art has expired
              bool isExpired = _isArtExpired(alertArt.upcomingDate);
              // If the art has expired, show a message instead of the saved art post.
              if (isExpired) {
                return SmallText(
                  text: 'Art has already expired',
                  color: AppColorConstant.errorColor,
                );
              }

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
                                  art: alertArt,
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              alertArt.image == ""
                                  ? "https://i.pinimg.com/564x/17/99/92/179992c2d7c70f86bfba2726f9e29afd.jpg"
                                  : '${ApiEndpoints.baseUrl}/uploads/${alertArts[index].image}',
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
                                        text: "Unalert Art Post",
                                        spacing: 0,
                                      ),
                                      content: const SmallText(
                                          text:
                                              "Are you sure you want to unalert this art post?"),
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
                                          child:
                                              const SmallText(text: "Unalert"),
                                        ),
                                      ],
                                    );
                                  });
                              if (confirmed) {
                                ref
                                    .read(homeViewModelProvider.notifier)
                                    .unAlertArt(alertArts[index].artId ?? "");
                                ref
                                    .read(homeViewModelProvider.notifier)
                                    .getAlertArts();

                                // ignore: use_build_context_synchronously
                                showSnackBar(
                                  message: "Art unalerted",
                                  context: context,
                                  color: AppColorConstant.errorColor,
                                );

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
                              child: Icon(
                                Icons.notifications_active,
                                color: AppColorConstant.whiteTextColor,
                              ),
                            ),
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
                            text: alertArt.title,
                          ),
                          SemiBigText(
                            text: DateFormat.yMMMd().format(upcomingDate),
                            spacing: 0
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
      ),
    );
  }
}
