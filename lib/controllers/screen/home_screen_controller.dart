import 'package:get/get.dart';
import 'package:szc/controllers/data/job_data_controller.dart';
import 'package:szc/models/job.dart';
import 'package:szc/models/school.dart';

class HomeScreenController extends GetxController {
  JobDataController _jobDataController = JobDataController([
    School(
      "DSZC",
      "https://www.dszc.hu/_next/data/v-WydHyHx525vK02lrDwf/karrier.json",
      "https://cms.debreceni.szc.edir.hu",
    ),
    School(
      "berettyoujfaluiszc",
      "https://berettyoujfaluiszc.hu/_next/data/r1JCPBEcCQVOGpyX5HtPz/karrier.json",
      "https://berettyoujfalui-szc.cms.szc.edir.hu",
    ),
  ]);

  List<Job> _JobList = [];

  int changeSelectedSchool(int newIndex) {
    if (newIndex != _jobDataController.indexOfselectedSchool) {
      _jobDataController.indexOfselectedSchool = newIndex;
      _fetchJobs();
      update();
    }
    return newIndex;
  }

  String getCurrentTitle() {
    return _jobDataController.getSelectedSchoolName();
  }

  int switchSelectedSchool() {
    if (_jobDataController.indexOfselectedSchool == 0) {
      _jobDataController.indexOfselectedSchool = 1;
    } else if (_jobDataController.indexOfselectedSchool == 1) {
      _jobDataController.indexOfselectedSchool = 0;
    }
    _fetchJobs();
    update();
    return _jobDataController.indexOfselectedSchool;
  }

  List<Job> get JobList => _JobList;

  void _fetchJobs() async {
    try {
      _JobList = await _jobDataController.getJobsOfSchool();
      print(_JobList);
    } catch (e) {
      print('Hiba történt az adatok betöltése során: $e');
    } finally {
      //isLoading.value = false; // Betöltés befejezése
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    _fetchJobs();
    changeSelectedSchool(1);
  }
}
