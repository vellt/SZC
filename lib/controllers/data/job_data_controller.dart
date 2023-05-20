import 'package:szc/controllers/data/school_data_controller.dart';
import 'package:szc/utilities/webpage_loader.dart';
import 'package:szc/models/job.dart';
import 'package:szc/models/job_file.dart';
import 'package:szc/utilities/networking.dart';
import 'dart:io';
import 'dart:convert';

class JobDataController {
  WebPageLoader loader = WebPageLoader();
  int schoolIndex = 0;
  Future<JobDetails> fetchJobDetails() async {
    List<Job> temp = [];
    String schoolUrl = getNameOfSchool(schoolIndex);

    SchoolData schoolData = await loader.getData(schoolUrl);
    print(schoolData.toString());
    if (schoolData.SZCName != "") {
      print("${schoolUrl}_next/data/${schoolData.buildId}/karrier.json");

      print(">>>>>>>>>>>>>>>1");
      NetworkHelper networkHelper = NetworkHelper(Uri.parse(
          "${schoolUrl}_next/data/${schoolData.buildId}/karrier.json"));
      var response = await networkHelper.getRequest();
      print(">>>>>>>>>>>>>>>2");
      if (response != null) {
        for (var data in response['pageProps']['jobs']) {
          List<JobFile> files = [];
          for (var innerData in data['files']) {
            files.add(JobFile(
              name: innerData['name'],
              ext: innerData['ext'],
              size: innerData['size'],
              url: schoolUrl, //.mediaDomainAddress + innerData['url'],
            ));
          }
          temp.add(Job(
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
            website: "${schoolUrl}karrier/${data['slug']}",
            SZCName: schoolData.SZCName,
            isFavorite: false,
            orderID: temp.length,
            schoolName: data['instituteBody']
                .toString()
                .split('>')[9]
                .replaceAll("</td", "")
                .trim(),
            files: files,
          ));
        }
      }
      print(">>>>>>>>>>>>>>>>3");
      return JobDetails(schoolData.SZCName, temp);
    } else {
      // todo: lekezelni, nincs adat a webhelyről
      throw Error();
    }
  }

  Future<String> execJsCode(String jsCode) async {
    var process = await Process.start('node', ['-e', jsCode]);
    var output = await process.stdout.transform(utf8.decoder).toList();
    var result = output.join();
    return result;
  }
}

class JobDetails {
  String SZCName = "";
  List<Job> jobs = [];
  JobDetails(
    this.SZCName,
    this.jobs,
  );
  JobDetails.empty();
}
