import 'package:get_storage/get_storage.dart';

class FavoriteRepository {
  static final _boxName = 'szc';
  static final _dataKey = 'jobs';

  static final _dataBox = GetStorage(_boxName);

  static Future addFavorite(String id) async {
    List<dynamic> dataMap = _dataBox.read(_dataKey) ?? [];
    dataMap.add(id);
    await _dataBox.write(_dataKey, dataMap);
  }

  static Future setFavorites(List<String> newIDs) async {
    await _dataBox.write(_dataKey, newIDs);
  }

  static Future removeFavorite(String id) async {
    List<dynamic> dataMap = _dataBox.read(_dataKey) ?? [];
    dataMap.remove(id);
    await _dataBox.write(_dataKey, dataMap);
  }

  static List<dynamic> getFavorites() {
    List<dynamic> dataMap = _dataBox.read(_dataKey) ?? [];
    return dataMap;
  }
}
