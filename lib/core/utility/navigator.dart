import 'package:flutter/material.dart';

// * global navigator key — ប្រើសម្រាប់រុករកពីកន្លែងគ្មាន BuildContext (ឧ. Dio 401 interceptor)
final navigatorKey = GlobalKey<NavigatorState>();

Future<dynamic> nav_push(BuildContext context, Widget page) async {
  return await Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

Future<dynamic> nav_replace(BuildContext context, Widget page) async {
  return await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
}
