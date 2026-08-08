import "package:intl/intl.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/dialog/datetime.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/widget/show_data.dart";

import "../config.dart";
import "package:speanmeas/core/schema/front_desk.g.dart";

import "package:speanmeas/core/schema/room.g.dart";
import "../widget/room_search.dart" as r_search;

import "package:speanmeas/core/schema/guest.g.dart";
import "../widget/guest_search.dart" as g_search;

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Create", //
        style: TextStyle(
          fontSize: 20, //
          fontWeight: FontWeight.bold,
        ),
      ),

      centerTitle: false,
      toolbarHeight: 40,
      titleSpacing: 0,

      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1), //
        child: Divider(height: 1, color: Colors.black),
      ),
    ),
    body: SingleChildScrollView(
      child: Center(
        child: Container(
          width: 600,
          padding: EdgeInsets.all(8),
          child: Column(
            spacing: 8,
            children: children, //
          ),
        ),
      ),
    ),
  );
}

class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  final c_room = TextEditingController();
  final c_guest = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    sm_front_desk.clear();

    if (sm_front_desk.data[sm_front_desk.ROOM_NUMBER]!["value"] != null) //
      c_room.text = sm_front_desk.data[sm_front_desk.ROOM_NUMBER]!["value"];

    if (sm_front_desk.data[sm_front_desk.GUEST_PHONE_NUMBER]!["value"] != null) //
      c_guest.text = sm_front_desk.data[sm_front_desk.GUEST_PHONE_NUMBER]!["value"];
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return _layout([
      for (var e in sm_front_desk.data.entries)
        (() {
          // * search
          if (e.key == sm_front_desk.ROOM_ID) {
            return r_search.Main_(
              controller: c_room,
              onChanged: (v) {
                e.value["value"] = v[sm_room.ID];
                sm_front_desk.data[sm_front_desk.ROOM_NUMBER]!["value"] = v[sm_room.NUMBER];
                sm_front_desk.data[sm_front_desk.ROOM_KIND]!["value"] = v[sm_room.KIND];
                sm_front_desk.data[sm_front_desk.ROOM_USD_PER_3H]!["value"] = v[sm_room.USD_PER_3H];
                sm_front_desk.data[sm_front_desk.ROOM_USD_PER_DAY]!["value"] = v[sm_room.USD_PER_DAY];
                setState(() {});
              },
              onCleared: () {
                e.value["value"] = null;
                sm_front_desk.data[sm_front_desk.ROOM_NUMBER]!["value"] = null;
                sm_front_desk.data[sm_front_desk.ROOM_KIND]!["value"] = null;
                sm_front_desk.data[sm_front_desk.ROOM_USD_PER_3H]!["value"] = null;
                sm_front_desk.data[sm_front_desk.ROOM_USD_PER_DAY]!["value"] = null;
                setState(() {});
              },
            );
          }

          // * search
          if (e.key == sm_front_desk.GUEST_ID) {
            return g_search.Main_(
              controller: c_guest,
              onChanged: (v) {
                e.value["value"] = v[sm_guest.ID];
                sm_front_desk.data[sm_front_desk.GUEST_FULL_NAME]!["value"] = v[sm_guest.FULL_NAME];
                sm_front_desk.data[sm_front_desk.GUEST_GENDER]!["value"] = v[sm_guest.GENDER];
                sm_front_desk.data[sm_front_desk.GUEST_PHONE_NUMBER]!["value"] = v[sm_guest.PHONE_NUMBER];
                sm_front_desk.data[sm_front_desk.GUEST_NATIONALITY]!["value"] = v[sm_guest.NATIONALITY];
                setState(() {});
              },
              onCleared: () {
                e.value["value"] = null;
                sm_front_desk.data[sm_front_desk.GUEST_FULL_NAME]!["value"] = null;
                sm_front_desk.data[sm_front_desk.GUEST_GENDER]!["value"] = null;
                sm_front_desk.data[sm_front_desk.GUEST_PHONE_NUMBER]!["value"] = null;
                sm_front_desk.data[sm_front_desk.GUEST_NATIONALITY]!["value"] = null;
                setState(() {});
              },
            );
          }

          // * lock
          if (e.value["lock"] == true) {
            String value = "";
            if (e.value["value"] != null) value = e.value["value"]?.toString() ?? "";
            return ShowData(
              title: e.value["title"], //
              value: value,
            );
          }

          // * អក្សរ
          if (e.value["type"] == "string") {
            String value = "";
            if (e.value["value"] != null) value = e.value["value"]?.toString() ?? "";
            return TextField(
              controller: TextEditingController(text: value.trim()),
              maxLines: e.key.contains("note") ? 4 : 1,
              decoration: InputDecoration(
                labelText: e.value["title"] + ":", //
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              onChanged: (v) {
                if (v.isEmpty)
                  e.value["value"] = " "; //
                else
                  e.value["value"] = v.trim(); //
              },
            );
          }

          // * លេខ
          if (e.value["type"] == "number") {
            String value = "";
            if (e.value["value"] != null && e.value["value"] != 0) {
              value = e.value["value"].toString();
            }
            return TextField(
              controller: TextEditingController(text: value.trim()),
              decoration: InputDecoration(
                labelText: e.value["title"] + ":", //
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]"))],
              onChanged: (v) {
                e.value["value"] = double.tryParse(v);
              },
            );
          }

          // * ថ្ងៃខែឆ្នាំ និង ម៉ោង
          // todo: clear date-time?
          if (e.value["type"] == "date-time") {
            String value = "";
            if (e.value["value"] != null) {
              DateTime? tmp = DateTime.tryParse(e.value["value"].toString());
              if (tmp != null) {
                value = DateFormat(DATE_FORMAT).format(tmp.toLocal());
              }
            }
            DateTime init = DateTime.now();
            if (DateTime.tryParse(value) != null) {
              init = DateTime.tryParse(value)!;
            }
            return TextField(
              controller: TextEditingController(text: value),
              readOnly: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(), //
                labelText: e.value["title"] + ":", //
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: IconButton(
                    icon: Icon(Icons.clear, color: Colors.red),
                    onPressed: () async {
                      e.value["value"] = "";
                      setState(() {});
                    },
                  ), //
                ),
              ),
              onTap: () async {
                DateTime? datetime = await datetime_picker(context, initial_datetime: init);
                if (datetime == null) return;
                e.value["value"] = datetime.toIso8601String();
                setState(() {});
              }, //,
            );
          }

          // * តក្កវិទ្យា
          if (e.value["type"] == "boolean") {
            String? value;
            if (e.value["value"] != null) {
              if (e.value["value"] == true) value = "Yes";
              if (e.value["value"] == false) value = "No";
            }
            final controller_search = TextEditingController(text: value ?? "");
            return TypeAheadField<String>(
              controller: controller_search,
              suggestionsCallback: (query) => ["Yes", "No"],
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: e.value["title"] + ":", //
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: IconButton(
                        icon: Icon(Icons.clear, color: Colors.red),
                        onPressed: () async {
                          e.value["value"] = "";
                          setState(() {});
                        },
                      ), //
                    ),
                  ),
                );
              },
              itemBuilder: (context, item) => ListTile(title: Text(item)),
              onSelected: (v) {
                controller_search.text = v;
                if (v == "Yes") e.value["value"] = true;
                if (v == "No") e.value["value"] = false;
                setState(() {});
              },
            );
          }

          //
          return SizedBox();
        })(),

      //
      OutlinedButton.icon(
        icon: Icon(Icons.check),
        label: Text("Create"),
        style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
        onPressed: on_create,
      ),

      SizedBox(height: height - 100),
    ]);
  }

  void on_create() async {
    try {
      //
      var payload = {};
      for (var e in sm_front_desk.data.entries) payload[e.key] = e.value["value"];

      //
      tmp = await dio.post("$PATH/create", data: payload);

      //
      Navigator.pop(context, tmp.data[0]);

      //
      snackbar(ct: context, ms: "Success", cl: Colors.green);

      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }
}

class Main_ extends StatefulWidget {
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: HEADER, //
      theme: theme_data, //
      home: const Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
