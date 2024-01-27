import 'package:flutter/material.dart';

class SemiBigText extends StatelessWidget {
  final Color color;
  final String text;
  final double spacing;
  final TextOverflow overFlow;

  const SemiBigText(
      {super.key,
      this.color = const Color(0xff000000),
      required this.text,
      this.spacing = 2,
      this.overFlow = TextOverflow.ellipsis});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    return Text(
      text,
      overflow: overFlow,
      // maxLines: 1,
      style: TextStyle(
          fontFamily: 'Poppins',
          color: color,
          fontSize: isTablet ? 30.0 : 20.0,
          letterSpacing: spacing,
          fontWeight: FontWeight.w600),
    );
  }
}
