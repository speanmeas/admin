Map<String, Map<String, dynamic>> data = {
  "_id": {
    "type": "_id",
    "title": "ID",
    "hide": true,
    "value": null
  },
  "room_id": {
    "type": "_id",
    "title": "Room ID",
    "hide": true,
    "value": null
  },
  "room_number": {
    "type": "string",
    "title": "Room Number",
    "hide": false,
    "value": null
  },
  "room_type": {
    "type": "string",
    "title": "Room Type",
    "hide": false,
    "value": null
  },
  "room_price_per_day_usd": {
    "type": "number",
    "title": "Room Price/Day",
    "hide": false,
    "value": null
  },
  "room_price_per_3h_usd": {
    "type": "number",
    "title": "Room Price/3H",
    "hide": false,
    "value": null
  },
  "room_status": {
    "type": "string",
    "title": "Room Status",
    "hide": false,
    "value": null
  },
  "room_note": {
    "type": "string",
    "title": "Room Note",
    "hide": false,
    "value": null
  },
  "guest_id": {
    "type": "_id",
    "title": "Guest ID",
    "hide": true,
    "value": null
  },
  "guest_full_name": {
    "type": "string",
    "title": "Guest Full Name",
    "hide": false,
    "value": null
  },
  "guest_phone_number": {
    "type": "string",
    "title": "Guest Phone Number",
    "hide": false,
    "value": null
  },
  "guest_gender": {
    "type": "string",
    "title": "Guest Gender",
    "hide": false,
    "value": null
  },
  "guest_nationality": {
    "type": "string",
    "title": "Guest Nationality",
    "hide": false,
    "value": null
  },
  "guest_guest_national_number": {
    "type": "string",
    "title": "Guest National Number",
    "hide": false,
    "value": null
  },
  "guest_guest_passport_number": {
    "type": "string",
    "title": "Guest Passport Number",
    "hide": false,
    "value": null
  },
  "guest_note": {
    "type": "string",
    "title": "Guest Note",
    "hide": false,
    "value": null
  },
  "text_1": {
    "type": "string",
    "title": "Text 1",
    "hide": false,
    "value": null
  },
  "number_1": {
    "type": "number",
    "title": "Number 1",
    "hide": false,
    "value": null
  },
  "date_1": {
    "type": "date-time",
    "title": "Date 1",
    "hide": false,
    "value": null
  },
  "logic_1": {
    "type": "boolean",
    "title": "Logic 1",
    "hide": false,
    "value": null
  },
  "check_in_by_id": {
    "type": "_id",
    "title": "Check-in By ID",
    "hide": true,
    "value": null
  },
  "check_in_by": {
    "type": "string",
    "title": "Check In By",
    "hide": false,
    "value": null
  },
  "check_in_at": {
    "type": "date-time",
    "title": "Check-in At",
    "hide": false,
    "value": null
  },
  "check_in_note": {
    "type": "string",
    "title": "Check-in Note",
    "hide": false,
    "value": null
  },
  "check_out_by_id": {
    "type": "_id",
    "title": "Check-out By ID",
    "hide": true,
    "value": null
  },
  "check_out_by": {
    "type": "string",
    "title": "Check Out By",
    "hide": false,
    "value": null
  },
  "check_out_at": {
    "type": "date-time",
    "title": "Check-out At",
    "hide": false,
    "value": null
  },
  "check_out_note": {
    "type": "string",
    "title": "Check-out Note",
    "hide": false,
    "value": null
  }
};

final ID = "_id";
final ROOM_ID = "room_id";
final ROOM_NUMBER = "room_number";
final ROOM_TYPE = "room_type";
final ROOM_PRICE_PER_DAY_USD = "room_price_per_day_usd";
final ROOM_PRICE_PER_3H_USD = "room_price_per_3h_usd";
final ROOM_STATUS = "room_status";
final ROOM_NOTE = "room_note";
final GUEST_ID = "guest_id";
final GUEST_FULL_NAME = "guest_full_name";
final GUEST_PHONE_NUMBER = "guest_phone_number";
final GUEST_GENDER = "guest_gender";
final GUEST_NATIONALITY = "guest_nationality";
final GUEST_GUEST_NATIONAL_NUMBER = "guest_guest_national_number";
final GUEST_GUEST_PASSPORT_NUMBER = "guest_guest_passport_number";
final GUEST_NOTE = "guest_note";
final TEXT_1 = "text_1";
final NUMBER_1 = "number_1";
final DATE_1 = "date_1";
final LOGIC_1 = "logic_1";
final CHECK_IN_BY_ID = "check_in_by_id";
final CHECK_IN_BY = "check_in_by";
final CHECK_IN_AT = "check_in_at";
final CHECK_IN_NOTE = "check_in_note";
final CHECK_OUT_BY_ID = "check_out_by_id";
final CHECK_OUT_BY = "check_out_by";
final CHECK_OUT_AT = "check_out_at";
final CHECK_OUT_NOTE = "check_out_note";


void clear() { for (var k in data.keys) data[k]!["value"] = null; }