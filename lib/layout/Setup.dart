import 'package:flutter/material.dart';

import 'package:speanmeas/page/check_in_out/Main.dart';
import 'package:speanmeas/page/dashboard/Main.dart';

import 'package:speanmeas/page/guest/Model.dart' as guest;
import 'package:speanmeas/page/staff/Model.dart' as staff;
import 'package:speanmeas/page/room/Model.dart' as room;
import 'package:speanmeas/page/template/Model.dart' as template;
import 'package:speanmeas/page/Setting.dart';
import 'package:speanmeas/page/Singin_AI.dart';

Map<String, Widget> pages = {
  //
  "Dashboard": Dashboard_(),

  //
  "Check In/Out": Check_In_Out_(),

  //
  "Room": room.Model_(),

  //
  "Guest": guest.Model_(),

  //
  "Staff": staff.Model_(),

  //
  "Template": template.Model_(),

  //
  "Manage Setting": Setting_(),

  //
  "Signin": Signin_(),
};
