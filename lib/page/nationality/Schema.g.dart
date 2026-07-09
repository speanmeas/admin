Map<String, Map<String, dynamic>> data = {
  "_id": {
    "type": "_id",
    "title": "ID",
    "hide": true,
    "value": null
  },
  "nationality": {
    "type": "string",
    "title": "Nationality",
    "hide": false,
    "value": null
  },
  "nationality_note": {
    "type": "string",
    "title": "Note",
    "hide": false,
    "value": null
  }
};

final ID = "_id";
final NATIONALITY = "nationality";
final NATIONALITY_NOTE = "nationality_note";


void clear() { for (var k in data.keys) data[k]!["value"] = null; }