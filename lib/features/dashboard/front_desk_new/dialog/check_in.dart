import "package:flutter/material.dart";

import "package:speanmeas/core/utility/all.dart";
import "package:speanmeas/core/widget/select/select_dynamic.dart";

// * បង្ហាញ dialog សម្រាប់ជ្រើសរើសលេខទំព័រ
Future<bool?> dialog_check_in({
  required BuildContext context, //
  required String lead,
  required String room_id, //
  required double price_per_day, //
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      int stay_number = 1;

      return AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        alignment: Alignment.topCenter,
        titlePadding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
        contentPadding: const EdgeInsets.all(4),
        actionsPadding: const EdgeInsets.all(4),
        actionsAlignment: MainAxisAlignment.center,
        title: Row(
          mainAxisAlignment: .center,
          children: [
            Text(
              lead, //
              style: TextStyle(
                fontSize: 20, //
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        //
        content: SizedBox(
          width: 400,
          // height: 100,
          child: Column(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(height: 1, color: Colors.grey),

              // * ជ្រើសរើសចំនួនភ្ញៀវ
              Select_Dynamic(
                lead: "Number of Guests:",
                init: stay_number, //
                options: List.generate(10, (index) => index + 1),
                prefixIcon: Icons.people_outline, //
                onChanged: (v) {
                  stay_number = v;
                  // setState(() {});
                },
              ),

              // Text("Please confirm the check-in."), //
            ],
          ),
        ),
        //
        actions: [
          OutlinedButton.icon(
            // autofocus: true,
            style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
            icon: const Icon(Icons.login_outlined), //
            label: const Text("Check In"),
            onPressed: () async {
              // create stay (Front_Desk + Check_In child, sets check_in_id)
              dynamic tmp_fd = await dio.post(
                endpoint.FRONT_DESK_CHECK_IN,
                data: {
                  "room_id": room_id, //
                  "number_of_guest": stay_number, //
                },
              );
              if (tmp_fd == null) return snackbar(ct: context, ms: "Error: Check-In", cl: Colors.red);
              String fd_id = tmp_fd.data[0][Front_Desk.ID];

              // set starting room price on the stay (records a Room_Pay row)
              await dio.post(
                endpoint.FRONT_DESK_UPDATE_ROOM_PAY,
                data: {
                  Front_Desk.ID: fd_id, //
                  "price": price_per_day, //
                  "cash": 0, //
                  "bank": 0, //
                },
              );

              // update room status to occupied
              await dio.post(
                endpoint.ROOM_UPDATE,
                data: {
                  Room.ID: room_id, //
                  Room.STATUS: "Occupied", //
                  Room.FRONT_DESK_ID: fd_id, //
                },
              );

              snackbar(ct: context, ms: "Success", cl: Colors.green);
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  );
  return result;
}

class _Main_State extends State<Main_> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
          onPressed: () async {
            final v = await dialog_check_in(
              context: context, //
              room_id: "111111111122222222223333", //
              price_per_day: 100.0, //
              lead: "Check-In to Room 201", //
            );
            if (v == null) return;
            // page = v;
            pprint(v);
            setState(() {});
          },
          child: const Text("Show"),
        ),
      ),
    );
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
      home: Main_(), //
      theme: theme_data, //
      title: "Development", //
      debugShowCheckedModeBanner: false, //
    ),
  );
}
