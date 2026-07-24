Map<String, Map<String, dynamic>> data = {
  "_id": {
    "type": "_id",
    "title": "ID",
    "hide": true,
    "value": null
  },
  "username": {
    "type": "string",
    "title": "Username",
    "hide": false,
    "value": null
  },
  "password": {
    "type": "string",
    "title": "Password",
    "hide": false,
    "value": null
  },
  "full_name": {
    "type": "string",
    "title": "Full Name",
    "hide": false,
    "value": null
  },
  "phone_number": {
    "type": "string",
    "title": "Phone Number",
    "hide": false,
    "value": null
  },
  "is_admin": {
    "type": "boolean",
    "title": "Is Admin",
    "hide": false,
    "value": null
  },
  "is_manager": {
    "type": "boolean",
    "title": "Is Manager",
    "hide": false,
    "value": null
  },
  "is_receptionist": {
    "type": "boolean",
    "title": "Is Receptionist",
    "hide": false,
    "value": null
  },
  "is_housekeeper": {
    "type": "boolean",
    "title": "Is Housekeeper",
    "hide": false,
    "value": null
  },
  "is_client": {
    "type": "boolean",
    "title": "Is Client",
    "hide": false,
    "value": null
  },
  "note": {
    "type": "string",
    "title": "Note",
    "hide": false,
    "value": null
  },
  "access_token": {
    "type": "string",
    "title": "Access Token",
    "hide": false,
    "value": null
  },
  "token_type": {
    "type": "string",
    "title": "Token Type",
    "hide": false,
    "value": null
  },
  "last_sign_in_at": {
    "type": "date-time",
    "title": "Last Sign In At",
    "hide": false,
    "value": null
  },
  "last_sign_out_at": {
    "type": "date-time",
    "title": "Last Sign Out At",
    "hide": false,
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
final IS_CLIENT = "is_client";
final NOTE = "note";
final ACCESS_TOKEN = "access_token";
final TOKEN_TYPE = "token_type";
final LAST_SIGN_IN_AT = "last_sign_in_at";
final LAST_SIGN_OUT_AT = "last_sign_out_at";


void clear() { for (var k in data.keys) data[k]!["value"] = null; }