import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/core/common/components/show_alert_dialog.dart';
import 'package:flutter_final_assignment/core/common/widget/semi_big_text.dart';
import 'package:flutter_final_assignment/features/home/domain/entity/home_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/constants/app_color_constant.dart';
import '../../../../core/common/widget/small_text.dart';

class Creator extends ConsumerStatefulWidget {
  final HomeEntity art;
  const Creator({
    super.key,
    required this.art,
  });

  @override
  ConsumerState<Creator> createState() => _CreatorState();
}

class _CreatorState extends ConsumerState<Creator> {
  @override
  Widget build(BuildContext context) {
    final art = widget.art;
    // final homeState = ref.watch(homeViewModelProvider);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    final gap = SizedBox(height: isTablet ? 15.0 : 10.0);
    return Card(
      color: AppColorConstant.mainSecondaryColor,
      shadowColor: AppColorConstant.mainSecondaryColor,
      elevation: 0,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: AppColorConstant.neutralColor.withOpacity(
              0.3
            ),
            radius: isTablet ? 30 : 24,
            backgroundImage: const NetworkImage(
                "https://flyclipart.com/thumb2/person-137537.png"),
          ),
          gap,
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: isTablet
                      ? const EdgeInsets.only(left: 20.0)
                      : const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // title
                      SemiBigText(
                        // "John Doe",
                        text: art.creator,
                        spacing: 0,
                      ),
                      // subtitle
                      SmallText(
                        text: "Artist",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     showNotification(context, "Following",
          //         icon: Icons.check_circle_outline_rounded);
          //   },
          //   child: SmallText(
          //     text: "Follow",
          //     color: AppColorConstant.whiteTextColor,
          //     // size: 14,
          //   ),
          // ),
        ],
      ),
    );
  }
}
