import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/theme/Theme_Data.dart';

import 'Panel_Body.dart';
import 'Panel_Left.dart';
import 'Panel_Top.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global.variable, //
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
      home: Layout_(),
    );
  }
}

class Layout_ extends StatefulWidget {
  const Layout_({super.key});

  @override
  State<Layout_> createState() => _Layout_State();
}

class _Layout_State extends State<Layout_> {
  bool is_mobile = false;

  @override
  Widget build(BuildContext context) {
    is_mobile = MediaQuery.of(context).size.width < MOBILE_SCREEN_WIDTH;
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
                if (!is_mobile)
                  Container(
                    // margin: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                    width: 250,
                    decoration: BoxDecoration(border: Border(right: BorderSide())), //
                    child: Panel_Left_(), //
                    // color: Colors.grey[50],
                  ),

                // panel body
                Expanded(
                  child: Container(
                    // margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    width: double.infinity,
                    height: double.infinity,
                    // decoration: BoxDecoration(border: Border.all()),
                    color: Colors.white,
                    child: Panel_Body_(), //
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: is_mobile ? Drawer(child: Panel_Left_()) : null,
    );
  }
}
