import 'package:flutter/material.dart';

Future<dynamic> nav_push(BuildContext context, Widget page) async {
  return await Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

Future<dynamic> nav_replace(BuildContext context, Widget page) async {
  return await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
}
