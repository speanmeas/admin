List<Map<String, dynamic>> data = [
  {
    "key": "_id",
    "type": "_id",
    "title": "ID",
    "hide": true
  },
  {
    "key": "guest_name",
    "type": "string",
    "title": "Guest Name",
    "hide": false
  },
  {
    "key": "guest_phone",
    "type": "string",
    "title": "Guest Phone Number",
    "hide": false
  },
  {
    "key": "guest_gender",
    "type": "string",
    "title": "Guest Gender",
    "hide": false
  },
  {
    "key": "guest_nationality",
    "type": "string",
    "title": "Guest Nationality",
    "hide": false
  },
  {
    "key": "guest_note",
    "type": "string",
    "title": "Guest Note",
    "hide": false
  }
];

final ID = "_id";
final GUEST_NAME = "guest_name";
final GUEST_PHONE = "guest_phone";
final GUEST_GENDER = "guest_gender";
final GUEST_NATIONALITY = "guest_nationality";
final GUEST_NOTE = "guest_note";


void clear() {for (var s in data) s["value"] = null;}