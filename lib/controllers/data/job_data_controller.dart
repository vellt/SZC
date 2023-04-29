import 'package:szc/models/job.dart';
import 'package:szc/models/job_file.dart';
import 'package:szc/models/school.dart';
import 'package:szc/utilities/networking.dart';

class JobDataController {
  List<School> _schools;
  int _indexOfselectedSchool = 0;

  JobDataController(this._schools);

  int get indexOfselectedSchool => _indexOfselectedSchool;

  set indexOfselectedSchool(int value) {
    _indexOfselectedSchool = value;
  }

  String getSelectedSchoolName() {
    return _schools[_indexOfselectedSchool].name;
  }

  Future<List<Job>> getJobsOfSchool() async {
    List<Job> temp = [];
    String carrierRoute = _schools[_indexOfselectedSchool].careerRoute;
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
            url: _schools[_indexOfselectedSchool].localFilesRoute +
                innerData['url'],
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
          files: files,
        ));
      }
    }
    return temp;
  }
}
