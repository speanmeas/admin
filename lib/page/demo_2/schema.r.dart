Map<String, Map<String, dynamic>> data = {
  "_id": {
    "type": "id",
    "title": "ID",
    "hide": true,
    "value": null
  },
  "text_1": {
    "type": "string",
    "title": "Text 1",
    "hide": false,
    "value": null
  },
  "number_1": {
    "type": "number",
    "title": "Number 1",
    "hide": false,
    "value": null
  },
  "datetime_1": {
    "type": "date-time",
    "title": "Datetime 1",
    "hide": false,
    "value": null
  },
  "logic_1": {
    "type": "boolean",
    "title": "Logic 1",
    "hide": false,
    "value": null
  },
  "note": {
    "type": "string",
    "title": "Note",
    "hide": false,
    "value": null
  },
  "nationality_id": {
    "type": "id",
    "title": "Nationality ID",
    "hide": true,
    "value": null
  },
  "nationality_name": {
    "type": "string",
    "title": "Nationality",
    "hide": false,
    "value": null
  }
};

final ID = "_id";
final TEXT_1 = "text_1";
final NUMBER_1 = "number_1";
final DATETIME_1 = "datetime_1";
final LOGIC_1 = "logic_1";
final NOTE = "note";
final NATIONALITY_ID = "nationality_id";
final NATIONALITY_NAME = "nationality_name";


void clear() { for (var k in data.keys) data[k]!["value"] = null; }