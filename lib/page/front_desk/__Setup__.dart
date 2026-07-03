String HEADER = "Front Desk";

String get PATH {
  String path = HEADER.toLowerCase().replaceAll(" ", "_");
  return "/$path";
}
