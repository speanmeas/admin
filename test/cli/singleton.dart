import "package:flutter/foundation.dart";

class Singleton extends ChangeNotifier {
  // singleton
  static final Singleton instance = Singleton._();
  Singleton._();

  // constants
  String VERSION = "0.0.0+0";
  double RATE = 4000; // 1 USD = 4000 KHR

  // pages
  // String body = "Front Desk";
  String body = "User";

  //

  void clear() {
    body = "Front Desk";
    notifyListeners();
  }
}

Singleton global = Singleton.instance;

void main() {
  // test singleton

  Singleton global1 = Singleton.instance;
  Singleton global2 = Singleton.instance;

  print(global1 == global2); // true
  print(global1.body); // User
  print(global2.body); // User

  global1.body = "Admin";
  print(global1.body); // Admin
  print(global2.body); // Admin

  global2.clear();
  print(global1.body); // Front Desk
  print(global2.body); // Front Desk
}
