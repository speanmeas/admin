Map<String, Map<String, dynamic>> data = {
  "_id": {
    "type": "id",
    "title": "ID",
    "hide": true,
    "value": null
  },
  "full_name": {
    "type": "string",
    "title": "Name",
    "hide": false,
    "value": null
  },
  "phone_number": {
    "type": "string",
    "title": "Phone Number",
    "hide": false,
    "value": null
  },
  "gender": {
    "type": "string",
    "title": "Gender",
    "hide": false,
    "value": null
  },
  "nationality_id": {
    "type": "id",
    "title": "Nationality ID",
    "hide": true,
    "value": null
  },
  "nationality": {
    "type": "string",
    "title": "Nationality",
    "hide": false,
    "value": null
  },
  "id_number": {
    "type": "string",
    "title": "ID Number",
    "hide": false,
    "value": null
  },
  "passport_number": {
    "type": "string",
    "title": "Passport Number",
    "hide": false,
    "value": null
  },
  "note": {
    "type": "string",
    "title": "Note",
    "hide": false,
    "value": null
  }
};

final ID = "_id";
final FULL_NAME = "full_name";
final PHONE_NUMBER = "phone_number";
final GENDER = "gender";
final NATIONALITY_ID = "nationality_id";
final NATIONALITY = "nationality";
final ID_NUMBER = "id_number";
final PASSPORT_NUMBER = "passport_number";
final NOTE = "note";


void clear() { for (var k in data.keys) data[k]!["value"] = null; }