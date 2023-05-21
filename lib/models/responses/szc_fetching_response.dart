class SZCFetchingResponse {
  late String buildId;
  late String SZCName;
  late String backendBaseUrl;
  late bool networkStatus;

  SZCFetchingResponse.success(
      {required this.buildId,
      required this.SZCName,
      required this.backendBaseUrl}) {
    networkStatus = true;
  }

  SZCFetchingResponse.error() {
    buildId = "";
    SZCName = "";
    networkStatus = false;
  }
}
