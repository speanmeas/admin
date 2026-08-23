// * ទំព័រកែប្រែព័ត៌មានធនាគារ

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/widget/input/input_text.dart";

// * បង្កើត layout មេរបស់ទំព័រកែប្រែធនាគារ
Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Update", //
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទម្រង់កែប្រែធនាគារ
class _Main_State extends State<Main_> {
  //
  dynamic tmp;
  bool is_loading = true;

  String? name;
  String? note;

  // * ផ្ទុកព័ត៌មានធនាគារបច្ចុប្បន្ន
  void init() async {
    // * អានទិន្នន័យធនាគារតាម id
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.BANK_READ_ID, data: {Bank.ID: widget.id});
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: "Error: ${endpoint.BANK_READ_ID}", cl: Colors.red);
    if (tmp.data.isEmpty) return snackbar(ct: context, ms: "No data found.", cl: Colors.red);

    final bank = Bank.fromJson(tmp.data[0]);
    name = bank.name;
    note = bank.note;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // * បង្ហាញ loading ពេលកំពុងផ្ទុក
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      // * បញ្ចូលឈ្មោះធនាគារ
      Input_Text(
        init: name, //
        lead: "Name:", //
        onChanged: (v) {
          name = v;
          setState(() {});
        },
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

      // * ប៊ូតុងកែប្រែ
      OutlinedButton.icon(
        icon: Icon(Icons.check),
        label: Text("Update"),
        style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
        onPressed: is_loading ? null : on_update,
      ),
      SizedBox(height: height - 100),
    ]);
  }

  // * អនុវត្តការកែប្រែធនាគារ
  void on_update() async {
    // * ផ្ញើសំណើកែប្រែធនាគារ
    setState(() => is_loading = true);
    tmp = await dio.post(
      endpoint.BANK_UPDATE, //
      data: {
        Bank.ID: widget.id,
        Bank.NAME: name,
        Bank.NOTE: note, //
      },
    );
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: "Error: ${endpoint.BANK_UPDATE}", cl: Colors.red);

    snackbar(ct: context, ms: "Success", cl: Colors.green);
    Navigator.pop(context, tmp.data[0]);
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

// * ថ្នាក់ Main_ ជាទំព័រកែប្រែធនាគារ
class Main_ extends StatefulWidget {
  const Main_({
    super.key, //
    required this.id, //
  });

  final String id;

  @override
  State<Main_> createState() => _Main_State();
}

// * ចំណុចចាប់ផ្តើមកម្មវិធី
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  glob.init();
  lang.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: glob),
        ChangeNotifierProvider.value(value: lang),
      ],
      child: MaterialApp(
        home: Main_(id: "1"), //
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
