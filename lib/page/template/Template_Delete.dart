import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';

void main() {
  runApp(Room_Delete());
}

class Room_Delete extends StatelessWidget {
  Room_Delete({super.key});

  Map<String, dynamic> input = {
    "_id": "69f984897186bcf74f8a5dde", //
    "name": "Room 1",
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Room_Delete_(input: input),
    );
  }
}

class Room_Delete_ extends StatefulWidget {
  Room_Delete_({
    super.key, //
    required this.input,
  });

  final Map<String, dynamic> input;

  @override
  State<Room_Delete_> createState() => _Room_Delete_State();
}

class _Room_Delete_State extends State<Room_Delete_> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Delete Room", //
          style: TextStyle(
            fontSize: 20, //
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.red),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(width: 8),
        ],
        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,
      ),
      body: Center(
        child: Container(
          width: 600,
          alignment: Alignment.center,
          child: ListView(
            children: [
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Delete ", //
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "${widget.input['name']}", //
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " ?", //
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton.icon(
                    icon: Icon(Icons.delete_outlined),
                    label: Text("Delete"),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: () async {
                      await dio
                          .post(
                            '/room/delete',
                            data: FormData.fromMap({
                              "_id": widget.input['_id'], //
                            }),
                          )
                          .then((value) {
                            print(value);
                            show_snackbar(context: context, message: "Room deleted successfully", color: Colors.green);
                            Navigator.pop(context, true);
                          })
                          .catchError((error) {
                            print(error);
                            show_snackbar(context: context, message: "Failed to delete room", color: Colors.red);
                          });
                    },
                    // style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void show_snackbar({
  required BuildContext context, //
  required String message, //
  required Color color, //
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: color,
      ),
    );
}
