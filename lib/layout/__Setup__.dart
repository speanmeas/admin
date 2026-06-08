import 'package:flutter/material.dart';

import 'package:speanmeas/page/front_desk/Main.dart' as front_desk;
import 'package:speanmeas/page/guest/Main.dart' as guest;
import 'package:speanmeas/page/room/Main.dart' as room;
import 'package:speanmeas/page/user/Main.dart' as user;
import 'package:speanmeas/page/check_in/Main.dart' as check_in;

import 'package:speanmeas/page/template/Main.dart' as template;
import 'package:speanmeas/page/setting/Main.dart' as setting;

Map<String, Widget> pages = {
  //
  "Front Desk": front_desk.Main_(),
  "Room": room.Main_(),
  "Guest": guest.Main_(),
  "User": user.Main_(),
  "Check In": check_in.Main_(),

  "Template": template.Main_(),
  // "Dashboard": Dashboard_(),

  //
  // "Check In/Out": check_in_out_.Model_(),

  //

  //

  //

  //
  // "Staff": staff.Model_(),

  //

  //
  // "Setting": setting.Setting_(),

  //

  //
};
