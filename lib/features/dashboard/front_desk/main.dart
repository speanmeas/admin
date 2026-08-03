import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/snackbar.dart" as snackbar;

import "__config__.dart";
import "package:speanmeas/features/database/room/schema.g.dart" as r_schema;

class _Main_State extends State<Main_> {
  //

  List<Map<String, dynamic>> rooms = [];

  void init() async {
    try {
      // * ទាញយកទិន្នន័យបន្ទប់ទាំងអស់ពីម៉ាស៊ីនមេ
      final r = await dio.post(
        "/room/read", //
        data: {
          "key": r_schema.NUMBER, //
          "order": 1, //
          "limit": 1000,
        },
      );

      // * រក្សាទុកទិន្នន័យបន្ទប់ទៅក្នុងបញ្ជី
      rooms = List<Map<String, dynamic>>.from(r.data);

      // * ធ្វើបច្ចុប្បន្នភាពចំណុចប្រទាក់អ្នកប្រើប្រាស់
      setState(() {});
    } catch (e) {
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Wrap(
            children: [
              // * បង្ហាញបញ្ជីបន្ទប់ទាំងអស់
              for (var r in rooms)
                Container(
                  width: 500,
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
                  child: Row(
                    children: [
                      // info.
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //
                            Row(
                              spacing: 8,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Text("Room", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), //
                                Text(
                                  "${r[r_schema.NUMBER]}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue, //
                                  ),
                                ), //
                              ],
                            ),

                            //
                            Row(
                              spacing: 8,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${r[r_schema.STATUS]}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold, //
                                    color: Colors.green, //
                                  ),
                                ), //
                              ],
                            ),

                            //
                            Row(
                              spacing: 8,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${r[r_schema.USD_PER_3H]}\$/3Hours",
                                  style: TextStyle(
                                    fontSize: 14, //
                                    fontWeight: FontWeight.bold, //
                                  ),
                                ), //
                                Text(
                                  "${r[r_schema.USD_PER_DAY]}\$/Day",
                                  style: TextStyle(
                                    fontSize: 14, //
                                    fontWeight: FontWeight.bold, //
                                  ),
                                ),
                              ],
                            ),

                            //
                            Row(
                              spacing: 8,
                              children: [
                                Text("Guest:", style: TextStyle(fontWeight: FontWeight.bold)), //
                                Text("NAME"), //
                                Text("GENDER"), //
                                Text("PHONE_NUMBER"), //
                                Text("NATIONALITY"), //
                                Text("NOTE", overflow: TextOverflow.ellipsis), //
                              ],
                            ),

                            //
                            Row(
                              spacing: 8,
                              children: [
                                Text("Stay:", style: TextStyle(fontWeight: FontWeight.bold)), //
                                Text("xxxxDays"), //
                                Text("xxxxHours"), //
                                Text("xxxxPersons"), //
                                Text("DUE"), //
                                Text("NOTE", overflow: TextOverflow.ellipsis), //
                              ],
                            ),

                            //
                            Row(
                              spacing: 8,
                              children: [
                                Text("Check In:", style: TextStyle(fontWeight: FontWeight.bold)), //
                                Text("CHECK_IN_DATE"), //
                                Text("CHECK_IN_BY"), //
                                Text("NOTE", overflow: TextOverflow.ellipsis), //
                              ],
                            ),

                            //
                            Row(
                              spacing: 8,
                              children: [
                                Text("Payment Room:", style: TextStyle(fontWeight: FontWeight.bold)), //
                                Text("PRICE"), //
                                Text("PAYMENT"), //
                                Text("GOT_DATE"), //
                                Text("GOT_BY"), //
                                Text("NOTE", overflow: TextOverflow.ellipsis), //
                              ],
                            ),

                            //
                            Row(
                              spacing: 8,
                              children: [
                                Text("Payment Revenue:", style: TextStyle(fontWeight: FontWeight.bold)), //
                                Text("PRICE"), //
                                Text("PAYMENT"), //
                                Text("GOT_DATE"), //
                                Text("GOT_BY"), //
                                Text("NOTE", overflow: TextOverflow.ellipsis), //
                              ],
                            ),

                            //
                            Row(
                              spacing: 8,
                              children: [
                                Text("Check Out:", style: TextStyle(fontWeight: FontWeight.bold)), //
                                Text("CHECK_OUT_DATE"), //
                                Text("CHECK_OUT_BY"), //
                                Text("NOTE", overflow: TextOverflow.ellipsis), //
                              ],
                            ),

                            //
                            Row(
                              spacing: 8,
                              children: [
                                Text("Clean:", style: TextStyle(fontWeight: FontWeight.bold)), //
                                Text("CLEAN_DATE"), //
                                Text("CLEAN_BY"), //
                                Text("NOTE", overflow: TextOverflow.ellipsis), //
                              ],
                            ),

                            //
                            Row(
                              spacing: 2,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () {}, //
                                  icon: Icon(Icons.login),
                                  label: Text("Check In"),
                                  style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.green)),
                                ), //
                                OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.payment),
                                  label: Text("Payment"),
                                  style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.orange)),
                                ), //
                                OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.logout),
                                  label: Text("Check Out"),
                                  style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.red)),
                                ), //
                                OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.cleaning_services),
                                  label: Text("Clean"),
                                  style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.black)),
                                ), //
                                Spacer(), //
                                MenuAnchor(
                                  style: MenuStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                                  builder: (context, controller, child) {
                                    return InkWell(
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        alignment: Alignment.center,
                                        child: Icon(Icons.more_vert, color: Colors.blue), //
                                      ), //
                                      onTap: () {
                                        controller.isOpen ? controller.close() : controller.open();
                                      },
                                    );
                                  },
                                  menuChildren: [
                                    //
                                    MenuItemButton(
                                      leadingIcon: Icon(Icons.receipt_outlined),
                                      child: Text("Summary"),
                                      onPressed: () {
                                        // on_summary(r);
                                      }, //
                                    ),
                                    MenuItemButton(
                                      leadingIcon: Icon(Icons.swap_horiz),
                                      child: Text("Change Room"),
                                      onPressed: () {}, //
                                    ),
                                    MenuItemButton(
                                      leadingIcon: Icon(Icons.edit_outlined),
                                      child: Text("Edit Guest"),
                                      onPressed: () {}, //
                                    ),
                                    MenuItemButton(
                                      leadingIcon: Icon(Icons.edit_outlined),
                                      child: Text("Edit Staying"),
                                      onPressed: () {}, //
                                    ),
                                    MenuItemButton(
                                      leadingIcon: Icon(Icons.edit_outlined),
                                      child: Text("Edit Room Payment"),
                                      onPressed: () {}, //
                                    ),
                                    MenuItemButton(
                                      leadingIcon: Icon(Icons.edit_outlined),
                                      child: Text("Edit Revenue Payment"),
                                      onPressed: () {}, //
                                    ),
                                    MenuItemButton(
                                      leadingIcon: Icon(Icons.cancel_outlined, color: Colors.red),
                                      child: Text("Cancel"),
                                      onPressed: () {}, //
                                    ),
                                  ],
                                ), //
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  //
  @override
  void initState() {
    super.initState();
    init();
  }
}

class Main_ extends StatefulWidget {
  Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: HEADER, //
      theme: data(), //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
