import "package:flutter/material.dart";
import "package:speanmeas/core/config.dart";
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "panel_body.dart" as body;
import "panel_left.dart" as left;
import "panel_top.dart" as top;
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import

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
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: "Development", //
      theme: theme_data, //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
