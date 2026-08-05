import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/secure_storage.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart" as ep; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart" as sb; // ignore: unused_import
import "package:speanmeas/core/theme/theme_light.dart" as theme; // ignore: unused_import

import "schema.g.dart" as sm;

// import "form/full_name.dart" as form_fn;
// import "form/phone_number.dart" as form_pn;
import "dialog/update_full_name.dart" as dialog_fn;
import "dialog/update_phone_number.dart" as dialog_pn;
import "dialog/update_username.dart" as dialog_un;
import "dialog/update_password.dart" as dialog_pw;

import "form/sign_in.dart" as form_si;

// import secure_storage from "package:speanmeas/core/utility/secure_storage.dart";

Widget _layout(List<Widget> children) {
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
      child: Center(
        child: Container(
          width: 600,
          margin: EdgeInsets.all(4),
          child: Column(children: children),
        ),
      ),
    ),
  );
}

class _Main_State extends State<Main_> {
  //

  //
  dynamic tmp;

  void init() async {
    //
    try {
      //

      tmp = await dio.post(
        ep.AUTH_ACCESS_TOKEN, //
        data: {"access_token": await ss.read(key: "access_token")},
      );
      if (tmp != null) {
        // print("tmp: $tmp");
        for (var e in sm.data.entries) e.value["value"] = tmp.data[0][e.key];
      }
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: "Failed", color: Colors.red);
    }

    setState(() {});
    //
  }

  @override
  Widget build(BuildContext context) {
    return _layout([
      // Position
      (() {
        String value = "N/A";
        if (sm.data[sm.IS_ADMIN]!["value"] == true) value = "Administrator";
        if (sm.data[sm.IS_MANAGER]!["value"] == true) value = "Manager";
        if (sm.data[sm.IS_RECEPTIONIST]!["value"] == true) value = "Receptionist";
        if (sm.data[sm.IS_HOUSEKEEPER]!["value"] == true) value = "Housekeeper";
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ],
        );
      })(),

      SizedBox(height: 4),

      (() {
        String value = "N/A";
        if (sm.data[sm.FULL_NAME]!["value"] != null) //
          value = sm.data[sm.FULL_NAME]!["value"].toString();
        return Row(
          spacing: 4,
          children: [
            Icon(Icons.person_pin_outlined),
            Text("Full Name: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(fontSize: 16, color: Colors.blue)),
            InkWell(
              child: Icon(Icons.edit_outlined, color: Colors.blue),
              onTap: () async {
                tmp = await dialog_fn.view(context: context, input: value);
                if (tmp != null) init();
              },
            ),
          ],
        );
      })(),

      // phone number
      (() {
        String value = "N/A";
        if (sm.data[sm.PHONE_NUMBER]!["value"] != null) //
          value = sm.data[sm.PHONE_NUMBER]!["value"].toString();
        return Row(
          spacing: 4,
          children: [
            Icon(Icons.phone_outlined),
            Text("Phone Number: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(fontSize: 16, color: Colors.blue)),
            InkWell(
              child: Icon(Icons.edit_outlined, color: Colors.blue),
              onTap: () async {
                tmp = await dialog_pn.view(context: context, input: value);
                if (tmp != null) init();
              },
            ),
          ],
        );
      })(),

      // username
      (() {
        String value = "N/A";
        if (sm.data[sm.USERNAME]!["value"] != null) //
          value = sm.data[sm.USERNAME]!["value"].toString();
        return Row(
          spacing: 4,
          children: [
            Icon(Icons.person_outline),
            Text("Username: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(fontSize: 16, color: Colors.blue)),
            InkWell(
              child: Icon(Icons.edit_outlined, color: Colors.blue),
              onTap: () async {
                tmp = await dialog_un.view(context: context, input: value);
                if (tmp != null) init();
              },
            ),
          ],
        );
      })(),

      // password
      (() {
        String value = "**********";
        return Row(
          spacing: 4,
          children: [
            Icon(Icons.lock_outline),
            Text("Password: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(fontSize: 16, color: Colors.blue)),
            InkWell(
              child: Icon(Icons.edit_outlined, color: Colors.blue),
              onTap: () async {
                tmp = await dialog_pw.view(context: context);
                if (tmp != null) init();
              },
            ),
          ],
        );
      })(),

      SizedBox(height: 8),

      OutlinedButton.icon(
        icon: Icon(Icons.logout), //
        label: Text("Sign Out"),
        style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
        onPressed: on_sign_out,
      ),
    ]);
  }

  void on_sign_out() async {
    try {
      //
      sm.clear();
      await dio.options.headers.remove("Authorization");
      await ss.delete(key: "access_token");

      // goto to sign in
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (_) => form_si.Main_()));

      //
      sb.view(context: context, message: "Success", color: Colors.green);
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: "Failed", color: Colors.red);
    }
  }

  //
  @override
  void initState() {
    super.initState();
    init();
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
