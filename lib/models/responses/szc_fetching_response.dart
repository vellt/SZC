class SZCFetchingResponse {
  late String buildId;
  late String SZCName;
  late bool networkStatus;

  SZCFetchingResponse.success({required this.buildId, required this.SZCName}) {
    networkStatus = true;
  }

  SZCFetchingResponse.error() {
    buildId = "";
    SZCName = "";
    networkStatus = false;
  }
}
