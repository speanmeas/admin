import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/layout/Layout.dart';
import 'package:speanmeas/page/front_desk/Main_Widget.dart';
import 'package:speanmeas/page/front_desk/form_check_in/__Model__.dart';
import 'package:speanmeas/page/front_desk/form_check_in/Step_2_Stay_Detail.dart';
import 'package:speanmeas/page/front_desk/form_check_in/Step_1_Guest_Info.dart';
import 'package:speanmeas/page/front_desk/form_check_out/Form_Check_Out.dart';
import 'package:speanmeas/page/front_desk/form_clean/Form_Clean.dart';
import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/utility/Secure_Storage.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global(), //
      child: const Main(),
    ),
  );
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: const Main_(),
    );
  }
}

class Main_ extends StatefulWidget {
  const Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

class _Main_State extends State<Main_> {
  //

  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await dio
        .post("/room/data_read")
        .then((r) {
          // print(r.data);
          data = List<Map<String, dynamic>>.from(r.data);

          print(data);

          setState(() {});
        })
        .catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              //
              ...data.map((room) {
                return Container(
                  width: 600,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.black26),
                      bottom: BorderSide(color: Colors.black26),
                    ),
                  ),

                  child: Row(
                    children: [
                      Room_Status(room: room),

                      Spacer(),

                      Button_Checkin(
                        onPressed: room['status'] != "Available"
                            ? null //
                            : () => on_check_in(room),
                      ),

                      Button_Check_Out(
                        onPressed: room['status'] != "Occupied"
                            ? null //
                            : () => on_check_out(room),
                      ),

                      //
                      Button_Clean(
                        onPressed: room['status'] != "Dirty"
                            ? null //
                            : () => on_check_clean(room),
                      ),
                    ],
                  ),
                );
              }),

              SizedBox(height: screen_height - 80),
            ],
          ),
        ),
      ),
    );
  }

  void on_check_in(dynamic room) {
    //
    print("${room['id']}");

    Model.data['room_id'] = room['id'];

    Navigator.push(
      context, //
      MaterialPageRoute(builder: (_) => Guest_Info_()),
    );
  }

  void on_check_out(dynamic room) {
    //
    print("${room['id']}");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Form_Check_Out_(
          id: room['id'], //
        ),
      ),
    );
  }

  void on_check_clean(dynamic room) {
    //
    print("${room['id']}");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Form_Check_Clean_(
          id: room['id'], //
        ),
      ),
    );
  }
}
