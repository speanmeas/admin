import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/schema/demo_2.g.dart";

import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/show/show_boolean.dart";
import "package:speanmeas/core/widget/show/show_datetime.dart";
import "package:speanmeas/core/widget/show/show_number.dart";
import "package:speanmeas/core/widget/show/show_text.dart";
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
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

  String? text_1;
  double? number_1;
  DateTime? datetime_1;
  bool? logic_1;
  String? note;

  void init() async {
    try {
      tmp = await dio.post(
        endpoint.DEMO_2_CRUD_READ_ID, //
        data: {sm_demo_2.ID: widget.id},
      );

      text_1 = tmp.data[0][sm_demo_2.TEXT_1];
      number_1 = tmp.data[0][sm_demo_2.NUMBER_1];
      datetime_1 = DateTime.parse(tmp.data[0][sm_demo_2.DATETIME_1]);
      logic_1 = tmp.data[0][sm_demo_2.LOGIC_1];
      note = tmp.data[0][sm_demo_2.NOTE];

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
        prefixIcon: Icons.text_fields,
        lead: "Text 1:", //
        value: text_1,
      ),

      Show_Number(
        prefixIcon: Icons.numbers,
        leading: "Number 1:", //
        value: number_1,
      ),

      Show_Datetime(
        prefixIcon: Icons.calendar_month,
        leading: "Datetime 1:", //
        value: datetime_1,
      ),

      Show_Boolean(
        prefixIcon: Icons.toggle_on,
        leading: "Boolean:", //
        value: logic_1,
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
