Map<String, Map<String, dynamic>> data = {
  "_id": {
    "type": "_id",
    "title": "ID",
    "hide": true,
    "value": null
  },
  "number": {
    "type": "string",
    "title": "Number",
    "value": null
  },
  "kind": {
    "type": "string",
    "title": "Kind",
    "value": null
  },
  "usd_per_day": {
    "type": "number",
    "title": "USD/Day",
    "value": null
  },
  "usd_per_3h": {
    "type": "number",
    "title": "USD/3H",
    "value": null
  },
  "status": {
    "type": "string",
    "title": "Status",
    "value": null
  },
  "note": {
    "type": "string",
    "title": "Note",
    "value": null
  }
};

final ID = "_id";
final NUMBER = "number";
final KIND = "kind";
final USD_PER_DAY = "usd_per_day";
final USD_PER_3H = "usd_per_3h";
final STATUS = "status";
final NOTE = "note";


void clear() { for (var k in data.keys) data[k]!["value"] = null; }