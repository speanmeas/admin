Map<String, Map<String, dynamic>> data = {
  "_id": {
    "type": "id",
    "title": "ID",
    "hide": true,
    "lock": false,
    "value": null
  },
  "number": {
    "type": "string",
    "title": "Number",
    "hide": false,
    "lock": false,
    "value": null
  },
  "usd_per_day": {
    "type": "number",
    "title": "USD/Day",
    "hide": false,
    "lock": false,
    "value": null
  },
  "usd_per_3h": {
    "type": "number",
    "title": "USD/3H",
    "hide": false,
    "lock": false,
    "value": null
  },
  "kind": {
    "type": "string",
    "title": "Kind",
    "hide": false,
    "lock": false,
    "value": null
  },
  "status": {
    "type": "string",
    "title": "Status",
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
  },
  "front_desk_id": {
    "type": "id",
    "title": "Front Desk ID",
    "hide": true,
    "lock": false,
    "value": null
  }
};

final ID = "_id";
final NUMBER = "number";
final USD_PER_DAY = "usd_per_day";
final USD_PER_3H = "usd_per_3h";
final KIND = "kind";
final STATUS = "status";
final NOTE = "note";
final FRONT_DESK_ID = "front_desk_id";

void clear() { for (var k in data.keys) data[k]!["value"] = null; }