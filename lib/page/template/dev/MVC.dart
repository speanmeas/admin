import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(Model());
}

class Model extends StatelessWidget {
  Model({super.key});

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
    controller.get_screen_size(context);
    return Scaffold(
      appBar: AppBar(title: Text(controller.HEADER)),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text(controller.text),

              TextField(
                controller: controller.textfield, //
                decoration: InputDecoration(
                  labelText: "Username", //
                  border: OutlineInputBorder(),
                ),
              ),

              OutlinedButton.icon(
                icon: Icon(Icons.delete_outlined),
                label: Text("Click"),
                onPressed: controller.on_click,
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

  var HEADER = "MVC Template";

  var textfield = TextEditingController();

  var text = "Hello World";

  void on_click() {
    text = textfield.text;
    notifyListeners();
  }

  void get_screen_size(BuildContext context) {
    final screen_size = MediaQuery.sizeOf(context);
    print(screen_size);
  }
}
