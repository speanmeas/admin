class Person {
  String name;
  int age;
  bool isStudent;

  Person({required this.name, required this.age, required this.isStudent});

  Map<String, dynamic> toJson() {
    return {"name": name, "age": age, "isStudent": isStudent};
  }
}

void main() {
  final person = Person(name: "John", age: 20, isStudent: true);

  print(person.toJson());

  // Print all attributes
  person.toJson().forEach((key, value) {
    print("$key = $value");
  });
}
