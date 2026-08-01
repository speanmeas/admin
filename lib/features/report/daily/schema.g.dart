Map<String, Map<String, dynamic>> data = {
  "_id": {
    "type": "id",
    "title": "ID",
    "hide": true,
    "lock": false,
    "value": null,
  },
  "time": {
    "type": "string",
    "title": "Time / ម៉ោង",
    "hide": false,
    "lock": false,
    "value": null,
  },
  "reference_no": {
    "type": "string",
    "title": "Ref No / លេខវិក្កយបត្រ",
    "hide": false,
    "lock": false,
    "value": null,
  },
  "room_number": {
    "type": "string",
    "title": "Room / បន្ទប់",
    "hide": false,
    "lock": false,
    "value": null,
  },
  "guest_name": {
    "type": "string",
    "title": "Guest Name / ឈ្មោះភ្ញៀវ",
    "hide": false,
    "lock": false,
    "value": null,
  },
  "category": {
    "type": "string",
    "title": "Category / ប្រភេទ",
    "hide": false,
    "lock": false,
    "value": null,
  },
  "payment_method": {
    "type": "string",
    "title": "Payment / ការទូទាត់",
    "hide": false,
    "lock": false,
    "value": null,
  },
  "amount": {
    "type": "number",
    "title": "Amount (\$) / ចំនួនទឹកប្រាក់",
    "hide": false,
    "lock": false,
    "value": null,
  },
  "status": {
    "type": "string",
    "title": "Status / ស្ថានភាព",
    "hide": false,
    "lock": false,
    "value": null,
  },
  "staff": {
    "type": "string",
    "title": "Staff / បុគ្គលិក",
    "hide": false,
    "lock": false,
    "value": null,
  },
};

final ID = "_id";
final TIME = "time";
final REFERENCE_NO = "reference_no";
final ROOM_NUMBER = "room_number";
final GUEST_NAME = "guest_name";
final CATEGORY = "category";
final PAYMENT_METHOD = "payment_method";
final AMOUNT = "amount";
final STATUS = "status";
final STAFF = "staff";

void clear() {
  for (var k in data.keys) {
    data[k]!["value"] = null;
  }
}
