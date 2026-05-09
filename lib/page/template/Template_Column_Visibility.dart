import 'package:flutter/material.dart';
import 'package:speanmeas/page/room/Schema.g.dart';

import 'package:speanmeas/theme/Theme_Data.dart';

void main() {
  runApp(Room_Select_Column_Visibility());
}

class Room_Select_Column_Visibility extends StatelessWidget {
  Room_Select_Column_Visibility({super.key});

  List<Map<String, dynamic>> schema = [
    {"alias": "_id", "title": "ID", "type": "string", "visible": 0},
    {"alias": "name", "title": "Room No.", "type": "string", "visible": 1},
    {"alias": "type", "title": "Room Type", "type": "string", "visible": 1},
    {"alias": "capacity", "title": "Capacity", "type": "number", "visible": 1},
    {"alias": "ac_or_fan", "title": "AC or Fan", "type": "string", "visible": 1},
    {"alias": "price", "title": "Price", "type": "number", "visible": 1},
    {"alias": "status", "title": "Status", "type": "string", "visible": 1},
    {"alias": "created_at", "title": "Created At", "type": "date-time", "visible": 0},
    {"alias": "updated_at", "title": "Updated At", "type": "date-time", "visible": 0},
    {"alias": "deleted_at", "title": "Deleted At", "type": "date-time", "visible": 0},
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Room_Select_Column_Visibility_(schema: schema),
    );
  }
}

class Room_Select_Column_Visibility_ extends StatefulWidget {
  Room_Select_Column_Visibility_({
    super.key, //
    required this.schema,
  });

  List<Map<String, dynamic>> schema;

  @override
  State<Room_Select_Column_Visibility_> createState() => _Room_Select_Column_Visibility_State();
}

class _Room_Select_Column_Visibility_State extends State<Room_Select_Column_Visibility_> {
  //
  //

  late List<Map<String, dynamic>> output;

  @override
  void initState() {
    super.initState();
    output = List.from(widget.schema);
    print(output);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Visibility", //
          style: TextStyle(
            fontSize: 20, //
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.red,
          ),
          SizedBox(width: 4),
        ],
        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,
      ),
      body: Center(
        child: Container(
          width: 600,
          // padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: ListView(
            children: [
              ReorderableListView.builder(
                buildDefaultDragHandles: false,
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                shrinkWrap: true,
                itemCount: output.length,
                onReorder: (int old_i, int new_i) {
                  print("Reorder: $old_i -> $new_i");
                  setState(() {
                    if (old_i < new_i) {
                      new_i -= 1;
                    }
                    final item = output.removeAt(old_i);
                    output.insert(new_i.clamp(0, output.length), item);
                  });
                },

                itemBuilder: (context, i) {
                  //
                  if (["_id", "created_at", "updated_at", "deleted_at"].contains(output[i]['alias'])) {
                    return Container(key: ValueKey(i));
                  }
                  //
                  return InkWell(
                    //
                    key: ValueKey(i),
                    //
                    onTap: () {
                      print("Tapped: ${output[i]['title']}");
                      setState(() {
                        output[i]['visible'] = (output[i]['visible'] + 1) % 2;
                      });
                    },
                    //
                    child: Container(
                      height: 40,
                      // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      child: Row(
                        children: [
                          //
                          Icon(output[i]['visible'] == 1 ? Icons.check_box_outlined : Icons.check_box_outline_blank, color: Colors.blue, size: 28), //
                          //
                          SizedBox(width: 4),
                          //
                          Text(
                            "${output[i]['title']}", //
                            style: TextStyle(fontSize: 16),
                          ),

                          Spacer(),

                          //
                          ReorderableDragStartListener(
                            index: i,
                            child: Icon(Icons.drag_indicator, color: Colors.blue, size: 28), //
                          ),

                          //
                          SizedBox(width: 4),
                        ],
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    icon: Icon(Icons.view_column_outlined),
                    label: Text("Apply"), //
                    onPressed: () {
                      print(output);
                      Navigator.pop(context, output);
                      show_snackbar(context: context, message: "Column updated.", color: Colors.green);
                    },
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
