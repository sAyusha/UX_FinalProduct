import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common/widget/big_text.dart';

class HomeContentTitle extends ConsumerWidget {
  const HomeContentTitle({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    // final gap = SizedBox(height: isTablet ? 5.0 : 20.0);
    return Container(
      padding: isTablet
          ? const EdgeInsets.fromLTRB(20.0, 0, 20, 0)
          : const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
      // alignment: Alignment.topLeft,
      // height: size.height * 0.05,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BigText(
            text: text,
          ),
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              "assets/icons/right-arrow.png",
              width: isTablet ? 42.0 : 30.0,
            ),
          ),
        ],
      ),
    );
  }
}
