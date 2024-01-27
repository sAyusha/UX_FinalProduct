import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/core/common/widget/big_text.dart';
import 'package:flutter_final_assignment/features/bidding/domain/entity/bidding_entity.dart';
import 'package:flutter_final_assignment/features/bidding/presentation/viewmodel/bid_viewmodel.dart';
import 'package:flutter_final_assignment/features/home/presentation/viewmodel/home_viewmodel.dart';
// import 'package:flutter_final_assignment/features/order_summary/presentation/view/order_summary/order_summary_view.dart';
import 'package:flutter_final_assignment/features/shipping/presentation/view/shipping/shipping_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../config/constants/api_endpoint.dart';
import '../../../../../config/constants/app_color_constant.dart';
import '../../../../../core/common/components/rounded_button_field.dart';
import '../../../../../core/common/components/show_alert_dialog.dart';
import '../../../../../core/common/widget/semi_big_text.dart';
import '../../../../../core/common/widget/small_text.dart';
import '../../../../home/domain/entity/home_entity.dart';

class BidItem {
  final String bidId;
  final num bidAmount;

  BidItem(this.bidId, this.bidAmount);
}

class BiddingView extends ConsumerStatefulWidget {
  final HomeEntity art;
  const BiddingView({Key? key, required this.art}) : super(key: key);

  @override
  ConsumerState<BiddingView> createState() => _BiddingViewState();
}

class _BiddingViewState extends ConsumerState<BiddingView> {
  double bidAmount = 0.0;
  TextEditingController? textFieldController;

  @override
  void initState() {
    super.initState();
    bidAmount = widget.art.startingBid.toDouble();
    textFieldController = TextEditingController(text: bidAmount.toString());
  }

  @override
  Widget build(BuildContext context) {
    final art = widget.art;
    final double startingBid = art.startingBid.toDouble();

    var bidState = ref.watch(bidViewModelProvider);
    final List<BidEntity> bidData = bidState.bids;
    final List<BidItem> bidItems = bidData.map((bid) {
      return BidItem(
        bid.bidId ?? "",
        bid.bidAmount,
      );
    }).toList();

    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;

    void updateTextField() {
      if (textFieldController != null) {
        textFieldController!.text = bidAmount.toString();
      }
    }

    void increaseBidAmount() {
      setState(() {
        bidAmount += 100.0;
        updateTextField();
      });
    }

    void decreaseBidAmount() {
      if (bidAmount > 100.0) {
        setState(() {
          bidAmount -= 100.0;
          updateTextField();
        });
      }
    }

    void placeBid() async {
      if (art.isUserLoggedIn != null && art.isUserLoggedIn!) {
        // Show an alert dialog or snackbar with the error message to check if it is the user who posted the art.
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const SemiBigText(
              text: "Cannot Bid",
              spacing: 0.0,
            ),
            content: const SmallText(text: "You cannot bid on your own art."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const SmallText(text: "OK", color: Color.fromARGB(255, 3, 126, 9)),
              ),
            ],
          ),
        );
        return;
      }

      // Show a confirmation dialog before placing the bid.
      bool confirmBid = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const SemiBigText(
            text: "Confirm Bid",
            spacing: 0.0,
          ),
          content:
              const SmallText(text: "Are you sure you want to place a bid?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // User canceled the bid
              },
              child: const SmallText(text: "Cancel", color: Color.fromARGB(255, 245, 22, 6)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // User confirmed the bid
              },
              child: const SmallText(text: "Confirm", color: Color.fromARGB(255, 8, 179, 14)),
            ),
          ],
        ),
      );

      if (confirmBid != null && confirmBid) {
        // User confirmed the bid, proceed to check other conditions and place the bid.
        if (bidAmount <= startingBid) {
          // Show an alert dialog or snackbar with the error message.
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const SemiBigText(
                text: "Invalid Bid",
                spacing: 0.0,
              ),
              content: const SmallText(
                  text: "Bid must be greater than the starting bid."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const SmallText(text: "OK", color: Color.fromARGB(255, 7, 163, 12)),
                ),
              ],
            ),
          );
          return;
        }

        // The bid is confirmed and valid, proceed to place the bid.
        await ref
            .watch(homeViewModelProvider.notifier)
            .getArtById(art.artId ?? "");

        // Bid amount is valid, proceed to place the bid.
        await ref.watch(bidViewModelProvider.notifier).bidOnArt(
              BidEntity(
                // bidId: bidItems[0].bidId,
                artId: art.artId,
                bidAmount: bidAmount,
              ),
              art.artId ?? "",
            );

        // Show a notification or snackbar indicating the bid was placed successfully.
        // ignore: use_build_context_synchronously
        showNotification(
          context,
          "Bid placed.",
          icon: Icons.check_circle_outline,
        );

        await ref.watch(bidViewModelProvider.notifier).getAllBids();
        if (bidItems.isNotEmpty) {
          await ref
              .watch(bidViewModelProvider.notifier)
              .getBid(bidItems[0].bidId);
        } else {
          await ref.watch(bidViewModelProvider.notifier).getAllBids();
        }

        // ignore: use_build_context_synchronously
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShippingView(
                  art: art,
                  bid: BidEntity(
                    bidAmount: bidAmount,
                  ),
                ),
              ));
        });
      }
    }

    return Padding(
      padding: EdgeInsets.all(AppColorConstant.kDefaultPadding),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -15,
            child: Container(
              height: 3,
              width: 60,
              decoration: BoxDecoration(
                color: AppColorConstant.whiteTextColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: AppColorConstant.kDefaultPadding / 2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmallText(
                    text: "Starting Bid",
                    color: AppColorConstant.whiteTextColor,
                  ),
                  SemiBigText(
                    text: "₹ $startingBid",
                    spacing: 0,
                    color: AppColorConstant.whiteTextColor,
                  ),
                ],
              ),
              SizedBox(height: AppColorConstant.kDefaultPadding / 2),
              SemiBigText(
                text: "Make Your Offer",
                spacing: 0,
                color: AppColorConstant.whiteTextColor,
              ),
              Card(
                color: AppColorConstant.whiteTextColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: isTablet ? 42 : 30,
                        backgroundImage: NetworkImage(
                          '${ApiEndpoints.baseUrl}/uploads/${art.image}',
                        ),
                      ),
                      IconButton(
                        onPressed: decreaseBidAmount,
                        color: Colors.black,
                        icon: Image.asset(
                          "assets/images/minus.png",
                          width: isTablet ? 42 : 20,
                          height: isTablet ? 42 : 20,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(
                            AppColorConstant.kDefaultPadding / 6),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 210, 210, 255),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SizedBox(
                          width: isTablet ? 150 : 100,
                          child: TextFormField(
                            cursorColor: Colors.black,
                            controller: textFieldController,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              setState(() {
                                bidAmount = double.tryParse(value) ?? 0.0;
                              });
                            },
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: isTablet ? 24 : 22,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: increaseBidAmount,
                        color: Colors.black,
                        icon: Image.asset(
                          "assets/images/plus.png",
                          width: isTablet ? 30 : 20,
                          height: isTablet ? 30 : 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppColorConstant.kDefaultPadding),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      AppColorConstant.whiteTextColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: AppColorConstant.whiteTextColor),
                    ),
                  ),
                ),
                child: const BigText(text: "Place Bid"),
                onPressed: () async {
                  placeBid();

                  // await ref.watch(bidViewModelProvider.notifier).getAllBids();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
