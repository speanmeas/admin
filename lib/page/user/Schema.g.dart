Map<String, Map<String, dynamic>> data = {
  "_id": {
    "type": "_id",
    "title": "ID",
    "hide": true,
    "value": null
  },
  "user_name": {
    "type": "string",
    "title": "Name",
    "hide": false,
    "value": null
  },
  "user_phone": {
    "type": "string",
    "title": "Phone Number",
    "hide": false,
    "value": null
  },
  "user_username": {
    "type": "string",
    "title": "Username",
    "hide": false,
    "value": null
  },
  "user_password": {
    "type": "string",
    "title": "Password",
    "hide": false,
    "value": null
  },
  "user_is_admin": {
    "type": "boolean",
    "title": "Is Admin",
    "hide": false,
    "value": null
  },
  "user_is_manager": {
    "type": "boolean",
    "title": "Is Manager",
    "hide": false,
    "value": null
  },
  "user_is_receptionist": {
    "type": "boolean",
    "title": "Is Receptionist",
    "hide": false,
    "value": null
  },
  "user_is_housekeeper": {
    "type": "boolean",
    "title": "Is Housekeeper",
    "hide": false,
    "value": null
  },
  "user_access_token": {
    "type": "string",
    "title": "Access Token",
    "hide": true,
    "value": null
  },
  "user_note": {
    "type": "string",
    "title": "Note",
    "hide": false,
    "value": null
  }
};

final ID = "_id";
final USER_NAME = "user_name";
final USER_PHONE = "user_phone";
final USER_USERNAME = "user_username";
final USER_PASSWORD = "user_password";
final USER_IS_ADMIN = "user_is_admin";
final USER_IS_MANAGER = "user_is_manager";
final USER_IS_RECEPTIONIST = "user_is_receptionist";
final USER_IS_HOUSEKEEPER = "user_is_housekeeper";
final USER_ACCESS_TOKEN = "user_access_token";
final USER_NOTE = "user_note";


void clear() { for (var k in data.keys) data[k]!["value"] = null; }