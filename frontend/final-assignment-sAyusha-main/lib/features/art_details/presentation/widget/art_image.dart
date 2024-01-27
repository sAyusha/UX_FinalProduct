import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/size_config.dart';
import 'package:flutter_final_assignment/core/common/components/show_alert_dialog.dart';
import 'package:flutter_final_assignment/features/home/domain/entity/home_entity.dart';
import 'package:flutter_final_assignment/features/home/presentation/viewmodel/home_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/constants/api_endpoint.dart';
import '../../../../config/constants/app_color_constant.dart';

class ArtImage extends ConsumerStatefulWidget {
  final HomeEntity art;
  const ArtImage({
    super.key,
    required this.art,
  });

  @override
  ConsumerState<ArtImage> createState() => _ArtImageState();
}

class _ArtImageState extends ConsumerState<ArtImage> {
  @override
  Widget build(BuildContext context) {
    final art = widget.art;
    // final homeState = ref.watch(homeViewModelProvider);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            '${ApiEndpoints.baseUrl}/uploads/${art.image ?? ''}',
            fit: isTablet ? BoxFit.fill : BoxFit.cover,
            width: double.infinity,
            height: isTablet ? 500 : 350,
          ),
        ),
        Positioned(
          bottom: isTablet ? 10 : 5,
          left: isTablet ? 15 : 10,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColorConstant.blackTextColor.withOpacity(0.7),
            ),
            child: IconButton(
              onPressed: () async {
                if (art.isSaved == true) {
                  ref
                      .watch(homeViewModelProvider.notifier)
                      .unsaveArt(art.artId ?? "");
                } else {
                  ref
                      .watch(homeViewModelProvider.notifier)
                      .saveArt(art.artId ?? "");
                }
                ref.read(homeViewModelProvider.notifier).getSavedArts();
                
                showNotification(context,
                    art.isSaved == true ? "Artwork Unsaved" : "Artwork Saved",
                    icon: Icons.check_circle_outline_rounded);

                setState(() {});
              },
              icon: art.isSaved == true
                  ? Icon(
                      size: isTablet ? 35 : 25,
                      Icons.bookmark,
                      color: AppColorConstant.whiteTextColor,
                    )
                  : Icon(
                      size: isTablet ? 35 : 25,
                      Icons.bookmark_border_outlined,
                      color: AppColorConstant.whiteTextColor,
                    ),
            ),
          ),
        ),
        Positioned(
          bottom: isTablet ? 10 : 5,
          right: isTablet ? 15 : 10,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColorConstant.blackTextColor.withOpacity(0.7),
            ),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          '${ApiEndpoints.baseUrl}/uploads/${art.image ?? ''}',
                          fit: BoxFit.fill,
                          width: isTablet ? double.infinity : double.infinity,
                          height: isTablet ? SizeConfig.defaultSize : 350,
                        ),
                      ),
                    );
                  },
                );
              },
              icon: Icon(
                size: isTablet ? 35 : 25,
                Icons.zoom_out_map,
                color: AppColorConstant.whiteTextColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
