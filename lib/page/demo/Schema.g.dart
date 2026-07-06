List<Map<String, dynamic>> data = [
  {
    "key": "_id",
    "type": "_id",
    "title": "ID"
  },
  {
    "key": "demo_text_1",
    "type": "string",
    "title": "Text 1"
  },
  {
    "key": "demo_text_2",
    "type": "string",
    "title": "Text 2"
  },
  {
    "key": "demo_number_1",
    "type": "number",
    "title": "Number 1"
  },
  {
    "key": "demo_number_2",
    "type": "number",
    "title": "Number 2"
  },
  {
    "key": "demo_datetime_1",
    "type": "date-time",
    "title": "Datetime 1"
  },
  {
    "key": "demo_datetime_2",
    "type": "date-time",
    "title": "Datetime 2"
  },
  {
    "key": "demo_boolean_1",
    "type": "boolean",
    "title": "Boolean 1"
  },
  {
    "key": "demo_boolean_2",
    "type": "boolean",
    "title": "Boolean 2"
  },
  {
    "key": "demo_note",
    "type": "string",
    "title": "Note"
  },
  {
    "key": "demo_1a_id",
    "type": "_id",
    "title": "Demo 1A ID"
  },
  {
    "key": "demo_1b_id",
    "type": "_id",
    "title": "Demo 1B ID"
  }
];

final ID = "_id";
final DEMO_TEXT_1 = "demo_text_1";
final DEMO_TEXT_2 = "demo_text_2";
final DEMO_NUMBER_1 = "demo_number_1";
final DEMO_NUMBER_2 = "demo_number_2";
final DEMO_DATETIME_1 = "demo_datetime_1";
final DEMO_DATETIME_2 = "demo_datetime_2";
final DEMO_BOOLEAN_1 = "demo_boolean_1";
final DEMO_BOOLEAN_2 = "demo_boolean_2";
final DEMO_NOTE = "demo_note";
final DEMO_1A_ID = "demo_1a_id";
final DEMO_1B_ID = "demo_1b_id";


void clear() {for (var s in data) s["value"] = null;}