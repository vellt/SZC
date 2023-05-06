import 'package:szc/models/job_file.dart';

class Job {
  late String
      _id; // ezeket mentem le lokálisan, ha egy újat betölt, akkor értesítést kuld
  late String _title;
  late DateTime _date;
  late DateTime _publishedAt;
  late DateTime _createdAt;
  late DateTime _updatedAt;
  late String _deadline;
  late String _employmentType;
  late String _shortDescription;
  late String _email;
  late String _location;
  late List<JobFile> _files = [];
  late String _website;
  late String _SZCName;
  late String _schoolName;

  Job({
    required String id,
    required String title,
    required DateTime date,
    required DateTime publishedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String deadline,
    required String employmentType,
    required String shortDescription,
    required String email,
    required String location,
    required List<JobFile> files,
    required String website,
    required String SZCName,
    required String schoolName,
  }) {
    _id = id;
    _title = title;
    _date = date;
    _publishedAt = publishedAt;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deadline = deadline;
    _employmentType = employmentType;
    _shortDescription = shortDescription;
    _email = email;
    _location = location;
    _files = files;
    _website = website;
    _SZCName = SZCName;
    _schoolName = schoolName;
  }

  String get id => _id;

  List<JobFile> get files => _files;

  String get location => _location;

  String get email => _email;

  String get shortDescription => _shortDescription;

  String get employmentType => _employmentType;

  String get deadline => _deadline;

  DateTime get date => _date;

  DateTime get createdAt => _createdAt;

  DateTime get updatedAt => _updatedAt;

  DateTime get publishedAt => _publishedAt;

  String get title => _title;

  String get website => _website;

  String get SZCName => _SZCName;

  String get schoolName => _schoolName;

  @override
  String toString() {
    return '\n\t{'
        '\n\t\tid: $_id'
        '\n\t\ttitle: $_title'
        '\n\t\tdate: ${date.year}. ${date.month}. ${date.day}.'
        '\n\t\tpublishedAt: $_publishedAt'
        '\n\t\tcreatedAt: $_createdAt'
        '\n\t\tupdatedAt: $_updatedAt'
        '\n\t\tdeadline: $_deadline'
        '\n\t\temploymentType: $_employmentType'
        '\n\t\tshortDescription: $_shortDescription'
        '\n\t\temail: $_email'
        '\n\t\tlocation: $_location'
        '\n\t\twebsite: $_website'
        '\n\t\tSZCName: $_SZCName'
        '\n\t\tschoolName: $_schoolName'
        '\n\t\tfiles: ${_files.toString()}'
        '\n\t}';
  }
}
