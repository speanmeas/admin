List<Map<String, dynamic>> data = [
  {
    "key": "_id",
    "type": "_id",
    "title": "ID",
    "hide": true
  },
  {
    "key": "room_number",
    "type": "string",
    "title": "Room Number",
    "hide": false
  },
  {
    "key": "room_type",
    "type": "string",
    "title": "Room Type",
    "hide": false
  },
  {
    "key": "room_price_per_day_usd",
    "type": "number",
    "title": "Room Price/Day",
    "hide": false
  },
  {
    "key": "room_price_per_3h_usd",
    "type": "number",
    "title": "Room Price/3H",
    "hide": false
  },
  {
    "key": "room_status",
    "type": "string",
    "title": "Room Status",
    "hide": false
  },
  {
    "key": "room_note",
    "type": "string",
    "title": "Room Note",
    "hide": false
  },
  {
    "key": "front_desk_id",
    "type": "_id",
    "title": "Front Desk ID",
    "hide": false
  }
];

final ID = "_id";
final ROOM_NUMBER = "room_number";
final ROOM_TYPE = "room_type";
final ROOM_PRICE_PER_DAY_USD = "room_price_per_day_usd";
final ROOM_PRICE_PER_3H_USD = "room_price_per_3h_usd";
final ROOM_STATUS = "room_status";
final ROOM_NOTE = "room_note";
final FRONT_DESK_ID = "front_desk_id";


void clear() {for (var s in data) s["value"] = null;}