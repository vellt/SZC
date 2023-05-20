import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';

class FavoriteDatabase extends GetxController {
  final _jobs = 'jobs';

  Future<void> initStorage() async {
    await GetStorage.init();
  }

  Future addFavorite(String id) async {
    List<dynamic> dataMap = GetStorage().read(_jobs) ?? [];
    dataMap.add(id);
    await GetStorage().write(_jobs, dataMap);
  }

  void setFavorites(List<String> newIDs) async {
    await GetStorage().write(_jobs, newIDs);
  }

  Future removeFavorite(String id) async {
    List<dynamic> dataMap = GetStorage().read(_jobs) ?? [];
    dataMap.remove(id);
    await GetStorage().write(_jobs, dataMap);
  }

  List<dynamic> getFavorites() {
    List<dynamic> dataMap = GetStorage().read(_jobs) ?? [];
    return dataMap;
  }
}
