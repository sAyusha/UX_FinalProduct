import 'package:flutter/material.dart';

class BigText extends StatelessWidget {
  final Color color;
  final String text;
  final TextOverflow overFlow;

  const BigText(
    {super.key, 
    this.color = const Color(0xff000000), 
    required this.text, 
    this.overFlow= TextOverflow.ellipsis}
  );

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    return Text(
      text,
      overflow: overFlow,
      maxLines: 2,
      style: TextStyle(
        fontFamily: 'Poppins',
        color: color,
        fontSize: isTablet ? 42.0 : 24.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}