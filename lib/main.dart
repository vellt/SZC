import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:szc/database/favorite_database.dart';
import 'package:szc/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.put(FavoriteDatabase()).initStorage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: HomeScreen(),
    );
  }
}
