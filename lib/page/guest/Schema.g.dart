Map<String, Map<String, dynamic>> data = {
  "_id": {
    "type": "_id",
    "title": "ID",
    "hide": true,
    "value": null
  },
  "guest_name": {
    "type": "string",
    "title": "Name",
    "hide": false,
    "value": null
  },
  "guest_phone": {
    "type": "string",
    "title": "Phone Number",
    "hide": false,
    "value": null
  },
  "guest_gender": {
    "type": "string",
    "title": "Gender",
    "hide": false,
    "value": null
  },
  "guest_nationality": {
    "type": "string",
    "title": "Nationality",
    "hide": false,
    "value": null
  },
  "guest_note": {
    "type": "string",
    "title": "Note",
    "hide": false,
    "value": null
  }
};

final ID = "_id";
final GUEST_NAME = "guest_name";
final GUEST_PHONE = "guest_phone";
final GUEST_GENDER = "guest_gender";
final GUEST_NATIONALITY = "guest_nationality";
final GUEST_NOTE = "guest_note";


void clear() { for (var k in data.keys) data[k]!["value"] = null; }