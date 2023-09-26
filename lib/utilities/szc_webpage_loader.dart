import 'dart:async';
import 'package:szc/models/responses/szc_fetching_response.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:szc/utilities/constants.dart' as constants;

class SZCWebPageLoader {
  final controller = WebViewController();
  Future<SZCFetchingResponse> fetchDataFromURL(String url) async {
    Completer<SZCFetchingResponse> completer = Completer<SZCFetchingResponse>();
    await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    await controller.setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (String url) async {
          await controller.getScrollPosition();
          Object buildId = await controller
              .runJavaScriptReturningResult(constants.buildIdJs);
          Object szcName = await controller
              .runJavaScriptReturningResult(constants.szcNameJs);
          Object backend = await controller
              .runJavaScriptReturningResult(constants.backendBaseUrlJs);
          await controller.clearCache();
          await controller.clearLocalStorage();
          SZCFetchingResponse sd = (buildId != "")
              ? SZCFetchingResponse.success(
                  buildId: buildId.toString().replaceAll('"', '').trim(),
                  SZCName: szcName.toString().replaceAll('"', '').trim(),
                  backendBaseUrl: backend
                      .toString()
                      .replaceAll('"', '')
                      .replaceAll(".hu/", ".hu")
                      .trim()
                      .split('uploads')[0])
              : SZCFetchingResponse.error();
          print(
              "### SZCWebPageLoader finished (id: ${sd.buildId}, name: ${sd.SZCName}), backend: ${sd.backendBaseUrl}");
          if (!completer.isCompleted) completer.complete(sd);
        },
      ),
    );
    await controller.loadRequest(Uri.parse(url));
    return completer.future;
  }
}

/*
 Object? szcname = await controller.getTitle();
          Object buildId = await controller
              .runJavaScriptReturningResult('self.__NEXT_DATA__.buildId');
          SchoolData sd = SchoolData.all(
              buildId.toString().replaceAll('"', '').trim(),
              szcname.toString().split('|')[1].trim());

 */
