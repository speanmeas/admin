Map<String, Map<String, dynamic>> data = {
  "_id": {
    "type": "id",
    "title": "ID",
    "hide": true,
    "lock": false,
    "value": null
  },
  "username": {
    "type": "string",
    "title": "Username",
    "hide": false,
    "lock": false,
    "value": null
  },
  "password": {
    "type": "string",
    "title": "Password",
    "hide": false,
    "lock": false,
    "value": null
  },
  "full_name": {
    "type": "string",
    "title": "Full Name",
    "hide": false,
    "lock": false,
    "value": null
  },
  "phone_number": {
    "type": "string",
    "title": "Phone Number",
    "hide": false,
    "lock": false,
    "value": null
  },
  "is_admin": {
    "type": "boolean",
    "title": "Is Admin",
    "hide": false,
    "lock": false,
    "value": null
  },
  "is_manager": {
    "type": "boolean",
    "title": "Is Manager",
    "hide": false,
    "lock": false,
    "value": null
  },
  "is_receptionist": {
    "type": "boolean",
    "title": "Is Receptionist",
    "hide": false,
    "lock": false,
    "value": null
  },
  "is_housekeeper": {
    "type": "boolean",
    "title": "Is Housekeeper",
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
  }
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
final NOTE = "note";

void clear() { for (var k in data.keys) data[k]!["value"] = null; }