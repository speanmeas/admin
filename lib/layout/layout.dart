import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:speanmeas/__config__.dart";
import "package:speanmeas/__variable__.dart";
import "package:speanmeas/theme/theme_data.dart";

import "panel_body.dart" as body;
import "panel_left.dart" as left;
import "panel_top.dart" as top;

class _Main_State extends State<Main_> {
  bool is_mobile = false;

  @override
  Widget build(BuildContext context) {
    is_mobile = MediaQuery.of(context).size.width < MOBILE_SCREEN_WIDTH;
    return Scaffold(
      appBar: AppBar(
        title: top.Main_(), //
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
                    child: left.Main_(), //
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
                    child: body.Main_(), //
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
      theme: Theme_Data(), //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
