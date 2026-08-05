import "package:flutter/material.dart";
import "package:speanmeas/core/config.dart";
import "package:speanmeas/core/theme/theme_light.dart" as theme;

import "panel_body.dart" as body;
import "panel_left.dart" as left;
import "panel_top.dart" as top;

class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  bool is_mobile = false;

  @override
  Widget build(BuildContext context) {
    is_mobile = MediaQuery.of(context).size.width < MOBILE_SCREEN_WIDTH;
    return Scaffold(
      appBar: AppBar(
        title: top.Main_(), //
        titleSpacing: 0,
        toolbarHeight: 48,
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1), //
          child: Divider(height: 1, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                // panel left
                if (!is_mobile)
                  Container(
                    width: 250,
                    decoration: BoxDecoration(border: Border(right: BorderSide())), //
                    child: left.Main_(), //
                  ),

                // panel body
                Expanded(
                  child: body.Main_(), //
                ),
              ],
            ),
          ),
        ],
      ),

      // drawer
      drawer: is_mobile ? Drawer(child: left.Main_()) : null,
    );
  }
}

class Main_ extends StatefulWidget {
  Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: "Development", //
      theme: theme.data(), //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
