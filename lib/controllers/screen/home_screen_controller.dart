import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:szc/controllers/data/job_data_controller.dart';
import 'package:szc/models/job.dart';
import 'package:szc/models/responses/view_response_info.dart';
import 'package:szc/database/favorite_database.dart';
import 'package:szc/models/responses/job_fetching_response.dart';

class HomeScreenController extends GetxController {
  final JobDataController _jobDataController = JobDataController();

  JobFetchingResponse _fetchedJobData = JobFetchingResponse.empty();

  // ahhoz kell ha vált akkor csukva legyenek az extendsbuttionok
  List<bool> extendsList = [];

  // inidklátorhoz kell
  bool isLoading = true;

  String getCurrentTitle() {
    return _fetchedJobData.SZCName;
  }

  void markTheJobThatHasBeenExtendedOrClosed(int index, bool value) {
    extendsList[index] = value; // true==expanded, false==closed
    update();
  }

  // pin or unpin a job
  Future<ViewResponseInfo> jobPinOrUnpin(index) async {
    Job job = _fetchedJobData.jobs[index];
    job.isFavorite = !job.isFavorite;

    if (job.isFavorite) {
      _fetchedJobData.jobs.removeAt(index);
      List<Job> favoriteJobs =
          _fetchedJobData.jobs.where((job) => job.isFavorite).toList();
      favoriteJobs.insert(0, job);
      List<Job> orderedJobs = _fetchedJobData.jobs
          .where((job) => !job.isFavorite)
          .toList()
        ..sort((a, b) => a.sortID.compareTo(b.sortID));
      orderedJobs.insertAll(0, favoriteJobs);
      _fetchedJobData.jobs = List.from(orderedJobs);
      // adat letárolása a lokális db-be
      Get.find<FavoriteDatabase>().addFavorite(job.id);
      update();
      return ViewResponseInfo(
          status: true,
          title: "Sikeresen rögzítve:",
          message: job.title,
          foregroundColor: Colors.white,
          backgroundColor: Colors.greenAccent);
    } else {
      _fetchedJobData.jobs[index].isFavorite = false;
      List<Job> favoriteJobs =
          _fetchedJobData.jobs.where((job) => job.isFavorite).toList();
      List<Job> orderedJobs = _fetchedJobData.jobs
          .where((job) => !job.isFavorite)
          .toList()
        ..sort((a, b) => a.sortID.compareTo(b.sortID));
      orderedJobs.insertAll(0, favoriteJobs);
      _fetchedJobData.jobs = List.from(orderedJobs);
      // adat felszabaditasa a lokális db-ből
      Get.find<FavoriteDatabase>().removeFavorite(job.id);
      update();
      return ViewResponseInfo(
          status: false,
          title: "Rögzítés megszünteve:",
          message: job.title,
          foregroundColor: Colors.white,
          backgroundColor: Colors.orangeAccent);
    }
  }

  // vált a két szc között
  int switchSelectedSchool() {
    if (_jobDataController.schoolIndex == 0) {
      _jobDataController.schoolIndex = 1;
    } else if (_jobDataController.schoolIndex == 1) {
      _jobDataController.schoolIndex = 0;
    }
    reload();
    return _jobDataController.schoolIndex;
  }

  // visszadja az aktuális job listát
  List<Job> get jobList => _fetchedJobData.jobs;

  // egy adat lekérését végzi, kell majd egy olyan mi az összes a listában lévő iskola adatát összue gyűjti
  Future<ViewResponseInfo> reload() async {
    isLoading = true;
    update();
    _fetchedJobData = JobFetchingResponse.empty();
    _fetchedJobData = await _jobDataController.fetchJobDetails();
    extendsList.assignAll(List.filled(_fetchedJobData.jobs.length, false));
    _fetchedJobData.jobs = getPinnedElements(_fetchedJobData.jobs);
    isLoading = false;
    update();
    return (_fetchedJobData.networkStatus)
        ? ViewResponseInfo(
            status: true,
            title: 'Az adatok sikeresen élekérve',
            message: 'További teendője nincs',
            foregroundColor: Colors.white,
            backgroundColor: Colors.greenAccent,
          )
        : ViewResponseInfo(
            status: false,
            title: 'Sikertelen adatlekérés',
            message:
                'Kérem ellenőrízze az internetkapcsolatát, majd próbálja újra',
            foregroundColor: Colors.white,
            backgroundColor: Colors.redAccent);
  }

  // visszadja hogy az adott szc-ben milyen pinned job-jaid vannak
  List<Job> getPinnedElements(List<Job> jobs) {
    List<dynamic> favs = Get.find<FavoriteDatabase>().getFavorites();
    for (String favId in favs) {
      for (Job job in jobs) {
        if (job.id == favId) {
          job.isFavorite = true;
          print(job.title);
        }
      }
    }
    List<Job> favoriteJobs = jobs.where((job) => job.isFavorite).toList();
    List<Job> sortedJobDataList = jobs.where((job) => !job.isFavorite).toList()
      ..sort((a, b) => a.sortID.compareTo(b.sortID));
    sortedJobDataList.insertAll(0, favoriteJobs);
    return sortedJobDataList;
  }

  @override
  void onInit() async {
    super.onInit();
    await reload();
  }
}
