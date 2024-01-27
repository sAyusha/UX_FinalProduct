import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/core/common/widget/semi_big_text.dart';
import 'package:flutter_final_assignment/core/common/widget/small_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/constants/app_color_constant.dart';

class PreviousBidders extends ConsumerWidget {
  const PreviousBidders({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    final gap = SizedBox(height: isTablet ? 15.0 : 10.0);
    return ListView.builder(
      itemCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => 
      Card(
        color: AppColorConstant.mainTeritaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          padding: isTablet 
                  ? const EdgeInsets.all(12) 
                  : const EdgeInsets.all(8),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: AppColorConstant.neutralColor.withOpacity(0.5),
                radius: isTablet ? 28 : 22,
                backgroundImage: const NetworkImage(
                    "https://flyclipart.com/thumb2/person-137537.png"),
              ),
              gap,
              Expanded(
                child: Container(
                  padding: isTablet 
                          ? const EdgeInsets.only(left: 20.0)
                          : const EdgeInsets.only(left: 10.0),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmallText(
                        text: "John Doe",
                        
                      ),
                      SemiBigText(
                        text: "₹ 10,299",
                        spacing: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
