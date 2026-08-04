import "package:speanmeas/core/endpoint.g.dart" as ep;
import "package:flutter/material.dart";

import "package:speanmeas/core/theme/theme_data.dart" as theme;
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/utility/secure_storage.dart";
import "package:speanmeas/core/widget/snackbar.dart" as snackbar;

import "form/full_name.dart" as f_full_name;
import "form/phone_number.dart" as f_phone_number;
import "form/username.dart" as f_username;
import "form/password.dart" as f_password;

import "schema.g.dart" as schema;

import "sign_in.dart" as sign_in;

class _Main_State extends State<Main_> {
  dynamic tmp;
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setState(() {});
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User Profile", //
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
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              //

              // Position
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Position: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                    (() {
                      var style = TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue);

                      if (schema.data[schema.IS_ADMIN]!["value"] == true) return Text("Administrator", style: style);
                      if (schema.data[schema.IS_MANAGER]!["value"] == true) return Text("Manager", style: style);
                      if (schema.data[schema.IS_RECEPTIONIST]!["value"] == true) return Text("Receptionist", style: style);
                      if (schema.data[schema.IS_HOUSEKEEPER]!["value"] == true) return Text("Housekeeper", style: style);

                      return SizedBox();
                    })(),
                  ],
                ),
              ),
              (() {
                String value = "";
                if (schema.data[schema.FULL_NAME]!["value"] != null) //
                  value = schema.data[schema.FULL_NAME]!["value"].toString();
                return Container(
                  width: 600,
                  margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Row(
                    children: [
                      Text(
                        "Name: ", //
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        value, //
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                      SizedBox(width: 8),
                      InkWell(
                        child: Icon(Icons.edit, color: Colors.blue),
                        onTap: () async {
                          final v = await Navigator.push(context, MaterialPageRoute(builder: (_) => f_full_name.Main_()));
                          if (v != null) init();
                        },
                      ),
                    ],
                  ),
                );
              })(),

              // phone number
              (() {
                String value = "";
                if (schema.data[schema.PHONE_NUMBER]!["value"] != null) //
                  value = schema.data[schema.PHONE_NUMBER]!["value"].toString();
                return Container(
                  width: 600,
                  margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Row(
                    children: [
                      Text(
                        "Phone Number: ", //
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        value, //
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                      SizedBox(width: 8),
                      InkWell(
                        child: Icon(Icons.edit, color: Colors.blue),
                        onTap: () async {
                          final v = await Navigator.push(context, MaterialPageRoute(builder: (_) => f_phone_number.Main_()));
                          if (v != null) init();
                        },
                      ),
                    ],
                  ),
                );
              })(),

              // username
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  children: [
                    Text(
                      "Username: ", //
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      schema.data[schema.USERNAME]!["value"].toString(), //
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    SizedBox(width: 8),
                    InkWell(
                      child: Icon(Icons.edit, color: Colors.blue),
                      onTap: () async {
                        final v = await Navigator.push(context, MaterialPageRoute(builder: (_) => f_username.Main_()));
                        if (v != null) init();
                      },
                    ),
                  ],
                ),
              ),

              // password
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  children: [
                    Text(
                      "Password: ", //
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "**********", //
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    SizedBox(width: 8),
                    InkWell(
                      child: Icon(Icons.edit, color: Colors.blue),
                      onTap: () async {
                        final v = await Navigator.push(context, MaterialPageRoute(builder: (_) => f_password.Main_()));
                        if (v != null) init();
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8),

              OutlinedButton.icon(
                icon: Icon(Icons.logout), //
                label: Text("Sign Out"),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                onPressed: on_sign_out,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void on_sign_out() async {
    try {
      //
      dio.options.headers.remove("Authorization");

      //
      await secure_storage.delete(key: "access_token");

      //
      schema.clear();

      // goto to sign in
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (_) => sign_in.Main_()));

      //
      snackbar.view(context: context, message: "Success Sign-Out", color: Colors.green);
    } catch (e) {
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
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
      title: "Development", //
      theme: theme.data(), //
      home: const Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
