import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speanmeas/Environment.dart';

import 'package:speanmeas/Global_Variable.dart';
import 'package:speanmeas/layout/Layout.dart';
import 'package:speanmeas/theme/Theme_Data.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Variable(), //
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
      home: Layout_Dashboard_(),
    );
  }
}
