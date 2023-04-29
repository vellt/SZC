import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:szc/controllers/screen/home_screen_controller.dart';

class HomeScreen extends StatelessWidget {
  final homeScreenController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(
        init: homeScreenController,
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              title: Text(homeScreenController.getCurrentTitle()),
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: SelectableText(
                homeScreenController.JobList.toString(),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                homeScreenController.switchSelectedSchool();
              },
              child: Icon(CupertinoIcons.arrow_2_circlepath),
            ),
          );
        });
  }
}
