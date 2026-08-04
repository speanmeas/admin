import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart" as theme;
import "package:speanmeas/core/widget/snackbar.dart" as snackbar;

import "__config__.dart";
import "package:speanmeas/features/database/room/schema.g.dart" as r_schema;
import "package:speanmeas/features/database/front_desk/schema.g.dart" as fd_schema;

import "check_in.dart" as check_in;

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
      print(rooms[0]);

      // * ធ្វើបច្ចុប្បន្នភាពចំណុចប្រទាក់អ្នកប្រើប្រាស់
      setState(() {});
    } catch (e) {
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _layout([
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
                    // * លេខបន្ទប់ (កណ្តាល) + ស្ថានភាព (ស្តាំ)
                    Stack(
                      children: [
                        // * លេខបន្ទប់នៅកណ្តាលជានិច្ច
                        Center(
                          child: Text(
                            "${r[r_schema.NUMBER]}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, //
                            ),
                          ),
                        ),

                        // * ស្ថានភាពបន្ទប់នៅខាងស្តាំ
                        (() {
                          var color = Colors.black; // Default color
                          if (r[r_schema.STATUS] == "Available") color = Colors.green;
                          if (r[r_schema.STATUS] == "Pending Pay") color = Colors.orange;
                          if (r[r_schema.STATUS] == "Pending Leave") color = Colors.red;
                          if (r[r_schema.STATUS] == "Pending Clean") color = Colors.black;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.circle, size: 10, color: color),
                              SizedBox(width: 4),
                              Text(
                                "${r[r_schema.STATUS]}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: color, //
                                ),
                              ),

                              // menu
                              MenuAnchor(
                                style: MenuStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                                builder: (context, controller, child) {
                                  return InkWell(
                                    child: Container(
                                      // width: 32,
                                      height: 32,
                                      alignment: Alignment.center,
                                      child: Icon(Icons.more_vert, color: color), //
                                    ), //
                                    onTap: () {
                                      controller.isOpen ? controller.close() : controller.open();
                                    },
                                  );
                                },
                                menuChildren: [
                                  //
                                  if (r[r_schema.STATUS] != "Available")
                                    MenuItemButton(
                                      leadingIcon: Icon(Icons.receipt_outlined, color: Colors.blue),
                                      child: Text("Detail", style: TextStyle(color: Colors.blue)), //
                                      onPressed: () {
                                        // on_summary(r);
                                      }, //
                                    ),

                                  if (r[r_schema.STATUS] != "Available")
                                    MenuItemButton(
                                      leadingIcon: Icon(Icons.swap_horiz_outlined, color: Colors.blue),
                                      child: Text("Change Room", style: TextStyle(color: Colors.blue)),
                                      onPressed: () {}, //
                                    ),

                                  if (r[r_schema.STATUS] != "Available")
                                    MenuItemButton(
                                      leadingIcon: Icon(Icons.cancel_outlined, color: Colors.red),
                                      child: Text("Cancel", style: TextStyle(color: Colors.red)),
                                      onPressed: () {}, //
                                    ),
                                ],
                              ),
                            ],
                          );
                        })(),
                      ],
                    ),

                    //
                    Row(
                      spacing: 4,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${r[r_schema.KIND]}",
                          style: TextStyle(
                            fontSize: 14, //
                            fontWeight: FontWeight.bold, //
                          ),
                        ),

                        Text("-"), //

                        Text(
                          "${r[r_schema.USD_PER_3H]}\$/3Hours",
                          style: TextStyle(
                            fontSize: 14, //
                            fontWeight: FontWeight.bold, //
                          ),
                        ), //

                        Text("-"), //

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
                    if (r["front_desk_id"] != null)
                      Row(
                        spacing: 4,
                        children: [
                          Icon(Icons.person, size: 16), //
                          Text("Guest:", style: TextStyle(fontWeight: FontWeight.bold)), //
                          Text("${r["front_desk_id"][fd_schema.GUEST_FULL_NAME]}", style: TextStyle(color: Colors.blue)), //
                          Text("-"), //
                          Text("${r["front_desk_id"][fd_schema.GUEST_PHONE_NUMBER]}", style: TextStyle(color: Colors.blue)), //

                          InkWell(
                            child: Icon(Icons.edit_outlined, size: 20, color: Colors.blue), //
                            onTap: () {}, //
                          ),
                        ],
                      ),

                    //
                    if (r["front_desk"] != null)
                      Row(
                        spacing: 4,
                        children: [
                          Icon(Icons.calendar_month, size: 16), //
                          Text("Stay:", style: TextStyle(fontWeight: FontWeight.bold)), //
                          Text("2 Persons", style: TextStyle(color: Colors.blue)), //
                          Text("-"), //
                          Text("1 Days", style: TextStyle(color: Colors.blue)), //
                          Text("-"), //
                          Text("0 Hours", style: TextStyle(color: Colors.blue)), //

                          InkWell(
                            child: Icon(Icons.edit_outlined, size: 20, color: Colors.blue), //
                            onTap: () {}, //
                          ),
                        ],
                      ),

                    //
                    if (r["front_desk"] != null)
                      Row(
                        spacing: 4,
                        children: [
                          Icon(Icons.time_to_leave_outlined, size: 16), //
                          Text("Due:", style: TextStyle(fontWeight: FontWeight.bold)), //
                          Text("Monday 2026-08-04 03:00 AM", style: TextStyle(color: Colors.blue)), //
                          // InkWell(
                          //   child: Icon(Icons.edit_outlined, size: 20, color: Colors.blue), //
                          //   onTap: () {}, //
                          // ),
                        ],
                      ),
                    //
                    if (r["front_desk"] != null)
                      Row(
                        spacing: 4,
                        children: [
                          Icon(Icons.login, size: 16), //
                          Text("Check In:", style: TextStyle(fontWeight: FontWeight.bold)), //
                          Text("Monday 2026-08-04 03:00 AM", style: TextStyle(color: Colors.blue)), //
                          // InkWell(
                          //   child: Icon(Icons.edit_outlined, size: 20, color: Colors.blue), //
                          //   onTap: () {}, //
                          // ),
                        ],
                      ),

                    //
                    if (r["front_desk"] != null)
                      Row(
                        spacing: 4,
                        children: [
                          Icon(Icons.payment, size: 16), //
                          Text("Room Payment:", style: TextStyle(fontWeight: FontWeight.bold)), //
                          Text("50\$", style: TextStyle(color: Colors.blue)), //
                          InkWell(
                            child: Icon(Icons.edit_outlined, size: 20, color: Colors.blue), //
                            onTap: () {}, //
                          ),
                          Text("  -  "), //
                          Icon(Icons.payment, size: 16), //
                          Text("Revenue Payment:", style: TextStyle(fontWeight: FontWeight.bold)), //
                          Text("0\$", style: TextStyle(color: Colors.blue)), //
                          InkWell(
                            child: Icon(Icons.edit_outlined, size: 20, color: Colors.blue), //
                            onTap: () {}, //
                          ),
                        ],
                      ),

                    //
                    if (r["front_desk"] != null)
                      Row(
                        spacing: 4,
                        children: [
                          Icon(Icons.logout, size: 16), //
                          Text("Check Out:", style: TextStyle(fontWeight: FontWeight.bold)), //
                          Text("Monday 2026-08-04 03:00 AM", style: TextStyle(color: Colors.blue)), //
                        ],
                      ),

                    //
                    Row(
                      spacing: 4,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (r[r_schema.STATUS] == "Available") //
                          OutlinedButton.icon(
                            onPressed: () => on_check_in(r[r_schema.ID]), //
                            icon: Icon(Icons.login),
                            label: Text("Check In"),
                            style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.green)),
                          ), //

                        if (r[r_schema.STATUS] == "Pending Pay") //
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.payment),
                            label: Text("Payment"),
                            style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.orange)),
                          ), //

                        if (r[r_schema.STATUS] == "Pending Leave") //
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.logout),
                            label: Text("Check Out"),
                            style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.red)),
                          ), //

                        if (r[r_schema.STATUS] == "Pending Clean") //
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.cleaning_services),
                            label: Text("Clean"),
                            style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.black)),
                          ), //
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    ]);
  }

  void on_check_in(String id) async {
    try {
      print("Check In Room ID: $id");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => check_in.Main_(room_id: id), //
        ),
      );

      //
    } catch (e) {
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  Widget _layout(List<Widget> children) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Wrap(
            children: children, //
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

//
class Main_ extends StatefulWidget {
  Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

//
void main() {
  runApp(
    MaterialApp(
      title: HEADER, //
      theme: theme.data(), //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
