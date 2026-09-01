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
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Bank({this.id, this.name, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
    id: json['_id'] as String?,
    name: json['name'] as String?,
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : (json['created_by'] is Map<String, dynamic> ? User_Show.fromJson(json['created_by'] as Map<String, dynamic>) : json['created_by']),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : (json['updated_by'] is Map<String, dynamic> ? User_Show.fromJson(json['updated_by'] as Map<String, dynamic>) : json['updated_by']),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : (json['deleted_by'] is Map<String, dynamic> ? User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>) : json['deleted_by']),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['name'] = name;
    json['note'] = note;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by == null ? null : updated_by is User_Show ? updated_by.toJson() : updated_by;
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by == null ? null : deleted_by is User_Show ? deleted_by.toJson() : deleted_by;
    return json;
  }
}

class Base {
  static const ID = '_id';

  final String? id;

  Base({this.id});

  factory Base.fromJson(Map<String, dynamic> json) => Base(
    id: json['_id'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    return json;
  }
}

class Demo_1 {
  static const ID = '_id';
  static const TEXT = 'text';
  static const NUMBER = 'number';
  static const DATE_TIME = 'date_time';
  static const LOGIC = 'logic';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final String? text;
  final double? number;
  final DateTime? date_time;
  final bool? logic;
  final DateTime? created_at;
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Demo_1({this.id, this.text, this.number, this.date_time, this.logic, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Demo_1.fromJson(Map<String, dynamic> json) => Demo_1(
    id: json['_id'] as String?,
    text: json['text'] as String?,
    number: json['number'] as double?,
    date_time: json['date_time'] == null ? null : DateTime.tryParse(json['date_time'] as String),
    logic: json['logic'] as bool?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : (json['created_by'] is Map<String, dynamic> ? User_Show.fromJson(json['created_by'] as Map<String, dynamic>) : json['created_by']),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : (json['updated_by'] is Map<String, dynamic> ? User_Show.fromJson(json['updated_by'] as Map<String, dynamic>) : json['updated_by']),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : (json['deleted_by'] is Map<String, dynamic> ? User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>) : json['deleted_by']),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['text'] = text;
    json['number'] = number;
    json['date_time'] = date_time?.toIso8601String();
    json['logic'] = logic;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by == null ? null : updated_by is User_Show ? updated_by.toJson() : updated_by;
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by == null ? null : deleted_by is User_Show ? deleted_by.toJson() : deleted_by;
    return json;
  }
}

class Log_Demo_1 {
  static const ID = '_id';
  static const TEXT = 'text';
  static const NUMBER = 'number';
  static const DATE_TIME = 'date_time';
  static const LOGIC = 'logic';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const BID = 'bid';
  static const OP = 'op';

  final String? id;
  final String? text;
  final double? number;
  final DateTime? date_time;
  final bool? logic;
  final DateTime? created_at;
  final dynamic created_by;
  final dynamic bid;
  final String? op;

  Log_Demo_1({this.id, this.text, this.number, this.date_time, this.logic, this.created_at, this.created_by, this.bid, this.op});

  factory Log_Demo_1.fromJson(Map<String, dynamic> json) => Log_Demo_1(
    id: json['_id'] as String?,
    text: json['text'] as String?,
    number: json['number'] as double?,
    date_time: json['date_time'] == null ? null : DateTime.tryParse(json['date_time'] as String),
    logic: json['logic'] as bool?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : (json['created_by'] is Map<String, dynamic> ? User_Show.fromJson(json['created_by'] as Map<String, dynamic>) : json['created_by']),
    bid: json['bid'] == null ? null : (json['bid'] is Map<String, dynamic> ? Demo_1_Show.fromJson(json['bid'] as Map<String, dynamic>) : json['bid']),
    op: json['op'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['text'] = text;
    json['number'] = number;
    json['date_time'] = date_time?.toIso8601String();
    json['logic'] = logic;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['bid'] = bid == null ? null : bid is Demo_1_Show ? bid.toJson() : bid;
    json['op'] = op;
    return json;
  }
}

class Demo_2_1 {
  static const ID = '_id';
  static const TEXT = 'text';
  static const NUMBER = 'number';
  static const DEMO_2_2_ID = 'demo_2_2_id';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final String? text;
  final int? number;
  final dynamic demo_2_2_id;
  final DateTime? created_at;
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Demo_2_1({this.id, this.text, this.number, this.demo_2_2_id, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Demo_2_1.fromJson(Map<String, dynamic> json) => Demo_2_1(
    id: json['_id'] as String?,
    text: json['text'] as String?,
    number: json['number'] as int?,
    demo_2_2_id: json['demo_2_2_id'] == null ? null : (json['demo_2_2_id'] is Map<String, dynamic> ? Demo_2_2.fromJson(json['demo_2_2_id'] as Map<String, dynamic>) : json['demo_2_2_id']),
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : (json['created_by'] is Map<String, dynamic> ? User_Show.fromJson(json['created_by'] as Map<String, dynamic>) : json['created_by']),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : (json['updated_by'] is Map<String, dynamic> ? User_Show.fromJson(json['updated_by'] as Map<String, dynamic>) : json['updated_by']),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : (json['deleted_by'] is Map<String, dynamic> ? User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>) : json['deleted_by']),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['text'] = text;
    json['number'] = number;
    json['demo_2_2_id'] = demo_2_2_id == null ? null : demo_2_2_id is Demo_2_2 ? demo_2_2_id.toJson() : demo_2_2_id;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by == null ? null : updated_by is User_Show ? updated_by.toJson() : updated_by;
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by == null ? null : deleted_by is User_Show ? deleted_by.toJson() : deleted_by;
    return json;
  }
}

class Demo_2_2 {
  static const ID = '_id';
  static const TEXT = 'text';
  static const NUMBER = 'number';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final String? text;
  final int? number;
  final DateTime? created_at;
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Demo_2_2({this.id, this.text, this.number, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Demo_2_2.fromJson(Map<String, dynamic> json) => Demo_2_2(
    id: json['_id'] as String?,
    text: json['text'] as String?,
    number: json['number'] as int?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : (json['created_by'] is Map<String, dynamic> ? User_Show.fromJson(json['created_by'] as Map<String, dynamic>) : json['created_by']),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : (json['updated_by'] is Map<String, dynamic> ? User_Show.fromJson(json['updated_by'] as Map<String, dynamic>) : json['updated_by']),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : (json['deleted_by'] is Map<String, dynamic> ? User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>) : json['deleted_by']),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['text'] = text;
    json['number'] = number;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by == null ? null : updated_by is User_Show ? updated_by.toJson() : updated_by;
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by == null ? null : deleted_by is User_Show ? deleted_by.toJson() : deleted_by;
    return json;
  }
}

class Demo_3_1 {
  static const ID = '_id';
  static const TEXT = 'text';
  static const NUMBER = 'number';
  static const LIST_DEMO_3_2_ID = 'list_demo_3_2_id';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final String? text;
  final int? number;
  final List<dynamic>? list_demo_3_2_id;
  final DateTime? created_at;
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Demo_3_1({this.id, this.text, this.number, this.list_demo_3_2_id, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Demo_3_1.fromJson(Map<String, dynamic> json) => Demo_3_1(
    id: json['_id'] as String?,
    text: json['text'] as String?,
    number: json['number'] as int?,
    list_demo_3_2_id: (json['list_demo_3_2_id'] as List<dynamic>?)?.map((e) => e is Map<String, dynamic> ? Demo_3_2.fromJson(e) : e).toList(),
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : (json['created_by'] is Map<String, dynamic> ? User_Show.fromJson(json['created_by'] as Map<String, dynamic>) : json['created_by']),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : (json['updated_by'] is Map<String, dynamic> ? User_Show.fromJson(json['updated_by'] as Map<String, dynamic>) : json['updated_by']),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : (json['deleted_by'] is Map<String, dynamic> ? User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>) : json['deleted_by']),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['text'] = text;
    json['number'] = number;
    json['list_demo_3_2_id'] = list_demo_3_2_id?.map((e) => e is Demo_3_2 ? e.toJson() : e).toList();
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by == null ? null : updated_by is User_Show ? updated_by.toJson() : updated_by;
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by == null ? null : deleted_by is User_Show ? deleted_by.toJson() : deleted_by;
    return json;
  }
}

class Demo_3_2 {
  static const ID = '_id';
  static const TEXT = 'text';
  static const NUMBER = 'number';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final String? text;
  final int? number;
  final DateTime? created_at;
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Demo_3_2({this.id, this.text, this.number, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Demo_3_2.fromJson(Map<String, dynamic> json) => Demo_3_2(
    id: json['_id'] as String?,
    text: json['text'] as String?,
    number: json['number'] as int?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : (json['created_by'] is Map<String, dynamic> ? User_Show.fromJson(json['created_by'] as Map<String, dynamic>) : json['created_by']),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : (json['updated_by'] is Map<String, dynamic> ? User_Show.fromJson(json['updated_by'] as Map<String, dynamic>) : json['updated_by']),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : (json['deleted_by'] is Map<String, dynamic> ? User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>) : json['deleted_by']),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['text'] = text;
    json['number'] = number;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by == null ? null : updated_by is User_Show ? updated_by.toJson() : updated_by;
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by == null ? null : deleted_by is User_Show ? deleted_by.toJson() : deleted_by;
    return json;
  }
}

class Front_Desk {
  static const ID = '_id';
  static const ROOM_ID = 'room_id';
  static const GUEST_ID = 'guest_id';
  static const NUMBER_OF_GUEST = 'number_of_guest';
  static const CHECK_IN_AT = 'check_in_at';
  static const CHECK_IN_BY = 'check_in_by';
  static const ROOM_PRICE = 'room_price';
  static const PENALTY_ITEM_ID = 'penalty_item_id';
  static const PENALTY_PRICE = 'penalty_price';
  static const MINI_BAR_ITEM_ID = 'mini_bar_item_id';
  static const MINI_BAR_PRICE = 'mini_bar_price';
  static const PAY_CASH = 'pay_cash';
  static const PAY_BANK = 'pay_bank';
  static const PAY_BALANCE = 'pay_balance';
  static const PAY_NOTE = 'pay_note';
  static const PAY_AT = 'pay_at';
  static const PAY_BY = 'pay_by';
  static const CHECK_OUT_AT = 'check_out_at';
  static const CHECK_OUT_BY = 'check_out_by';
  static const OVERTIME_AT = 'overtime_at';
  static const PREV_FRONT_DESK_ID = 'prev_front_desk_id';
  static const CLEAN_AT = 'clean_at';
  static const CLEAN_BY = 'clean_by';
  static const CHANGE_FROM = 'change_from';
  static const CHANGE_TO = 'change_to';
  static const CHANGE_AT = 'change_at';
  static const CHANGE_BY = 'change_by';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final dynamic room_id;
  final dynamic guest_id;
  final int? number_of_guest;
  final DateTime? check_in_at;
  final dynamic check_in_by;
  final double? room_price;
  final List<dynamic>? penalty_item_id;
  final double? penalty_price;
  final List<dynamic>? mini_bar_item_id;
  final double? mini_bar_price;
  final double? pay_cash;
  final double? pay_bank;
  final double? pay_balance;
  final String? pay_note;
  final DateTime? pay_at;
  final dynamic pay_by;
  final DateTime? check_out_at;
  final dynamic check_out_by;
  final DateTime? overtime_at;
  final dynamic prev_front_desk_id;
  final DateTime? clean_at;
  final dynamic clean_by;
  final dynamic change_from;
  final dynamic change_to;
  final DateTime? change_at;
  final dynamic change_by;
  final DateTime? created_at;
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Front_Desk({this.id, this.room_id, this.guest_id, this.number_of_guest, this.check_in_at, this.check_in_by, this.room_price, this.penalty_item_id, this.penalty_price, this.mini_bar_item_id, this.mini_bar_price, this.pay_cash, this.pay_bank, this.pay_balance, this.pay_note, this.pay_at, this.pay_by, this.check_out_at, this.check_out_by, this.overtime_at, this.prev_front_desk_id, this.clean_at, this.clean_by, this.change_from, this.change_to, this.change_at, this.change_by, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Front_Desk.fromJson(Map<String, dynamic> json) => Front_Desk(
    id: json['_id'] as String?,
    room_id: json['room_id'] == null ? null : (json['room_id'] is Map<String, dynamic> ? Room.fromJson(json['room_id'] as Map<String, dynamic>) : json['room_id']),
    guest_id: json['guest_id'] == null ? null : (json['guest_id'] is Map<String, dynamic> ? Guest.fromJson(json['guest_id'] as Map<String, dynamic>) : json['guest_id']),
    number_of_guest: json['number_of_guest'] as int?,
    check_in_at: json['check_in_at'] == null ? null : DateTime.tryParse(json['check_in_at'] as String),
    check_in_by: json['check_in_by'] == null ? null : (json['check_in_by'] is Map<String, dynamic> ? User_Show.fromJson(json['check_in_by'] as Map<String, dynamic>) : json['check_in_by']),
    room_price: json['room_price'] as double?,
    penalty_item_id: (json['penalty_item_id'] as List<dynamic>?)?.map((e) => e is Map<String, dynamic> ? Penalty_Item.fromJson(e) : e).toList(),
    penalty_price: json['penalty_price'] as double?,
    mini_bar_item_id: (json['mini_bar_item_id'] as List<dynamic>?)?.map((e) => e is Map<String, dynamic> ? Mini_Bar_Item.fromJson(e) : e).toList(),
    mini_bar_price: json['mini_bar_price'] as double?,
    pay_cash: json['pay_cash'] as double?,
    pay_bank: json['pay_bank'] as double?,
    pay_balance: json['pay_balance'] as double?,
    pay_note: json['pay_note'] as String?,
    pay_at: json['pay_at'] == null ? null : DateTime.tryParse(json['pay_at'] as String),
    pay_by: json['pay_by'] == null ? null : (json['pay_by'] is Map<String, dynamic> ? User_Show.fromJson(json['pay_by'] as Map<String, dynamic>) : json['pay_by']),
    check_out_at: json['check_out_at'] == null ? null : DateTime.tryParse(json['check_out_at'] as String),
    check_out_by: json['check_out_by'] == null ? null : (json['check_out_by'] is Map<String, dynamic> ? User_Show.fromJson(json['check_out_by'] as Map<String, dynamic>) : json['check_out_by']),
    overtime_at: json['overtime_at'] == null ? null : DateTime.tryParse(json['overtime_at'] as String),
    prev_front_desk_id: json['prev_front_desk_id'] == null ? null : (json['prev_front_desk_id'] is Map<String, dynamic> ? Front_Desk.fromJson(json['prev_front_desk_id'] as Map<String, dynamic>) : json['prev_front_desk_id']),
    clean_at: json['clean_at'] == null ? null : DateTime.tryParse(json['clean_at'] as String),
    clean_by: json['clean_by'] == null ? null : (json['clean_by'] is Map<String, dynamic> ? User_Show.fromJson(json['clean_by'] as Map<String, dynamic>) : json['clean_by']),
    change_from: json['change_from'] == null ? null : (json['change_from'] is Map<String, dynamic> ? Room_Show.fromJson(json['change_from'] as Map<String, dynamic>) : json['change_from']),
    change_to: json['change_to'] == null ? null : (json['change_to'] is Map<String, dynamic> ? Room_Show.fromJson(json['change_to'] as Map<String, dynamic>) : json['change_to']),
    change_at: json['change_at'] == null ? null : DateTime.tryParse(json['change_at'] as String),
    change_by: json['change_by'] == null ? null : (json['change_by'] is Map<String, dynamic> ? User_Show.fromJson(json['change_by'] as Map<String, dynamic>) : json['change_by']),
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : (json['created_by'] is Map<String, dynamic> ? User_Show.fromJson(json['created_by'] as Map<String, dynamic>) : json['created_by']),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : (json['updated_by'] is Map<String, dynamic> ? User_Show.fromJson(json['updated_by'] as Map<String, dynamic>) : json['updated_by']),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : (json['deleted_by'] is Map<String, dynamic> ? User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>) : json['deleted_by']),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['room_id'] = room_id == null ? null : room_id is Room ? room_id.toJson() : room_id;
    json['guest_id'] = guest_id == null ? null : guest_id is Guest ? guest_id.toJson() : guest_id;
    json['number_of_guest'] = number_of_guest;
    json['check_in_at'] = check_in_at?.toIso8601String();
    json['check_in_by'] = check_in_by == null ? null : check_in_by is User_Show ? check_in_by.toJson() : check_in_by;
    json['room_price'] = room_price;
    json['penalty_item_id'] = penalty_item_id?.map((e) => e is Penalty_Item ? e.toJson() : e).toList();
    json['penalty_price'] = penalty_price;
    json['mini_bar_item_id'] = mini_bar_item_id?.map((e) => e is Mini_Bar_Item ? e.toJson() : e).toList();
    json['mini_bar_price'] = mini_bar_price;
    json['pay_cash'] = pay_cash;
    json['pay_bank'] = pay_bank;
    json['pay_balance'] = pay_balance;
    json['pay_note'] = pay_note;
    json['pay_at'] = pay_at?.toIso8601String();
    json['pay_by'] = pay_by == null ? null : pay_by is User_Show ? pay_by.toJson() : pay_by;
    json['check_out_at'] = check_out_at?.toIso8601String();
    json['check_out_by'] = check_out_by == null ? null : check_out_by is User_Show ? check_out_by.toJson() : check_out_by;
    json['overtime_at'] = overtime_at?.toIso8601String();
    json['prev_front_desk_id'] = prev_front_desk_id == null ? null : prev_front_desk_id is Front_Desk ? prev_front_desk_id.toJson() : prev_front_desk_id;
    json['clean_at'] = clean_at?.toIso8601String();
    json['clean_by'] = clean_by == null ? null : clean_by is User_Show ? clean_by.toJson() : clean_by;
    json['change_from'] = change_from == null ? null : change_from is Room_Show ? change_from.toJson() : change_from;
    json['change_to'] = change_to == null ? null : change_to is Room_Show ? change_to.toJson() : change_to;
    json['change_at'] = change_at?.toIso8601String();
    json['change_by'] = change_by == null ? null : change_by is User_Show ? change_by.toJson() : change_by;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by == null ? null : updated_by is User_Show ? updated_by.toJson() : updated_by;
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by == null ? null : deleted_by is User_Show ? deleted_by.toJson() : deleted_by;
    return json;
  }
}

class Log_Front_Desk {
  static const ID = '_id';
  static const ROOM_ID = 'room_id';
  static const GUEST_ID = 'guest_id';
  static const NUMBER_OF_GUEST = 'number_of_guest';
  static const CHECK_IN_AT = 'check_in_at';
  static const CHECK_IN_BY = 'check_in_by';
  static const ROOM_PRICE = 'room_price';
  static const PENALTY_ITEM_ID = 'penalty_item_id';
  static const PENALTY_PRICE = 'penalty_price';
  static const MINI_BAR_ITEM_ID = 'mini_bar_item_id';
  static const MINI_BAR_PRICE = 'mini_bar_price';
  static const PAY_CASH = 'pay_cash';
  static const PAY_BANK = 'pay_bank';
  static const PAY_BALANCE = 'pay_balance';
  static const PAY_NOTE = 'pay_note';
  static const PAY_AT = 'pay_at';
  static const PAY_BY = 'pay_by';
  static const CHECK_OUT_AT = 'check_out_at';
  static const CHECK_OUT_BY = 'check_out_by';
  static const OVERTIME_AT = 'overtime_at';
  static const PREV_FRONT_DESK_ID = 'prev_front_desk_id';
  static const CLEAN_AT = 'clean_at';
  static const CLEAN_BY = 'clean_by';
  static const CHANGE_FROM = 'change_from';
  static const CHANGE_TO = 'change_to';
  static const CHANGE_AT = 'change_at';
  static const CHANGE_BY = 'change_by';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const BID = 'bid';
  static const OP = 'op';

  final String? id;
  final dynamic room_id;
  final dynamic guest_id;
  final int? number_of_guest;
  final DateTime? check_in_at;
  final dynamic check_in_by;
  final double? room_price;
  final List<dynamic>? penalty_item_id;
  final double? penalty_price;
  final List<dynamic>? mini_bar_item_id;
  final double? mini_bar_price;
  final double? pay_cash;
  final double? pay_bank;
  final double? pay_balance;
  final String? pay_note;
  final DateTime? pay_at;
  final dynamic pay_by;
  final DateTime? check_out_at;
  final dynamic check_out_by;
  final DateTime? overtime_at;
  final dynamic prev_front_desk_id;
  final DateTime? clean_at;
  final dynamic clean_by;
  final dynamic change_from;
  final dynamic change_to;
  final DateTime? change_at;
  final dynamic change_by;
  final DateTime? created_at;
  final dynamic created_by;
  final dynamic bid;
  final String? op;

  Log_Front_Desk({this.id, this.room_id, this.guest_id, this.number_of_guest, this.check_in_at, this.check_in_by, this.room_price, this.penalty_item_id, this.penalty_price, this.mini_bar_item_id, this.mini_bar_price, this.pay_cash, this.pay_bank, this.pay_balance, this.pay_note, this.pay_at, this.pay_by, this.check_out_at, this.check_out_by, this.overtime_at, this.prev_front_desk_id, this.clean_at, this.clean_by, this.change_from, this.change_to, this.change_at, this.change_by, this.created_at, this.created_by, this.bid, this.op});

  factory Log_Front_Desk.fromJson(Map<String, dynamic> json) => Log_Front_Desk(
    id: json['_id'] as String?,
    room_id: json['room_id'] == null ? null : (json['room_id'] is Map<String, dynamic> ? Room.fromJson(json['room_id'] as Map<String, dynamic>) : json['room_id']),
    guest_id: json['guest_id'] == null ? null : (json['guest_id'] is Map<String, dynamic> ? Guest.fromJson(json['guest_id'] as Map<String, dynamic>) : json['guest_id']),
    number_of_guest: json['number_of_guest'] as int?,
    check_in_at: json['check_in_at'] == null ? null : DateTime.tryParse(json['check_in_at'] as String),
    check_in_by: json['check_in_by'] == null ? null : (json['check_in_by'] is Map<String, dynamic> ? User_Show.fromJson(json['check_in_by'] as Map<String, dynamic>) : json['check_in_by']),
    room_price: json['room_price'] as double?,
    penalty_item_id: (json['penalty_item_id'] as List<dynamic>?)?.map((e) => e is Map<String, dynamic> ? Penalty_Item.fromJson(e) : e).toList(),
    penalty_price: json['penalty_price'] as double?,
    mini_bar_item_id: (json['mini_bar_item_id'] as List<dynamic>?)?.map((e) => e is Map<String, dynamic> ? Mini_Bar_Item.fromJson(e) : e).toList(),
    mini_bar_price: json['mini_bar_price'] as double?,
    pay_cash: json['pay_cash'] as double?,
    pay_bank: json['pay_bank'] as double?,
    pay_balance: json['pay_balance'] as double?,
    pay_note: json['pay_note'] as String?,
    pay_at: json['pay_at'] == null ? null : DateTime.tryParse(json['pay_at'] as String),
    pay_by: json['pay_by'] == null ? null : (json['pay_by'] is Map<String, dynamic> ? User_Show.fromJson(json['pay_by'] as Map<String, dynamic>) : json['pay_by']),
    check_out_at: json['check_out_at'] == null ? null : DateTime.tryParse(json['check_out_at'] as String),
    check_out_by: json['check_out_by'] == null ? null : (json['check_out_by'] is Map<String, dynamic> ? User_Show.fromJson(json['check_out_by'] as Map<String, dynamic>) : json['check_out_by']),
    overtime_at: json['overtime_at'] == null ? null : DateTime.tryParse(json['overtime_at'] as String),
    prev_front_desk_id: json['prev_front_desk_id'] == null ? null : (json['prev_front_desk_id'] is Map<String, dynamic> ? Front_Desk.fromJson(json['prev_front_desk_id'] as Map<String, dynamic>) : json['prev_front_desk_id']),
    clean_at: json['clean_at'] == null ? null : DateTime.tryParse(json['clean_at'] as String),
    clean_by: json['clean_by'] == null ? null : (json['clean_by'] is Map<String, dynamic> ? User_Show.fromJson(json['clean_by'] as Map<String, dynamic>) : json['clean_by']),
    change_from: json['change_from'] == null ? null : (json['change_from'] is Map<String, dynamic> ? Room_Show.fromJson(json['change_from'] as Map<String, dynamic>) : json['change_from']),
    change_to: json['change_to'] == null ? null : (json['change_to'] is Map<String, dynamic> ? Room_Show.fromJson(json['change_to'] as Map<String, dynamic>) : json['change_to']),
    change_at: json['change_at'] == null ? null : DateTime.tryParse(json['change_at'] as String),
    change_by: json['change_by'] == null ? null : (json['change_by'] is Map<String, dynamic> ? User_Show.fromJson(json['change_by'] as Map<String, dynamic>) : json['change_by']),
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : (json['created_by'] is Map<String, dynamic> ? User_Show.fromJson(json['created_by'] as Map<String, dynamic>) : json['created_by']),
    bid: json['bid'] == null ? null : (json['bid'] is Map<String, dynamic> ? Front_Desk_Show.fromJson(json['bid'] as Map<String, dynamic>) : json['bid']),
    op: json['op'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['room_id'] = room_id == null ? null : room_id is Room ? room_id.toJson() : room_id;
    json['guest_id'] = guest_id == null ? null : guest_id is Guest ? guest_id.toJson() : guest_id;
    json['number_of_guest'] = number_of_guest;
    json['check_in_at'] = check_in_at?.toIso8601String();
    json['check_in_by'] = check_in_by == null ? null : check_in_by is User_Show ? check_in_by.toJson() : check_in_by;
    json['room_price'] = room_price;
    json['penalty_item_id'] = penalty_item_id?.map((e) => e is Penalty_Item ? e.toJson() : e).toList();
    json['penalty_price'] = penalty_price;
    json['mini_bar_item_id'] = mini_bar_item_id?.map((e) => e is Mini_Bar_Item ? e.toJson() : e).toList();
    json['mini_bar_price'] = mini_bar_price;
    json['pay_cash'] = pay_cash;
    json['pay_bank'] = pay_bank;
    json['pay_balance'] = pay_balance;
    json['pay_note'] = pay_note;
    json['pay_at'] = pay_at?.toIso8601String();
    json['pay_by'] = pay_by == null ? null : pay_by is User_Show ? pay_by.toJson() : pay_by;
    json['check_out_at'] = check_out_at?.toIso8601String();
    json['check_out_by'] = check_out_by == null ? null : check_out_by is User_Show ? check_out_by.toJson() : check_out_by;
    json['overtime_at'] = overtime_at?.toIso8601String();
    json['prev_front_desk_id'] = prev_front_desk_id == null ? null : prev_front_desk_id is Front_Desk ? prev_front_desk_id.toJson() : prev_front_desk_id;
    json['clean_at'] = clean_at?.toIso8601String();
    json['clean_by'] = clean_by == null ? null : clean_by is User_Show ? clean_by.toJson() : clean_by;
    json['change_from'] = change_from == null ? null : change_from is Room_Show ? change_from.toJson() : change_from;
    json['change_to'] = change_to == null ? null : change_to is Room_Show ? change_to.toJson() : change_to;
    json['change_at'] = change_at?.toIso8601String();
    json['change_by'] = change_by == null ? null : change_by is User_Show ? change_by.toJson() : change_by;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['bid'] = bid == null ? null : bid is Front_Desk_Show ? bid.toJson() : bid;
    json['op'] = op;
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
  final int? stock;
  final String? note;
  final DateTime? created_at;
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Mini_Bar({this.id, this.name, this.price, this.stock, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Mini_Bar.fromJson(Map<String, dynamic> json) => Mini_Bar(
    id: json['_id'] as String?,
    name: json['name'] as String?,
    price: json['price'] as double?,
    stock: json['stock'] as int?,
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : (json['created_by'] is Map<String, dynamic> ? User_Show.fromJson(json['created_by'] as Map<String, dynamic>) : json['created_by']),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : (json['updated_by'] is Map<String, dynamic> ? User_Show.fromJson(json['updated_by'] as Map<String, dynamic>) : json['updated_by']),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : (json['deleted_by'] is Map<String, dynamic> ? User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>) : json['deleted_by']),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['name'] = name;
    json['price'] = price;
    json['stock'] = stock;
    json['note'] = note;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by == null ? null : updated_by is User_Show ? updated_by.toJson() : updated_by;
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by == null ? null : deleted_by is User_Show ? deleted_by.toJson() : deleted_by;
    return json;
  }
}

class Penalty {
  static const ID = '_id';
  static const NAME = 'name';
  static const PRICE = 'price';
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
  final String? note;
  final DateTime? created_at;
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Penalty({this.id, this.name, this.price, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Penalty.fromJson(Map<String, dynamic> json) => Penalty(
    id: json['_id'] as String?,
    name: json['name'] as String?,
    price: json['price'] as double?,
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : (json['created_by'] is Map<String, dynamic> ? User_Show.fromJson(json['created_by'] as Map<String, dynamic>) : json['created_by']),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : (json['updated_by'] is Map<String, dynamic> ? User_Show.fromJson(json['updated_by'] as Map<String, dynamic>) : json['updated_by']),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : (json['deleted_by'] is Map<String, dynamic> ? User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>) : json['deleted_by']),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['name'] = name;
    json['price'] = price;
    json['note'] = note;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by == null ? null : updated_by is User_Show ? updated_by.toJson() : updated_by;
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by == null ? null : deleted_by is User_Show ? deleted_by.toJson() : deleted_by;
    return json;
  }
}

class Guest {
  static const ID = '_id';
  static const FULL_NAME = 'full_name';
  static const PHONE_NUMBER = 'phone_number';
  static const GENDER = 'gender';
  static const NATIONALITY_ID = 'nationality_id';
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
  final dynamic nationality_id;
  final String? note;
  final DateTime? created_at;
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Guest({this.id, this.full_name, this.phone_number, this.gender, this.nationality_id, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Guest.fromJson(Map<String, dynamic> json) => Guest(
    id: json['_id'] as String?,
    full_name: json['full_name'] as String?,
    phone_number: json['phone_number'] as String?,
    gender: json['gender'] as String?,
    nationality_id: json['nationality_id'] == null ? null : (json['nationality_id'] is Map<String, dynamic> ? Nationality_Show.fromJson(json['nationality_id'] as Map<String, dynamic>) : json['nationality_id']),
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : (json['created_by'] is Map<String, dynamic> ? User_Show.fromJson(json['created_by'] as Map<String, dynamic>) : json['created_by']),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : (json['updated_by'] is Map<String, dynamic> ? User_Show.fromJson(json['updated_by'] as Map<String, dynamic>) : json['updated_by']),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : (json['deleted_by'] is Map<String, dynamic> ? User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>) : json['deleted_by']),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['full_name'] = full_name;
    json['phone_number'] = phone_number;
    json['gender'] = gender;
    json['nationality_id'] = nationality_id == null ? null : nationality_id is Nationality_Show ? nationality_id.toJson() : nationality_id;
    json['note'] = note;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by == null ? null : updated_by is User_Show ? updated_by.toJson() : updated_by;
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by == null ? null : deleted_by is User_Show ? deleted_by.toJson() : deleted_by;
    return json;
  }
}

class Log_Mini_Bar {
  static const ID = '_id';
  static const NAME = 'name';
  static const PRICE = 'price';
  static const STOCK = 'stock';
  static const NOTE = 'note';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const BID = 'bid';
  static const OP = 'op';

  final String? id;
  final String? name;
  final double? price;
  final int? stock;
  final String? note;
  final DateTime? created_at;
  final dynamic created_by;
  final dynamic bid;
  final String? op;

  Log_Mini_Bar({this.id, this.name, this.price, this.stock, this.note, this.created_at, this.created_by, this.bid, this.op});

  factory Log_Mini_Bar.fromJson(Map<String, dynamic> json) => Log_Mini_Bar(
    id: json['_id'] as String?,
    name: json['name'] as String?,
    price: json['price'] as double?,
    stock: json['stock'] as int?,
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : (json['created_by'] is Map<String, dynamic> ? User_Show.fromJson(json['created_by'] as Map<String, dynamic>) : json['created_by']),
    bid: json['bid'] == null ? null : (json['bid'] is Map<String, dynamic> ? Mini_Bar_Show.fromJson(json['bid'] as Map<String, dynamic>) : json['bid']),
    op: json['op'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['name'] = name;
    json['price'] = price;
    json['stock'] = stock;
    json['note'] = note;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['bid'] = bid == null ? null : bid is Mini_Bar_Show ? bid.toJson() : bid;
    json['op'] = op;
    return json;
  }
}

class Mini_Bar_Item {
  static const ID = '_id';
  static const MINI_BAR_ID = 'mini_bar_id';
  static const QUANTITY = 'quantity';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final dynamic mini_bar_id;
  final int? quantity;
  final DateTime? created_at;
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Mini_Bar_Item({this.id, this.mini_bar_id, this.quantity, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Mini_Bar_Item.fromJson(Map<String, dynamic> json) => Mini_Bar_Item(
    id: json['_id'] as String?,
    mini_bar_id: json['mini_bar_id'] == null ? null : (json['mini_bar_id'] is Map<String, dynamic> ? Mini_Bar_Show_2.fromJson(json['mini_bar_id'] as Map<String, dynamic>) : json['mini_bar_id']),
    quantity: json['quantity'] as int?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : (json['created_by'] is Map<String, dynamic> ? User_Show.fromJson(json['created_by'] as Map<String, dynamic>) : json['created_by']),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : (json['updated_by'] is Map<String, dynamic> ? User_Show.fromJson(json['updated_by'] as Map<String, dynamic>) : json['updated_by']),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : (json['deleted_by'] is Map<String, dynamic> ? User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>) : json['deleted_by']),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['mini_bar_id'] = mini_bar_id == null ? null : mini_bar_id is Mini_Bar_Show_2 ? mini_bar_id.toJson() : mini_bar_id;
    json['quantity'] = quantity;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by == null ? null : updated_by is User_Show ? updated_by.toJson() : updated_by;
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by == null ? null : deleted_by is User_Show ? deleted_by.toJson() : deleted_by;
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
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Nationality({this.id, this.name, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Nationality.fromJson(Map<String, dynamic> json) => Nationality(
    id: json['_id'] as String?,
    name: json['name'] as String?,
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : (json['created_by'] is Map<String, dynamic> ? User_Show.fromJson(json['created_by'] as Map<String, dynamic>) : json['created_by']),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : (json['updated_by'] is Map<String, dynamic> ? User_Show.fromJson(json['updated_by'] as Map<String, dynamic>) : json['updated_by']),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : (json['deleted_by'] is Map<String, dynamic> ? User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>) : json['deleted_by']),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['name'] = name;
    json['note'] = note;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by == null ? null : updated_by is User_Show ? updated_by.toJson() : updated_by;
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by == null ? null : deleted_by is User_Show ? deleted_by.toJson() : deleted_by;
    return json;
  }
}

class Penalty_Item {
  static const ID = '_id';
  static const PENALTY_ID = 'penalty_id';
  static const QUANTITY = 'quantity';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final dynamic penalty_id;
  final int? quantity;
  final DateTime? created_at;
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Penalty_Item({this.id, this.penalty_id, this.quantity, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Penalty_Item.fromJson(Map<String, dynamic> json) => Penalty_Item(
    id: json['_id'] as String?,
    penalty_id: json['penalty_id'] == null ? null : (json['penalty_id'] is Map<String, dynamic> ? Penalty_Show.fromJson(json['penalty_id'] as Map<String, dynamic>) : json['penalty_id']),
    quantity: json['quantity'] as int?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : (json['created_by'] is Map<String, dynamic> ? User_Show.fromJson(json['created_by'] as Map<String, dynamic>) : json['created_by']),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : (json['updated_by'] is Map<String, dynamic> ? User_Show.fromJson(json['updated_by'] as Map<String, dynamic>) : json['updated_by']),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : (json['deleted_by'] is Map<String, dynamic> ? User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>) : json['deleted_by']),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['penalty_id'] = penalty_id == null ? null : penalty_id is Penalty_Show ? penalty_id.toJson() : penalty_id;
    json['quantity'] = quantity;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by == null ? null : updated_by is User_Show ? updated_by.toJson() : updated_by;
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by == null ? null : deleted_by is User_Show ? deleted_by.toJson() : deleted_by;
    return json;
  }
}

class Room {
  static const ID = '_id';
  static const NUMBER = 'number';
  static const KIND = 'kind';
  static const PRICE_PER_DAY = 'price_per_day';
  static const PRICE_PER_3H = 'price_per_3h';
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
  final String? kind;
  final double? price_per_day;
  final double? price_per_3h;
  final String? status;
  final String? note;
  final dynamic front_desk_id;
  final DateTime? created_at;
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Room({this.id, this.number, this.kind, this.price_per_day, this.price_per_3h, this.status, this.note, this.front_desk_id, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Room.fromJson(Map<String, dynamic> json) => Room(
    id: json['_id'] as String?,
    number: json['number'] as String?,
    kind: json['kind'] as String?,
    price_per_day: json['price_per_day'] as double?,
    price_per_3h: json['price_per_3h'] as double?,
    status: json['status'] as String?,
    note: json['note'] as String?,
    front_desk_id: json['front_desk_id'] == null ? null : (json['front_desk_id'] is Map<String, dynamic> ? Front_Desk_Show.fromJson(json['front_desk_id'] as Map<String, dynamic>) : json['front_desk_id']),
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : (json['created_by'] is Map<String, dynamic> ? User_Show.fromJson(json['created_by'] as Map<String, dynamic>) : json['created_by']),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : (json['updated_by'] is Map<String, dynamic> ? User_Show.fromJson(json['updated_by'] as Map<String, dynamic>) : json['updated_by']),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : (json['deleted_by'] is Map<String, dynamic> ? User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>) : json['deleted_by']),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['number'] = number;
    json['kind'] = kind;
    json['price_per_day'] = price_per_day;
    json['price_per_3h'] = price_per_3h;
    json['status'] = status;
    json['note'] = note;
    json['front_desk_id'] = front_desk_id == null ? null : front_desk_id is Front_Desk_Show ? front_desk_id.toJson() : front_desk_id;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by == null ? null : updated_by is User_Show ? updated_by.toJson() : updated_by;
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by == null ? null : deleted_by is User_Show ? deleted_by.toJson() : deleted_by;
    return json;
  }
}

class Server_Side_Event {
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
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Server_Side_Event({this.id, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Server_Side_Event.fromJson(Map<String, dynamic> json) => Server_Side_Event(
    id: json['_id'] as String?,
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : (json['created_by'] is Map<String, dynamic> ? User_Show.fromJson(json['created_by'] as Map<String, dynamic>) : json['created_by']),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : (json['updated_by'] is Map<String, dynamic> ? User_Show.fromJson(json['updated_by'] as Map<String, dynamic>) : json['updated_by']),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : (json['deleted_by'] is Map<String, dynamic> ? User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>) : json['deleted_by']),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['note'] = note;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by == null ? null : updated_by is User_Show ? updated_by.toJson() : updated_by;
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by == null ? null : deleted_by is User_Show ? deleted_by.toJson() : deleted_by;
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
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Setting({this.id, this.key, this.value, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
    id: json['_id'] as String?,
    key: json['key'] as String?,
    value: json['value'],
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : (json['created_by'] is Map<String, dynamic> ? User_Show.fromJson(json['created_by'] as Map<String, dynamic>) : json['created_by']),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : (json['updated_by'] is Map<String, dynamic> ? User_Show.fromJson(json['updated_by'] as Map<String, dynamic>) : json['updated_by']),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : (json['deleted_by'] is Map<String, dynamic> ? User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>) : json['deleted_by']),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['key'] = key;
    json['value'] = value;
    json['note'] = note;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by == null ? null : updated_by is User_Show ? updated_by.toJson() : updated_by;
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by == null ? null : deleted_by is User_Show ? deleted_by.toJson() : deleted_by;
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
  static const TOKEN_TYPE = 'token_type';
  static const ACCESS_TOKEN = 'access_token';
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
  final String? token_type;
  final String? access_token;
  final DateTime? created_at;
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  User({this.id, this.username, this.password, this.full_name, this.phone_number, this.is_admin, this.is_manager, this.is_receptionist, this.is_housekeeper, this.note, this.token_type, this.access_token, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

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
    token_type: json['token_type'] as String?,
    access_token: json['access_token'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : (json['created_by'] is Map<String, dynamic> ? User_Show.fromJson(json['created_by'] as Map<String, dynamic>) : json['created_by']),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : (json['updated_by'] is Map<String, dynamic> ? User_Show.fromJson(json['updated_by'] as Map<String, dynamic>) : json['updated_by']),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : (json['deleted_by'] is Map<String, dynamic> ? User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>) : json['deleted_by']),
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
    json['token_type'] = token_type;
    json['access_token'] = access_token;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by == null ? null : updated_by is User_Show ? updated_by.toJson() : updated_by;
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by == null ? null : deleted_by is User_Show ? deleted_by.toJson() : deleted_by;
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
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

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
    created_by: json['created_by'] == null ? null : (json['created_by'] is Map<String, dynamic> ? User_Show.fromJson(json['created_by'] as Map<String, dynamic>) : json['created_by']),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : (json['updated_by'] is Map<String, dynamic> ? User_Show.fromJson(json['updated_by'] as Map<String, dynamic>) : json['updated_by']),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : (json['deleted_by'] is Map<String, dynamic> ? User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>) : json['deleted_by']),
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
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by == null ? null : updated_by is User_Show ? updated_by.toJson() : updated_by;
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by == null ? null : deleted_by is User_Show ? deleted_by.toJson() : deleted_by;
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
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Web_Socket({this.id, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Web_Socket.fromJson(Map<String, dynamic> json) => Web_Socket(
    id: json['_id'] as String?,
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : (json['created_by'] is Map<String, dynamic> ? User_Show.fromJson(json['created_by'] as Map<String, dynamic>) : json['created_by']),
    updated_at: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    updated_by: json['updated_by'] == null ? null : (json['updated_by'] is Map<String, dynamic> ? User_Show.fromJson(json['updated_by'] as Map<String, dynamic>) : json['updated_by']),
    deleted_at: json['deleted_at'] == null ? null : DateTime.tryParse(json['deleted_at'] as String),
    deleted_by: json['deleted_by'] == null ? null : (json['deleted_by'] is Map<String, dynamic> ? User_Show.fromJson(json['deleted_by'] as Map<String, dynamic>) : json['deleted_by']),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['note'] = note;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by == null ? null : updated_by is User_Show ? updated_by.toJson() : updated_by;
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by == null ? null : deleted_by is User_Show ? deleted_by.toJson() : deleted_by;
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

class Demo_1_Show {
  static const ID = '_id';

  final String? id;

  Demo_1_Show({this.id});

  factory Demo_1_Show.fromJson(Map<String, dynamic> json) => Demo_1_Show(
    id: json['_id'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    return json;
  }
}

class Room_Show {
  static const ID = '_id';
  static const NUMBER = 'number';

  final String? id;
  final String? number;

  Room_Show({this.id, this.number});

  factory Room_Show.fromJson(Map<String, dynamic> json) => Room_Show(
    id: json['_id'] as String?,
    number: json['number'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['number'] = number;
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

class Mini_Bar_Show {
  static const ID = '_id';

  final String? id;

  Mini_Bar_Show({this.id});

  factory Mini_Bar_Show.fromJson(Map<String, dynamic> json) => Mini_Bar_Show(
    id: json['_id'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    return json;
  }
}

class Mini_Bar_Show_2 {
  static const ID = '_id';
  static const NAME = 'name';
  static const PRICE = 'price';

  final String? id;
  final String? name;
  final double? price;

  Mini_Bar_Show_2({this.id, this.name, this.price});

  factory Mini_Bar_Show_2.fromJson(Map<String, dynamic> json) => Mini_Bar_Show_2(
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

class Penalty_Show {
  static const ID = '_id';
  static const NAME = 'name';
  static const PRICE = 'price';

  final String? id;
  final String? name;
  final double? price;

  Penalty_Show({this.id, this.name, this.price});

  factory Penalty_Show.fromJson(Map<String, dynamic> json) => Penalty_Show(
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
