import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkHelper {
  NetworkHelper(this._url);
  final Uri _url;
  Future<dynamic> getRequest() async {
    try {
      http.Response response = await http.get(_url);
      if (response.statusCode == 200) {
        print("### NetworkHelper finished (http response from: $_url)");
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        print(response.statusCode);
        return null;
      }
    } catch (e, s) {
      print("hiba: $s");
      return null;
    }
  }
}
