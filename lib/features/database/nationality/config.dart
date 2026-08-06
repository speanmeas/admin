const String HEADER = "Nationality";

String get PATH => "/${HEADER.toLowerCase().replaceAll(" ", "_")}";

String DATE_FORMAT = "EEEE dd-MM-yyyy h:mm a";

int LIMIT = 1000;

String KEY = "name";
int ORDER = 1;
