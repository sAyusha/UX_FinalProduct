import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
import 'package:flutter_final_assignment/config/constants/size_config.dart';
import 'package:flutter_final_assignment/core/common/widget/semi_big_text.dart';
import 'package:flutter_final_assignment/features/profile/presentation/widget/alerted_art_view.dart';
import 'package:flutter_final_assignment/features/profile/presentation/widget/saved_art_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'collected_art_view.dart';
import 'posted_art_view.dart';

class ProfileCategories extends ConsumerStatefulWidget {
  const ProfileCategories({super.key});

  @override
  ConsumerState<ProfileCategories> createState() => _ProfileCategoriesState();
}

class _ProfileCategoriesState extends ConsumerState<ProfileCategories> {
  List<String> profileCategories = ["Posts", "Saved", "Alerts"];

  // by default first item will be selected
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final orientations = MediaQuery.of(context).orientation;
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    return Padding(
      padding: isTablet
          ? const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0)
          : const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 20.0),
      child: Column(
        children: [
          SizedBox(
            height: orientations == Orientation.portrait
                ? SizeConfig.screenHeight * 0.05
                : SizeConfig.screenHeight * 0.18,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: profileCategories.length,
                itemBuilder: (context, index) => buildCategory(index)),
          ),
          const SizedBox(height: 20), // Adjust this spacing as needed
          IndexedStack(
            index: selectedIndex,
            children: const [
              PostedArt(),
              SavedArt(),
              AlertedArt()
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCategory(int index) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Padding(
        padding: isTablet
            ? EdgeInsets.symmetric(horizontal: AppColorConstant.kDefaultPadding / 1.5)
            : EdgeInsets.symmetric(
                horizontal: AppColorConstant.kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SemiBigText(
              text: profileCategories[index],
              spacing: 0,
            ),
            Container(
              height: isTablet ? 3 : 2,
              width: isTablet ? 60 : 50,
              color: selectedIndex == index
                  ? AppColorConstant.blackTextColor
                  : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
