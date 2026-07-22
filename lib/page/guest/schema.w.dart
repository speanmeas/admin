Map<String, Map<String, dynamic>> data = {
  "_id": {"type": "_id", "title": "ID", "hide": true, "value": null},
  "full_name": {"type": "string", "title": "Full Name", "value": null},
  "phone_number": {"type": "string", "title": "Phone Number", "value": null},
  "gender": {"type": "string", "title": "Gender", "value": null},
  "nationality_link": {"type": "link", "title": "Nationality Link", "value": null},
  "id_number": {"type": "string", "title": "ID Number", "value": null},
  "passport_number": {"type": "string", "title": "Passport Number", "value": null},
  "note": {"type": "string", "title": "Note", "value": null},
};

final ID = "_id";
final FULL_NAME = "full_name";
final PHONE_NUMBER = "phone_number";
final GENDER = "gender";
final NATIONALITY_LINK = "nationality_link";
final ID_NUMBER = "id_number";
final PASSPORT_NUMBER = "passport_number";
final NOTE = "note";

void clear() {
  for (var k in data.keys) data[k]!["value"] = null;
}
