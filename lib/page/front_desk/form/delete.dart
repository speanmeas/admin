import "package:flutter/material.dart";
import "package:dio/dio.dart";

import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/__config__.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/widget/datetime_picker.dart";
import "package:speanmeas/widget/snackbar_show.dart";

import "../__config__.dart";
import "../schema.w.dart" as schema_w;

class _Main_State extends State<Main_> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Delete - $HEADER", //
          style: TextStyle(
            fontSize: 20, //
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // * បញ្ជាក់
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                alignment: Alignment.center,
                child: Text("Confirm to delete?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),

              // * ប៊ូតុង Delete
              Container(
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: OutlinedButton.icon(
                  autofocus: true,
                  icon: Icon(Icons.delete_outlined),
                  label: Text("Delete"),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: on_delete,
                  // style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void on_delete() async {
    try {
      // * ធ្វើការស្នើសុំទៅកាន់ Server ដើម្បីលុបទិន្នន័យ
      final r = await dio.post("$PATH/delete", data: FormData.fromMap({"_id": schema_w.data[schema_w.ID]?["value"]}));

      // * បង្ហាញសារថា លុបទិន្នន័យដោយជោគជ័យ
      snackbar_show(context: context, message: "Delete successfully", color: Colors.green);

      // * បិទ Form និងបញ្ជូនតម្លៃ true ទៅកាន់ទំព័រមុន
      Navigator.pop(context, true);

      //
    } catch (e) {
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
    }
  }
}

class Main_ extends StatefulWidget {
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: HEADER, //
      theme: Theme_Data(), //
      home: const Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
