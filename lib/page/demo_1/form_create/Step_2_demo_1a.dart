import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/widget/Datetime_Picker.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

import '../Schema.g.dart';

import '../../demo_1a/__Setup__.dart';
import '../../demo_1a/Schema.g.dart' as demo_1a;

import 'Step_3_demo_1b.dart' as step_3;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global.variable, //
      child: Main(),
    ),
  );
}

class Main extends StatelessWidget {
  Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Main_(),
    );
  }
}

class Main_ extends StatefulWidget {
  Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

class _Main_State extends State<Main_> {
  TextEditingController controller_search = TextEditingController();
  Map<String, dynamic>? selected_guest;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create - $HEADER", //
          style: TextStyle(
            fontSize: 20, //
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: OutlinedButton.icon(
              icon: Icon(Icons.arrow_right_alt_outlined),
              label: Text("Next"),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
              onPressed: on_next,
            ),
          ),
        ],
        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // search
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: (() {
                  String key = "ABC";
                  List<Map<String, dynamic>> optionsaaaa = [];
                  return TypeAheadField<String>(
                    controller: controller_search,
                    suggestionsCallback: (query) async {
                      List<String> option_datas = [];
                      await dio
                          .post(
                            '$PATH/data_read', //
                            data: FormData.fromMap({
                              "key": key, //
                              "query": query, //
                              "order": 1, //
                              "limit": 1000, //
                            }),
                          )
                          .then((r) {
                            optionsaaaa = List<Map<String, dynamic>>.from(r.data);

                            for (var g in optionsaaaa) {
                              if (g[key] == null) continue;
                              option_datas.add(g[key] ?? "");
                            }
                          })
                          .catchError((_) {});

                      return option_datas;

                      //
                    },
                    builder: (context, controller, focusNode) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        keyboardType: TextInputType.numberWithOptions(decimal: false),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                        decoration: InputDecoration(
                          labelText: "Search:", //
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Icon(Icons.search), //
                        ),
                        onChanged: (_) => setState(() {}),
                      );
                    },
                    itemBuilder: (context, item) {
                      return ListTile(
                        title: Text(item),
                        onTap: () {
                          for (var g in optionsaaaa) {
                            if (g["ABC"] == item) {
                              selected_guest = g;
                              break;
                            }
                          }

                          controller_search.text = item;
                          FocusScope.of(context).unfocus();
                          setState(() {});
                          // setState(() {});
                        },
                      );
                    },
                    onSelected: (_) {},
                  );
                })(),
              ),

              // phone number - search

              // view search guest result
              ...demo_1a.schema.map((row) {
                //
                if (row["key"] == "note") return SizedBox();

                //
                if (row["type"] == "string") {
                  // String value = "";
                  String value = selected_guest?[row["key"]]?.toString() ?? "";
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(row['title'] + ": ", style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text(
                            value,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 4,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                //
                if (row["type"] == "number") {
                  // String value = "";
                  String value = selected_guest?[row["key"]]?.toString() ?? "";
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row['title'] + ": ", //
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            value,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 4,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                //
                if (row["type"] == "boolean") {
                  // String value = "";
                  String value = selected_guest?[row["key"]]?.toString() ?? "false";
                  value = value.toLowerCase() == "true" ? "Yes" : "No";
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row['title'] + ": ", //
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            value,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 4,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                //
                if (row["type"] == "date-time") {
                  // String value = "";
                  String value = selected_guest?[row["key"]]?.toString() ?? "";
                  if (value.isNotEmpty) {
                    DateTime? tmp = DateTime.tryParse(value);
                    if (tmp != null) {
                      value = DateFormat('yyyy-MM-dd HH:mm:ss').format(tmp.toLocal());
                    }
                  }
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row['title'] + ": ", //
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            value,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 4,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return SizedBox.shrink();
              }),

              // button add new guest
              Container(
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: OutlinedButton.icon(
                  icon: Icon(Icons.person_add_alt_1_outlined),
                  label: Text("Create New"),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void on_next() async {
    //

    // print(demo_1a.schema.map((i) => i["value"]).toList());

    // () {
    // print(model.map((i) => i["value"]).toList());
    Navigator.push(
      context, //
      MaterialPageRoute(
        builder: (context) => step_3.Main_(), //
      ),
    );
    // },

    // print(output);

    // await dio
    //     .post('$PATH/data_create', data: FormData.fromMap({...output}))
    //     .then((r) {
    //       output["id"] = r.data["id"]; //
    //       snackbar_show(context: context, message: "$HEADER create successfully.", color: Colors.green);
    //       Navigator.pop(context, output);
    //     })
    //     .catchError((error) {
    //       snackbar_show(context: context, message: "$HEADER create failed.", color: Colors.red);
    //     });
  }
}
