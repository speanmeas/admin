Map<String, Map<String, dynamic>> data = {
  "_id": {"type": "_id", "title": "ID", "hide": true, "value": null},
  "username": {"type": "string", "title": "Username", "value": null},
  "password": {"type": "string", "title": "Password", "value": null},
  "full_name": {"type": "string", "title": "Full Name", "value": null},
  "phone_number": {"type": "string", "title": "Phone Number", "value": null},
  "is_admin": {"type": "boolean", "title": "Is Admin", "value": null},
  "is_manager": {"type": "boolean", "title": "Is Manager", "value": null},
  "is_receptionist": {"type": "boolean", "title": "Is Receptionist", "value": null},
  "is_housekeeper": {"type": "boolean", "title": "Is Housekeeper", "value": null},
  "is_client": {"type": "boolean", "title": "Is Client", "value": null},
  "note": {"type": "string", "title": "Note", "value": null},
};

final ID = "_id";
final USERNAME = "username";
final PASSWORD = "password";
final FULL_NAME = "full_name";
final PHONE_NUMBER = "phone_number";
final IS_ADMIN = "is_admin";
final IS_MANAGER = "is_manager";
final IS_RECEPTIONIST = "is_receptionist";
final IS_HOUSEKEEPER = "is_housekeeper";
final IS_CLIENT = "is_client";
final NOTE = "note";

void clear() {
  for (var k in data.keys) data[k]!["value"] = null;
}
