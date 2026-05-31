import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/layout/Layout.dart';
import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/utility/Secure_Storage.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global(), //
      child: const Check_Out(),
    ),
  );
}

class Check_Out extends StatelessWidget {
  const Check_Out({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: const Check_Out_(),
    );
  }
}

class Check_Out_ extends StatefulWidget {
  const Check_Out_({super.key});

  @override
  State<Check_Out_> createState() => _Check_Out_State();
}

class _Check_Out_State extends State<Check_Out_> {
  final rooms = [
    101, 102, 103, 104, 105, 106, 107, 108, 109, 110, //
    201, 202, 203, 204, 205, 206, 207, 208, 209, 210, //
    301, 302, 303, 304, 305, 306, 307, 308, 309, 310, //
    401, 402, 403, 404, 405, 406, 407, 408, 409, 410, //
    501, 502, 503, 504, 505, 506, 507, 508, 509, 510, //
    601, 602, 603, 604, 605, 606, 607, 608, 609, 610, //
    701, 702, 703, 704, 705, 706, 707, 708, 709, 710, //
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              ...List.generate(7, (floorIndex) {
                final floor = floorIndex + 1;
                final floorRooms = rooms.where((room) => room ~/ 100 == floor).toList();
                final floorSuffix = floor == 1
                    ? 'st'
                    : floor == 2
                    ? 'nd'
                    : floor == 3
                    ? 'rd'
                    : 'th';

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        '$floor$floorSuffix Floor', //
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.start,
                      children: [
                        ...floorRooms.map(
                          (room) => Padding(
                            padding: const EdgeInsets.all(4),
                            child: OutlinedButton(
                              onPressed: () {}, //
                              child: Text('Room $room'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
