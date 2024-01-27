// import 'package:flutter/material.dart';
// import 'package:flutter_final_assignment/core/common/widget/small_text.dart';
// import 'package:flutter_final_assignment/features/search/presentation/view/search_art_view.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../../config/constants/app_color_constant.dart';

// class HeaderWithSearchBox extends ConsumerWidget {
//   const HeaderWithSearchBox({
//     super.key,
//     required this.searchController,
//   });

//   final TextEditingController searchController;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final screenSize = MediaQuery.of(context).size;
//     final isTablet = screenSize.shortestSide >= 600;
//     return GestureDetector(
//       onTap: (){
//         Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchArtView()));
//       },
//       child: Container(
//         alignment: Alignment.center,
//         margin: isTablet 
//                 ? EdgeInsets.symmetric(horizontal: AppColorConstant.kDefaultPadding / 2)
//                 : EdgeInsets.symmetric(horizontal: AppColorConstant.kDefaultPadding / 4),
//         padding: isTablet
//                 ? EdgeInsets.symmetric(horizontal: AppColorConstant.kDefaultPadding / 2)
//                 : EdgeInsets.symmetric(horizontal: AppColorConstant.kDefaultPadding),
//         decoration: BoxDecoration(
//           color: AppColorConstant.mainSecondaryColor,
//           borderRadius: BorderRadius.circular(29.0),
//         ),
//         child: Padding(
//           padding: isTablet 
//           ? const EdgeInsets.all(16.0)
//           : const EdgeInsets.all(8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               SmallText(text: "Click here for search", color: AppColorConstant.lightColor,),
//               Icon(
//                 Icons.search,
//                 size: isTablet ? 32.0 : 29.0,
//               )
//             ],
//           ),
//         ),
//         // child: TextFormField(
//         //   controller: searchController,
//         //   onChanged: (value) {
//         //     // Handle search logic here
//         //   },
//         //   decoration: InputDecoration(
//         //     hintText: 'Search',
//         //     hintStyle: TextStyle(fontSize: isTablet ? 22.0 : 20.0),
//         //     border: InputBorder.none,
//         //     suffixIcon: Icon(
//         //       Icons.search,
//         //       size: isTablet ? 32.0 : 29.0,
//         //     ),
//         //   ),
//         // ),
//       ),
//     );
//   }
// }
