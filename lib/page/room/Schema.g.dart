List<Map<String, dynamic>> data = [
  {"key": "_id", "type": "_id", "title": "ID"},
  {"key": "room_number", "type": "string", "title": "Room Number"},
  {"key": "room_type", "type": "string", "title": "Room Type"},
  {"key": "room_price_per_day_usd", "type": "number", "title": "Room Price/Day"},
  {"key": "room_price_per_3h_usd", "type": "number", "title": "Room Price/3H"},
  {"key": "room_status", "type": "string", "title": "Room Status"},
  {"key": "room_note", "type": "string", "title": "Room Note"},
];

final ID = "_id";
final ROOM_NUMBER = "room_number";
final ROOM_TYPE = "room_type";
final ROOM_PRICE_PER_DAY_USD = "room_price_per_day_usd";
final ROOM_PRICE_PER_3H_USD = "room_price_per_3h_usd";
final ROOM_STATUS = "room_status";
final ROOM_NOTE = "room_note";

void clear() {
  for (var s in data) s["value"] = null;
}
