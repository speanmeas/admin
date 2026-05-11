import 'package:flutter/material.dart';

import 'package:speanmeas/theme/Theme_Data.dart';

import 'Initialize.dart';
import 'Schema.g.dart';

void main() {
  runApp(Select_Visibility());
}

class Select_Visibility extends StatelessWidget {
  Select_Visibility({super.key});

  List<Map<String, dynamic>> _schema = schema;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Select_Visibility_(schema: _schema),
    );
  }
}

class Select_Visibility_ extends StatefulWidget {
  Select_Visibility_({
    super.key, //
    required this.schema,
  });

  List<Map<String, dynamic>> schema;

  @override
  State<Select_Visibility_> createState() => _Select_Visibility_State();
}

class _Select_Visibility_State extends State<Select_Visibility_> {
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
          "Visibility $HEADER", //
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
