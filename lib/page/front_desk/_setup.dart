String HEADER = "Front Desk";

String get PATH => "/${HEADER.toLowerCase().replaceAll(" ", "_")}";

String DATE_FORMAT = "yyyy-MM-dd HH:mm";
int ROW_LIMIT = 10000;
