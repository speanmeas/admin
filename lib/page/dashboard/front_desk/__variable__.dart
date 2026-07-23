import "package:flutter/foundation.dart";

class Variable extends ChangeNotifier {
  // singleton
  static final Variable instance = Variable._();
  Variable._();

  void clear() {
    //

    notifyListeners();

    //
  }
}

Variable variable = Variable.instance;
