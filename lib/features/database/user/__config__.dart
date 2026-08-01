String HEADER = "User";

String get PATH => "/${HEADER.toLowerCase().replaceAll(" ", "_")}";

String DATE_FORMAT = "yyyy-MM-dd HH:mm";

int LIMIT = 1000;

String KEY = "created_at";
int ORDER = -1;
