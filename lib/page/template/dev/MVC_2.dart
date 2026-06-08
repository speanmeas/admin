import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MVC_1.dart';

void main() {
  runApp(MVC_2());
}

class MVC_2 extends StatelessWidget {
  MVC_2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(), //
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: (_) => Controller(),
        child: Builder(
          builder: (context) {
            return View();
          },
        ),
      ),
    );
  }
}

class View extends StatelessWidget {
  const View({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<Controller>();
    return Scaffold(
      appBar: AppBar(title: Text(controller.HEADER)),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text(controller.text),

              OutlinedButton.icon(
                icon: Icon(Icons.class_outlined),
                label: Text("Gogo Screen 1"),
                onPressed: () => controller.on_click(context),
                // style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Controller extends ChangeNotifier {
  //

  var HEADER = "Screen 2";

  String _text = "Hello World";

  String get text => _text;

  set text(String value) {
    _text = value;
    notifyListeners();
  }

  void on_click(BuildContext context) {
    Navigator.push(
      context, //
      MaterialPageRoute(builder: (context) => MVC_1()),
    );
    notifyListeners();
  }
}
