import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/core/common/widget/big_text.dart';
// import 'package:flutter_final_assignment/core/common/widget/semi_big_text.dart';
import 'package:flutter_final_assignment/features/navbar/presentation/view/bottom_navigation/bottom_navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/constants/app_color_constant.dart';
import '../../../../core/common/widget/small_text.dart';

class PostArt extends ConsumerWidget {
  const PostArt({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    final gap = SizedBox(height: isTablet ? 15.0 : 5.0);
    return Container(
      padding: isTablet
          ? const EdgeInsets.fromLTRB(0, 20, 0, 20)
          : const EdgeInsets.fromLTRB(0, 10, 0, 10),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const BigText(
            text: "Sell Your Own Artwork",
          ),
          gap,
          SizedBox(
            width: isTablet ? 650 : 350,
            child: Text(
              "Let our experts find the best sales option for you to direct lisiting on Artalyst",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isTablet ? 25 : 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          gap,
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColorConstant.primaryAccentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 20 : 10,
                vertical: isTablet ? 15 : 10,
              ),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ButtomNavView(selectedIndex: 2,))
              );
            },
            child: SmallText(
              text: "Submit",
              color: AppColorConstant.whiteTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
