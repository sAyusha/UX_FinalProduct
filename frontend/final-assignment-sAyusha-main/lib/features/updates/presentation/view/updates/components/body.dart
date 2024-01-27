import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
import 'package:flutter_final_assignment/core/common/widget/big_text.dart';
import 'package:flutter_final_assignment/features/updates/presentation/view/updates/components/updates_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../home/presentation/viewmodel/home_viewmodel.dart';

// import 'package:flutter_final_assignment/view/upcoming/components/content_title.dart';

class Body extends ConsumerWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artState = ref.watch(homeViewModelProvider);
    final art = artState.arts;
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    final gap = SizedBox(height: isTablet ? 5.0 : 10.0);
    return SizedBox(
      width: double.infinity,
      height: screenSize.height,
      child: SingleChildScrollView(
        child: Padding(
          padding: isTablet
              ? EdgeInsets.all(AppColorConstant.kDefaultPadding)
              : EdgeInsets.all(AppColorConstant.kDefaultPadding / 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: BigText(text: 'Your Updates'),
              ),
              gap,
              UpdatesView(
                art: art.first,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
