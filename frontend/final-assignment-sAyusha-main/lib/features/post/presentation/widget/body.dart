import 'dart:io';

// import 'package:intl/date_symbol_data_local.dart';

import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
import 'package:flutter_final_assignment/core/common/widget/small_text.dart';
import 'package:flutter_final_assignment/features/post/domain/entity/post_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/common/components/rounded_button_field.dart';
import '../../../../core/common/components/rounded_input_field.dart';
import '../../../../core/common/widget/semi_big_text.dart';
import '../viewmodel/post_viewmodel.dart';

class Body extends ConsumerStatefulWidget {
  const Body({super.key});

  @override
  ConsumerState<Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {
  checkCameraPermission() async {
    if (await Permission.camera.request().isRestricted ||
        await Permission.camera.request().isDenied) {
      await Permission.camera.request();
    }
  }

  File? _img;
  Future<void> _browseImage(WidgetRef ref, ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image != null) {
        setState(() {
          _img = File(image.path);
          ref.read(postViewModelProvider.notifier).uploadArtPicture(_img!);
        });
      } else {
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  final newArtKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final creatorController = TextEditingController();
  final descriptionController = TextEditingController();
  final bidController = TextEditingController();

  @override
  void initState() {
    titleController.text = '';
    creatorController.text = '';
    descriptionController.text = '';
    bidController.text = '';
    super.initState();
  }

  DateTime? date = DateTime.now();
  DateTime selectedEndingDate = DateTime.now();
  DateTime selectedUpcomingDate = DateTime.now();

  TimeOfDay? selectedTime =
      TimeOfDay.now(); // Add this variable for the selected time

  final List<String> artTypeOptions = ["Recent", "Upcoming"];
  String selectedArtTypeOption = "Upcoming";
  final List<String> artCategoriesOption = [
    "Abstract",
    "Painting",
    "Drawing",
    "Digital",
    "Mixed media"
  ];
  String selectedArtCategory = "Abstract";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    final gap = SizedBox(height: isTablet ? 20.0 : 16.0);

        // Check if the selected art type is "Recent" or "Upcoming"
    bool isRecentArt = selectedArtTypeOption == "Recent";
    bool isUpcomingArt = selectedArtTypeOption == "Upcoming";


    return SingleChildScrollView(
      child: Padding(
        padding: isTablet
            ? EdgeInsets.only(
                top: AppColorConstant.kDefaultPadding,
                bottom: AppColorConstant.kDefaultPadding)
            : EdgeInsets.only(
                top: AppColorConstant.kDefaultPadding,
                bottom: AppColorConstant.kDefaultPadding),
        child: Column(
          children: [
            InkWell(
                onTap: () {
                  showModalBottomSheet(
                    constraints: const BoxConstraints(
                      maxWidth: double.infinity,
                    ),
                    backgroundColor: Colors.grey[700],
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) => Padding(
                      padding: isTablet
                          ? const EdgeInsets.all(22)
                          : const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              checkCameraPermission();
                              _browseImage(ref, ImageSource.camera);
                              Navigator.pop(context);
                              // Upload image it is not null
                            },
                            icon: const Icon(Icons.camera),
                            label: SmallText(
                              text: 'Camera',
                              color: AppColorConstant.whiteTextColor,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              _browseImage(ref, ImageSource.gallery);
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.image),
                            label: SmallText(
                              text: 'Gallery',
                              color: AppColorConstant.whiteTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                  child: SizedBox(
                    height: isTablet ? 500 : 250,
                    width: isTablet ? 500 : 250,
                    child: _img != null
                        ? Image.file(_img!, fit: BoxFit.cover)
                        : Image.asset('assets/images/drawing.jpg',
                            fit: isTablet ? BoxFit.fill : BoxFit.cover),
                  ),
                )),
            isTablet
                ? const SizedBox(
                    height: 0,
                  )
                : gap,
            Form(
              key: newArtKey,
              child: Padding(
                padding: isTablet
                    ? EdgeInsets.all(AppColorConstant.kDefaultPadding)
                    : EdgeInsets.all(AppColorConstant.kDefaultPadding / 2),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SemiBigText(
                      text: "Title",
                      spacing: 0,
                    ),
                    TextFormField(
                    // cursorColor: Colors.black,
                    controller: titleController,
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
                    const SemiBigText(
                      text: "Creator",
                      spacing: 0,
                    ),
                    TextFormField(
                    // cursorColor: Colors.black,
                    controller: creatorController,
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
                    const SemiBigText(
                      text: "Description",
                      spacing: 0,
                    ),
                    // gap,
                    TextFormField(
                    // cursorColor: Colors.black,
                    controller: descriptionController,
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
                    const SemiBigText(
                      text: "Starting Bid",
                      spacing: 0,
                    ),
                    // gap,
                    TextFormField(
                    // cursorColor: Colors.black,
                    controller: bidController,
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
                    const SemiBigText(text: "Art Type"),
                    Container(
                      height: isTablet ? 75 : 65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColorConstant.neutralColor,
                          // width: 1,
                        ),
                      ),
                      child: DropdownButton(
                        padding: EdgeInsets.only(top: isTablet ? 15 : 8),
                        isExpanded: true,
                        underline: gap,
                        value: selectedArtTypeOption,
                        items: artTypeOptions.map((String option) {
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
                            selectedArtTypeOption = newValue.toString();
                          });
                        },
                      ),
                    ),
                    gap,
                    Row(
                      children: [
                        const SemiBigText(
                          text: "Deadline : ",
                          spacing: 0,
                        ),
                        // Show the "Deadline" only for "Recent" art type
                        if (isRecentArt)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColorConstant.primaryAccentColor,
                          ),
                          onPressed: () async {
                            DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: selectedEndingDate,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(3000),
                              builder:
                                  (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData.dark(),
                                  child: child!,
                                );
                              },
                            );
                            if (newDate != null) {
                              // ignore: use_build_context_synchronously
                              TimeOfDay? newTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(
                                    selectedEndingDate),
                                builder:
                                    (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData.dark(),
                                    child: child!,
                                  );
                                },
                              );
                              if (newTime != null) {
                                setState(() {
                                  selectedEndingDate = DateTime(
                                    newDate.year,
                                    newDate.month,
                                    newDate.day,
                                    newTime.hour,
                                    newTime.minute,
                                  );
                                });
                              }
                            }
                          },
                          child: SmallText(
                            text: DateFormat('M/d/y HH:mm', 'en_US')
                                .format(selectedEndingDate.toLocal()),
                            color: AppColorConstant.whiteTextColor,
                          ),
                        ),
                      ],
                    ),
                    gap,
                    Row(
                      children: [
                        const SemiBigText(
                          text: "Upcoming: ",
                          spacing: 0,
                        ),
                        // Show the "Upcoming Date" only for "Upcoming" art type
                        if (isUpcomingArt)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColorConstant.primaryAccentColor,
                          ),
                          onPressed: () async {
                            DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: selectedUpcomingDate,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(3000),
                              builder:
                                  (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData.dark(),
                                  child: child!,
                                );
                              },
                            );
                            if (newDate != null) {
                              // ignore: use_build_context_synchronously
                              TimeOfDay? newTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(
                                    selectedUpcomingDate),
                                builder:
                                    (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData.dark(),
                                    child: child!,
                                  );
                                },
                              );
                              if (newTime != null) {
                                setState(() {
                                  selectedUpcomingDate = DateTime(
                                    newDate.year,
                                    newDate.month,
                                    newDate.day,
                                    newTime.hour,
                                    newTime.minute,
                                  );
                                });
                              }
                            }
                          },
                          child: SmallText(
                            text: DateFormat('M/d/y HH:mm', 'en_US')
                                .format(selectedUpcomingDate.toLocal()),
                            color: AppColorConstant.whiteTextColor,
                          ),
                        ),
                      ],
                    ),
                    gap,
                    const SemiBigText(
                      text: "Art Category",
                      spacing: 0,
                    ),
                    Container(
                      height: isTablet ? 75 : 65,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColorConstant.neutralColor,
                            // width: 1,
                          ),
                        ),
                        child: DropdownButton(
                          padding: EdgeInsets.only(top: isTablet ? 15 : 8),
                          underline: gap,
                          isExpanded: true,
                          value: selectedArtCategory,
                          items: artCategoriesOption.map((String option) {
                            return DropdownMenuItem(
                              value: option,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: isTablet ? 10.0 : 8.0, ),
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: isTablet ? 25 : 20,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedArtCategory = newValue.toString();
                            });
                          },
                        )),
                    gap,
                  ],
                ),
              ),
            ),
            SizedBox(
              width: isTablet ? 700 : 375,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorConstant.primaryAccentColor,
                  padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 30 : 20,
                      vertical: isTablet ? 15 : 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: SemiBigText(
                  text: 'POST NOW',
                  spacing: 0,
                  color: AppColorConstant.whiteTextColor,
                ),
                onPressed: () {
                  if (newArtKey.currentState!.validate()) {
                    // Convert the selectedEndingDate to the device's local timezone
                    DateTime localEndingDate = selectedEndingDate.toLocal();
                    var art = PostEntity(
                      image: ref.read(postViewModelProvider).imageName ?? '',
                      title: titleController.text,
                      creator: creatorController.text,
                      description: descriptionController.text,
                      startingBid: double.tryParse(bidController.text) ?? 0.0,
                      endingDate: localEndingDate,
                      artType: selectedArtTypeOption,
                      upcomingDate: selectedUpcomingDate,
                      categories: selectedArtCategory,
                    );

                    ref
                        .read(postViewModelProvider.notifier)
                        .postArt(context, art);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
