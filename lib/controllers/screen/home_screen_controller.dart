import 'package:get/get.dart';
import 'package:szc/controllers/data/job_data_controller.dart';
import 'package:szc/models/job.dart';
import 'package:szc/models/school.dart';

class HomeScreenController extends GetxController {
  JobDataController _jobDataController = JobDataController();

  List<Job> _jobList = [];

  List<bool> extendsList = [];

  bool isLoading = true;

  int changeSelectedSchool(int newIndex) {
    if (newIndex != _jobDataController.selectedSchoolIndex) {
      _jobDataController.selectedSchoolIndex = newIndex;
      _fetchJobs();
      update();
    }
    return newIndex;
  }

  String getCurrentTitle() {
    return _jobDataController.currentSchool()?.name ?? "";
  }

  int switchSelectedSchool() {
    if (_jobDataController.selectedSchoolIndex == 0) {
      _jobDataController.selectedSchoolIndex = 1;
    } else if (_jobDataController.selectedSchoolIndex == 1) {
      _jobDataController.selectedSchoolIndex = 0;
    }
    _fetchJobs();

    update();
    return _jobDataController.selectedSchoolIndex;
  }

  List<Job> get jobList => _jobList;

  Future _fetchJobs() async {
    isLoading = true;
    try {
      _jobList = [];
      _jobList = await _jobDataController.getJobsOfSchool();
      extendsList = [];
      extendsList.assignAll(List.filled(_jobList.length, false));
      print(extendsList.toString());
    } catch (e) {
      print('Hiba történt az adatok betöltése során: $e');
    } finally {
      isLoading = false;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    _jobDataController.addSchool(
      School(
        name: "Debreceni SZC",
        schoolDomainAddress: "https://www.dszc.hu",
        careerRouteOfSchoolDomainAddress:
            "/_next/data/v-WydHyHx525vK02lrDwf/karrier.json",
        mediaDomainAddress: "https://cms.debreceni.szc.edir.hu",
      ),
    );
    _jobDataController.addSchool(
      School(
        name: "Berettyoujfalui SZC",
        schoolDomainAddress: "https://berettyoujfaluiszc.hu",
        careerRouteOfSchoolDomainAddress:
            "/_next/data/r1JCPBEcCQVOGpyX5HtPz/karrier.json",
        mediaDomainAddress: "https://berettyoujfalui-szc.cms.szc.edir.hu",
      ),
    );
    _fetchJobs();
  }
}
