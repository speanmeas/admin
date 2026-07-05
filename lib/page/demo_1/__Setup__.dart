String HEADER = "Demo 1";

String get PATH {
  String path = HEADER.toLowerCase().replaceAll(" ", "_");
  return "/$path";
}

String get NAME {
  String name = HEADER.toLowerCase().replaceAll(" ", "_");
  return name;
}

String DATE_FORMAT = "yyyy-MM-dd HH:mm";
