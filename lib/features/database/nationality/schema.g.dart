Map<String, Map<String, dynamic>> data = {
  "_id": {
    "type": "id",
    "title": "ID",
    "hide": true,
    "lock": false,
    "value": null
  },
  "name": {
    "type": "string",
    "title": "Name",
    "hide": false,
    "lock": false,
    "value": null
  },
  "note": {
    "type": "string",
    "title": "Note",
    "hide": false,
    "lock": false,
    "value": null
  }
};

final ID = "_id";
final NAME = "name";
final NOTE = "note";

void clear() { for (var k in data.keys) data[k]!["value"] = null; }