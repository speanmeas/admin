import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';

import 'package:speanmeas/page/.dashboard/Main.dart';
import 'package:speanmeas/layout/Panel_Body.dart';
import 'package:speanmeas/layout/Panel_Left.dart';
import 'package:speanmeas/layout/Panel_Top.dart';
import 'package:speanmeas/theme/Theme_Data.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global(), //
      child: const Layout_Dashboard(),
    ),
  );
}

class Layout_Dashboard extends StatelessWidget {
  const Layout_Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo', //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: Layout_Dashboard_(),
    );
  }
}

class Layout_Dashboard_ extends StatefulWidget {
  const Layout_Dashboard_({super.key});

  @override
  State<Layout_Dashboard_> createState() => _Layout_Dashboard_State();
}

class _Layout_Dashboard_State extends State<Layout_Dashboard_> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < MOBILE_SCREEN_WIDTH;
    // final v = context.watch<Variable>();
    return Scaffold(
      appBar: AppBar(
        title: Panel_Top_(), //
        // backgroundColor: Colors.blue[50],
        titleSpacing: 0,
        toolbarHeight: 48,
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                // panel left
                if (!isMobile)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                    child: Container(
                      width: 300,
                      decoration: BoxDecoration(border: Border(right: BorderSide())), //
                      // color: Colors.grey[50],
                      child: Panel_Left_(), //
                    ),
                  ),

                // panel body
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      // decoration: BoxDecoration(border: Border.all()),
                      color: Colors.white,
                      child: Panel_Body_(), //
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: isMobile ? Drawer(child: Panel_Left_()) : null,
    );
  }
}
