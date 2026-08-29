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
        titlePadding: const EdgeInsets.all(4),
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
              // create stay
              dynamic tmp_cin = await dio.post(
                endpoint.CHECK_IN_CREATE,
                data: {
                  Check_In.NUMBER: stay_number, //
                },
              );

              //  create room pay
              dynamic tmp_rp = await dio.post(
                endpoint.ROOM_PAY_CREATE,
                data: {
                  Room_Pay.PRICE: price_per_day, //
                },
              );

              // create front desk
              dynamic tmp_fd = await dio.post(
                endpoint.FRONT_DESK_CREATE,
                data: {
                  Front_Desk.ROOM_ID: room_id, //
                  Front_Desk.CHECK_IN_ID: tmp_cin.data[0][Check_In.ID], //
                  Front_Desk.ROOM_PAY_ID: tmp_rp.data[0][Room_Pay.ID], //
                },
              );
              // update

              // update room status to occupied
              await dio.post(
                endpoint.ROOM_UPDATE,
                data: {
                  Room.ID: room_id, //
                  Room.STATUS: "Occupied", //
                  Room.FRONT_DESK_ID: tmp_fd.data[0][Front_Desk.ID], //
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
