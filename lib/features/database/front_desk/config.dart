String HEADER = "Front Desk";

String get PATH => "/${HEADER.toLowerCase().replaceAll(" ", "_")}";

final DATE_FORMAT = "EEEE dd-MM-yyyy h:mm a";

int LIMIT = 1000;

String KEY = "created_at";
int ORDER = -1;
