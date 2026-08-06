const String HEADER = "Nationality";

String get PATH => "/${HEADER.toLowerCase().replaceAll(" ", "_")}";

const String DATE_FORMAT = "EEEE dd-MM-yyyy h:mm a";

const int LIMIT = 1000;

const String KEY = "name";
const int ORDER = 1;
