const String HEADER = "Front Desk";

String get PATH => "/${HEADER.toLowerCase().replaceAll(" ", "_")}";

const String DATE_FORMAT = "EEEE dd-MM-yyyy h:mm a";

const int LIMIT = 1000;

const String KEY = "created_at";
const int ORDER = -1;
