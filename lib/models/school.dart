class School {
  late String _name;
  late String _schoolDomainAddress;
  late String _careerRouteOfSchoolDomainAddress;
  late String _mediaDomainAddress;

  School({
    required String name,
    required String schoolDomainAddress,
    required String careerRouteOfSchoolDomainAddress,
    required String mediaDomainAddress,
  }) {
    _name = name;
    _schoolDomainAddress = schoolDomainAddress;
    _careerRouteOfSchoolDomainAddress = careerRouteOfSchoolDomainAddress;
    _mediaDomainAddress = mediaDomainAddress;
  }

  String get mediaDomainAddress => _mediaDomainAddress;

  String get careerApiRouteOfSchoolDomainAddress =>
      _schoolDomainAddress + _careerRouteOfSchoolDomainAddress;

  String get carrierRouteOfSchoolDomainAddress =>
      _schoolDomainAddress + "/karrier/";

  String get name => _name;
}
