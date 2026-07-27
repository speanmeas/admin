Map<String, Map<String, dynamic>> data = {
  "_id": {
    "type": "id",
    "title": "ID",
    "value": null
  },
  "name": {
    "type": "string",
    "title": "Name",
    "value": null
  },
  "note": {
    "type": "string",
    "title": "Note",
    "value": null
  }
};

final ID = "_id";
final NAME = "name";
final NOTE = "note";


void clear() { for (var k in data.keys) data[k]!["value"] = null; }