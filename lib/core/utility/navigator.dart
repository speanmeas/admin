import 'package:flutter/material.dart';

Future<dynamic> navigator(BuildContext context, Widget page) async {
  return await Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}
