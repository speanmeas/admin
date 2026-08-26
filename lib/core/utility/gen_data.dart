import 'dart:math';

String gen_text() {
  const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  final random = Random();
  return List.generate(10, (_) => chars[random.nextInt(chars.length)]).join();
}

double gen_number() {
  return Random().nextDouble();
}

bool gen_boolean() {
  return Random().nextBool();
}

DateTime gen_datetime() {
  final start = DateTime(2020, 1, 1);
  final end = DateTime(2030, 1, 1);
  final range = end.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
  final randomMillis = start.millisecondsSinceEpoch + (Random().nextDouble() * range).round();
  return DateTime.fromMillisecondsSinceEpoch(randomMillis);
}

// test
void main() {
  for (var i = 0; i < 3; i++) {
    print('text: ${gen_text()}');
    print('number: ${gen_number()}');
    print('boolean: ${gen_boolean()}');
    print('datetime: ${gen_datetime()}');
    print('---');
  }
}
