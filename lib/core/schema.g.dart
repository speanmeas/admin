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
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Cancel({this.id, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Cancel.fromJson(Map<String, dynamic> json) => Cancel(
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

class Change {
  static const ID = '_id';
  static const FROM_ROOM_ID = 'from_room_id';
  static const TO_ROOM_ID = 'to_room_id';
  static const NOTE = 'note';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final dynamic from_room_id;
  final dynamic to_room_id;
  final String? note;
  final DateTime? created_at;
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Change({this.id, this.from_room_id, this.to_room_id, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Change.fromJson(Map<String, dynamic> json) => Change(
    id: json['_id'] as String?,
    from_room_id: json['from_room_id'] == null ? null : (json['from_room_id'] is Map<String, dynamic> ? Room_Show.fromJson(json['from_room_id'] as Map<String, dynamic>) : json['from_room_id']),
    to_room_id: json['to_room_id'] == null ? null : (json['to_room_id'] is Map<String, dynamic> ? Room_Show.fromJson(json['to_room_id'] as Map<String, dynamic>) : json['to_room_id']),
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
    json['from_room_id'] = from_room_id == null ? null : from_room_id is Room_Show ? from_room_id.toJson() : from_room_id;
    json['to_room_id'] = to_room_id == null ? null : to_room_id is Room_Show ? to_room_id.toJson() : to_room_id;
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

class Check_In {
  static const ID = '_id';
  static const NUMBER_OF_GUEST = 'number_of_guest';
  static const NOTE = 'note';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final int? number_of_guest;
  final String? note;
  final DateTime? created_at;
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Check_In({this.id, this.number_of_guest, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Check_In.fromJson(Map<String, dynamic> json) => Check_In(
    id: json['_id'] as String?,
    number_of_guest: json['number_of_guest'] as int?,
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
    json['number_of_guest'] = number_of_guest;
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
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Check_Out({this.id, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Check_Out.fromJson(Map<String, dynamic> json) => Check_Out(
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

class Clean {
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

  Clean({this.id, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Clean.fromJson(Map<String, dynamic> json) => Clean(
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
  static const LIST_DEMO_3_2 = 'list_demo_3_2';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final String? text;
  final int? number;
  final List<Demo_3_2>? list_demo_3_2;
  final DateTime? created_at;
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Demo_3_1({this.id, this.text, this.number, this.list_demo_3_2, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Demo_3_1.fromJson(Map<String, dynamic> json) => Demo_3_1(
    id: json['_id'] as String?,
    text: json['text'] as String?,
    number: json['number'] as int?,
    list_demo_3_2: (json['list_demo_3_2'] as List<dynamic>?)?.map((e) => Demo_3_2.fromJson(e as Map<String, dynamic>)).toList(),
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
    json['list_demo_3_2'] = list_demo_3_2?.map((e) => e.toJson()).toList();
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
  static const CHECK_IN_ID = 'check_in_id';
  static const CHECK_OUT_ID = 'check_out_id';
  static const CLEAN_ID = 'clean_id';
  static const CHANGE_ID = 'change_id';
  static const CANCEL_ID = 'cancel_id';
  static const ROOM_PAY = 'room_pay';
  static const PENALTY_ITEM = 'penalty_item';
  static const PENALTY_PAY = 'penalty_pay';
  static const MINI_BAR_ITEM = 'mini_bar_item';
  static const MINI_BAR_PAY = 'mini_bar_pay';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final dynamic room_id;
  final dynamic guest_id;
  final dynamic check_in_id;
  final dynamic check_out_id;
  final dynamic clean_id;
  final dynamic change_id;
  final dynamic cancel_id;
  final List<Room_Pay>? room_pay;
  final List<Penalty_Item>? penalty_item;
  final List<Penalty_Pay>? penalty_pay;
  final List<Mini_Bar_Item>? mini_bar_item;
  final List<Mini_Bar_Pay>? mini_bar_pay;
  final DateTime? created_at;
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Front_Desk({this.id, this.room_id, this.guest_id, this.check_in_id, this.check_out_id, this.clean_id, this.change_id, this.cancel_id, this.room_pay, this.penalty_item, this.penalty_pay, this.mini_bar_item, this.mini_bar_pay, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Front_Desk.fromJson(Map<String, dynamic> json) => Front_Desk(
    id: json['_id'] as String?,
    room_id: json['room_id'] == null ? null : (json['room_id'] is Map<String, dynamic> ? Room.fromJson(json['room_id'] as Map<String, dynamic>) : json['room_id']),
    guest_id: json['guest_id'] == null ? null : (json['guest_id'] is Map<String, dynamic> ? Guest.fromJson(json['guest_id'] as Map<String, dynamic>) : json['guest_id']),
    check_in_id: json['check_in_id'] == null ? null : (json['check_in_id'] is Map<String, dynamic> ? Check_In.fromJson(json['check_in_id'] as Map<String, dynamic>) : json['check_in_id']),
    check_out_id: json['check_out_id'] == null ? null : (json['check_out_id'] is Map<String, dynamic> ? Check_Out.fromJson(json['check_out_id'] as Map<String, dynamic>) : json['check_out_id']),
    clean_id: json['clean_id'] == null ? null : (json['clean_id'] is Map<String, dynamic> ? Clean.fromJson(json['clean_id'] as Map<String, dynamic>) : json['clean_id']),
    change_id: json['change_id'] == null ? null : (json['change_id'] is Map<String, dynamic> ? Change.fromJson(json['change_id'] as Map<String, dynamic>) : json['change_id']),
    cancel_id: json['cancel_id'] == null ? null : (json['cancel_id'] is Map<String, dynamic> ? Cancel.fromJson(json['cancel_id'] as Map<String, dynamic>) : json['cancel_id']),
    room_pay: (json['room_pay'] as List<dynamic>?)?.map((e) => Room_Pay.fromJson(e as Map<String, dynamic>)).toList(),
    penalty_item: (json['penalty_item'] as List<dynamic>?)?.map((e) => Penalty_Item.fromJson(e as Map<String, dynamic>)).toList(),
    penalty_pay: (json['penalty_pay'] as List<dynamic>?)?.map((e) => Penalty_Pay.fromJson(e as Map<String, dynamic>)).toList(),
    mini_bar_item: (json['mini_bar_item'] as List<dynamic>?)?.map((e) => Mini_Bar_Item.fromJson(e as Map<String, dynamic>)).toList(),
    mini_bar_pay: (json['mini_bar_pay'] as List<dynamic>?)?.map((e) => Mini_Bar_Pay.fromJson(e as Map<String, dynamic>)).toList(),
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
    json['check_in_id'] = check_in_id == null ? null : check_in_id is Check_In ? check_in_id.toJson() : check_in_id;
    json['check_out_id'] = check_out_id == null ? null : check_out_id is Check_Out ? check_out_id.toJson() : check_out_id;
    json['clean_id'] = clean_id == null ? null : clean_id is Clean ? clean_id.toJson() : clean_id;
    json['change_id'] = change_id == null ? null : change_id is Change ? change_id.toJson() : change_id;
    json['cancel_id'] = cancel_id == null ? null : cancel_id is Cancel ? cancel_id.toJson() : cancel_id;
    json['room_pay'] = room_pay?.map((e) => e.toJson()).toList();
    json['penalty_item'] = penalty_item?.map((e) => e.toJson()).toList();
    json['penalty_pay'] = penalty_pay?.map((e) => e.toJson()).toList();
    json['mini_bar_item'] = mini_bar_item?.map((e) => e.toJson()).toList();
    json['mini_bar_pay'] = mini_bar_pay?.map((e) => e.toJson()).toList();
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by == null ? null : updated_by is User_Show ? updated_by.toJson() : updated_by;
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by == null ? null : deleted_by is User_Show ? deleted_by.toJson() : deleted_by;
    return json;
  }
}

class Mini_Bar_Item {
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
  final dynamic mini_bar_id;
  final int? quantity;
  final String? front_desk_id;
  final DateTime? created_at;
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Mini_Bar_Item({this.id, this.mini_bar_id, this.quantity, this.front_desk_id, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Mini_Bar_Item.fromJson(Map<String, dynamic> json) => Mini_Bar_Item(
    id: json['_id'] as String?,
    mini_bar_id: json['mini_bar_id'] == null ? null : (json['mini_bar_id'] is Map<String, dynamic> ? Mini_Bar_Show.fromJson(json['mini_bar_id'] as Map<String, dynamic>) : json['mini_bar_id']),
    quantity: json['quantity'] as int?,
    front_desk_id: json['front_desk_id'] as String?,
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
    json['mini_bar_id'] = mini_bar_id == null ? null : mini_bar_id is Mini_Bar_Show ? mini_bar_id.toJson() : mini_bar_id;
    json['quantity'] = quantity;
    json['front_desk_id'] = front_desk_id;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by == null ? null : updated_by is User_Show ? updated_by.toJson() : updated_by;
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by == null ? null : deleted_by is User_Show ? deleted_by.toJson() : deleted_by;
    return json;
  }
}

class Mini_Bar_Pay {
  static const ID = '_id';
  static const PRICE = 'price';
  static const CASH = 'cash';
  static const BANK = 'bank';
  static const FRONT_DESK_ID = 'front_desk_id';
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
  final String? front_desk_id;
  final DateTime? created_at;
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Mini_Bar_Pay({this.id, this.price, this.cash, this.bank, this.front_desk_id, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Mini_Bar_Pay.fromJson(Map<String, dynamic> json) => Mini_Bar_Pay(
    id: json['_id'] as String?,
    price: json['price'] as double?,
    cash: json['cash'] as double?,
    bank: json['bank'] as double?,
    front_desk_id: json['front_desk_id'] as String?,
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
    json['price'] = price;
    json['cash'] = cash;
    json['bank'] = bank;
    json['front_desk_id'] = front_desk_id;
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
  static const FRONT_DESK_ID = 'front_desk_id';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const UPDATED_AT = 'updated_at';
  static const UPDATED_BY = 'updated_by';
  static const DELETED_AT = 'deleted_at';
  static const DELETED_BY = 'deleted_by';

  final String? id;
  final dynamic penalty_id;
  final int? quantity;
  final String? front_desk_id;
  final DateTime? created_at;
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Penalty_Item({this.id, this.penalty_id, this.quantity, this.front_desk_id, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Penalty_Item.fromJson(Map<String, dynamic> json) => Penalty_Item(
    id: json['_id'] as String?,
    penalty_id: json['penalty_id'] == null ? null : (json['penalty_id'] is Map<String, dynamic> ? Penalty_Show.fromJson(json['penalty_id'] as Map<String, dynamic>) : json['penalty_id']),
    quantity: json['quantity'] as int?,
    front_desk_id: json['front_desk_id'] as String?,
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
    json['front_desk_id'] = front_desk_id;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by == null ? null : updated_by is User_Show ? updated_by.toJson() : updated_by;
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by == null ? null : deleted_by is User_Show ? deleted_by.toJson() : deleted_by;
    return json;
  }
}

class Penalty_Pay {
  static const ID = '_id';
  static const PRICE = 'price';
  static const CASH = 'cash';
  static const BANK = 'bank';
  static const NOTE = 'note';
  static const FRONT_DESK_ID = 'front_desk_id';
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
  final String? front_desk_id;
  final DateTime? created_at;
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Penalty_Pay({this.id, this.price, this.cash, this.bank, this.note, this.front_desk_id, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Penalty_Pay.fromJson(Map<String, dynamic> json) => Penalty_Pay(
    id: json['_id'] as String?,
    price: json['price'] as double?,
    cash: json['cash'] as double?,
    bank: json['bank'] as double?,
    note: json['note'] as String?,
    front_desk_id: json['front_desk_id'] as String?,
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
    json['price'] = price;
    json['cash'] = cash;
    json['bank'] = bank;
    json['note'] = note;
    json['front_desk_id'] = front_desk_id;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['updated_at'] = updated_at?.toIso8601String();
    json['updated_by'] = updated_by == null ? null : updated_by is User_Show ? updated_by.toJson() : updated_by;
    json['deleted_at'] = deleted_at?.toIso8601String();
    json['deleted_by'] = deleted_by == null ? null : deleted_by is User_Show ? deleted_by.toJson() : deleted_by;
    return json;
  }
}

class Room_Pay {
  static const ID = '_id';
  static const PRICE = 'price';
  static const CASH = 'cash';
  static const BANK = 'bank';
  static const NOTE = 'note';
  static const PAID_AT = 'paid_at';
  static const FRONT_DESK_ID = 'front_desk_id';
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
  final DateTime? paid_at;
  final String? front_desk_id;
  final DateTime? created_at;
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Room_Pay({this.id, this.price, this.cash, this.bank, this.note, this.paid_at, this.front_desk_id, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Room_Pay.fromJson(Map<String, dynamic> json) => Room_Pay(
    id: json['_id'] as String?,
    price: json['price'] as double?,
    cash: json['cash'] as double?,
    bank: json['bank'] as double?,
    note: json['note'] as String?,
    paid_at: json['paid_at'] == null ? null : DateTime.tryParse(json['paid_at'] as String),
    front_desk_id: json['front_desk_id'] as String?,
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
    json['price'] = price;
    json['cash'] = cash;
    json['bank'] = bank;
    json['note'] = note;
    json['paid_at'] = paid_at?.toIso8601String();
    json['front_desk_id'] = front_desk_id;
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
  final String? note;
  final DateTime? created_at;
  final dynamic created_by;
  final DateTime? updated_at;
  final dynamic updated_by;
  final DateTime? deleted_at;
  final dynamic deleted_by;

  Guest({this.id, this.full_name, this.phone_number, this.note, this.created_at, this.created_by, this.updated_at, this.updated_by, this.deleted_at, this.deleted_by});

  factory Guest.fromJson(Map<String, dynamic> json) => Guest(
    id: json['_id'] as String?,
    full_name: json['full_name'] as String?,
    phone_number: json['phone_number'] as String?,
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
    bid: json['bid'] == null ? null : (json['bid'] is Map<String, dynamic> ? Mini_Bar_Show_2.fromJson(json['bid'] as Map<String, dynamic>) : json['bid']),
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
    json['bid'] = bid == null ? null : bid is Mini_Bar_Show_2 ? bid.toJson() : bid;
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

class Log_Mini_Bar_Item {
  static const ID = '_id';
  static const MINI_BAR_ID = 'mini_bar_id';
  static const QUANTITY = 'quantity';
  static const FRONT_DESK_ID = 'front_desk_id';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const BID = 'bid';
  static const OP = 'op';

  final String? id;
  final dynamic mini_bar_id;
  final int? quantity;
  final String? front_desk_id;
  final DateTime? created_at;
  final dynamic created_by;
  final dynamic bid;
  final String? op;

  Log_Mini_Bar_Item({this.id, this.mini_bar_id, this.quantity, this.front_desk_id, this.created_at, this.created_by, this.bid, this.op});

  factory Log_Mini_Bar_Item.fromJson(Map<String, dynamic> json) => Log_Mini_Bar_Item(
    id: json['_id'] as String?,
    mini_bar_id: json['mini_bar_id'] == null ? null : (json['mini_bar_id'] is Map<String, dynamic> ? Mini_Bar_Show.fromJson(json['mini_bar_id'] as Map<String, dynamic>) : json['mini_bar_id']),
    quantity: json['quantity'] as int?,
    front_desk_id: json['front_desk_id'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : (json['created_by'] is Map<String, dynamic> ? User_Show.fromJson(json['created_by'] as Map<String, dynamic>) : json['created_by']),
    bid: json['bid'] == null ? null : (json['bid'] is Map<String, dynamic> ? Mini_Bar_Item_Show.fromJson(json['bid'] as Map<String, dynamic>) : json['bid']),
    op: json['op'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['mini_bar_id'] = mini_bar_id == null ? null : mini_bar_id is Mini_Bar_Show ? mini_bar_id.toJson() : mini_bar_id;
    json['quantity'] = quantity;
    json['front_desk_id'] = front_desk_id;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['bid'] = bid == null ? null : bid is Mini_Bar_Item_Show ? bid.toJson() : bid;
    json['op'] = op;
    return json;
  }
}

class Log_Mini_Bar_Pay {
  static const ID = '_id';
  static const PRICE = 'price';
  static const CASH = 'cash';
  static const BANK = 'bank';
  static const FRONT_DESK_ID = 'front_desk_id';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const BID = 'bid';
  static const OP = 'op';

  final String? id;
  final double? price;
  final double? cash;
  final double? bank;
  final String? front_desk_id;
  final DateTime? created_at;
  final dynamic created_by;
  final dynamic bid;
  final String? op;

  Log_Mini_Bar_Pay({this.id, this.price, this.cash, this.bank, this.front_desk_id, this.created_at, this.created_by, this.bid, this.op});

  factory Log_Mini_Bar_Pay.fromJson(Map<String, dynamic> json) => Log_Mini_Bar_Pay(
    id: json['_id'] as String?,
    price: json['price'] as double?,
    cash: json['cash'] as double?,
    bank: json['bank'] as double?,
    front_desk_id: json['front_desk_id'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : (json['created_by'] is Map<String, dynamic> ? User_Show.fromJson(json['created_by'] as Map<String, dynamic>) : json['created_by']),
    bid: json['bid'] == null ? null : (json['bid'] is Map<String, dynamic> ? Mini_Bar_Pay_Show.fromJson(json['bid'] as Map<String, dynamic>) : json['bid']),
    op: json['op'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['price'] = price;
    json['cash'] = cash;
    json['bank'] = bank;
    json['front_desk_id'] = front_desk_id;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['bid'] = bid == null ? null : bid is Mini_Bar_Pay_Show ? bid.toJson() : bid;
    json['op'] = op;
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

class Log_Penalty_Item {
  static const ID = '_id';
  static const PENALTY_ID = 'penalty_id';
  static const QUANTITY = 'quantity';
  static const FRONT_DESK_ID = 'front_desk_id';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const BID = 'bid';
  static const OP = 'op';

  final String? id;
  final dynamic penalty_id;
  final int? quantity;
  final String? front_desk_id;
  final DateTime? created_at;
  final dynamic created_by;
  final dynamic bid;
  final String? op;

  Log_Penalty_Item({this.id, this.penalty_id, this.quantity, this.front_desk_id, this.created_at, this.created_by, this.bid, this.op});

  factory Log_Penalty_Item.fromJson(Map<String, dynamic> json) => Log_Penalty_Item(
    id: json['_id'] as String?,
    penalty_id: json['penalty_id'] == null ? null : (json['penalty_id'] is Map<String, dynamic> ? Penalty_Show.fromJson(json['penalty_id'] as Map<String, dynamic>) : json['penalty_id']),
    quantity: json['quantity'] as int?,
    front_desk_id: json['front_desk_id'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : (json['created_by'] is Map<String, dynamic> ? User_Show.fromJson(json['created_by'] as Map<String, dynamic>) : json['created_by']),
    bid: json['bid'] == null ? null : (json['bid'] is Map<String, dynamic> ? Penalty_Item_Show.fromJson(json['bid'] as Map<String, dynamic>) : json['bid']),
    op: json['op'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['penalty_id'] = penalty_id == null ? null : penalty_id is Penalty_Show ? penalty_id.toJson() : penalty_id;
    json['quantity'] = quantity;
    json['front_desk_id'] = front_desk_id;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['bid'] = bid == null ? null : bid is Penalty_Item_Show ? bid.toJson() : bid;
    json['op'] = op;
    return json;
  }
}

class Log_Penalty_Pay {
  static const ID = '_id';
  static const PRICE = 'price';
  static const CASH = 'cash';
  static const BANK = 'bank';
  static const NOTE = 'note';
  static const FRONT_DESK_ID = 'front_desk_id';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const BID = 'bid';
  static const OP = 'op';

  final String? id;
  final double? price;
  final double? cash;
  final double? bank;
  final String? note;
  final String? front_desk_id;
  final DateTime? created_at;
  final dynamic created_by;
  final dynamic bid;
  final String? op;

  Log_Penalty_Pay({this.id, this.price, this.cash, this.bank, this.note, this.front_desk_id, this.created_at, this.created_by, this.bid, this.op});

  factory Log_Penalty_Pay.fromJson(Map<String, dynamic> json) => Log_Penalty_Pay(
    id: json['_id'] as String?,
    price: json['price'] as double?,
    cash: json['cash'] as double?,
    bank: json['bank'] as double?,
    note: json['note'] as String?,
    front_desk_id: json['front_desk_id'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : (json['created_by'] is Map<String, dynamic> ? User_Show.fromJson(json['created_by'] as Map<String, dynamic>) : json['created_by']),
    bid: json['bid'] == null ? null : (json['bid'] is Map<String, dynamic> ? Penalty_Pay_Show.fromJson(json['bid'] as Map<String, dynamic>) : json['bid']),
    op: json['op'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['price'] = price;
    json['cash'] = cash;
    json['bank'] = bank;
    json['note'] = note;
    json['front_desk_id'] = front_desk_id;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['bid'] = bid == null ? null : bid is Penalty_Pay_Show ? bid.toJson() : bid;
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

class Log_Room_Pay {
  static const ID = '_id';
  static const PRICE = 'price';
  static const CASH = 'cash';
  static const BANK = 'bank';
  static const NOTE = 'note';
  static const PAID_AT = 'paid_at';
  static const FRONT_DESK_ID = 'front_desk_id';
  static const CREATED_AT = 'created_at';
  static const CREATED_BY = 'created_by';
  static const BID = 'bid';
  static const OP = 'op';

  final String? id;
  final double? price;
  final double? cash;
  final double? bank;
  final String? note;
  final DateTime? paid_at;
  final String? front_desk_id;
  final DateTime? created_at;
  final dynamic created_by;
  final dynamic bid;
  final String? op;

  Log_Room_Pay({this.id, this.price, this.cash, this.bank, this.note, this.paid_at, this.front_desk_id, this.created_at, this.created_by, this.bid, this.op});

  factory Log_Room_Pay.fromJson(Map<String, dynamic> json) => Log_Room_Pay(
    id: json['_id'] as String?,
    price: json['price'] as double?,
    cash: json['cash'] as double?,
    bank: json['bank'] as double?,
    note: json['note'] as String?,
    paid_at: json['paid_at'] == null ? null : DateTime.tryParse(json['paid_at'] as String),
    front_desk_id: json['front_desk_id'] as String?,
    created_at: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    created_by: json['created_by'] == null ? null : (json['created_by'] is Map<String, dynamic> ? User_Show.fromJson(json['created_by'] as Map<String, dynamic>) : json['created_by']),
    bid: json['bid'] == null ? null : (json['bid'] is Map<String, dynamic> ? Room_Pay_Show.fromJson(json['bid'] as Map<String, dynamic>) : json['bid']),
    op: json['op'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    json['price'] = price;
    json['cash'] = cash;
    json['bank'] = bank;
    json['note'] = note;
    json['paid_at'] = paid_at?.toIso8601String();
    json['front_desk_id'] = front_desk_id;
    json['created_at'] = created_at?.toIso8601String();
    json['created_by'] = created_by == null ? null : created_by is User_Show ? created_by.toJson() : created_by;
    json['bid'] = bid == null ? null : bid is Room_Pay_Show ? bid.toJson() : bid;
    json['op'] = op;
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

class Mini_Bar_Show_2 {
  static const ID = '_id';

  final String? id;

  Mini_Bar_Show_2({this.id});

  factory Mini_Bar_Show_2.fromJson(Map<String, dynamic> json) => Mini_Bar_Show_2(
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

class Mini_Bar_Pay_Show {
  static const ID = '_id';

  final String? id;

  Mini_Bar_Pay_Show({this.id});

  factory Mini_Bar_Pay_Show.fromJson(Map<String, dynamic> json) => Mini_Bar_Pay_Show(
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

class Penalty_Pay_Show {
  static const ID = '_id';

  final String? id;

  Penalty_Pay_Show({this.id});

  factory Penalty_Pay_Show.fromJson(Map<String, dynamic> json) => Penalty_Pay_Show(
    id: json['_id'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
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

class Room_Pay_Show {
  static const ID = '_id';

  final String? id;

  Room_Pay_Show({this.id});

  factory Room_Pay_Show.fromJson(Map<String, dynamic> json) => Room_Pay_Show(
    id: json['_id'] as String?,
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_id'] = id;
    return json;
  }
}
