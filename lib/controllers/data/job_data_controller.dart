import 'package:szc/models/job.dart';
import 'package:szc/models/job_file.dart';
import 'package:szc/models/school.dart';
import 'package:szc/utilities/networking.dart';

class JobDataController {
  final List<School> _schools = [];
  int selectedSchoolIndex = 0;

  void addSchool(School school) {
    _schools.add(school);
  }

  void removeSchool(School school) {
    _schools.remove(school);
  }

  School? currentSchool() {
    if (_schools.isNotEmpty) {
      return _schools[selectedSchoolIndex];
    } else {
      return null;
    }
  }

  Future<List<Job>> getJobsOfSchool() async {
    List<Job> temp = [];
    if (_schools.isNotEmpty) {
      School seleced = _schools[selectedSchoolIndex];
      String carrierRoute = seleced.careerApiRouteOfSchoolDomainAddress;
      NetworkHelper networkHelper = NetworkHelper(Uri.parse(carrierRoute));

      var response = await networkHelper.getRequest();

      if (response != null) {
        for (var data in response['pageProps']['jobs']) {
          List<JobFile> files = [];
          for (var innerData in data['files']) {
            files.add(JobFile(
              name: innerData['name'],
              ext: innerData['ext'],
              size: innerData['size'],
              url: seleced.mediaDomainAddress + innerData['url'],
            ));
          }
          temp.add(Job(
            id: data['_id'],
            title: data['title'],
            date: DateTime.parse(data['date']),
            createdAt: DateTime.parse(data['createdAt']),
            publishedAt: DateTime.parse(data['published_at']),
            updatedAt: DateTime.parse(data['updatedAt']),
            deadline: data['deadline'],
            email: data['email'],
            employmentType: data['employmentType'],
            location: data['location'],
            shortDescription: data['shortDescription'],
            website: seleced.carrierRouteOfSchoolDomainAddress + data['slug'],
            schoolName: _schools[selectedSchoolIndex].name,
            files: files,
          ));
        }
      }
    }

    return temp;
  }
}
