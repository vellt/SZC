import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:szc/controllers/screen/home_screen_controller.dart';

class HomeScreen extends StatelessWidget {
  final homeScreenController = Get.put(HomeScreenController());

  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(
        init: homeScreenController,
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF26BDD0),
              title: Text(homeScreenController.getCurrentTitle()),
            ),
            body: ListView.separated(
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Builder(builder: (context) {
                    print(homeScreenController.closeAll.value);
                    return Theme(
                      data: ThemeData()
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        initiallyExpanded:
                            homeScreenController.extendsList[index],
                        onExpansionChanged: (bool value) {
                          homeScreenController.extendsList[index] = value;
                          homeScreenController.update();
                        },
                        tilePadding: EdgeInsets.only(
                            top: 5, left: 16, right: 16, bottom: 10),
                        title: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Text(homeScreenController.jobList[index].title,
                                    maxLines: (homeScreenController
                                            .extendsList[index])
                                        ? null
                                        : 1,
                                    overflow: (homeScreenController
                                            .extendsList[index])
                                        ? null
                                        : TextOverflow.ellipsis),
                                SizedBox(height: 5),
                                Text(
                                    homeScreenController
                                        .jobList[index].schoolName,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 11.5,
                                        color: Color(0xFF26BDD0)),
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ),
                            trailing: SizedBox(
                              height: 20,
                              width: 20,
                              child: IconButton(
                                onPressed: () {
                                  print(homeScreenController
                                      .jobList[index].website);
                                },
                                icon: Icon(
                                  Icons.language,
                                  size: 20,
                                  color: Color(0xFF26BDD0),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                            )),
                        childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                        collapsedTextColor: Colors.black,
                        textColor: Colors.black,
                        iconColor: Color(0xFF26BDD0),
                        collapsedIconColor: Color(0xFFD9D9D9),
                        backgroundColor: Colors.transparent,
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Wrap(
                            spacing: 18,
                            runSpacing: 8,
                            children: [
                              Builder(builder: (context) {
                                var date = DateFormat('yyyy. MM. dd.').format(
                                    homeScreenController.jobList[index].date);
                                return Text(
                                  "📅  $date",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300),
                                );
                              }),
                              Builder(builder: (context) {
                                var type = homeScreenController
                                    .jobList[index].employmentType;
                                return Text("💼  $type",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300));
                              }),
                              Builder(builder: (context) {
                                var deadline = homeScreenController
                                    .jobList[index].deadline;
                                return Text("⏳  $deadline",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300));
                              }),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            homeScreenController
                                .jobList[index].shortDescription,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w300),
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                  onPressed: () {},
                                  child: Column(children: [
                                    Icon(
                                      CupertinoIcons.mail,
                                      color: Color(0xFF26BDD0),
                                      size: 20,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Jelentkezés",
                                      style: TextStyle(
                                          color: Color(0xFFB1B1B1),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w300),
                                    )
                                  ])),
                              TextButton(
                                  onPressed: () {},
                                  child: Column(children: [
                                    Icon(
                                      CupertinoIcons.map,
                                      color: Color(0xFF26BDD0),
                                      size: 20,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Iskola címe",
                                      style: TextStyle(
                                          color: Color(0xFFB1B1B1),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w300),
                                    )
                                  ])),
                              TextButton(
                                  onPressed: () {},
                                  child: Column(children: [
                                    Icon(
                                      CupertinoIcons.folder_open,
                                      color: Color(0xFF26BDD0),
                                      size: 20,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Csatolt fájlok",
                                      style: TextStyle(
                                          color: Color(0xFFB1B1B1),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w300),
                                    )
                                  ]))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    );
                  });
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(height: 1),
                itemCount: homeScreenController.jobList.length),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Color(0xFF26BDD0),
              onPressed: () {
                homeScreenController.switchSelectedSchool();
              },
              child: Icon(CupertinoIcons.arrow_2_circlepath),
            ),
          );
        });
  }
}
