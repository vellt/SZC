import 'package:szc/models/job.dart';

class JobFetchingResponse {
  late String SZCName;
  late List<Job> jobs;
  late bool networkStatus;

  JobFetchingResponse.success({required this.SZCName, required this.jobs}) {
    networkStatus = true;
  }
  JobFetchingResponse.error() {
    SZCName = "Hálózati Hiba";
    jobs = [];
    networkStatus = false;
  }
  JobFetchingResponse.empty() {
    SZCName = "Nincs Adat";
    jobs = [];
    networkStatus = true;
  }
}
