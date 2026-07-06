import "package:dio/dio.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/Global.dart";
import "package:speanmeas/Environment.dart";
import "package:speanmeas/utility/Dio.dart";
import "package:speanmeas/theme/Theme_Data.dart";
import "package:speanmeas/widget/Datetime_Picker.dart";
import "package:speanmeas/widget/Snackbar_Show.dart";

import "../../__Setup__.dart";
import "../../Constant.dart";
import "../../Schema.g.dart" as schema;

import "Step_3_Staying.dart" as step_3;

import "package:speanmeas/page/guest/Form_Create.dart" as guest_create;
import "package:speanmeas/page/guest/Schema.g.dart" as guest_schema;

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
  // keys

  TextEditingController controller_search = TextEditingController();
  Map<String, dynamic> selected_guest = {};

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    for (var s in schema.data) {
      if (s["key"] == GUEST_NAME) selected_guest[GUEST_NAME] = s["value"] ?? "";
      if (s["key"] == GUEST_GENDER) selected_guest[GUEST_GENDER] = s["value"] ?? "";
      if (s["key"] == GUEST_PHONE_NUMBER) selected_guest[GUEST_PHONE_NUMBER] = s["value"] ?? "";
      if (s["key"] == GUEST_NATIONALITY) selected_guest[GUEST_NATIONALITY] = s["value"] ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "2. Check In - Guest", //
          style: TextStyle(
            fontSize: 20, //
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // if (can_next())
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
                  List<Map<String, dynamic>> guest_datas = [];
                  return TypeAheadField<String>(
                    controller: controller_search,
                    suggestionsCallback: (query) async {
                      String key = GUEST_PHONE_NUMBER;
                      List<String> option_datas = [];
                      await dio
                          .post(
                            "/guest/data_read", //
                            data: FormData.fromMap({
                              "key": key, //
                              "query": query, //
                              "order": 1, //
                              "limit": 1000, //
                            }),
                          )
                          .then((r) {
                            guest_datas = List<Map<String, dynamic>>.from(r.data);

                            for (var g in guest_datas) {
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
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                        decoration: InputDecoration(
                          labelText: "Phone Number:", //
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
                          for (var g in guest_datas) {
                            if (g[GUEST_PHONE_NUMBER] == item) {
                              selected_guest = g;
                              // print(selected_guest);
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
              ...guest_schema.data.map((row) {
                //
                if (row["type"] == "string") {
                  String value = "";
                  if (selected_guest[row["key"]] != null) value = selected_guest[row["key"]]!.toString();
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(row["title"] + ": ", style: TextStyle(fontWeight: FontWeight.bold)),
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
                  String value = "";
                  if (selected_guest[row["key"]] != null) value = selected_guest[row["key"]]!.toString();
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row["title"] + ": ", //
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
                  String value = selected_guest[row["key"]]?.toString() ?? "false";
                  value = value.toLowerCase() == "true" ? "Yes" : "No";
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row["title"] + ": ", //
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
                  String value = selected_guest[row["key"]]?.toString() ?? "";
                  if (value.isNotEmpty) {
                    DateTime? tmp = DateTime.tryParse(value);
                    if (tmp != null) {
                      value = DateFormat(DATE_FORMAT).format(tmp.toLocal());
                    }
                  }
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row["title"] + ": ", //
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
                  label: Text("Create New Guest"),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
                  onPressed: on_add_new,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void on_add_new() async {
    Navigator.push(
      context, //
      MaterialPageRoute(builder: (context) => guest_create.Main_()),
    ).then((value) {
      if (value == null) return;

      controller_search.text = value[GUEST_PHONE_NUMBER] ?? "";
      selected_guest = value;
      setState(() {});
    });
  }

  void on_next() async {
    //

    for (var e in selected_guest.entries) {
      for (var s in schema.data) {
        if (e.key == "_id" && s["key"] == "guest_id") s["value"] = e.value;
        if (e.key == s["key"]) s["value"] = e.value;
      }
    }

    Navigator.push(
      context, //
      MaterialPageRoute(builder: (context) => step_3.Main_()),
    );
  }
}
