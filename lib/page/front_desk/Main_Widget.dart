import 'package:flutter/material.dart';
import 'package:speanmeas/Environment.dart';

Widget Button_Checkin({
  required VoidCallback? onPressed, //
}) {
  return Container(
    margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
    child: OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.login),
      label: const Text("Check In"), //
    ),
  );
}

Widget Button_Check_Out({
  required VoidCallback? onPressed, //
}) {
  return Container(
    margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
    child: OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.logout),
      label: const Text("Check Out"), //
    ),
  );
}

Widget Button_Clean({
  required VoidCallback? onPressed, //
}) {
  return Container(
    margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
    child: OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.cleaning_services),
      label: const Text("Clean"), //
    ),
  );
}

Widget Room_Status({
  required dynamic room, //
}) {
  return Container(
    alignment: Alignment.centerLeft,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Room ${room['room_number']} (${room['room_type']})", //
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 16),
        Text(
          "${room['status']}",
          style: TextStyle(
            color: room['status'] == "Available"
                ? Colors.green
                : room['status'] == "Dirty"
                ? Colors.orange
                : Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}


// Container(
//                         alignment: Alignment.centerLeft,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Room ${room['room_number']} (${room['room_type']})", //
//                               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                             ),
//                             SizedBox(width: 16),
//                             Text(
//                               "${room['status']}",
//                               style: TextStyle(
//                                 color: room['status'] == "Available"
//                                     ? Colors.green
//                                     : room['status'] == "Dirty"
//                                     ? Colors.orange
//                                     : Colors.red,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),