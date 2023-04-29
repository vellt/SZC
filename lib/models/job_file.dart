class JobFile {
  late String _name;
  late String _ext;
  late double _size;
  late String _url;

  JobFile(
      {required String name,
      required String ext,
      required double size,
      required String url}) {
    _name = name;
    _ext = ext;
    _size = size;
    _url = url;
  }

  String get url => _url;

  double get size => _size;

  String get ext => _ext;

  String get name => _name;

  @override
  String toString() {
    return ''
        '\n\t\t\tname: $_name'
        '\n\t\t\tnext: $_ext'
        '\n\t\t\tsize: $_size'
        '\n\t\t\turl: $_url';
  }
}
