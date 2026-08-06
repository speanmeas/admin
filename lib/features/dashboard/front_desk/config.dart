final HEADER = "Front Desk";

String get PATH => "/${HEADER.toLowerCase().replaceAll(" ", "_")}";

// final DATE_FORMAT = "yyyy-MM-dd HH:mm";
String DATE_FORMAT = "EEEE dd-MM-yyyy h:mm a";

final OPTION_NUM_GUESTS = List.generate(10, (index) => (index + 1));
final OPTION_DAYS = List.generate(31, (index) => index);
final OPTION_HOURS = [0, 3, 6, 9, 12];
