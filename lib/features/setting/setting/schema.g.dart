Map<String, Map<String, dynamic>> data = {
  "_id": {
    "type": "id",
    "title": "ID",
    "hide": true,
    "lock": false,
    "value": null
  },
  "key": {
    "type": "string",
    "title": "Key",
    "hide": false,
    "lock": false,
    "value": null
  },
  "note": {
    "type": "string",
    "title": "Value",
    "hide": false,
    "lock": false,
    "value": null
  }
};

final ID = "_id";
final KEY = "key";
final NOTE = "note";

void clear() { for (var k in data.keys) data[k]!["value"] = null; }