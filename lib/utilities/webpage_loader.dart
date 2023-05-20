import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:szc/utilities/constants.dart' as constants;

class WebPageLoader {
  final controller = WebViewController();
  Future<SchoolData> getData(String url) async {
    Completer<SchoolData> completer = Completer<SchoolData>();
    await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    await controller.setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (String url) async {
          await controller.getScrollPosition();
          Object buildId = await controller
              .runJavaScriptReturningResult(constants.buildIdJs);
          Object szcName = await controller
              .runJavaScriptReturningResult(constants.szcNameJs);
          SchoolData sd = SchoolData.all(
              buildId.toString().replaceAll('"', '').trim(),
              szcName.toString().replaceAll('"', '').trim());
          print("### finished (id: ${sd.buildId}, name: ${sd.SZCName})");
          if (!completer.isCompleted) completer.complete(sd);
        },
      ),
    );
    await controller.loadRequest(Uri.parse(url));
    return completer.future;
  }
}

class SchoolData {
  String buildId = "";
  String SZCName = "";

  SchoolData.all(this.buildId, this.SZCName);
  SchoolData.empty();
}

/*
 Object? szcname = await controller.getTitle();
          Object buildId = await controller
              .runJavaScriptReturningResult('self.__NEXT_DATA__.buildId');
          SchoolData sd = SchoolData.all(
              buildId.toString().replaceAll('"', '').trim(),
              szcname.toString().split('|')[1].trim());

 */
