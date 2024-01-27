import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
import 'package:flutter_final_assignment/core/common/widget/big_text.dart';
import 'package:flutter_final_assignment/core/common/widget/semi_big_text.dart';
import 'package:flutter_final_assignment/features/home/presentation/view/home/home_page_view.dart';
import 'package:flutter_final_assignment/features/navbar/presentation/view/bottom_navigation/bottom_navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../widget/body.dart';

// import 'components/body.dart';

class PostArtView extends ConsumerWidget {
   const PostArtView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColorConstant.mainSecondaryColor,
      appBar: AppBar(
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/back.svg"),
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => const ButtomNavView(
                selectedIndex: 0,
              ),
            ),
          );
        },
      ),
      title: const BigText(
        text: 'NEW BID', 
      ),
      ),
      body:  const Body(),
    );
  }
}
