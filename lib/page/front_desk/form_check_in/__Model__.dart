import 'package:flutter/material.dart';

class Model_Check_In extends ChangeNotifier {
  //

  // foreign key
  static String? room_id;
  static String? room_number;
  static String? room_type;

  // foreign key
  static String? guest_id;
  static String? guest_name;
  static String? guest_gender;
  static String? guest_phone_number;

  // data
  static String? number_of_guests;

  static String? number_of_days;
  static String? number_of_hours;

  static String? price_per_day;
  static String? price_per_3_hour;

  static String? price_total_usd;
  static String? price_total_khr;

  static String? paid_bank_usd;
  static String? paid_bank_khr;

  static String? paid_cash_usd;
  static String? paid_cash_khr;

  // static String? paid_total_usd; // todo: remove
  // static String? paid_total_khr; // todo: remove

  static String? return_usd;
  static String? return_khr;

  static String? remain_usd;
  static String? remain_khr;

  //
}
