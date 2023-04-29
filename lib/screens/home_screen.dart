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
            body: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return Theme(
                    data:
                        ThemeData().copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Text(homeScreenController.JobList[index].title),
                      childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                      collapsedTextColor: Colors.black,
                      textColor: Colors.black,
                      backgroundColor: Colors.transparent,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(homeScreenController
                              .JobList[index].shortDescription),
                        ),
                        Divider(),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                homeScreenController.JobList[index].location)),
                        Divider(),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(homeScreenController
                                .JobList[index].employmentType)),
                        Divider(),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                homeScreenController.JobList[index].email)),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(height: 1),
                itemCount: homeScreenController.JobList.length),
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
