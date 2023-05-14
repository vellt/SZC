import 'package:webview_flutter/webview_flutter.dart';

abstract class WebPageLoader {
  static bool isLoaded = false;
  static Future<SchoolData> getData(String url) async {
    final controller = WebViewController()
      ..loadRequest(Uri.parse(url))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) => isLoaded = true,
      ));
    SchoolData schoolData = SchoolData.empty();
    await Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      if (isLoaded) {
        final buildID = await controller
            .runJavaScriptReturningResult("self.__NEXT_DATA__.buildId");
        final SZCName = await controller.runJavaScriptReturningResult(
            "self.__NEXT_DATA__.props.pageProps.commonData.configData.SZCname");
        schoolData = SchoolData.all(
          buildID.toString().replaceAll('"', "").trim(),
          SZCName.toString().replaceAll('"', "").trim(),
        );
        return false;
      }
      return true;
    });
    controller.clearLocalStorage();
    controller.clearCache();
    return schoolData;
  }
}

class SchoolData {
  String buildId = "";
  String SZCName = "";
  SchoolData.all(this.buildId, this.SZCName);
  SchoolData.empty();
}
