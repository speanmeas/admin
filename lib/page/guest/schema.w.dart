Map<String, Map<String, dynamic>> data = {
  "_id": {
    "type": "id",
    "title": "ID",
    "value": null
  },
  "full_name": {
    "type": "string",
    "title": "Name",
    "value": null
  },
  "phone_number": {
    "type": "string",
    "title": "Phone Number",
    "value": null
  },
  "gender": {
    "type": "string",
    "title": "Gender",
    "value": null
  },
  "nationality_id": {
    "type": "id",
    "title": "Nationality ID",
    "value": null
  },
  "id_number": {
    "type": "string",
    "title": "ID Number",
    "value": null
  },
  "passport_number": {
    "type": "string",
    "title": "Passport Number",
    "value": null
  },
  "note": {
    "type": "string",
    "title": "Note",
    "value": null
  }
};

final ID = "_id";
final FULL_NAME = "full_name";
final PHONE_NUMBER = "phone_number";
final GENDER = "gender";
final NATIONALITY_ID = "nationality_id";
final ID_NUMBER = "id_number";
final PASSPORT_NUMBER = "passport_number";
final NOTE = "note";


void clear() { for (var k in data.keys) data[k]!["value"] = null; }