import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/layout/Layout.dart';
import 'package:speanmeas/Environment.dart';

import 'package:speanmeas/page/Singin.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global(), //
      child: const Main(),
    ),
  );
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$TITLE Admin', //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      // home: Layout_Dashboard_(),
      home: Signin_(),
    );
  }
}
