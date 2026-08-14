import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n.dart";

import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/show/show_number.dart";
import "package:speanmeas/core/widget/show/show_text.dart";
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/schema/room.g.dart";
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Read", //
        style: TextStyle(
          fontSize: 20, //
          fontWeight: FontWeight.bold,
        ),
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
          padding: EdgeInsets.all(8),
          child: Column(
            spacing: 8,
            children: children, //
          ),
        ),
      ),
    ),
  );
}

class _Main_State extends State<Main_> {
  //
  dynamic tmp;
  bool is_loading = true;

  String? number;
  double? usd_per_day;
  double? usd_per_3h;
  String? kind;
  String? status;
  String? note;

  void init() async {
    try {
      tmp = await dio.post(
        endpoint.ROOM_CRUD_READ_ID, //
        data: {sm_room.ID: widget.id},
      );

      number = tmp.data[0][sm_room.NUMBER];
      usd_per_day = tmp.data[0][sm_room.USD_PER_DAY];
      usd_per_3h = tmp.data[0][sm_room.USD_PER_3H];
      kind = tmp.data[0][sm_room.KIND];
      status = tmp.data[0][sm_room.STATUS];
      note = tmp.data[0][sm_room.NOTE];

      is_loading = false;
      setState(() {});
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      Show_Text(
        prefixIcon: Icons.meeting_room_outlined,
        lead: "Number:", //
        value: number,
      ),

      Show_Number(
        prefixIcon: Icons.attach_money,
        leading: "USD/Day:", //
        value: usd_per_day,
      ),

      Show_Number(
        prefixIcon: Icons.attach_money,
        leading: "USD/3H:", //
        value: usd_per_3h,
      ),

      Show_Text(
        prefixIcon: Icons.king_bed_outlined,
        lead: "Kind:", //
        value: kind,
      ),

      Show_Text(
        prefixIcon: Icons.verified_outlined,
        lead: "Status:", //
        value: status,
      ),

      Show_Text(
        prefixIcon: Icons.note_alt_outlined,
        lead: "Note:", //
        value: note,
        maxLines: 4,
      ),

      SizedBox(height: height - 100),
    ]);
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

class Main_ extends StatefulWidget {
  const Main_({
    super.key, //
    required this.id,
  });

  final String id;

  @override
  State<Main_> createState() => _Main_State();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  glob.init();
  lang.init();
  //
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: glob),
        ChangeNotifierProvider.value(value: lang),
      ],
      child: Main_(id: "1"),
    ),
  );
}
