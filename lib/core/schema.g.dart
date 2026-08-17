// បង្កើតដោយស្វ័យប្រវត្តិ - គ្មាន build_runner ត្រូវការ

class Bank {
  static const ID = '_id';
  static const NAME = 'name';
  static const NOTE = 'note';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final String? name;
  final String? note;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Bank({this.id, this.name, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
    id: json['_id'] as String?,
    name: json['name'] as String?,
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User_Show.fromJson(json['created_by'] as Map<String, dynamic>),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : User_Show.fromJson(json['updated_by'] as Map<String, dynamic>),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['name'] = name;
    json['note'] = note;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by?.toJson();
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by?.toJson();
    return json;
  }
}

class Demo_1 {
  static const ID = '_id';
  static const TEXT_1 = 'text_1';
  static const NUMBER_1 = 'number_1';
  static const DATETIME_1 = 'datetime_1';
  static const LOGIC_1 = 'logic_1';
  static const NOTE = 'note';
  static const NATIONALITY_ID = 'nationality_id';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final String? text_1;
  final double? number_1;
  final DateTime? datetime_1;
  final bool? logic_1;
  final String? note;
  final Nationality? nationality_id;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Demo_1({this.id, this.text_1, this.number_1, this.datetime_1, this.logic_1, this.note, this.nationality_id, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Demo_1.fromJson(Map<String, dynamic> json) => Demo_1(
    id: json['_id'] as String?,
    text_1: json['text_1'] as String?,
    number_1: json['number_1'] as double?,
    datetime_1: json['datetime_1'] == null ? null : DateTime.tryParse(json['datetime_1'] as String),
    logic_1: json['logic_1'] as bool?,
    note: json['note'] as String?,
    nationality_id: json['nationality_id'] == null ? null : Nationality.fromJson(json['nationality_id'] as Map<String, dynamic>),
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User_Show.fromJson(json['created_by'] as Map<String, dynamic>),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : User_Show.fromJson(json['updated_by'] as Map<String, dynamic>),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['text_1'] = text_1;
    json['number_1'] = number_1;
    json['datetime_1'] = datetime_1?.toIso8601String();
    json['logic_1'] = logic_1;
    json['note'] = note;
    json['nationality_id'] = nationality_id?.toJson();
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by?.toJson();
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by?.toJson();
    return json;
  }
}

class Demo_2 {
  static const ID = '_id';
  static const TEXT_1 = 'text_1';
  static const NUMBER_1 = 'number_1';
  static const DATETIME_1 = 'datetime_1';
  static const LOGIC_1 = 'logic_1';
  static const NOTE = 'note';
  static const NATIONALITY_ID = 'nationality_id';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final String? text_1;
  final double? number_1;
  final DateTime? datetime_1;
  final bool? logic_1;
  final String? note;
  final Nationality_Show? nationality_id;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Demo_2({this.id, this.text_1, this.number_1, this.datetime_1, this.logic_1, this.note, this.nationality_id, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Demo_2.fromJson(Map<String, dynamic> json) => Demo_2(
    id: json['_id'] as String?,
    text_1: json['text_1'] as String?,
    number_1: json['number_1'] as double?,
    datetime_1: json['datetime_1'] == null ? null : DateTime.tryParse(json['datetime_1'] as String),
    logic_1: json['logic_1'] as bool?,
    note: json['note'] as String?,
    nationality_id: json['nationality_id'] == null ? null : Nationality_Show.fromJson(json['nationality_id'] as Map<String, dynamic>),
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User_Show.fromJson(json['created_by'] as Map<String, dynamic>),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : User_Show.fromJson(json['updated_by'] as Map<String, dynamic>),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['text_1'] = text_1;
    json['number_1'] = number_1;
    json['datetime_1'] = datetime_1?.toIso8601String();
    json['logic_1'] = logic_1;
    json['note'] = note;
    json['nationality_id'] = nationality_id?.toJson();
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by?.toJson();
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by?.toJson();
    return json;
  }
}

class Demo_3 {
  static const ID = '_id';
  static const TEXT_1 = 'text_1';
  static const NUMBER_1 = 'number_1';
  static const NOTE = 'note';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final String? text_1;
  final double? number_1;
  final String? note;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Demo_3({this.id, this.text_1, this.number_1, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Demo_3.fromJson(Map<String, dynamic> json) => Demo_3(
    id: json['_id'] as String?,
    text_1: json['text_1'] as String?,
    number_1: json['number_1'] as double?,
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User_Show.fromJson(json['created_by'] as Map<String, dynamic>),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : User_Show.fromJson(json['updated_by'] as Map<String, dynamic>),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['text_1'] = text_1;
    json['number_1'] = number_1;
    json['note'] = note;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by?.toJson();
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by?.toJson();
    return json;
  }
}

class Front_Desk {
  static const ID = '_id';
  static const ROOM_ID = 'room_id';
  static const GUEST_ID = 'guest_id';
  static const CHECK_IN_DAY = 'check_in_day';
  static const CHECK_IN_HOUR = 'check_in_hour';
  static const CHECK_IN_NUMBER = 'check_in_number';
  static const CHECK_IN_DUE = 'check_in_due';
  static const CHECK_IN_NOTE = 'check_in_note';
  static const CHECK_IN_AT = 'check_in_at';
  static const CHECK_IN_BY = 'check_in_by';
  static const PAY_ROOM = 'pay_room';
  static const PAY_OTHER = 'pay_other';
  static const ORDER_MINI_BAR = 'order_mini_bar';
  static const PAY_MINI_BAR = 'pay_mini_bar';
  static const CANCEL_NOTE = 'cancel_note';
  static const CANCEL_AT = 'cancel_at';
  static const CANCEL_BY = 'cancel_by';
  static const CHANGE_NOTE = 'change_note';
  static const CHANGE_AT = 'change_at';
  static const CHANGE_BY = 'change_by';
  static const CHECK_OUT_NOTE = 'check_out_note';
  static const CHECK_OUT_AT = 'check_out_at';
  static const CHECK_OUT_BY = 'check_out_by';
  static const CLEAN_NOTE = 'clean_note';
  static const CLEAN_AT = 'clean_at';
  static const CLEAN_BY = 'clean_by';
  static const BROKE_NOTE = 'broke_note';
  static const BROKE_AT = 'broke_at';
  static const BROKE_BY = 'broke_by';
  static const FIX_NOTE = 'fix_note';
  static const FIX_AT = 'fix_at';
  static const FIX_BY = 'fix_by';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final Room_Show? room_id;
  final Guest_Show? guest_id;
  final double? check_in_day;
  final double? check_in_hour;
  final double? check_in_number;
  final DateTime? check_in_due;
  final String? check_in_note;
  final DateTime? check_in_at;
  final User_Show? check_in_by;
  final List<Pay_Room>? pay_room;
  final List<Pay_Other>? pay_other;
  final List<Order_Mini_Bar>? order_mini_bar;
  final List<Pay_Mini_Bar>? pay_mini_bar;
  final String? cancel_note;
  final DateTime? cancel_at;
  final User_Show? cancel_by;
  final String? change_note;
  final DateTime? change_at;
  final User_Show? change_by;
  final String? check_out_note;
  final DateTime? check_out_at;
  final User_Show? check_out_by;
  final String? clean_note;
  final DateTime? clean_at;
  final User_Show? clean_by;
  final String? broke_note;
  final DateTime? broke_at;
  final User_Show? broke_by;
  final String? fix_note;
  final DateTime? fix_at;
  final User_Show? fix_by;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Front_Desk({this.id, this.room_id, this.guest_id, this.check_in_day, this.check_in_hour, this.check_in_number, this.check_in_due, this.check_in_note, this.check_in_at, this.check_in_by, this.pay_room, this.pay_other, this.order_mini_bar, this.pay_mini_bar, this.cancel_note, this.cancel_at, this.cancel_by, this.change_note, this.change_at, this.change_by, this.check_out_note, this.check_out_at, this.check_out_by, this.clean_note, this.clean_at, this.clean_by, this.broke_note, this.broke_at, this.broke_by, this.fix_note, this.fix_at, this.fix_by, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Front_Desk.fromJson(Map<String, dynamic> json) => Front_Desk(
    id: json['_id'] as String?,
    room_id: json['room_id'] == null ? null : Room_Show.fromJson(json['room_id'] as Map<String, dynamic>),
    guest_id: json['guest_id'] == null ? null : Guest_Show.fromJson(json['guest_id'] as Map<String, dynamic>),
    check_in_day: json['check_in_day'] as double?,
    check_in_hour: json['check_in_hour'] as double?,
    check_in_number: json['check_in_number'] as double?,
    check_in_due: json['check_in_due'] == null ? null : DateTime.tryParse(json['check_in_due'] as String),
    check_in_note: json['check_in_note'] as String?,
    check_in_at: json['check_in_at'] == null ? null : DateTime.tryParse(json['check_in_at'] as String),
    check_in_by: json['check_in_by'] == null ? null : User_Show.fromJson(json['check_in_by'] as Map<String, dynamic>),
    pay_room: (json['pay_room'] as List<dynamic>?)?.map((e) => Pay_Room.fromJson(e as Map<String, dynamic>)).toList(),
    pay_other: (json['pay_other'] as List<dynamic>?)?.map((e) => Pay_Other.fromJson(e as Map<String, dynamic>)).toList(),
    order_mini_bar: (json['order_mini_bar'] as List<dynamic>?)?.map((e) => Order_Mini_Bar.fromJson(e as Map<String, dynamic>)).toList(),
    pay_mini_bar: (json['pay_mini_bar'] as List<dynamic>?)?.map((e) => Pay_Mini_Bar.fromJson(e as Map<String, dynamic>)).toList(),
    cancel_note: json['cancel_note'] as String?,
    cancel_at: json['cancel_at'] == null ? null : DateTime.tryParse(json['cancel_at'] as String),
    cancel_by: json['cancel_by'] == null ? null : User_Show.fromJson(json['cancel_by'] as Map<String, dynamic>),
    change_note: json['change_note'] as String?,
    change_at: json['change_at'] == null ? null : DateTime.tryParse(json['change_at'] as String),
    change_by: json['change_by'] == null ? null : User_Show.fromJson(json['change_by'] as Map<String, dynamic>),
    check_out_note: json['check_out_note'] as String?,
    check_out_at: json['check_out_at'] == null ? null : DateTime.tryParse(json['check_out_at'] as String),
    check_out_by: json['check_out_by'] == null ? null : User_Show.fromJson(json['check_out_by'] as Map<String, dynamic>),
    clean_note: json['clean_note'] as String?,
    clean_at: json['clean_at'] == null ? null : DateTime.tryParse(json['clean_at'] as String),
    clean_by: json['clean_by'] == null ? null : User_Show.fromJson(json['clean_by'] as Map<String, dynamic>),
    broke_note: json['broke_note'] as String?,
    broke_at: json['broke_at'] == null ? null : DateTime.tryParse(json['broke_at'] as String),
    broke_by: json['broke_by'] == null ? null : User_Show.fromJson(json['broke_by'] as Map<String, dynamic>),
    fix_note: json['fix_note'] as String?,
    fix_at: json['fix_at'] == null ? null : DateTime.tryParse(json['fix_at'] as String),
    fix_by: json['fix_by'] == null ? null : User_Show.fromJson(json['fix_by'] as Map<String, dynamic>),
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User_Show.fromJson(json['created_by'] as Map<String, dynamic>),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : User_Show.fromJson(json['updated_by'] as Map<String, dynamic>),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['room_id'] = room_id?.toJson();
    json['guest_id'] = guest_id?.toJson();
    json['check_in_day'] = check_in_day;
    json['check_in_hour'] = check_in_hour;
    json['check_in_number'] = check_in_number;
    json['check_in_due'] = check_in_due?.toIso8601String();
    json['check_in_note'] = check_in_note;
    json['check_in_at'] = check_in_at?.toIso8601String();
    json['check_in_by'] = check_in_by?.toJson();
    json['pay_room'] = pay_room?.map((e) => e.toJson()).toList();
    json['pay_other'] = pay_other?.map((e) => e.toJson()).toList();
    json['order_mini_bar'] = order_mini_bar?.map((e) => e.toJson()).toList();
    json['pay_mini_bar'] = pay_mini_bar?.map((e) => e.toJson()).toList();
    json['cancel_note'] = cancel_note;
    json['cancel_at'] = cancel_at?.toIso8601String();
    json['cancel_by'] = cancel_by?.toJson();
    json['change_note'] = change_note;
    json['change_at'] = change_at?.toIso8601String();
    json['change_by'] = change_by?.toJson();
    json['check_out_note'] = check_out_note;
    json['check_out_at'] = check_out_at?.toIso8601String();
    json['check_out_by'] = check_out_by?.toJson();
    json['clean_note'] = clean_note;
    json['clean_at'] = clean_at?.toIso8601String();
    json['clean_by'] = clean_by?.toJson();
    json['broke_note'] = broke_note;
    json['broke_at'] = broke_at?.toIso8601String();
    json['broke_by'] = broke_by?.toJson();
    json['fix_note'] = fix_note;
    json['fix_at'] = fix_at?.toIso8601String();
    json['fix_by'] = fix_by?.toJson();
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by?.toJson();
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by?.toJson();
    return json;
  }
}

class Order_Mini_Bar {
  static const ID = '_id';
  static const MINI_BAR_ID = 'mini_bar_id';
  static const QUANTITY = 'quantity';
  static const FRONT_DESK_ID = 'front_desk_id';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final Mini_Bar_Show? mini_bar_id;
  final int? quantity;
  final List<Front_Desk_Show>? front_desk_id;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Order_Mini_Bar({this.id, this.mini_bar_id, this.quantity, this.front_desk_id, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Order_Mini_Bar.fromJson(Map<String, dynamic> json) => Order_Mini_Bar(
    id: json['_id'] as String?,
    mini_bar_id: json['mini_bar_id'] == null ? null : Mini_Bar_Show.fromJson(json['mini_bar_id'] as Map<String, dynamic>),
    quantity: json['quantity'] as int?,
    front_desk_id: (json['front_desk_id'] as List<dynamic>?)?.map((e) => Front_Desk_Show.fromJson(e as Map<String, dynamic>)).toList(),
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User_Show.fromJson(json['created_by'] as Map<String, dynamic>),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : User_Show.fromJson(json['updated_by'] as Map<String, dynamic>),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['mini_bar_id'] = mini_bar_id?.toJson();
    json['quantity'] = quantity;
    json['front_desk_id'] = front_desk_id?.map((e) => e.toJson()).toList();
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by?.toJson();
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by?.toJson();
    return json;
  }
}

class Pay_Mini_Bar {
  static const ID = '_id';
  static const ADD_PRICE = 'add_price';
  static const SUB_PRICE = 'sub_price';
  static const ADD_CASH = 'add_cash';
  static const ADD_BANK = 'add_bank';
  static const SUB_RETURN = 'sub_return';
  static const NOTE = 'note';
  static const FRONT_DESK_ID = 'front_desk_id';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final double? add_price;
  final double? sub_price;
  final double? add_cash;
  final double? add_bank;
  final double? sub_return;
  final String? note;
  final Front_Desk_Show? front_desk_id;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Pay_Mini_Bar({this.id, this.add_price, this.sub_price, this.add_cash, this.add_bank, this.sub_return, this.note, this.front_desk_id, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Pay_Mini_Bar.fromJson(Map<String, dynamic> json) => Pay_Mini_Bar(
    id: json['_id'] as String?,
    add_price: json['add_price'] as double?,
    sub_price: json['sub_price'] as double?,
    add_cash: json['add_cash'] as double?,
    add_bank: json['add_bank'] as double?,
    sub_return: json['sub_return'] as double?,
    note: json['note'] as String?,
    front_desk_id: json['front_desk_id'] == null ? null : Front_Desk_Show.fromJson(json['front_desk_id'] as Map<String, dynamic>),
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User_Show.fromJson(json['created_by'] as Map<String, dynamic>),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : User_Show.fromJson(json['updated_by'] as Map<String, dynamic>),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['add_price'] = add_price;
    json['sub_price'] = sub_price;
    json['add_cash'] = add_cash;
    json['add_bank'] = add_bank;
    json['sub_return'] = sub_return;
    json['note'] = note;
    json['front_desk_id'] = front_desk_id?.toJson();
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by?.toJson();
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by?.toJson();
    return json;
  }
}

class Pay_Other {
  static const ID = '_id';
  static const ADD_PRICE = 'add_price';
  static const SUB_PRICE = 'sub_price';
  static const ADD_CASH = 'add_cash';
  static const ADD_BANK = 'add_bank';
  static const SUB_RETURN = 'sub_return';
  static const NOTE = 'note';
  static const FRONT_DESK_ID = 'front_desk_id';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final double? add_price;
  final double? sub_price;
  final double? add_cash;
  final double? add_bank;
  final double? sub_return;
  final String? note;
  final Front_Desk_Show? front_desk_id;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Pay_Other({this.id, this.add_price, this.sub_price, this.add_cash, this.add_bank, this.sub_return, this.note, this.front_desk_id, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Pay_Other.fromJson(Map<String, dynamic> json) => Pay_Other(
    id: json['_id'] as String?,
    add_price: json['add_price'] as double?,
    sub_price: json['sub_price'] as double?,
    add_cash: json['add_cash'] as double?,
    add_bank: json['add_bank'] as double?,
    sub_return: json['sub_return'] as double?,
    note: json['note'] as String?,
    front_desk_id: json['front_desk_id'] == null ? null : Front_Desk_Show.fromJson(json['front_desk_id'] as Map<String, dynamic>),
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User_Show.fromJson(json['created_by'] as Map<String, dynamic>),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : User_Show.fromJson(json['updated_by'] as Map<String, dynamic>),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['add_price'] = add_price;
    json['sub_price'] = sub_price;
    json['add_cash'] = add_cash;
    json['add_bank'] = add_bank;
    json['sub_return'] = sub_return;
    json['note'] = note;
    json['front_desk_id'] = front_desk_id?.toJson();
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by?.toJson();
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by?.toJson();
    return json;
  }
}

class Pay_Room {
  static const ID = '_id';
  static const ADD_PRICE = 'add_price';
  static const SUB_PRICE = 'sub_price';
  static const ADD_CASH = 'add_cash';
  static const ADD_BANK = 'add_bank';
  static const SUB_RETURN = 'sub_return';
  static const NOTE = 'note';
  static const FRONT_DESK_ID = 'front_desk_id';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final double? add_price;
  final double? sub_price;
  final double? add_cash;
  final double? add_bank;
  final double? sub_return;
  final String? note;
  final Front_Desk_Show? front_desk_id;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Pay_Room({this.id, this.add_price, this.sub_price, this.add_cash, this.add_bank, this.sub_return, this.note, this.front_desk_id, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Pay_Room.fromJson(Map<String, dynamic> json) => Pay_Room(
    id: json['_id'] as String?,
    add_price: json['add_price'] as double?,
    sub_price: json['sub_price'] as double?,
    add_cash: json['add_cash'] as double?,
    add_bank: json['add_bank'] as double?,
    sub_return: json['sub_return'] as double?,
    note: json['note'] as String?,
    front_desk_id: json['front_desk_id'] == null ? null : Front_Desk_Show.fromJson(json['front_desk_id'] as Map<String, dynamic>),
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User_Show.fromJson(json['created_by'] as Map<String, dynamic>),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : User_Show.fromJson(json['updated_by'] as Map<String, dynamic>),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['add_price'] = add_price;
    json['sub_price'] = sub_price;
    json['add_cash'] = add_cash;
    json['add_bank'] = add_bank;
    json['sub_return'] = sub_return;
    json['note'] = note;
    json['front_desk_id'] = front_desk_id?.toJson();
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by?.toJson();
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by?.toJson();
    return json;
  }
}

class Guest {
  static const ID = '_id';
  static const FULL_NAME = 'full_name';
  static const PHONE_NUMBER = 'phone_number';
  static const GENDER = 'gender';
  static const NATIONALITY_ID = 'nationality_id';
  static const ID_NUMBER = 'id_number';
  static const PASSPORT_NUMBER = 'passport_number';
  static const NOTE = 'note';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final String? full_name;
  final String? phone_number;
  final String? gender;
  final Nationality_Show? nationality_id;
  final String? id_number;
  final String? passport_number;
  final String? note;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Guest({this.id, this.full_name, this.phone_number, this.gender, this.nationality_id, this.id_number, this.passport_number, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Guest.fromJson(Map<String, dynamic> json) => Guest(
    id: json['_id'] as String?,
    full_name: json['full_name'] as String?,
    phone_number: json['phone_number'] as String?,
    gender: json['gender'] as String?,
    nationality_id: json['nationality_id'] == null ? null : Nationality_Show.fromJson(json['nationality_id'] as Map<String, dynamic>),
    id_number: json['id_number'] as String?,
    passport_number: json['passport_number'] as String?,
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User_Show.fromJson(json['created_by'] as Map<String, dynamic>),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : User_Show.fromJson(json['updated_by'] as Map<String, dynamic>),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['full_name'] = full_name;
    json['phone_number'] = phone_number;
    json['gender'] = gender;
    json['nationality_id'] = nationality_id?.toJson();
    json['id_number'] = id_number;
    json['passport_number'] = passport_number;
    json['note'] = note;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by?.toJson();
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by?.toJson();
    return json;
  }
}

class Mini_Bar {
  static const ID = '_id';
  static const NAME = 'name';
  static const PRICE = 'price';
  static const STOCK = 'stock';
  static const NOTE = 'note';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final String? name;
  final double? price;
  final double? stock;
  final String? note;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Mini_Bar({this.id, this.name, this.price, this.stock, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Mini_Bar.fromJson(Map<String, dynamic> json) => Mini_Bar(
    id: json['_id'] as String?,
    name: json['name'] as String?,
    price: json['price'] as double?,
    stock: json['stock'] as double?,
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User_Show.fromJson(json['created_by'] as Map<String, dynamic>),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : User_Show.fromJson(json['updated_by'] as Map<String, dynamic>),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['name'] = name;
    json['price'] = price;
    json['stock'] = stock;
    json['note'] = note;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by?.toJson();
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by?.toJson();
    return json;
  }
}

class Nationality {
  static const ID = '_id';
  static const NAME = 'name';
  static const NOTE = 'note';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final String? name;
  final String? note;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Nationality({this.id, this.name, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Nationality.fromJson(Map<String, dynamic> json) => Nationality(
    id: json['_id'] as String?,
    name: json['name'] as String?,
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User_Show.fromJson(json['created_by'] as Map<String, dynamic>),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : User_Show.fromJson(json['updated_by'] as Map<String, dynamic>),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['name'] = name;
    json['note'] = note;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by?.toJson();
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by?.toJson();
    return json;
  }
}

class Room {
  static const ID = '_id';
  static const NUMBER = 'number';
  static const USD_PER_DAY = 'usd_per_day';
  static const USD_PER_3H = 'usd_per_3h';
  static const KIND = 'kind';
  static const STATUS = 'status';
  static const NOTE = 'note';
  static const FRONT_DESK_ID = 'front_desk_id';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final String? number;
  final double? usd_per_day;
  final double? usd_per_3h;
  final String? kind;
  final String? status;
  final String? note;
  final Front_Desk? front_desk_id;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Room({this.id, this.number, this.usd_per_day, this.usd_per_3h, this.kind, this.status, this.note, this.front_desk_id, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Room.fromJson(Map<String, dynamic> json) => Room(
    id: json['_id'] as String?,
    number: json['number'] as String?,
    usd_per_day: json['usd_per_day'] as double?,
    usd_per_3h: json['usd_per_3h'] as double?,
    kind: json['kind'] as String?,
    status: json['status'] as String?,
    note: json['note'] as String?,
    front_desk_id: json['front_desk_id'] == null ? null : Front_Desk.fromJson(json['front_desk_id'] as Map<String, dynamic>),
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User_Show.fromJson(json['created_by'] as Map<String, dynamic>),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : User_Show.fromJson(json['updated_by'] as Map<String, dynamic>),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['number'] = number;
    json['usd_per_day'] = usd_per_day;
    json['usd_per_3h'] = usd_per_3h;
    json['kind'] = kind;
    json['status'] = status;
    json['note'] = note;
    json['front_desk_id'] = front_desk_id?.toJson();
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by?.toJson();
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by?.toJson();
    return json;
  }
}

class Sever_Side_Event {
  static const ID = '_id';
  static const NOTE = 'note';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final String? note;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Sever_Side_Event({this.id, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Sever_Side_Event.fromJson(Map<String, dynamic> json) => Sever_Side_Event(
    id: json['_id'] as String?,
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User_Show.fromJson(json['created_by'] as Map<String, dynamic>),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : User_Show.fromJson(json['updated_by'] as Map<String, dynamic>),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['note'] = note;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by?.toJson();
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by?.toJson();
    return json;
  }
}

class Setting {
  static const ID = '_id';
  static const KEY = 'key';
  static const VALUE = 'value';
  static const NOTE = 'note';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final String? key;
  final dynamic value;
  final String? note;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Setting({this.id, this.key, this.value, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
    id: json['_id'] as String?,
    key: json['key'] as String?,
    value: json['value'],
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User_Show.fromJson(json['created_by'] as Map<String, dynamic>),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : User_Show.fromJson(json['updated_by'] as Map<String, dynamic>),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['key'] = key;
    json['value'] = value;
    json['note'] = note;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by?.toJson();
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by?.toJson();
    return json;
  }
}

class User {
  static const ID = '_id';
  static const USERNAME = 'username';
  static const PASSWORD = 'password';
  static const FULL_NAME = 'full_name';
  static const PHONE_NUMBER = 'phone_number';
  static const IS_ADMIN = 'is_admin';
  static const IS_MANAGER = 'is_manager';
  static const IS_RECEPTIONIST = 'is_receptionist';
  static const IS_HOUSEKEEPER = 'is_housekeeper';
  static const NOTE = 'note';
  static const ACCESS_TOKEN = 'access_token';
  static const TOKEN_TYPE = 'token_type';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final String? username;
  final String? password;
  final String? full_name;
  final String? phone_number;
  final bool? is_admin;
  final bool? is_manager;
  final bool? is_receptionist;
  final bool? is_housekeeper;
  final String? note;
  final String? access_token;
  final String? token_type;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  User({this.id, this.username, this.password, this.full_name, this.phone_number, this.is_admin, this.is_manager, this.is_receptionist, this.is_housekeeper, this.note, this.access_token, this.token_type, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['_id'] as String?,
    username: json['username'] as String?,
    password: json['password'] as String?,
    full_name: json['full_name'] as String?,
    phone_number: json['phone_number'] as String?,
    is_admin: json['is_admin'] as bool?,
    is_manager: json['is_manager'] as bool?,
    is_receptionist: json['is_receptionist'] as bool?,
    is_housekeeper: json['is_housekeeper'] as bool?,
    note: json['note'] as String?,
    access_token: json['access_token'] as String?,
    token_type: json['token_type'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User_Show.fromJson(json['created_by'] as Map<String, dynamic>),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : User_Show.fromJson(json['updated_by'] as Map<String, dynamic>),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['username'] = username;
    json['password'] = password;
    json['full_name'] = full_name;
    json['phone_number'] = phone_number;
    json['is_admin'] = is_admin;
    json['is_manager'] = is_manager;
    json['is_receptionist'] = is_receptionist;
    json['is_housekeeper'] = is_housekeeper;
    json['note'] = note;
    json['access_token'] = access_token;
    json['token_type'] = token_type;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by?.toJson();
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by?.toJson();
    return json;
  }
}

class User_Client {
  static const ID = '_id';
  static const USERNAME = 'username';
  static const PASSWORD = 'password';
  static const FULL_NAME = 'full_name';
  static const PHONE_NUMBER = 'phone_number';
  static const NOTE = 'note';
  static const ACCESS_TOKEN = 'access_token';
  static const TOKEN_TYPE = 'token_type';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final String? username;
  final String? password;
  final String? full_name;
  final String? phone_number;
  final String? note;
  final String? access_token;
  final String? token_type;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  User_Client({this.id, this.username, this.password, this.full_name, this.phone_number, this.note, this.access_token, this.token_type, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory User_Client.fromJson(Map<String, dynamic> json) => User_Client(
    id: json['_id'] as String?,
    username: json['username'] as String?,
    password: json['password'] as String?,
    full_name: json['full_name'] as String?,
    phone_number: json['phone_number'] as String?,
    note: json['note'] as String?,
    access_token: json['access_token'] as String?,
    token_type: json['token_type'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User_Show.fromJson(json['created_by'] as Map<String, dynamic>),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : User_Show.fromJson(json['updated_by'] as Map<String, dynamic>),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['username'] = username;
    json['password'] = password;
    json['full_name'] = full_name;
    json['phone_number'] = phone_number;
    json['note'] = note;
    json['access_token'] = access_token;
    json['token_type'] = token_type;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by?.toJson();
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by?.toJson();
    return json;
  }
}

class Web_Socket {
  static const ID = '_id';
  static const NOTE = 'note';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final String? note;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Web_Socket({this.id, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Web_Socket.fromJson(Map<String, dynamic> json) => Web_Socket(
    id: json['_id'] as String?,
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User_Show.fromJson(json['created_by'] as Map<String, dynamic>),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : User_Show.fromJson(json['updated_by'] as Map<String, dynamic>),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['note'] = note;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by?.toJson();
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by?.toJson();
    return json;
  }
}

class User_Show {
  static const ID = '_id';
  static const FULL_NAME = 'full_name';

  final String? id;
  final String? full_name;

  User_Show({this.id, this.full_name});

  factory User_Show.fromJson(Map<String, dynamic> json) => User_Show(
    id: json['_id'] as String?,
    full_name: json['full_name'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['full_name'] = full_name;
    return json;
  }
}

class Nationality_Show {
  static const ID = '_id';
  static const NAME = 'name';

  final String? id;
  final String? name;

  Nationality_Show({this.id, this.name});

  factory Nationality_Show.fromJson(Map<String, dynamic> json) => Nationality_Show(
    id: json['_id'] as String?,
    name: json['name'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['name'] = name;
    return json;
  }
}

class Room_Show {
  static const ID = '_id';
  static const NUMBER = 'number';
  static const KIND = 'kind';
  static const USD_PER_DAY = 'usd_per_day';
  static const USD_PER_3H = 'usd_per_3h';

  final String? id;
  final String? number;
  final String? kind;
  final double? usd_per_day;
  final double? usd_per_3h;

  Room_Show({this.id, this.number, this.kind, this.usd_per_day, this.usd_per_3h});

  factory Room_Show.fromJson(Map<String, dynamic> json) => Room_Show(
    id: json['_id'] as String?,
    number: json['number'] as String?,
    kind: json['kind'] as String?,
    usd_per_day: json['usd_per_day'] as double?,
    usd_per_3h: json['usd_per_3h'] as double?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['number'] = number;
    json['kind'] = kind;
    json['usd_per_day'] = usd_per_day;
    json['usd_per_3h'] = usd_per_3h;
    return json;
  }
}

class Guest_Show {
  static const ID = '_id';
  static const FULL_NAME = 'full_name';
  static const PHONE_NUMBER = 'phone_number';
  static const GENDER = 'gender';

  final String? id;
  final String? full_name;
  final String? phone_number;
  final String? gender;

  Guest_Show({this.id, this.full_name, this.phone_number, this.gender});

  factory Guest_Show.fromJson(Map<String, dynamic> json) => Guest_Show(
    id: json['_id'] as String?,
    full_name: json['full_name'] as String?,
    phone_number: json['phone_number'] as String?,
    gender: json['gender'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['full_name'] = full_name;
    json['phone_number'] = phone_number;
    json['gender'] = gender;
    return json;
  }
}

class Mini_Bar_Show {
  static const ID = '_id';
  static const NAME = 'name';
  static const PRICE = 'price';

  final String? id;
  final String? name;
  final double? price;

  Mini_Bar_Show({this.id, this.name, this.price});

  factory Mini_Bar_Show.fromJson(Map<String, dynamic> json) => Mini_Bar_Show(
    id: json['_id'] as String?,
    name: json['name'] as String?,
    price: json['price'] as double?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['name'] = name;
    json['price'] = price;
    return json;
  }
}

class Front_Desk_Show {
  static const ID = '_id';

  final String? id;

  Front_Desk_Show({this.id});

  factory Front_Desk_Show.fromJson(Map<String, dynamic> json) => Front_Desk_Show(
    id: json['_id'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    return json;
  }
}
