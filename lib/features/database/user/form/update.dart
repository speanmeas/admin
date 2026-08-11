import "package:intl/intl.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/config.dart";
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/dialog/datetime.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/widget/showdata.dart";

import "package:speanmeas/core/schema/user.g.dart";

import "../widget/password_input.dart" as p_input;

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Update", //
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

  final c_password = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    try {
      sm_user.clear();

      tmp = await dio.post(
        endpoint.USER_READ_ID, //
        data: {sm_user.ID: widget.id},
      );
      for (var e in sm_user.data.entries) e.value["value"] = tmp.data[0][e.key];

      setState(() {});
      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return _layout([
      for (var e in sm_user.data.entries)
        (() {
          // * password input
          if (e.key == sm_user.PASSWORD) {
            return p_input.Main_(
              controller: c_password,
              onChanged: (v) {
                e.value["value"] = v;
                setState(() {});
              },
              onCleared: () {
                e.value["value"] = null;
                setState(() {});
              },
            );
          }

          // * lock
          if (e.value["lock"] == true) {
            String value = "";
            if (e.value["value"] != null) //
              value = e.value["value"].toString();
            return Show_Data(
              title: e.value["title"], //
              value: value,
            );
          }

          // * អក្សរ
          if (e.value["type"] == "string") {
            String value = "";
            if (e.value["value"] != null) //
              value = e.value["value"].toString();
            if (e.key == "password") //
              value = "";
            return TextField(
              controller: TextEditingController(text: value.trim()),
              maxLines: e.key.contains("note") ? 4 : 1,
              decoration: InputDecoration(
                hintText: e.key == "password" ? "New Password" : null, //
                labelText: e.value["title"] + ":", //
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              onChanged: (v) {
                e.value["value"] = v.isEmpty ? null : v.trim();
              },
            );
          }

          // * លេខ
          if (e.value["type"] == "number") {
            String value = "";
            if (e.value["value"] != null && e.value["value"] != 0) //
              value = e.value["value"].toStringAsFixed(2);
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
          if (e.value["type"] == "date-time") {
            final tmp = DateTime.tryParse(e.value["value"]?.toString() ?? "");
            final value = tmp != null ? DateFormat(DEFAULT_DATE_FORMAT).format(tmp.toLocal()) : "";
            final init = tmp ?? DateTime.now();
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
                      e.value["value"] = null;
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
                          e.value["value"] = null;
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

      // button update
      OutlinedButton.icon(
        icon: Icon(Icons.check), //
        label: Text("Update"),
        style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
        onPressed: on_update,
      ),

      SizedBox(height: height - 100),
    ]);
  }

  void on_update() async {
    try {
      // * រៀបចំ payload
      var payload = {};
      for (var e in sm_user.data.entries) //
        payload[e.key] = e.value["value"];

      //
      tmp = await dio.post(endpoint.USER_UPDATE, data: payload);

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
  const Main_({
    super.key, //
    required this.id, //
  });

  final String id;

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: "Development", //
      theme: theme_data, //
      home: Main_(id: "1"),
      debugShowCheckedModeBanner: false,
    ),
  );
}
