String? datetime_to_string(DateTime? datetime) {
  if (datetime == null) return null;

  final year = datetime.year.toString().padLeft(4, '0'); // year
  final month = datetime.month.toString().padLeft(2, '0'); // month
  final day = datetime.day.toString().padLeft(2, '0'); // day
  final hour = datetime.hour.toString().padLeft(2, '0'); // hour
  final minute = datetime.minute.toString().padLeft(2, '0'); // minute
  final second = datetime.second.toString().padLeft(2, '0'); // second

  return "$year-$month-$day $hour:$minute:$second";
}

DateTime? string_to_datetime(String? datetime) {
  if (datetime == null) return null;

  final year = datetime.substring(0, 4);
  final month = datetime.substring(5, 7);
  final day = datetime.substring(8, 10);
  final hour = datetime.substring(11, 13);
  final minute = datetime.substring(14, 16);
  final second = datetime.substring(17, 19);

  return DateTime(
    int.parse(year), // year
    int.parse(month), // month
    int.parse(day), // day
    int.parse(hour), // hour
    int.parse(minute), // minute
    int.parse(second), // second
  );
}

void main() {
  print(datetime_to_string(DateTime.now()));
  print(string_to_datetime(datetime_to_string(DateTime.now())));
}
