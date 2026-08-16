// dart run build_runner build --delete-conflicting-outputs

import 'package:json_annotation/json_annotation.dart';

part 'json_ser.g.dart';

@JsonSerializable()
class Template {
  final String? id;
  final String? name;
  final int? age;

  Template({this.id, this.name, this.age});

  factory Template.fromJson(Map<String, dynamic> json) => _$From_Json(json);

  Map<String, dynamic> toJson() => _$To_Json(this);
}

void main() {
  // Usage
  final user = Template(id: '1', name: 'Alice');
  final jsonMap = user.toJson();

  // Iterate over all attributes dynamically
  for (var entry in jsonMap.entries) {
    print('${entry.key}: ${entry.value}');
  }
}
