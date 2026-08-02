import "package:flutter/material.dart";
import "package:speanmeas/core/theme/theme_data.dart";

/// Usage:
///   import "..." as form;
///   form.Main_(context);

class _Main_State extends State<Main_> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Title"), //
        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,

        actions: [
          OutlinedButton.icon(
            icon: Icon(Icons.arrow_forward), //
            label: Text("Next"), //
            onPressed: () {
              //
            }, //
          ),
          SizedBox(width: 4),
        ],

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1), //
          child: Divider(height: 1, color: Colors.black), //
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 600,
            margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Column(
              children: [
                Text("This is a simple form."), //

                OutlinedButton.icon(
                  icon: Icon(Icons.check), //
                  label: Text("Okay"), //
                  onPressed: () {
                    //
                  }, //
                ),
              ],
            ),
          ),
        ),
      ),
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
      title: "Template Form", //
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Main_(),
    ),
  );
}
