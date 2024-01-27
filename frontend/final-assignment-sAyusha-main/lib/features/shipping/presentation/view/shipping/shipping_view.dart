import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
// import 'package:flutter_final_assignment/core/common/widget/small_text.dart';
import 'package:flutter_final_assignment/features/bidding/domain/entity/bidding_entity.dart';
import 'package:flutter_final_assignment/features/home/domain/entity/home_entity.dart';
import 'package:flutter_final_assignment/features/order_summary/presentation/view/order_summary/order_summary_view.dart';
// import 'package:flutter_final_assignment/features/order_summary/presentation/viewmodel/order_viewmodel.dart';
import 'package:flutter_final_assignment/features/profile/presentation/viewmodel/profile_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common/components/rounded_button_field.dart';
import '../../../../../core/common/components/rounded_input_field.dart';
import '../../../../../core/common/snackbar/my_snackbar.dart';
import '../../../../../core/common/widget/semi_big_text.dart';
import '../../../../bidding/presentation/viewmodel/bid_viewmodel.dart';
// import '../../../../home/presentation/viewmodel/home_viewmodel.dart';
import '../../../../order_summary/domain/entity/order_entity.dart';
import '../../../../profile/domain/entity/profile_entity.dart';

class ShippingView extends ConsumerStatefulWidget {
  final HomeEntity art;
  final BidEntity bid; 

  const ShippingView({
    Key? key,
    required this.art,
    required this.bid,
  }) : super(key: key);

  @override
  ConsumerState<ShippingView> createState() => _ShippingViewState();
}

class _ShippingViewState extends ConsumerState<ShippingView> {
  
  final _shippingKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _requestController = TextEditingController();

  final List<String> paymentOptions = ["COD", "Khalti"];
  String selectedPayOption = "Khalti";

  @override
  void initState() {
    var userState = ref.read(profileViewModelProvider);
    List<ProfileEntity> userData = userState.userData;
    if (userData.isNotEmpty) {
      _fullNameController.text = userData[0].fullname;
    }
    super.initState();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    _requestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final art = widget.art;

    final bid = widget.bid;
    // final double bidAmount = bid.bidAmount!.toDouble();

    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    final gap = SizedBox(height: isTablet ? 18.0 : 16.0);

    return Scaffold(
      backgroundColor: AppColorConstant.mainSecondaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: const SemiBigText(
          text: 'SHIPPING',
          spacing: 0,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColorConstant.lightNeutralColor4,
                  width: 1.0,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: isTablet
              ? EdgeInsets.all(AppColorConstant.kDefaultPadding)
              : EdgeInsets.all(AppColorConstant.kDefaultPadding / 2),
          child: Column(
            children: [
              const SemiBigText(
                text: "Fill your shipping details",
                spacing: 0,
                // size: size.width * 0.03,
              ),
              gap,
              Form(
                key: _shippingKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SemiBigText(text: "Fullname"),
                    TextFormField(
                    // cursorColor: Colors.black,
                    controller: _fullNameController,
                    keyboardType: TextInputType.name,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: '',
                      // hintStyle: TextStyle(
                      //   color: AppColorConstant.blackTextColor,
                      // ), 
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: AppColorConstant.blackTextColor, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: AppColorConstant.blackTextColor, width: 2),
                      ),   
                    ),
                  ),
                    gap,
                    const SemiBigText(text: "Address"),
                   TextFormField(
                    // cursorColor: Colors.black,
                    controller: _addressController,
                    keyboardType: TextInputType.text,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: '',
                      // hintStyle: TextStyle(
                      //   color: AppColorConstant.blackTextColor,
                      // ), 
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: AppColorConstant.blackTextColor, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: AppColorConstant.blackTextColor, width: 2),
                      ),   
                    ),
                  ),
                    gap,
                    const SemiBigText(text: "Postal Code"),
                    // gap,
                    TextFormField(
                    // cursorColor: Colors.black,
                    controller: _postalCodeController,
                    keyboardType: TextInputType.number,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: '',
                      // hintStyle: TextStyle(
                      //   color: AppColorConstant.blackTextColor,
                      // ), 
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: AppColorConstant.blackTextColor, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: AppColorConstant.blackTextColor, width: 2),
                      ),   
                    ),
                  ),
                    gap,
                    const SemiBigText(text: "City"),
                    // gap,
                    TextFormField(
                    // cursorColor: Colors.black,
                    controller: _cityController,
                    keyboardType: TextInputType.text,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: '',
                      // hintStyle: TextStyle(
                      //   color: AppColorConstant.blackTextColor,
                      // ), 
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: AppColorConstant.blackTextColor, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: AppColorConstant.blackTextColor, width: 2),
                      ),   
                    ),
                  ),
                    gap,
                    const SemiBigText(text: "Payment Option"),
                    // gap,
                    Container(
                      height: isTablet ? 90 : 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColorConstant.neutralColor,
                          // width: 1,
                        ),
                      ),
                      child: DropdownButton(
                        padding: EdgeInsets.only(top: isTablet ? 20 : 5),
                        isExpanded: true,
                        underline: gap,
                        value: selectedPayOption,
                        items: paymentOptions.map((String option) {
                          return DropdownMenuItem(
                            value: option,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: isTablet ? 10.0 : 8.0),
                              child: Text(option,
                                  style: TextStyle(
                                    fontSize: isTablet ? 25 : 20,
                                  )),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedPayOption = newValue.toString();
                          });
                        },
                      ),
                    ),
                    gap,
                    const SemiBigText(text: "Request"),
                    TextFormField(
                    // cursorColor: Colors.black,
                    controller: _requestController,
                    keyboardType: TextInputType.text,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: '',
                      // hintStyle: TextStyle(
                      //   color: AppColorConstant.blackTextColor,
                      // ), 
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: AppColorConstant.blackTextColor, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: AppColorConstant.blackTextColor, width: 2),
                      ),   
                    ),
                  ),
                    // gap,
                  ],
                ),
              ),
              gap,
              gap,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColorConstant.primaryAccentColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  
                  ),
                  child: SemiBigText(text: "NEXT", spacing: 0, color: AppColorConstant.whiteTextColor,),
                  onPressed: () async {
                    if (_shippingKey.currentState!.validate()) {
                      final shippingAddress = ShippingAddress(
                        fullname: _fullNameController.text,
                        address: _addressController.text,
                        postalCode: _postalCodeController.text,
                        city: _cityController.text,
                        request: _requestController.text,
                      );
              
                      // ignore: use_build_context_synchronously
                      showSnackBar(
                        message: 'Shipping Deatails added',
                        context: context,
                        color: AppColorConstant.successColor,
                      );
              
                      // Bid amount is valid, proceed to place the bid.
                      await ref.watch(bidViewModelProvider.notifier).getBid(
                        bid.bidId ?? "",
                      );
              
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderSummaryView(
                            art: widget.art,
                            bid: widget.bid,
                            shippingAddress: shippingAddress,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
