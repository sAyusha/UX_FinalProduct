import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
import 'package:flutter_final_assignment/config/constants/size_config.dart';
import 'package:flutter_final_assignment/core/common/widget/semi_big_text.dart';
// import 'package:flutter_final_assignment/core/common/widget/small_text.dart';
import 'package:flutter_final_assignment/features/home/presentation/widget/arts_in_categories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Categories extends ConsumerStatefulWidget {
  const Categories({super.key});

  @override
  ConsumerState<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends ConsumerState<Categories> {
  List<String> categories = [
    "Abstract",
    "Painting",
    "Drawing",
    "Digital",
    "Mixed media"
  ];

  // by default first item will be selected
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final orientations = MediaQuery.of(context).orientation;
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;

    return Padding(
      padding: isTablet
          ? const EdgeInsets.fromLTRB(0.0, .0, 0.0, 0.0)
          : const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 20.0),
      child: Column(
        children: [
          SizedBox(
            height: orientations == Orientation.portrait
                ? isTablet
                    ? 70
                    : SizeConfig.screenHeight * 0.07
                : SizeConfig.screenHeight * 0.18,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) => buildCategory(index)),
          ),
          const SizedBox(height: 10), // Adjust this spacing as needed
          IndexedStack(
            index: selectedIndex,
            children: [
              for (var i = 0; i < categories.length; i++)
                if (i == selectedIndex)
                  ArtView(category: categories[selectedIndex])
                else
                  Container(),
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
        padding:
            EdgeInsets.symmetric(horizontal: AppColorConstant.kDefaultPadding / 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 160,
              height: 47,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 10 : 10,
                vertical: isTablet ? 5 : 10,
              ),
              decoration: BoxDecoration(
                color: selectedIndex == index
                    ? AppColorConstant.primaryAccentColor
                    : const Color.fromARGB(255, 215, 215, 255),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SemiBigText(
                // textAlign: TextAlign.center,
                text: categories[index],
                color: selectedIndex == index 
                      ? AppColorConstant.whiteTextColor 
                      : AppColorConstant.blackTextColor,
                spacing: 0,
              ),
            ),
            // Container(
            //   height: isTablet ? 3 : 2,
            //   width: isTablet ? 75 : 70,
            //   color: selectedIndex == index
            //       ? AppColorConstant.blackTextColor
            //       : Colors.transparent,
            // ),
          ],
        ),
      ),
    );
  }
}
