import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:szc/controllers/data/job_data_controller.dart';
import 'package:szc/models/job.dart';
import 'package:szc/models/response_info.dart';
import 'package:szc/repositories/favorite_repository.dart';

class HomeScreenController extends GetxController {
  JobDataController _jobDataController = JobDataController();

  JobDetails _jobDetails = JobDetails.empty();

  List<bool> extendsList = [];

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
      await FavoriteRepository.addFavorite(job.id);
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
      await FavoriteRepository.removeFavorite(job.id);
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

  Future _fetchJobs() async {
    isLoading = true;
    try {
      _jobDetails = JobDetails.empty();
      _jobDetails = await _jobDataController.fetchJobs();
      extendsList = [];
      extendsList.assignAll(List.filled(_jobDetails.jobs.length, false));
      List<dynamic> favs = FavoriteRepository.getFavorites();
      for (String id in favs) {
        for (Job job in _jobDetails.jobs) {
          if (job.id == id) {
            job.isFavorite = true;
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
      _jobDetails.jobs = List.from(orderedJobs);
      update();
    } catch (e) {
      print('Hiba történt az adatok betöltése során: $e');
    } finally {
      isLoading = false;
      update();
    }
  }

  @override
  void onInit() async {
    super.onInit();
    /*
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
    await _fetchJobs();

     */
    await _fetchJobs();
  }
}
