// import 'package:flutter/material.dart';
// import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
// import 'package:flutter_final_assignment/config/constants/size_config.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../../core/common/widget/small_text.dart';

// class CollectedArt extends ConsumerWidget {
//   const CollectedArt({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final screenSize = MediaQuery.of(context).size;
//     final isTablet = screenSize.shortestSide >= 600;
//     return SingleChildScrollView(
//       child: GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           childAspectRatio: isTablet ? 225 / 260 : 92 / 130,
//         ),
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: 4,
//         itemBuilder: (context, index) {
//           return CollectedArtWorks(
//             image: _getImageUrl(index),
//           );
//         },
//       ),
//     );
//   }

//   String _getImageUrl(int index) {
//     switch (index) {
//       case 0:
//         return "https://images.unsplash.com/photo-1634986666676-ec8fd927c23d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=735&q=80";
//       case 1:
//         return "https://i.pinimg.com/550x/fe/37/32/fe37325df5487b9cf83671c3a7f91c81.jpg";
//       case 2:
//         return "https://images.unsplash.com/photo-1516238840914-94dfc0c873ae?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80";
//       case 3:
//         return "https://images.unsplash.com/photo-1582201942988-13e60e4556ee?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=702&q=80";
//       default:
//         return "";
//     }
//   }
// }

// class CollectedArtWorks extends ConsumerWidget {
//   const CollectedArtWorks({
//     Key? key,
//     required this.image,
//   }) : super(key: key);

//   final String image;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final screenSize = MediaQuery.of(context).size;
//     final isTablet = screenSize.shortestSide >= 600;
//     final gap = SizedBox(height: isTablet ? 15.0 : 10.0);
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(8)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Image.network(
//             image,
//             fit: isTablet ? BoxFit.fill : BoxFit.cover,
//             width: isTablet ? 350 : 250,
//             height: isTablet ? 350 : 190,
//           ),
//           gap,
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SmallText(text: "Owned By"),
//                 Text(
//                   "@zayn12", 
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: isTablet ? 22 : 18,
//                     color: AppColorConstant.neutralColor,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
