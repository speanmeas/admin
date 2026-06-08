import 'package:flutter/material.dart';

class Model extends ChangeNotifier {
  String? _id;

  String? _text_1;
  String? _text_2;
  String? _text_3;

  double? _number_1;
  double? _number_2;
  double? _number_3;

  String? _is_admin;
  String? _is_user;
  String? _is_guest;

  String? _datetime_1;
  String? _datetime_2;
  String? _datetime_3;
  //

  String? get id {
    return _id;
  }

  set id(String? value) {
    _id = value;
    notifyListeners();
  }

  String? get text_1 {
    return _text_1;
  }

  set text_1(String? value) {
    _text_1 = value;
    notifyListeners();
  }

  String? get text_2 {
    return _text_2;
  }

  set text_2(String? value) {
    _text_2 = value;
    notifyListeners();
  }

  String? get text_3 {
    return _text_3;
  }

  set text_3(String? value) {
    _text_3 = value;
    notifyListeners();
  }

  double? get number_1 {
    return _number_1;
  }

  set number_1(double? value) {
    _number_1 = value;
    notifyListeners();
  }

  double? get number_2 {
    return _number_2;
  }

  set number_2(double? value) {
    _number_2 = value;
    notifyListeners();
  }

  double? get number_3 {
    return _number_3;
  }

  set number_3(double? value) {
    _number_3 = value;
    notifyListeners();
  }

  String? get is_admin {
    return _is_admin;
  }

  set is_admin(String? value) {
    _is_admin = value;
    notifyListeners();
  }

  String? get is_user {
    return _is_user;
  }

  set is_user(String? value) {
    _is_user = value;
    notifyListeners();
  }

  String? get is_guest {
    return _is_guest;
  }

  set is_guest(String? value) {
    _is_guest = value;
    notifyListeners();
  }

  String? get datetime_1 {
    return _datetime_1;
  }

  set datetime_1(String? value) {
    _datetime_1 = value;
    notifyListeners();
  }

  String? get datetime_2 {
    return _datetime_2;
  }

  set datetime_2(String? value) {
    _datetime_2 = value;
    notifyListeners();
  }

  String? get datetime_3 {
    return _datetime_3;
  }

  set datetime_3(String? value) {
    _datetime_3 = value;
    notifyListeners();
  }
}

class Data extends ChangeNotifier {
  //
  List<Map<String, dynamic>> _data = [];

  List<Map<String, dynamic>> get data {
    return _data;
  }

  set data(List<Map<String, dynamic>> value) {
    _data = value;
    notifyListeners();
  }
}
