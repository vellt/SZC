import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder_buddy/geocoder_buddy.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:szc/controllers/screen/home_screen_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              title: Text(
                  "${homeScreenController.getCurrentTitle()} ${(homeScreenController.jobList.length == 0) ? "" : "(${homeScreenController.jobList.length})"}"),
            ),
            body: (homeScreenController.isLoading)
                ? Center(
                    child: CircularProgressIndicator(color: Color(0xFF26BDD0)))
                : ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Builder(builder: (context) {
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
                            tilePadding:
                                EdgeInsets.only(top: 5, left: 16, right: 16),
                            title: ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                        homeScreenController
                                            .jobList[index].title,
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
                                            .jobList[index].SZCName,
                                        style: TextStyle(
                                            fontSize: 11.5,
                                            color: Color(0xFF26BDD0)),
                                        maxLines: (homeScreenController
                                                .extendsList[index])
                                            ? null
                                            : 1,
                                        overflow: (homeScreenController
                                                .extendsList[index])
                                            ? null
                                            : TextOverflow.ellipsis),
                                  ],
                                ),
                                minVerticalPadding: 10,
                                trailing: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: IconButton(
                                    onPressed: () async {
                                      await launchUrl(Uri.parse(
                                              homeScreenController
                                                  .jobList[index].website))
                                          .then((value) => (!value)
                                              ? Get.snackbar(
                                                  'Nem lehet megnyitni az oldalt',
                                                  homeScreenController
                                                      .jobList[index].website,
                                                  snackPosition:
                                                      SnackPosition.TOP,
                                                  colorText: Colors.white,
                                                  borderRadius: 10,
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  icon: Icon(
                                                    Icons.language,
                                                    size: 25,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : null);
                                    },
                                    icon: Icon(
                                      Icons.language,
                                      size: 20,
                                      color: Color(0xFF26BDD0),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                )),
                            childrenPadding:
                                EdgeInsets.symmetric(horizontal: 16),
                            collapsedTextColor: Colors.black,
                            textColor: Colors.black,
                            iconColor: Color(0xFF26BDD0),
                            collapsedIconColor: Color(0xFFD9D9D9),
                            backgroundColor: Colors.transparent,
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Wrap(
                                spacing: 18,
                                runSpacing: 8,
                                children: [
                                  Builder(builder: (context) {
                                    var date = DateFormat('yyyy. MM. dd.')
                                        .format(homeScreenController
                                            .jobList[index].date);
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                      onPressed: () async {
                                        String email = Uri.encodeComponent(
                                            homeScreenController
                                                .jobList[index].email);
                                        String subject = Uri.encodeComponent(
                                            "[Jelentkezés] - ${homeScreenController.jobList[index].title}");
                                        String body = Uri.encodeComponent(
                                            "Meghirdetett pozíció: ${homeScreenController.jobList[index].title}"
                                            "\nNév:"
                                            "\nTelefon:"
                                            "\nLegkorábbi kezdés időpontja: "
                                            "\nÜzenet: ");
                                        print(
                                            subject); //output: Hello%20Flutter
                                        Uri mail = Uri.parse(
                                            "mailto:$email?subject=$subject&body=$body");
                                        if (await launchUrl(mail,
                                            mode: LaunchMode
                                                .externalApplication)) {
                                          print("email app opened");
                                        } else {
                                          print("email app is not opened");
                                        }
                                      },
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
                                      onPressed: () {
                                        print(homeScreenController
                                            .jobList[index].schoolName);
                                        Get.bottomSheet(
                                          Material(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  child: SizedBox(
                                                    width: 50,
                                                    child: Divider(
                                                      thickness: 3,
                                                      color: Color(0xFFDBDBDB),
                                                    ),
                                                  ),
                                                ),
                                                ListTile(
                                                  leading: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 3),
                                                    child: Icon(
                                                      CupertinoIcons.map,
                                                      size: 19,
                                                      color: Color(0xFF26BDD0),
                                                    ),
                                                  ),
                                                  title: Text(
                                                      homeScreenController
                                                          .jobList[index]
                                                          .schoolName,
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xFF26BDD0))),
                                                ),
                                                Divider(
                                                  thickness: 1,
                                                  color: Color(0xFFF1F1F1),
                                                ),
                                                ListTile(
                                                  leading: SizedBox(
                                                    width: 25,
                                                    height: 25,
                                                    child: IconButton(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        icon: Icon(
                                                          Icons.copy,
                                                          size: 20,
                                                          color:
                                                              Color(0xFFD3D3D3),
                                                        ),
                                                        onPressed: () {
                                                          FlutterClipboard.copy(
                                                                  homeScreenController
                                                                      .jobList[
                                                                          index]
                                                                      .location)
                                                              .then((value) =>
                                                                  Get.snackbar(
                                                                    'A cím sikeresen másolva',
                                                                    homeScreenController
                                                                        .jobList[
                                                                            index]
                                                                        .location,
                                                                    snackPosition:
                                                                        SnackPosition
                                                                            .TOP,
                                                                    colorText:
                                                                        Colors
                                                                            .white,
                                                                    borderRadius:
                                                                        10,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .greenAccent,
                                                                    icon: Icon(
                                                                      CupertinoIcons
                                                                          .chevron_down_circle,
                                                                      size: 25,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ));
                                                        }),
                                                  ),
                                                  title: Text(
                                                    homeScreenController
                                                        .jobList[index]
                                                        .location,
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.only(
                                                      top: 10,
                                                      left: 15,
                                                      right: 15,
                                                      bottom: 25),
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  12), // <-- Radius
                                                        ),
                                                        backgroundColor:
                                                            Color(0xFF26BDD0),
                                                      ),
                                                      onPressed: () async {
                                                        List<GBSearchData>
                                                            data =
                                                            await GeocoderBuddy.query(
                                                                homeScreenController
                                                                    .jobList[
                                                                        index]
                                                                    .location);

                                                        if (data.length == 0) {
                                                          print(
                                                              "HIBA nem nyitható meg");
                                                          Get.snackbar(
                                                            "Nem sikerült megnyini az alábbi címet:",
                                                            homeScreenController
                                                                .jobList[index]
                                                                .location,
                                                            snackPosition:
                                                                SnackPosition
                                                                    .TOP,
                                                            backgroundColor:
                                                                Colors
                                                                    .redAccent,
                                                            colorText:
                                                                Colors.white,
                                                            borderRadius: 10,
                                                            icon: Icon(
                                                              CupertinoIcons
                                                                  .map,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          );
                                                        } else {
                                                          print(
                                                              "${data[0].lat} ${data[0].lon}");
                                                          Uri googleUrl = Uri.parse(
                                                              'https://www.google.com/maps/search/${homeScreenController.jobList[index].location.replaceAll("/", "-")}/@${data[0].lat},${data[0].lon},100z/');
                                                          if (await launchUrl(
                                                              googleUrl,
                                                              mode: LaunchMode
                                                                  .externalApplication)) {
                                                            print(
                                                                "opening app");
                                                          } else {
                                                            throw 'Could not open the map.';
                                                          }
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(15),
                                                        child: Text(
                                                            "Megnyitás térkében"),
                                                      )),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
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
                                          "Munkavégzés helye",
                                          style: TextStyle(
                                              color: Color(0xFFB1B1B1),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w300),
                                        )
                                      ])),
                                  TextButton(
                                      onPressed: () {
                                        Get.bottomSheet(Container(
                                          color: Colors.white,
                                          height: 200,
                                          child: Text("Csatolt fájlok"),
                                        ));
                                      },
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
