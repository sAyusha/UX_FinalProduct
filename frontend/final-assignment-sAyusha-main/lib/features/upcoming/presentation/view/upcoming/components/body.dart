import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
import 'package:flutter_final_assignment/core/common/widget/big_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'explore_upcoming_view.dart';

class Body extends ConsumerWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    return SingleChildScrollView(
      child: Padding(
        padding: isTablet 
                ? EdgeInsets.all(AppColorConstant.kDefaultPadding)
                : EdgeInsets.all(AppColorConstant.kDefaultPadding / 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BigText(
                text: 'Explore Upcoming', 
                color: AppColorConstant.blackTextColor,
              ),
            ),
            // SizedBox(height: AppColorConstant.kDefaultPadding / 2,),
            const ExploreUpcoming(),
          ],
        ),
      ),
    );
  }
}
