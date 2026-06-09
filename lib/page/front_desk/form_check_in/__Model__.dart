import 'package:flutter/material.dart';

class Model {
  //

  // foreign key
  static String room_id = "";
  static String room_number = "";
  static String room_type = "";
  static double price_per_day = 0;
  static double price_per_3_hour = 0;

  // foreign key
  static String guest_name = "";
  static String guest_gender = "Male";
  static String guest_nationality = "Cambodian";
  static String guest_phone_number = "";
  static int number_of_guests = 1;

  // duration
  static int stay_duration_day = 0;
  static int stay_duration_hour = 0;
  static double price_total_usd = 0;
  static double price_total_khr = 0;

  // payment
  static double paid_bank_usd = 0;
  static double paid_bank_khr = 0;

  static double paid_cash_usd = 0;
  static double paid_cash_khr = 0;

  // return
  static double return_usd = 0;
  static double return_khr = 0;

  // account receivable
  static double balance_usd = 0;
  static double balance_khr = 0;

  //

  static void clear() {
    room_id = "";
    room_number = "";
    room_type = "";
    price_per_day = 0;
    price_per_3_hour = 0;

    guest_name = "";
    guest_gender = "Male";
    guest_nationality = "Cambodian";
    guest_phone_number = "";
    number_of_guests = 1;

    stay_duration_day = 0;
    stay_duration_hour = 0;
    price_total_usd = 0;
    price_total_khr = 0;

    paid_bank_usd = 0;
    paid_bank_khr = 0;

    paid_cash_usd = 0;
    paid_cash_khr = 0;

    return_usd = 0;
    return_khr = 0;

    balance_usd = 0;
    balance_khr = 0;
  }
}
