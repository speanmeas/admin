import "package:flutter/material.dart";
import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/widget/input/input_text.dart";

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទម្រង់ check in
class _Main_State extends State<Main_> {
  dynamic tmp;
  bool is_load = false;

  String? note;

  @override
  void initState() {
    super.initState();
    init();
  }

  // * ផ្ទុកព័ត៌មានបន្ទប់ពី server
  void init() async {
    //
  }

  // * អនុវត្តការ check in ភ្ញៀវ
  void on_clean() async {
    if (is_load) return snackbar(ct: context, ms: "Please wait.", cl: Colors.red);

    dynamic tpm_clean = await dio.post(
      endpoint.CLEAN_CREATE,
      data: {
        Clean.NOTE: note, //
      },
    );

    await dio.post(
      endpoint.FRONT_DESK_UPDATE,
      data: {
        Front_Desk.ID: widget.front_desk_id, //
        Front_Desk.CLEAN_ID: tpm_clean.data[0][Clean.ID], //
      },
    );

    await dio.post(
      endpoint.ROOM_UPDATE,
      data: {
        Room.ID: widget.room_id, //
        Room.STATUS: "Available", //
        Room.FRONT_DESK_ID: null, //
      },
    );

    snackbar(ct: context, ms: "Success", cl: Colors.green);
    Navigator.pop(context, true);
  }

  Widget _layout(List<Widget> children) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Clean", //
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1), //
          child: Divider(height: 1, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 600,
            padding: EdgeInsets.fromLTRB(8, 8, 16, 8),
            child: Column(
              spacing: 8,
              children: children, //
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return _layout([
      // * បង្ហាញលេខបន្ទប់
      Text(
        'Room ${widget.room_number ?? "N/A"}', //
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),

      // * បញ្ចូលកំណត់ចំណាំ
      Input_Text(
        init: note, //
        lead: "Note:", //
        maxLines: 4, //
        onChanged: (v) {
          note = v;
          setState(() {});
        },
      ),

      // * ប៊ូតុងបញ្ជូន check in
      OutlinedButton.icon(
        icon: Icon(Icons.cleaning_services), //
        label: Text("Clean"), //
        onPressed: on_clean,
      ),

      SizedBox(height: height - 100),
    ]);
  }
}

// * ថ្នាក់ Main_ ជាទំព័រ check in
class Main_ extends StatefulWidget {
  const Main_({
    super.key, //
    this.front_desk_id,
    this.room_id,
    this.room_number,
  });

  final String? front_desk_id;
  final String? room_id;
  final String? room_number;

  @override
  State<Main_> createState() => _Main_State();
}

// * ចំណុចចាប់ផ្តើមកម្មវិធី
void main() async {
  runApp(
    MaterialApp(
      home: Main_(
        room_number: "101", //
      ), //
      theme: theme_data, //
      title: "Development", //
      debugShowCheckedModeBanner: false, //
    ),
  );
}
