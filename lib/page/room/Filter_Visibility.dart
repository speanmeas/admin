import 'package:flutter/material.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

import 'Setup.dart';
import 'Schema.g.dart';

void main() {
  runApp(Filter_Visibility());
}

class Filter_Visibility extends StatelessWidget {
  Filter_Visibility({super.key});

  List<Map<String, dynamic>> _schema = schema;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Filter_Visibility_(schema: _schema),
    );
  }
}

class Filter_Visibility_ extends StatefulWidget {
  Filter_Visibility_({
    super.key, //
    required this.schema,
  });

  List<Map<String, dynamic>> schema;

  @override
  State<Filter_Visibility_> createState() => _Filter_Visibility_State();
}

class _Filter_Visibility_State extends State<Filter_Visibility_> {
  //
  //

  late List<Map<String, dynamic>> output;

  List<int> get _visibleIndices => List<int>.generate(output.length, (index) => index).where((index) => output[index]["is_exclude"] != 1).toList();

  @override
  void initState() {
    super.initState();
    output = List.from(widget.schema);
    // print(output);
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
                itemCount: _visibleIndices.length,
                onReorder: (int old_i, int new_i) {
                  print("Reorder: $old_i -> $new_i");
                  setState(() {
                    final visibleIndices = _visibleIndices;
                    final oldIndex = visibleIndices[old_i];
                    final item = output.removeAt(oldIndex);

                    if (old_i < new_i) {
                      new_i -= 1;
                    }

                    final visibleTargets = _visibleIndices;
                    final insertIndex = new_i >= visibleTargets.length ? output.length : visibleTargets[new_i];

                    output.insert(insertIndex, item);
                  });
                },

                itemBuilder: (context, i) {
                  final outputIndex = _visibleIndices[i];

                  //
                  return InkWell(
                    //
                    key: ValueKey(outputIndex),
                    //
                    onTap: () {
                      print("Tapped: ${output[outputIndex]['title']}");
                      setState(() {
                        output[outputIndex]["is_visible"] = (output[outputIndex]["is_visible"] + 1) % 2;
                      });
                    },
                    //
                    child: Container(
                      height: 40,
                      // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      child: Row(
                        children: [
                          //
                          Icon(output[outputIndex]["is_visible"] == 1 ? Icons.check_box_outlined : Icons.check_box_outline_blank, color: Colors.blue, size: 28), //
                          //
                          SizedBox(width: 4),
                          //
                          Text(
                            "${output[outputIndex]['title']}", //
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
                    onPressed: on_apply,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void on_apply() {
    // validate
    if (output.every((element) => element["is_visible"] == 0)) {
      snackbar_show(
        context: context, //
        message: "Please select at least one column.",
        color: Colors.red,
      );
      return;
    }

    // print(output);

    Navigator.pop(context, output);

    snackbar_show(
      context: context, //
      message: "Visibility updated.",
      color: Colors.green,
    );
  }
}
