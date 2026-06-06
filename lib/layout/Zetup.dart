import 'package:flutter/material.dart';

import 'package:speanmeas/page/check_in_out/Main.dart';
import 'package:speanmeas/page/dashboard/Main.dart';

import 'package:speanmeas/page/check_in_out/Main.dart' as check_in_out_;
import 'package:speanmeas/page/guest/Main.dart' as guest;
import 'package:speanmeas/page/room/Model.dart' as room;
import 'package:speanmeas/page/user/Main.dart' as user;

import 'package:speanmeas/page/staff/Model.dart' as staff;
import 'package:speanmeas/page/template/Main.dart' as template;
import 'package:speanmeas/page/setting/Main.dart' as setting;
import 'package:speanmeas/page/front_desk/Main.dart' as check_in_out_clean;

Map<String, Widget> pages = {
  //
  "Dashboard": Dashboard_(),

  //
  "Check In/Out": check_in_out_.Model_(),

  //
  "Room": room.Model_(),

  //
  "Guest": guest.Main_(),

  //
  "User": user.Main_(),

  //
  "Staff": staff.Model_(),

  //
  "Template": template.Main_(),

  //
  "Setting": setting.Setting_(),

  //
  "Main Desk": check_in_out_clean.Check_In_Out_Clean_(),

  //
};
