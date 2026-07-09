List<Map<String, dynamic>> data = [
  {
    "key": "_id",
    "type": "_id",
    "title": "ID",
    "hide": true
  },
  {
    "key": "user_name",
    "type": "string",
    "title": "Name",
    "hide": false
  },
  {
    "key": "user_phone",
    "type": "string",
    "title": "Phone Number",
    "hide": false
  },
  {
    "key": "user_username",
    "type": "string",
    "title": "Username",
    "hide": false
  },
  {
    "key": "user_password",
    "type": "string",
    "title": "Password",
    "hide": false
  },
  {
    "key": "user_is_admin",
    "type": "boolean",
    "title": "Is Admin",
    "hide": false
  },
  {
    "key": "user_is_manager",
    "type": "boolean",
    "title": "Is Manager",
    "hide": false
  },
  {
    "key": "user_is_receptionist",
    "type": "boolean",
    "title": "Is Receptionist",
    "hide": false
  },
  {
    "key": "user_is_housekeeper",
    "type": "boolean",
    "title": "Is Housekeeper",
    "hide": false
  },
  {
    "key": "user_access_token",
    "type": "string",
    "title": "Access Token",
    "hide": false
  },
  {
    "key": "user_note",
    "type": "string",
    "title": "User Note",
    "hide": false
  }
];

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


void clear() {for (var s in data) s["value"] = null;}