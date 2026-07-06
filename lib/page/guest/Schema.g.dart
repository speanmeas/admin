List<Map<String, dynamic>> data = [
  {
    "key": "_id",
    "type": "_id",
    "title": "ID"
  },
  {
    "key": "guest_name",
    "type": "string",
    "title": "Guest Name"
  },
  {
    "key": "guest_phone",
    "type": "string",
    "title": "Guest Phone Number"
  },
  {
    "key": "guest_gender",
    "type": "string",
    "title": "Guest Gender"
  },
  {
    "key": "guest_nationality",
    "type": "string",
    "title": "Guest Nationality"
  },
  {
    "key": "guest_note",
    "type": "string",
    "title": "Guest Note"
  }
];

void clear() {for (var s in data) s["value"] = null;}