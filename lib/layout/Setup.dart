import 'package:flutter/material.dart';

import 'package:speanmeas/page/User.dart';
import 'package:speanmeas/page/check_in_out/Main.dart';
import 'package:speanmeas/page/dashboard/Main.dart';
import 'package:speanmeas/page/guest/Main.dart';
import 'package:speanmeas/page/room/Main.dart';
import 'package:speanmeas/page/staff/Main.dart';
import 'package:speanmeas/page/template/Model.dart';

Map<String, Widget> pages = {
  "Dashboard": Dashboard_(), //
  "Check In/Out": Check_In_Out_(), //
  "Room": Room_(), //
  "Guest": Guest_(),
  "Staff": Staff_(),
  "Template": Model_(),
};
