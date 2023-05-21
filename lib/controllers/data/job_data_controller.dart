import 'package:szc/controllers/data/school_data_controller.dart';
import 'package:szc/models/responses/job_fetching_response.dart';
import 'package:szc/models/responses/szc_fetching_response.dart';
import 'package:szc/utilities/szc_webpage_loader.dart';
import 'package:szc/models/job.dart';
import 'package:szc/models/job_file.dart';
import 'package:szc/utilities/networking.dart';

class JobDataController {
  SZCWebPageLoader szcLoader = SZCWebPageLoader();
  int schoolIndex = 0;
  Future<JobFetchingResponse> fetchJobDetails() async {
    List<Job> jobs = [];
    // lekérjük az aktuális iskolának a webcímét
    String szcUrl = getNameOfSchool(schoolIndex);
    // http hívással lekérjük az új build it-t
    SZCFetchingResponse szcData = await szcLoader.fetchDataFromURL(szcUrl);
    if (szcData.networkStatus) {
      NetworkHelper networkHelper = NetworkHelper(
          Uri.parse("${szcUrl}_next/data/${szcData.buildId}/karrier.json"));
      var response = await networkHelper.getRequest();
      if (response != null) {
        for (var data in response['pageProps']['jobs']) {
          List<JobFile> files = [];
          for (var innerData in data['files']) {
            files.add(JobFile(
              name: innerData['name'],
              ext: innerData['ext'],
              size: innerData['size'],
              url:
                  "${szcData.backendBaseUrl}${innerData['url']}", //.mediaDomainAddress + ,
            ));
          }
          jobs.add(Job(
            id: data['id'],
            title: data['title'],
            date: DateTime.parse(data['date']),
            createdAt: DateTime.parse(data['createdAt']),
            publishedAt: DateTime.parse(data['published_at']),
            updatedAt: DateTime.parse(data['updatedAt']),
            deadline: data['deadline'],
            email: data['email'],
            employmentType: data['employmentType'].toString().trim(),
            location: data['location'].toString().replaceAll("sz.", "").trim(),
            shortDescription: data['shortDescription'].toString().trim(),
            website: "${szcUrl}karrier/${data['slug']}",
            SZCName: szcData.SZCName,
            isFavorite: false,
            sortID: jobs.length,
            schoolName: data['instituteBody']
                .toString()
                .split('>')[9]
                .replaceAll("</td", "")
                .trim(),
            files: files,
          ));
        }
      }
      print(
          "### JobDataController finished (SZCName: ${szcData.SZCName}, jobs: $jobs)");
      return JobFetchingResponse.success(SZCName: szcData.SZCName, jobs: jobs);
    } else {
      // nincs adat a webhelyről, igy a visszatérési értékeben a status false lesz
      return JobFetchingResponse.error();
    }
  }
}
