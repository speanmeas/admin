import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MVC_2.dart' show Controller;

import 'MVC_2.dart';

void main() {
  runApp(MVC_1());
}

class MVC_1 extends StatelessWidget {
  MVC_1({super.key});

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
                label: Text("Gogo Screen 2"),
                onPressed: () => controller.on_click(context),
                // style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),

              OutlinedButton.icon(
                icon: Icon(Icons.class_outlined),
                label: Text("Send Data to Screen 2"),
                onPressed: () => controller.on_send_data(context),
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

  var HEADER = "Screen 1";

  var text = "Hello World";

  void on_click(BuildContext context) {
    Navigator.push(
      context, //
      MaterialPageRoute(builder: (context) => MVC_2()),
    );
    notifyListeners();
  }

  void on_send_data(BuildContext context) {
    final controller = context.read<Controller>();
    controller.text = "Data from Screen 1";
  }
}
