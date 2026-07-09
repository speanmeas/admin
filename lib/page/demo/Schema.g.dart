Map<String, Map<String, dynamic>> data = {
  "_id": {
    "type": "_id",
    "title": "ID",
    "hide": true,
    "value": null
  },
  "demo_text_1": {
    "type": "string",
    "title": "Text 1",
    "hide": false,
    "value": null
  },
  "demo_text_2": {
    "type": "string",
    "title": "Text 2",
    "hide": false,
    "value": null
  },
  "demo_text_3": {
    "type": "string",
    "title": "Text 3",
    "hide": true,
    "value": null
  },
  "demo_number_1": {
    "type": "number",
    "title": "Number 1",
    "hide": false,
    "value": null
  },
  "demo_number_2": {
    "type": "number",
    "title": "Number 2",
    "hide": false,
    "value": null
  },
  "demo_number_3": {
    "type": "number",
    "title": "Number 3",
    "hide": true,
    "value": null
  },
  "demo_datetime_1": {
    "type": "date-time",
    "title": "Datetime 1",
    "hide": false,
    "value": null
  },
  "demo_datetime_2": {
    "type": "date-time",
    "title": "Datetime 2",
    "hide": false,
    "value": null
  },
  "demo_datetime_3": {
    "type": "date-time",
    "title": "Datetime 3",
    "hide": true,
    "value": null
  },
  "demo_boolean_1": {
    "type": "boolean",
    "title": "Boolean 1",
    "hide": false,
    "value": null
  },
  "demo_boolean_2": {
    "type": "boolean",
    "title": "Boolean 2",
    "hide": false,
    "value": null
  },
  "demo_boolean_3": {
    "type": "boolean",
    "title": "Boolean 3",
    "hide": true,
    "value": null
  },
  "demo_note": {
    "type": "string",
    "title": "Note",
    "hide": false,
    "value": null
  }
};

final ID = "_id";
final DEMO_TEXT_1 = "demo_text_1";
final DEMO_TEXT_2 = "demo_text_2";
final DEMO_TEXT_3 = "demo_text_3";
final DEMO_NUMBER_1 = "demo_number_1";
final DEMO_NUMBER_2 = "demo_number_2";
final DEMO_NUMBER_3 = "demo_number_3";
final DEMO_DATETIME_1 = "demo_datetime_1";
final DEMO_DATETIME_2 = "demo_datetime_2";
final DEMO_DATETIME_3 = "demo_datetime_3";
final DEMO_BOOLEAN_1 = "demo_boolean_1";
final DEMO_BOOLEAN_2 = "demo_boolean_2";
final DEMO_BOOLEAN_3 = "demo_boolean_3";
final DEMO_NOTE = "demo_note";


void clear() { for (var k in data.keys) data[k]!["value"] = null; }