String HEADER = "Nationality";

String get PATH {
  String path = HEADER.toLowerCase().replaceAll(" ", "_");
  return "/$path";
}

String DATE_FORMAT = "yyyy-MM-dd HH:mm";
