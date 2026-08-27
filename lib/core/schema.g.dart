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

class Cancel {
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

  Cancel({this.id, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Cancel.fromJson(Map<String, dynamic> json) => Cancel(
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

class Check_Out {
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

  Check_Out({this.id, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Check_Out.fromJson(Map<String, dynamic> json) => Check_Out(
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

class Check_In {
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

  Check_In({this.id, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Check_In.fromJson(Map<String, dynamic> json) => Check_In(
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
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Demo_1({this.id, this.text, this.number, this.date_time, this.logic, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Demo_1.fromJson(Map<String, dynamic> json) => Demo_1(
    id: json['_id'] as String?,
    text: json['text'] as String?,
    number: json['number'] as double?,
    date_time: json['date_time'] == null ? null : DateTime.tryParse(json['date_time'] as String),
    logic: json['logic'] as bool?,
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
    json['text'] = text;
    json['number'] = number;
    json['date_time'] = date_time?.toIso8601String();
    json['logic'] = logic;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by?.toJson();
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by?.toJson();
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
  final User_Show? created_by;
  final Demo_1_Show? bid;
  final String? op;

  Log_Demo_1({this.id, this.text, this.number, this.date_time, this.logic, this.created_at, this.created_by, this.bid, this.op});

  factory Log_Demo_1.fromJson(Map<String, dynamic> json) => Log_Demo_1(
    id: json['_id'] as String?,
    text: json['text'] as String?,
    number: json['number'] as double?,
    date_time: json['date_time'] == null ? null : DateTime.tryParse(json['date_time'] as String),
    logic: json['logic'] as bool?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User_Show.fromJson(json['created_by'] as Map<String, dynamic>),
    bid: json['bid'] == null ? null : Demo_1_Show.fromJson(json['bid'] as Map<String, dynamic>),
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
    json['created_by'] = created_by?.toJson();
    json['bid'] = bid?.toJson();
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
  final Demo_2_2? demo_2_2_id;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Demo_2_1({this.id, this.text, this.number, this.demo_2_2_id, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Demo_2_1.fromJson(Map<String, dynamic> json) => Demo_2_1(
    id: json['_id'] as String?,
    text: json['text'] as String?,
    number: json['number'] as int?,
    demo_2_2_id: json['demo_2_2_id'] == null ? null : Demo_2_2.fromJson(json['demo_2_2_id'] as Map<String, dynamic>),
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
    json['text'] = text;
    json['number'] = number;
    json['demo_2_2_id'] = demo_2_2_id?.toJson();
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by?.toJson();
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by?.toJson();
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
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Demo_2_2({this.id, this.text, this.number, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Demo_2_2.fromJson(Map<String, dynamic> json) => Demo_2_2(
    id: json['_id'] as String?,
    text: json['text'] as String?,
    number: json['number'] as int?,
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
    json['text'] = text;
    json['number'] = number;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by?.toJson();
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by?.toJson();
    return json;
  }
}

class Demo_3_1 {
  static const ID = '_id';
  static const TEXT = 'text';
  static const NUMBER = 'number';
  static const DEMO_3_2_LIST = 'demo_3_2_list';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final String? text;
  final int? number;
  final List<Demo_3_2>? demo_3_2_list;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Demo_3_1({this.id, this.text, this.number, this.demo_3_2_list, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Demo_3_1.fromJson(Map<String, dynamic> json) => Demo_3_1(
    id: json['_id'] as String?,
    text: json['text'] as String?,
    number: json['number'] as int?,
    demo_3_2_list: (json['demo_3_2_list'] as List<dynamic>?)?.map((e) => Demo_3_2.fromJson(e as Map<String, dynamic>)).toList(),
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
    json['text'] = text;
    json['number'] = number;
    json['demo_3_2_list'] = demo_3_2_list?.map((e) => e.toJson()).toList();
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by?.toJson();
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by?.toJson();
    return json;
  }
}

class Demo_3_2 {
  static const ID = '_id';
  static const TEXT = 'text';
  static const NUMBER = 'number';
  static const DEMO_3_1_ID = 'demo_3_1_id';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final String? text;
  final int? number;
  final String? demo_3_1_id;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Demo_3_2({this.id, this.text, this.number, this.demo_3_1_id, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Demo_3_2.fromJson(Map<String, dynamic> json) => Demo_3_2(
    id: json['_id'] as String?,
    text: json['text'] as String?,
    number: json['number'] as int?,
    demo_3_1_id: json['demo_3_1_id'] as String?,
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
    json['text'] = text;
    json['number'] = number;
    json['demo_3_1_id'] = demo_3_1_id;
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
  static const STAY_ID = 'stay_id';
  static const ROOM_PAY_ID = 'room_pay_id';
  static const PENALTY_PAY_ID = 'penalty_pay_id';
  static const MINI_BAR_PAY_ID = 'mini_bar_pay_id';
  static const CHECK_IN_ID = 'check_in_id';
  static const CHECK_OUT_ID = 'check_out_id';
  static const CLEAN_ID = 'clean_id';
  static const CANCEL_ID = 'cancel_id';
  static const CHANGE_ID = 'change_id';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final Room_Show? room_id;
  final Guest_Show? guest_id;
  final Stay_Show? stay_id;
  final Pay_Room_Show? room_pay_id;
  final Penalty_Pay_Show? penalty_pay_id;
  final Mini_Bar_Pay_Show? mini_bar_pay_id;
  final Check_In_Show? check_in_id;
  final Check_Out_Show? check_out_id;
  final Check_Out_Show? clean_id;
  final Cancel_Show? cancel_id;
  final Check_Out_Show? change_id;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Front_Desk({this.id, this.room_id, this.guest_id, this.stay_id, this.room_pay_id, this.penalty_pay_id, this.mini_bar_pay_id, this.check_in_id, this.check_out_id, this.clean_id, this.cancel_id, this.change_id, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Front_Desk.fromJson(Map<String, dynamic> json) => Front_Desk(
    id: json['_id'] as String?,
    room_id: json['room_id'] == null ? null : Room_Show.fromJson(json['room_id'] as Map<String, dynamic>),
    guest_id: json['guest_id'] == null ? null : Guest_Show.fromJson(json['guest_id'] as Map<String, dynamic>),
    stay_id: json['stay_id'] == null ? null : Stay_Show.fromJson(json['stay_id'] as Map<String, dynamic>),
    room_pay_id: json['room_pay_id'] == null ? null : Pay_Room_Show.fromJson(json['room_pay_id'] as Map<String, dynamic>),
    penalty_pay_id: json['penalty_pay_id'] == null ? null : Penalty_Pay_Show.fromJson(json['penalty_pay_id'] as Map<String, dynamic>),
    mini_bar_pay_id: json['mini_bar_pay_id'] == null ? null : Mini_Bar_Pay_Show.fromJson(json['mini_bar_pay_id'] as Map<String, dynamic>),
    check_in_id: json['check_in_id'] == null ? null : Check_In_Show.fromJson(json['check_in_id'] as Map<String, dynamic>),
    check_out_id: json['check_out_id'] == null ? null : Check_Out_Show.fromJson(json['check_out_id'] as Map<String, dynamic>),
    clean_id: json['clean_id'] == null ? null : Check_Out_Show.fromJson(json['clean_id'] as Map<String, dynamic>),
    cancel_id: json['cancel_id'] == null ? null : Cancel_Show.fromJson(json['cancel_id'] as Map<String, dynamic>),
    change_id: json['change_id'] == null ? null : Check_Out_Show.fromJson(json['change_id'] as Map<String, dynamic>),
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
    json['stay_id'] = stay_id?.toJson();
    json['room_pay_id'] = room_pay_id?.toJson();
    json['penalty_pay_id'] = penalty_pay_id?.toJson();
    json['mini_bar_pay_id'] = mini_bar_pay_id?.toJson();
    json['check_in_id'] = check_in_id?.toJson();
    json['check_out_id'] = check_out_id?.toJson();
    json['clean_id'] = clean_id?.toJson();
    json['cancel_id'] = cancel_id?.toJson();
    json['change_id'] = change_id?.toJson();
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
  final String? note;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Guest({this.id, this.full_name, this.phone_number, this.gender, this.nationality_id, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Guest.fromJson(Map<String, dynamic> json) => Guest(
    id: json['_id'] as String?,
    full_name: json['full_name'] as String?,
    phone_number: json['phone_number'] as String?,
    gender: json['gender'] as String?,
    nationality_id: json['nationality_id'] == null ? null : Nationality_Show.fromJson(json['nationality_id'] as Map<String, dynamic>),
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
  final User_Show? created_by;
  final Mini_Bar_Show? bid;
  final String? op;

  Log_Mini_Bar({this.id, this.name, this.price, this.stock, this.note, this.created_at, this.created_by, this.bid, this.op});

  factory Log_Mini_Bar.fromJson(Map<String, dynamic> json) => Log_Mini_Bar(
    id: json['_id'] as String?,
    name: json['name'] as String?,
    price: json['price'] as double?,
    stock: json['stock'] as int?,
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User_Show.fromJson(json['created_by'] as Map<String, dynamic>),
    bid: json['bid'] == null ? null : Mini_Bar_Show.fromJson(json['bid'] as Map<String, dynamic>),
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
    json['created_by'] = created_by?.toJson();
    json['bid'] = bid?.toJson();
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
    stock: json['stock'] as int?,
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

class Log_Mini_Bar_Item {
  static const ID = '_id';
  static const MINI_BAR_ID = 'mini_bar_id';
  static const QUANTITY = 'quantity';
  static const MINI_BAR_PAY_ID = 'mini_bar_pay_id';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const BID = 'bid';
  static const OP = 'op';

  final String? id;
  final Mini_Bar_Show_2? mini_bar_id;
  final int? quantity;
  final Mini_Bar_Pay_Show_2? mini_bar_pay_id;
  final DateTime? created_at;
  final User_Show? created_by;
  final Mini_Bar_Item_Show? bid;
  final String? op;

  Log_Mini_Bar_Item({this.id, this.mini_bar_id, this.quantity, this.mini_bar_pay_id, this.created_at, this.created_by, this.bid, this.op});

  factory Log_Mini_Bar_Item.fromJson(Map<String, dynamic> json) => Log_Mini_Bar_Item(
    id: json['_id'] as String?,
    mini_bar_id: json['mini_bar_id'] == null ? null : Mini_Bar_Show_2.fromJson(json['mini_bar_id'] as Map<String, dynamic>),
    quantity: json['quantity'] as int?,
    mini_bar_pay_id: json['mini_bar_pay_id'] == null ? null : Mini_Bar_Pay_Show_2.fromJson(json['mini_bar_pay_id'] as Map<String, dynamic>),
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User_Show.fromJson(json['created_by'] as Map<String, dynamic>),
    bid: json['bid'] == null ? null : Mini_Bar_Item_Show.fromJson(json['bid'] as Map<String, dynamic>),
    op: json['op'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['mini_bar_id'] = mini_bar_id?.toJson();
    json['quantity'] = quantity;
    json['mini_bar_pay_id'] = mini_bar_pay_id?.toJson();
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['bid'] = bid?.toJson();
    json['op'] = op;
    return json;
  }
}

class Mini_Bar_Item {
  static const ID = '_id';
  static const MINI_BAR_ID = 'mini_bar_id';
  static const QUANTITY = 'quantity';
  static const MINI_BAR_PAY_ID = 'mini_bar_pay_id';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final Mini_Bar_Show_2? mini_bar_id;
  final int? quantity;
  final Mini_Bar_Pay_Show_2? mini_bar_pay_id;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Mini_Bar_Item({this.id, this.mini_bar_id, this.quantity, this.mini_bar_pay_id, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Mini_Bar_Item.fromJson(Map<String, dynamic> json) => Mini_Bar_Item(
    id: json['_id'] as String?,
    mini_bar_id: json['mini_bar_id'] == null ? null : Mini_Bar_Show_2.fromJson(json['mini_bar_id'] as Map<String, dynamic>),
    quantity: json['quantity'] as int?,
    mini_bar_pay_id: json['mini_bar_pay_id'] == null ? null : Mini_Bar_Pay_Show_2.fromJson(json['mini_bar_pay_id'] as Map<String, dynamic>),
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
    json['mini_bar_pay_id'] = mini_bar_pay_id?.toJson();
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by?.toJson();
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by?.toJson();
    return json;
  }
}

class Log_Mini_Bar_Pay {
  static const ID = '_id';
  static const MINI_BAR_LIST = 'mini_bar_list';
  static const PRICE = 'price';
  static const CASH = 'cash';
  static const BANK = 'bank';
  static const NOTE = 'note';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const BID = 'bid';
  static const OP = 'op';

  final String? id;
  final List<Mini_Bar_Item>? mini_bar_list;
  final double? price;
  final double? cash;
  final double? bank;
  final String? note;
  final DateTime? created_at;
  final User_Show? created_by;
  final Mini_Bar_Pay_Show_2? bid;
  final String? op;

  Log_Mini_Bar_Pay({this.id, this.mini_bar_list, this.price, this.cash, this.bank, this.note, this.created_at, this.created_by, this.bid, this.op});

  factory Log_Mini_Bar_Pay.fromJson(Map<String, dynamic> json) => Log_Mini_Bar_Pay(
    id: json['_id'] as String?,
    mini_bar_list: (json['mini_bar_list'] as List<dynamic>?)?.map((e) => Mini_Bar_Item.fromJson(e as Map<String, dynamic>)).toList(),
    price: json['price'] as double?,
    cash: json['cash'] as double?,
    bank: json['bank'] as double?,
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User_Show.fromJson(json['created_by'] as Map<String, dynamic>),
    bid: json['bid'] == null ? null : Mini_Bar_Pay_Show_2.fromJson(json['bid'] as Map<String, dynamic>),
    op: json['op'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['mini_bar_list'] = mini_bar_list?.map((e) => e.toJson()).toList();
    json['price'] = price;
    json['cash'] = cash;
    json['bank'] = bank;
    json['note'] = note;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['bid'] = bid?.toJson();
    json['op'] = op;
    return json;
  }
}

class Mini_Bar_Pay {
  static const ID = '_id';
  static const MINI_BAR_LIST = 'mini_bar_list';
  static const PRICE = 'price';
  static const CASH = 'cash';
  static const BANK = 'bank';
  static const NOTE = 'note';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final List<Mini_Bar_Item>? mini_bar_list;
  final double? price;
  final double? cash;
  final double? bank;
  final String? note;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Mini_Bar_Pay({this.id, this.mini_bar_list, this.price, this.cash, this.bank, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Mini_Bar_Pay.fromJson(Map<String, dynamic> json) => Mini_Bar_Pay(
    id: json['_id'] as String?,
    mini_bar_list: (json['mini_bar_list'] as List<dynamic>?)?.map((e) => Mini_Bar_Item.fromJson(e as Map<String, dynamic>)).toList(),
    price: json['price'] as double?,
    cash: json['cash'] as double?,
    bank: json['bank'] as double?,
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
    json['mini_bar_list'] = mini_bar_list?.map((e) => e.toJson()).toList();
    json['price'] = price;
    json['cash'] = cash;
    json['bank'] = bank;
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
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Penalty({this.id, this.name, this.price, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Penalty.fromJson(Map<String, dynamic> json) => Penalty(
    id: json['_id'] as String?,
    name: json['name'] as String?,
    price: json['price'] as double?,
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

class Log_Penalty_Item {
  static const ID = '_id';
  static const PENALTY_ID = 'penalty_id';
  static const QUANTITY = 'quantity';
  static const PENALTY_PAY_ID = 'penalty_pay_id';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const BID = 'bid';
  static const OP = 'op';

  final String? id;
  final Penalty_Show? penalty_id;
  final int? quantity;
  final Penalty_Pay_Show_2? penalty_pay_id;
  final DateTime? created_at;
  final User_Show? created_by;
  final Penalty_Item_Show? bid;
  final String? op;

  Log_Penalty_Item({this.id, this.penalty_id, this.quantity, this.penalty_pay_id, this.created_at, this.created_by, this.bid, this.op});

  factory Log_Penalty_Item.fromJson(Map<String, dynamic> json) => Log_Penalty_Item(
    id: json['_id'] as String?,
    penalty_id: json['penalty_id'] == null ? null : Penalty_Show.fromJson(json['penalty_id'] as Map<String, dynamic>),
    quantity: json['quantity'] as int?,
    penalty_pay_id: json['penalty_pay_id'] == null ? null : Penalty_Pay_Show_2.fromJson(json['penalty_pay_id'] as Map<String, dynamic>),
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User_Show.fromJson(json['created_by'] as Map<String, dynamic>),
    bid: json['bid'] == null ? null : Penalty_Item_Show.fromJson(json['bid'] as Map<String, dynamic>),
    op: json['op'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['penalty_id'] = penalty_id?.toJson();
    json['quantity'] = quantity;
    json['penalty_pay_id'] = penalty_pay_id?.toJson();
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['bid'] = bid?.toJson();
    json['op'] = op;
    return json;
  }
}

class Penalty_Item {
  static const ID = '_id';
  static const PENALTY_ID = 'penalty_id';
  static const QUANTITY = 'quantity';
  static const PENALTY_PAY_ID = 'penalty_pay_id';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final Penalty_Show? penalty_id;
  final int? quantity;
  final Penalty_Pay_Show_2? penalty_pay_id;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Penalty_Item({this.id, this.penalty_id, this.quantity, this.penalty_pay_id, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Penalty_Item.fromJson(Map<String, dynamic> json) => Penalty_Item(
    id: json['_id'] as String?,
    penalty_id: json['penalty_id'] == null ? null : Penalty_Show.fromJson(json['penalty_id'] as Map<String, dynamic>),
    quantity: json['quantity'] as int?,
    penalty_pay_id: json['penalty_pay_id'] == null ? null : Penalty_Pay_Show_2.fromJson(json['penalty_pay_id'] as Map<String, dynamic>),
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
    json['penalty_id'] = penalty_id?.toJson();
    json['quantity'] = quantity;
    json['penalty_pay_id'] = penalty_pay_id?.toJson();
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by?.toJson();
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by?.toJson();
    return json;
  }
}

class Log_Penalty_Pay {
  static const ID = '_id';
  static const PENALTY_LIST = 'penalty_list';
  static const PRICE = 'price';
  static const CASH = 'cash';
  static const BANK = 'bank';
  static const NOTE = 'note';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const BID = 'bid';
  static const OP = 'op';

  final String? id;
  final List<Penalty_Item>? penalty_list;
  final double? price;
  final double? cash;
  final double? bank;
  final String? note;
  final DateTime? created_at;
  final User_Show? created_by;
  final Penalty_Pay_Show_2? bid;
  final String? op;

  Log_Penalty_Pay({this.id, this.penalty_list, this.price, this.cash, this.bank, this.note, this.created_at, this.created_by, this.bid, this.op});

  factory Log_Penalty_Pay.fromJson(Map<String, dynamic> json) => Log_Penalty_Pay(
    id: json['_id'] as String?,
    penalty_list: (json['penalty_list'] as List<dynamic>?)?.map((e) => Penalty_Item.fromJson(e as Map<String, dynamic>)).toList(),
    price: json['price'] as double?,
    cash: json['cash'] as double?,
    bank: json['bank'] as double?,
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User_Show.fromJson(json['created_by'] as Map<String, dynamic>),
    bid: json['bid'] == null ? null : Penalty_Pay_Show_2.fromJson(json['bid'] as Map<String, dynamic>),
    op: json['op'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['penalty_list'] = penalty_list?.map((e) => e.toJson()).toList();
    json['price'] = price;
    json['cash'] = cash;
    json['bank'] = bank;
    json['note'] = note;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['bid'] = bid?.toJson();
    json['op'] = op;
    return json;
  }
}

class Penalty_Pay {
  static const ID = '_id';
  static const PENALTY_LIST = 'penalty_list';
  static const PRICE = 'price';
  static const CASH = 'cash';
  static const BANK = 'bank';
  static const NOTE = 'note';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final List<Penalty_Item>? penalty_list;
  final double? price;
  final double? cash;
  final double? bank;
  final String? note;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Penalty_Pay({this.id, this.penalty_list, this.price, this.cash, this.bank, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Penalty_Pay.fromJson(Map<String, dynamic> json) => Penalty_Pay(
    id: json['_id'] as String?,
    penalty_list: (json['penalty_list'] as List<dynamic>?)?.map((e) => Penalty_Item.fromJson(e as Map<String, dynamic>)).toList(),
    price: json['price'] as double?,
    cash: json['cash'] as double?,
    bank: json['bank'] as double?,
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
    json['penalty_list'] = penalty_list?.map((e) => e.toJson()).toList();
    json['price'] = price;
    json['cash'] = cash;
    json['bank'] = bank;
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

class Log_Room {
  static const ID = '_id';
  static const NUMBER = 'number';
  static const KIND = 'kind';
  static const PRICE_PER_DAY = 'price_per_day';
  static const PRICE_PER_3H = 'price_per_3h';
  static const STATUS = 'status';
  static const NOTE = 'note';
  static const FRONT_DESKS = 'front_desks';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const BID = 'bid';
  static const OP = 'op';

  final String? id;
  final String? number;
  final String? kind;
  final double? price_per_day;
  final double? price_per_3h;
  final String? status;
  final String? note;
  final List<Front_Desk>? front_desks;
  final DateTime? created_at;
  final User_Show? created_by;
  final Room_Show_2? bid;
  final String? op;

  Log_Room({this.id, this.number, this.kind, this.price_per_day, this.price_per_3h, this.status, this.note, this.front_desks, this.created_at, this.created_by, this.bid, this.op});

  factory Log_Room.fromJson(Map<String, dynamic> json) => Log_Room(
    id: json['_id'] as String?,
    number: json['number'] as String?,
    kind: json['kind'] as String?,
    price_per_day: json['price_per_day'] as double?,
    price_per_3h: json['price_per_3h'] as double?,
    status: json['status'] as String?,
    note: json['note'] as String?,
    front_desks: (json['front_desks'] as List<dynamic>?)?.map((e) => Front_Desk.fromJson(e as Map<String, dynamic>)).toList(),
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User_Show.fromJson(json['created_by'] as Map<String, dynamic>),
    bid: json['bid'] == null ? null : Room_Show_2.fromJson(json['bid'] as Map<String, dynamic>),
    op: json['op'] as String?,
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
    json['front_desks'] = front_desks?.map((e) => e.toJson()).toList();
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['bid'] = bid?.toJson();
    json['op'] = op;
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
  static const FRONT_DESKS = 'front_desks';
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
  final List<Front_Desk>? front_desks;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Room({this.id, this.number, this.kind, this.price_per_day, this.price_per_3h, this.status, this.note, this.front_desks, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Room.fromJson(Map<String, dynamic> json) => Room(
    id: json['_id'] as String?,
    number: json['number'] as String?,
    kind: json['kind'] as String?,
    price_per_day: json['price_per_day'] as double?,
    price_per_3h: json['price_per_3h'] as double?,
    status: json['status'] as String?,
    note: json['note'] as String?,
    front_desks: (json['front_desks'] as List<dynamic>?)?.map((e) => Front_Desk.fromJson(e as Map<String, dynamic>)).toList(),
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
    json['kind'] = kind;
    json['price_per_day'] = price_per_day;
    json['price_per_3h'] = price_per_3h;
    json['status'] = status;
    json['note'] = note;
    json['front_desks'] = front_desks?.map((e) => e.toJson()).toList();
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by?.toJson();
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by?.toJson();
    return json;
  }
}

class Log_Pay_Room {
  static const ID = '_id';
  static const PRICE = 'price';
  static const CASH = 'cash';
  static const BANK = 'bank';
  static const NOTE = 'note';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const BID = 'bid';
  static const OP = 'op';

  final String? id;
  final double? price;
  final double? cash;
  final double? bank;
  final String? note;
  final DateTime? created_at;
  final User_Show? created_by;
  final Pay_Room_Show_2? bid;
  final String? op;

  Log_Pay_Room({this.id, this.price, this.cash, this.bank, this.note, this.created_at, this.created_by, this.bid, this.op});

  factory Log_Pay_Room.fromJson(Map<String, dynamic> json) => Log_Pay_Room(
    id: json['_id'] as String?,
    price: json['price'] as double?,
    cash: json['cash'] as double?,
    bank: json['bank'] as double?,
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User_Show.fromJson(json['created_by'] as Map<String, dynamic>),
    bid: json['bid'] == null ? null : Pay_Room_Show_2.fromJson(json['bid'] as Map<String, dynamic>),
    op: json['op'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['price'] = price;
    json['cash'] = cash;
    json['bank'] = bank;
    json['note'] = note;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    json['bid'] = bid?.toJson();
    json['op'] = op;
    return json;
  }
}

class Pay_Room {
  static const ID = '_id';
  static const PRICE = 'price';
  static const CASH = 'cash';
  static const BANK = 'bank';
  static const NOTE = 'note';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final double? price;
  final double? cash;
  final double? bank;
  final String? note;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Pay_Room({this.id, this.price, this.cash, this.bank, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Pay_Room.fromJson(Map<String, dynamic> json) => Pay_Room(
    id: json['_id'] as String?,
    price: json['price'] as double?,
    cash: json['cash'] as double?,
    bank: json['bank'] as double?,
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
    json['price'] = price;
    json['cash'] = cash;
    json['bank'] = bank;
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
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Server_Side_Event({this.id, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Server_Side_Event.fromJson(Map<String, dynamic> json) => Server_Side_Event(
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

class Stay {
  static const ID = '_id';
  static const DAY = 'day';
  static const HOUR = 'hour';
  static const NUMBER = 'number';
  static const NOTE = 'note';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final int? day;
  final int? hour;
  final int? number;
  final String? note;
  final DateTime? created_at;
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

  Stay({this.id, this.day, this.hour, this.number, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Stay.fromJson(Map<String, dynamic> json) => Stay(
    id: json['_id'] as String?,
    day: json['day'] as int?,
    hour: json['hour'] as int?,
    number: json['number'] as int?,
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
    json['day'] = day;
    json['hour'] = hour;
    json['number'] = number;
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
  final User_Show? created_by;
  final DateTime? updated_at;
  final User_Show? updated_by;
  final DateTime? deleted_at;
  final User_Show? deleted_by;

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
    json['token_type'] = token_type;
    json['access_token'] = access_token;
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
  static const KIND = 'kind';
  static const PRICE_PER_DAY = 'price_per_day';
  static const PRICE_PER_3H = 'price_per_3h';

  final String? id;
  final String? number;
  final String? kind;
  final double? price_per_day;
  final double? price_per_3h;

  Room_Show({this.id, this.number, this.kind, this.price_per_day, this.price_per_3h});

  factory Room_Show.fromJson(Map<String, dynamic> json) => Room_Show(
    id: json['_id'] as String?,
    number: json['number'] as String?,
    kind: json['kind'] as String?,
    price_per_day: json['price_per_day'] as double?,
    price_per_3h: json['price_per_3h'] as double?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['number'] = number;
    json['kind'] = kind;
    json['price_per_day'] = price_per_day;
    json['price_per_3h'] = price_per_3h;
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

class Stay_Show {
  static const ID = '_id';
  static const DAY = 'day';
  static const HOUR = 'hour';
  static const NUMBER = 'number';
  static const NOTE = 'note';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';

  final String? id;
  final int? day;
  final int? hour;
  final int? number;
  final String? note;
  final DateTime? created_at;
  final User? created_by;

  Stay_Show({this.id, this.day, this.hour, this.number, this.note, this.created_at, this.created_by});

  factory Stay_Show.fromJson(Map<String, dynamic> json) => Stay_Show(
    id: json['_id'] as String?,
    day: json['day'] as int?,
    hour: json['hour'] as int?,
    number: json['number'] as int?,
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User.fromJson(json['created_by'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['day'] = day;
    json['hour'] = hour;
    json['number'] = number;
    json['note'] = note;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    return json;
  }
}

class Pay_Room_Show {
  static const ID = '_id';
  static const PRICE = 'price';
  static const CASH = 'cash';
  static const BANK = 'bank';
  static const NOTE = 'note';
  static const CREATED_AT = 'created_at';

  final String? id;
  final double? price;
  final double? cash;
  final double? bank;
  final String? note;
  final DateTime? created_at;

  Pay_Room_Show({this.id, this.price, this.cash, this.bank, this.note, this.created_at});

  factory Pay_Room_Show.fromJson(Map<String, dynamic> json) => Pay_Room_Show(
    id: json['_id'] as String?,
    price: json['price'] as double?,
    cash: json['cash'] as double?,
    bank: json['bank'] as double?,
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['price'] = price;
    json['cash'] = cash;
    json['bank'] = bank;
    json['note'] = note;
    json['created_at'] = created_at?.toIso8601String();
    return json;
  }
}

class Penalty_Pay_Show {
  static const ID = '_id';
  static const PRICE = 'price';
  static const CASH = 'cash';
  static const BANK = 'bank';
  static const NOTE = 'note';
  static const CREATED_AT = 'created_at';

  final String? id;
  final double? price;
  final double? cash;
  final double? bank;
  final String? note;
  final DateTime? created_at;

  Penalty_Pay_Show({this.id, this.price, this.cash, this.bank, this.note, this.created_at});

  factory Penalty_Pay_Show.fromJson(Map<String, dynamic> json) => Penalty_Pay_Show(
    id: json['_id'] as String?,
    price: json['price'] as double?,
    cash: json['cash'] as double?,
    bank: json['bank'] as double?,
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['price'] = price;
    json['cash'] = cash;
    json['bank'] = bank;
    json['note'] = note;
    json['created_at'] = created_at?.toIso8601String();
    return json;
  }
}

class Mini_Bar_Pay_Show {
  static const ID = '_id';
  static const PRICE = 'price';
  static const CASH = 'cash';
  static const BANK = 'bank';
  static const NOTE = 'note';
  static const CREATED_AT = 'created_at';

  final String? id;
  final double? price;
  final double? cash;
  final double? bank;
  final String? note;
  final DateTime? created_at;

  Mini_Bar_Pay_Show({this.id, this.price, this.cash, this.bank, this.note, this.created_at});

  factory Mini_Bar_Pay_Show.fromJson(Map<String, dynamic> json) => Mini_Bar_Pay_Show(
    id: json['_id'] as String?,
    price: json['price'] as double?,
    cash: json['cash'] as double?,
    bank: json['bank'] as double?,
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['price'] = price;
    json['cash'] = cash;
    json['bank'] = bank;
    json['note'] = note;
    json['created_at'] = created_at?.toIso8601String();
    return json;
  }
}

class Check_In_Show {
  static const ID = '_id';
  static const NOTE = 'note';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';

  final String? id;
  final String? note;
  final DateTime? created_at;
  final User? created_by;

  Check_In_Show({this.id, this.note, this.created_at, this.created_by});

  factory Check_In_Show.fromJson(Map<String, dynamic> json) => Check_In_Show(
    id: json['_id'] as String?,
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User.fromJson(json['created_by'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['note'] = note;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    return json;
  }
}

class Check_Out_Show {
  static const ID = '_id';
  static const NOTE = 'note';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';

  final String? id;
  final String? note;
  final DateTime? created_at;
  final User? created_by;

  Check_Out_Show({this.id, this.note, this.created_at, this.created_by});

  factory Check_Out_Show.fromJson(Map<String, dynamic> json) => Check_Out_Show(
    id: json['_id'] as String?,
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User.fromJson(json['created_by'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['note'] = note;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
    return json;
  }
}

class Cancel_Show {
  static const ID = '_id';
  static const NOTE = 'note';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';

  final String? id;
  final String? note;
  final DateTime? created_at;
  final User? created_by;

  Cancel_Show({this.id, this.note, this.created_at, this.created_by});

  factory Cancel_Show.fromJson(Map<String, dynamic> json) => Cancel_Show(
    id: json['_id'] as String?,
    note: json['note'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : User.fromJson(json['created_by'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['note'] = note;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by?.toJson();
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

class Mini_Bar_Pay_Show_2 {
  static const ID = '_id';

  final String? id;

  Mini_Bar_Pay_Show_2({this.id});

  factory Mini_Bar_Pay_Show_2.fromJson(Map<String, dynamic> json) => Mini_Bar_Pay_Show_2(
    id: json['_id'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    return json;
  }
}

class Mini_Bar_Item_Show {
  static const ID = '_id';

  final String? id;

  Mini_Bar_Item_Show({this.id});

  factory Mini_Bar_Item_Show.fromJson(Map<String, dynamic> json) => Mini_Bar_Item_Show(
    id: json['_id'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
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

class Penalty_Pay_Show_2 {
  static const ID = '_id';

  final String? id;

  Penalty_Pay_Show_2({this.id});

  factory Penalty_Pay_Show_2.fromJson(Map<String, dynamic> json) => Penalty_Pay_Show_2(
    id: json['_id'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    return json;
  }
}

class Penalty_Item_Show {
  static const ID = '_id';

  final String? id;

  Penalty_Item_Show({this.id});

  factory Penalty_Item_Show.fromJson(Map<String, dynamic> json) => Penalty_Item_Show(
    id: json['_id'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    return json;
  }
}

class Room_Show_2 {
  static const ID = '_id';

  final String? id;

  Room_Show_2({this.id});

  factory Room_Show_2.fromJson(Map<String, dynamic> json) => Room_Show_2(
    id: json['_id'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    return json;
  }
}

class Pay_Room_Show_2 {
  static const ID = '_id';

  final String? id;

  Pay_Room_Show_2({this.id});

  factory Pay_Room_Show_2.fromJson(Map<String, dynamic> json) => Pay_Room_Show_2(
    id: json['_id'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    return json;
  }
}
