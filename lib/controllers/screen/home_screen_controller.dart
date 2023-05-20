import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:szc/controllers/data/job_data_controller.dart';
import 'package:szc/models/job.dart';
import 'package:szc/models/response_info.dart';
import 'package:szc/database/favorite_database.dart';

class HomeScreenController extends GetxController {
  final JobDataController _jobDataController = JobDataController();

  JobDetails _jobDetails = JobDetails.empty();

  List<bool> extendsList =
      []; // ahhoz kell ha vált akkor csukva legyenek az extendsbuttionok

  bool isLoading = true;

  int changeSelectedSchool(int newIndex) {
    /*
    if (newIndex != _jobDataController.selectedSchoolIndex) {
      _jobDataController.selectedSchoolIndex = newIndex;
      _fetchJobs();
      update();
    }

     */
    return newIndex;
  }

  String getCurrentTitle() {
    return _jobDetails.SZCName;
  }

  void setExpansionTileValue(int index, bool value) {
    extendsList[index] = value;
    update();
  }

  // pin or unpin a job
  Future<ResponseInfo> switchFavorite(index) async {
    Job job = _jobDetails.jobs[index];
    job.isFavorite = !job.isFavorite;

    if (job.isFavorite) {
      _jobDetails.jobs.removeAt(index);
      List<Job> favoriteJobs =
          _jobDetails.jobs.where((job) => job.isFavorite).toList();
      favoriteJobs.insert(0, job);
      List<Job> orderedJobs = _jobDetails.jobs
          .where((job) => !job.isFavorite)
          .toList()
        ..sort((a, b) => a.orderID.compareTo(b.orderID));
      orderedJobs.insertAll(0, favoriteJobs);
      _jobDetails.jobs = List.from(orderedJobs);
      // adat letárolása a lokális db-be
      Get.find<FavoriteDatabase>().addFavorite(job.id);
      update();
      return ResponseInfo(
          status: true,
          title: "Sikeresen rögzítve:",
          message: job.title,
          foregroundColor: Colors.white,
          backgroundColor: Colors.greenAccent);
    } else {
      _jobDetails.jobs[index].isFavorite = false;
      List<Job> favoriteJobs =
          _jobDetails.jobs.where((job) => job.isFavorite).toList();
      List<Job> orderedJobs = _jobDetails.jobs
          .where((job) => !job.isFavorite)
          .toList()
        ..sort((a, b) => a.orderID.compareTo(b.orderID));
      orderedJobs.insertAll(0, favoriteJobs);
      _jobDetails.jobs = List.from(orderedJobs);
      // adat felszabaditasa a lokális db-ből
      Get.find<FavoriteDatabase>().removeFavorite(job.id);
      update();
      return ResponseInfo(
          status: false,
          title: "Rögzítés megszünteve:",
          message: job.title,
          foregroundColor: Colors.white,
          backgroundColor: Colors.orangeAccent);
    }
  }

  int switchSelectedSchool() {
    _jobDataController.schoolIndex = 1;
    reload();
    /*
    if (_jobDataController.selectedSchoolIndex == 0) {
      _jobDataController.selectedSchoolIndex = 1;
    } else if (_jobDataController.selectedSchoolIndex == 1) {
      _jobDataController.selectedSchoolIndex = 0;
    }
    _fetchJobs();

    update();
    return _jobDataController.selectedSchoolIndex;
 */
    return 1;
  }

  List<Job> get jobList => _jobDetails.jobs;

  Future reload() async {
    try {
      print("@@@@@@@@@@@@@@@@@@@");
      isLoading = true;
      update();
      _jobDetails = JobDetails.empty();
      _jobDetails = await _jobDataController.fetchJobDetails();
      // extendsList=[]; ez lehet hiba később h kiszedtem
      extendsList.assignAll(List.filled(_jobDetails.jobs.length, false));
      _jobDetails.jobs = getPinnedElements(_jobDetails.jobs);
      isLoading = false;
    } catch (e) {
      print("reload hiba: $e");
    } finally {
      update();
    }
  }

  List<Job> getPinnedElements(List<Job> jobsForOrdring) {
    List<dynamic> favs = Get.find<FavoriteDatabase>().getFavorites();
    print("MMMM ${favs.length}");
    for (String favId in favs) {
      for (Job job in _jobDetails.jobs) {
        if (job.id == favId) {
          job.isFavorite = true;
          print(job.title);
        }
      }
    }
    List<Job> favoriteJobs =
        _jobDetails.jobs.where((job) => job.isFavorite).toList();
    List<Job> orderedJobs = _jobDetails.jobs
        .where((job) => !job.isFavorite)
        .toList()
      ..sort((a, b) => a.orderID.compareTo(b.orderID));
    orderedJobs.insertAll(0, favoriteJobs);
    return orderedJobs;
  }

  @override
  void onInit() async {
    super.onInit();
    await reload();
  }
}
