import "package:flutter/material.dart";

Future<DateTime?> dialog_datetime(
  BuildContext context, {
  DateTime? initial, //
}) async {
  DateTime init = DateTime.now();
  if (initial is DateTime) init = initial;

  final DateTime? picked_date = await showDatePicker(
    context: context, //
    initialDate: init, //
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );
  if (picked_date == null) return null;

  TimeOfDay initial_time = TimeOfDay(hour: 0, minute: 0);
  if (initial is DateTime) initial_time = TimeOfDay.fromDateTime(initial);
  final TimeOfDay? picked_time = await showTimePicker(
    context: context, //
    initialTime: initial_time,
  );
  if (picked_time == null) return null;

  return DateTime(
    picked_date.year, //
    picked_date.month,
    picked_date.day,
    picked_time.hour,
    picked_time.minute,
  );
}