import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SmallText extends ConsumerWidget {
  final Color color;
  final String text;
  final double height;
  final TextAlign textAlign;
  // TextOverflow overFlow;

  const SmallText(
    {super.key, 
    this.color = const Color(0xff000000), 
    required this.text, 
    this.height =  1.2,
    this.textAlign = TextAlign.left,
    // this.overFlow= TextOverflow.ellipsis
    }
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: 'Poppins',
        color: color,
        fontSize: isTablet ? 26.0 : 18.0,
        height: height,
        fontWeight: FontWeight.w500
      ),
    );
  }
}