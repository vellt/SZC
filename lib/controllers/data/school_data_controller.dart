final List<String> schools = [
  'https://www.kisvardaiszc.hu/',
  'https://www.nyszc.hu/',
  'https://www.dszc.hu/',
  'https://berettyoujfaluiszc.hu/',
];
int selectedSchool = 0;

String getCurrentSchool() {
  return schools[selectedSchool];
}

String getNameOfSchool(int index) {
  return schools[index];
}
