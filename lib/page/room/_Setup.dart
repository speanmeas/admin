String HEADER = "Room";

String get PATH {
  String path = HEADER.toLowerCase().replaceAll(" ", "_");
  return "/$path";
}

String DATE_FORMAT = "yyyy-MM-dd HH:mm";
int ROW_LIMIT = 10000;
