String HEADER = "Demo 1A";

String get PATH {
  String path = HEADER.toLowerCase().replaceAll(" ", "_");
  return "/$path";
}

String DATE_FORMAT = "yyyy-MM-dd HH:mm";

String get NAME {
  String name = HEADER.toLowerCase().replaceAll(" ", "_");
  return name;
}
