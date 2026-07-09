Map<String, Map<String, dynamic>> data = {
  "_id": {
    "type": "_id",
    "title": "ID",
    "hide": true,
    "value": null
  },
  "room_number": {
    "type": "string",
    "title": "Number",
    "hide": false,
    "value": null
  },
  "room_type": {
    "type": "string",
    "title": "Type",
    "hide": false,
    "value": null
  },
  "room_price_per_day_usd": {
    "type": "number",
    "title": "Price/Day",
    "hide": false,
    "value": null
  },
  "room_price_per_3h_usd": {
    "type": "number",
    "title": "Price/3H",
    "hide": false,
    "value": null
  },
  "room_status": {
    "type": "string",
    "title": "Status",
    "hide": false,
    "value": null
  },
  "room_note": {
    "type": "string",
    "title": "Note",
    "hide": false,
    "value": null
  },
  "front_desk_id": {
    "type": "_id",
    "title": "Front Desk ID",
    "hide": true,
    "value": null
  }
};

final ID = "_id";
final ROOM_NUMBER = "room_number";
final ROOM_TYPE = "room_type";
final ROOM_PRICE_PER_DAY_USD = "room_price_per_day_usd";
final ROOM_PRICE_PER_3H_USD = "room_price_per_3h_usd";
final ROOM_STATUS = "room_status";
final ROOM_NOTE = "room_note";
final FRONT_DESK_ID = "front_desk_id";


void clear() { for (var k in data.keys) data[k]!["value"] = null; }