import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
import 'package:flutter_final_assignment/core/common/widget/big_text.dart';
import 'package:flutter_final_assignment/features/bidding/presentation/view/bidding/bid_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/common/components/rounded_button_field.dart';
import '../../../../../core/common/widget/semi_big_text.dart';
import '../../../../../core/common/widget/small_text.dart';
import '../../../../bidding/presentation/view/bidding/helper_page.dart';
import '../../../../home/domain/entity/home_entity.dart';
// import '../../../../home/presentation/viewmodel/home_viewmodel.dart';
import '../../../../navbar/presentation/view/bottom_navigation/bottom_navigation_bar.dart';
import '../../widget/art_image.dart';
import '../../widget/creator.dart';
import '../../widget/deadline.dart';
import '../../widget/previous_bidders.dart';

class ArtDetailsView extends ConsumerStatefulWidget {
  final HomeEntity? art;
  const ArtDetailsView({Key? key, this.art}) : super(key: key);

  @override
  ConsumerState<ArtDetailsView> createState() => _ArtDetailsViewState();
}

class _ArtDetailsViewState extends ConsumerState<ArtDetailsView> with TickerProviderStateMixin{
  late Ticker _ticker;
  String remainingTimeText = '';

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      final art = widget.art;
      if (art != null) {
        final now = DateTime.now();
        final remainingTime = art.endingDate.difference(now);
        setState(() {
          remainingTimeText = _formatDuration(remainingTime);
        });
      }
    });
      // Start the ticker
  _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (days > 0) {
      return '$days${"D"} : ${twoDigits(hours)}${"H"} : ${twoDigits(minutes)}${"M"} : ${twoDigits(seconds)}${"S"} ';
    } else if (hours > 0) {
      return '$hours${"H"} :${twoDigits(minutes)}${"M"} : ${twoDigits(seconds)}${"S"}';
    } else if (minutes > 0) {
      return '$minutes${"M"} : ${twoDigits(seconds)}${"S"} ';
    } else {
      return '$seconds${"S"} ';
    }
  }
  
  bool _isArtExpired(HomeEntity? art) {
    // ignore: unnecessary_null_comparison
    if (art == null || art.endingDate == null) {
      return true; // Treat as expired if the art or endingDate is null
    }
    return art.endingDate.isBefore(DateTime.now());
  }

  void showBottomSheet(BuildContext context, HomeEntity art) {
    showModalBottomSheet(
      backgroundColor: AppColorConstant.primaryAccentColor,
      constraints: const BoxConstraints(
        maxWidth: double.infinity,
      ),
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.4,
          maxChildSize: 0.9,
          minChildSize: 0.32,
          builder: (context, scrollController) => SingleChildScrollView(
              controller: scrollController, child: BiddingView(art: art))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final art = widget.art;

    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    final gap = SizedBox(height: isTablet ? 18.0 : 16.0);

    // Check if the art has expired
    final bool isExpired = _isArtExpired(art);

    return Scaffold(
      backgroundColor: AppColorConstant.mainSecondaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: BigText(
          text: remainingTimeText,
          color: AppColorConstant.blackTextColor,
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/icons/back.svg"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ButtomNavView(selectedIndex: 0),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: isTablet
              ? EdgeInsets.all(AppColorConstant.kDefaultPadding)
              : EdgeInsets.all(AppColorConstant.kDefaultPadding / 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(alignment: Alignment.center, child: ArtImage(art: art!)),
              gap,
              // Deadline(art: art),
              // gap,
              SemiBigText(
                text: art.title,
                spacing: 0,
              ),

              SizedBox(height: isTablet ? 15 : 5),
              SmallText(
                text: art.categories,
              ),

              SizedBox(height: isTablet ? 15 : 5),
              SmallText(
                text: art.description,
                textAlign: TextAlign.justify,
              ),
              gap,
              const SemiBigText(
                text: "Creator",
                spacing: 0,
                // size: 22,
              ),
              SizedBox(height: isTablet ? 15 : 5),
              Creator(art: art),
              SizedBox(height: isTablet ? 15 : 10),
              // helper page
              TextButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BiddingHelperPage(),
                    ),
                  );
                }, 
                child: SemiBigText(
                  text: 'Bidding Helper', 
                  spacing: 0,
                  color: AppColorConstant.blueTextColor,
                )
              ),
              SizedBox(height: isTablet ? 15 : 10),
              const SemiBigText(text: "Top Bidders", spacing: 0),
              SizedBox(height: isTablet ? 15 : 10),
              SizedBox(
                  width: double.infinity,
                  height: isTablet ? 200 : 150,
                  child: const PreviousBidders(
                    
                  )),
              // gap,
              // Show the button only if the art is not expired
              if (!isExpired)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          AppColorConstant.primaryAccentColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: const BorderSide(
                              color: AppColorConstant.primaryAccentColor),
                        ),
                      ),
                    ),
                    child: SemiBigText(
                      text: "Make a Bid", 
                      spacing: 0,
                      color: AppColorConstant.whiteTextColor,
                    ),
                    onPressed: () async {
                      // await ref.watch(homeViewModelProvider.notifier).getArtById(art.artId!);
                      showBottomSheet(context, art);
                    },
                  ),
                ),
              if (isExpired) // Show a message if the art is expired
                Center(
                  child: Text(
                    "This art has expired and is no longer available for bidding.",
                    style: TextStyle(
                      fontSize: isTablet ? 24 : 18,
                      fontWeight: FontWeight.w500,
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
