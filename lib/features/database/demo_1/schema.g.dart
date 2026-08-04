Map<String, Map<String, dynamic>> data = {
  "_id": {"type": "id", "title": "ID", "hide": true, "lock": false, "value": null},
  "text_1": {"type": "string", "title": "Text 1", "hide": false, "lock": false, "value": null},
  "text_2": {"type": "string", "title": "Text 2", "hide": false, "lock": false, "value": null},
  "number_1": {"type": "number", "title": "Number 1", "hide": false, "lock": false, "value": null},
  "number_2": {"type": "number", "title": "Number 2", "hide": false, "lock": false, "value": null},
  "datetime_1": {"type": "date-time", "title": "Datetime 1", "hide": false, "lock": false, "value": null},
  "datetime_2": {"type": "date-time", "title": "Datetime 2", "hide": false, "lock": false, "value": null},
  "logic_1": {"type": "boolean", "title": "Logic 1", "hide": false, "lock": false, "value": null},
  "logic_2": {"type": "boolean", "title": "Logic 2", "hide": false, "lock": false, "value": null},
  "note": {"type": "string", "title": "Note", "hide": false, "lock": false, "value": null},
};

final ID = "_id";
final TEXT_1 = "text_1";
final TEXT_2 = "text_2";
final NUMBER_1 = "number_1";
final NUMBER_2 = "number_2";
final DATETIME_1 = "datetime_1";
final DATETIME_2 = "datetime_2";
final LOGIC_1 = "logic_1";
final LOGIC_2 = "logic_2";
final NOTE = "note";

void clear() {
  for (var k in data.keys) data[k]!["value"] = null;
}
