List<Map<String, dynamic>> data = [
  {"key": "_id", "type": "_id", "title": "ID"},
  {"key": "nationality", "type": "string", "title": "Nationality"},
  {"key": "nationality_note", "type": "string", "title": "Nationality Note"},
];

final _ID = "_id";
final NATIONALITY = "nationality";
final NATIONALITY_NOTE = "nationality_note";

void clear() {
  for (var s in data) s["value"] = null;
}
