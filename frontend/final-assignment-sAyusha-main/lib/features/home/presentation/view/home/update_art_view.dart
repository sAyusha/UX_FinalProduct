import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/app_color_constant.dart';
import 'package:flutter_final_assignment/core/common/components/rounded_input_field.dart';
import 'package:flutter_final_assignment/core/common/widget/semi_big_text.dart';
import 'package:flutter_final_assignment/features/home/presentation/viewmodel/home_viewmodel.dart';
import 'package:flutter_final_assignment/features/navbar/presentation/view/bottom_navigation/bottom_navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class UpdateArt extends ConsumerStatefulWidget {
  const UpdateArt({Key? key}) : super(key: key);

  @override
  _UpdateArtState createState() => _UpdateArtState();
}

class _UpdateArtState extends ConsumerState<UpdateArt> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bidController = TextEditingController();
  String? artId;

  @override
  void didChangeDependencies() {
    artId = ModalRoute.of(context)!.settings.arguments as String?;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final artState = ref.watch(homeViewModelProvider);

    if (artState.isLoading) {
      return Scaffold(
        backgroundColor: AppColorConstant.mainSecondaryColor,
        body: Center(
          child: RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: const AlwaysStoppedAnimation(0.0),
                curve: Curves.linear,
              ),
            ),
            child: const CircularProgressIndicator(
              color: AppColorConstant.appBarColor,
              backgroundColor: Colors.grey,
            ),
          ),
        ),
      );
    }

    // Set the initial value for the title field
    titleController.text = artState.arts[0].title;
    bidController.text = artState.arts[0].startingBid.toString();

    return Scaffold(
      backgroundColor: AppColorConstant.mainSecondaryColor,
      appBar: AppBar(
        backgroundColor: AppColorConstant.mainSecondaryColor,
        title: const SemiBigText(
          text: 'Update Art',
        ),
        centerTitle: true,
        leading: IconButton(
          icon: SvgPicture.asset("assets/icons/back.svg"),
          onPressed: () {
            setState(() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ButtomNavView(
                            selectedIndex: 0,
                          )));
            });
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    keyboardType: TextInputType.text,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Update Title...',
                      hintStyle: TextStyle(
                        color: AppColorConstant.blackTextColor,
                      ), 
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
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    // cursorColor: Colors.black,
                    controller: bidController,
                    keyboardType: TextInputType.number,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Update Starting Bid...',
                      hintStyle: TextStyle(
                        color: AppColorConstant.blackTextColor,
                      ), 
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
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final String updatedTitle = titleController.text;
          final String updatedBid = bidController.text;

          // Call the updateArt method from the HomeViewModel
          ref
              .watch(homeViewModelProvider.notifier)
              .updateArt(updatedTitle, updatedBid, artId!);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ButtomNavView(
                        selectedIndex: 0,
                      )));
          ref.read(homeViewModelProvider.notifier).getAllArt();
          ref.read(homeViewModelProvider.notifier).getUserArts();
        },
        backgroundColor: AppColorConstant.successColor,
        foregroundColor: AppColorConstant.whiteTextColor,
        child: const Icon(
          Icons.check,
          size: 25,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
