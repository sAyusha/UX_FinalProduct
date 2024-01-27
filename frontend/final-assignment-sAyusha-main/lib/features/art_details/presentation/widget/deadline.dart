
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../../config/constants/app_color_constant.dart';
// import '../../../home/domain/entity/home_entity.dart';

// class Deadline extends ConsumerStatefulWidget {
//   final HomeEntity? art;
//   const Deadline({
//     Key? key,
//     this.art,
//   }) : super(key: key);

//   @override
//   ConsumerState<Deadline> createState() => _DeadlineState();
// }

// class _DeadlineState extends ConsumerState<Deadline> with TickerProviderStateMixin {
//   late Ticker _ticker;
//   String remainingTimeText = '';

//   @override
//   void initState() {
//     super.initState();
//     _ticker = createTicker((elapsed) {
//       final art = widget.art;
//       if (art != null) {
//         final now = DateTime.now();
//         final remainingTime = art.endingDate.difference(now);
//         setState(() {
//           remainingTimeText = _formatDuration(remainingTime);
//         });
//       }
//     });
//     _ticker.start();
//   }

//   @override
//   void dispose() {
//     _ticker.dispose();
//     super.dispose();
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');

//     final days = duration.inDays;
//     final hours = duration.inHours % 24;
//     final minutes = duration.inMinutes % 60;
//     final seconds = duration.inSeconds % 60;

//     if (days > 0) {
//       return '$days ${"D"} : ${twoDigits(hours)} ${"H"} : ${twoDigits(minutes)} ${"M"} : ${twoDigits(seconds)} ${"S"} ';
//     } else if (hours > 0) {
//       return '$hours ${"H"} : ${twoDigits(minutes)} ${"M"} : ${twoDigits(seconds)} ${"S"}';
//     } else if (minutes > 0) {
//       return '$minutes ${"M"} : ${twoDigits(seconds)} ${"S"} ';
//     } else {
//       return '$seconds ${"S"} ';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final art = widget.art;
//     final screenSize = MediaQuery.of(context).size;
//     final isTablet = screenSize.shortestSide >= 600;

//     if (art == null) {
//       return const SizedBox.shrink(); // If art is null, show nothing
//     }

//     return SizedBox(
//       width: double.infinity,
//       child: Column(
//         children: [
//           RichText(
//             text: TextSpan(
//               style: TextStyle(
//                 fontFamily: "Laila",
//                 fontSize: isTablet ? 55 : 30,
//                 fontWeight: FontWeight.w600,
//                 color: AppColorConstant.blackTextColor,
//               ),
//               children: <TextSpan>[
//                 TextSpan(text: remainingTimeText),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
