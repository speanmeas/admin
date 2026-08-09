class Mini_bar {
static final Mini_bar instance = Mini_bar._();
Mini_bar._();

Map<String, Map<String, dynamic>> data = {
  "_id": {
    "type": "id",
    "title": "ID",
    "hide": true,
    "lock": false,
    "value": null
  },
  "name": {
    "type": "string",
    "title": "Name",
    "hide": false,
    "lock": false,
    "value": null
  },
  "price": {
    "type": "number",
    "title": "Price",
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
final NAME = "name";
final PRICE = "price";
final NOTE = "note";

void clear() { for (var k in data.keys) data[k]!["value"] = null; }

}

Mini_bar sm_mini_bar = Mini_bar.instance;
