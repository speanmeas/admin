// * ទំព័រអានព័ត៌មានmini bar

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/widget/show/show_text.dart";
import "package:speanmeas/core/widget/show/show_number.dart";

// * បង្កើត layout មេរបស់ទំព័រអានព័ត៌មានmini bar
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងការអានព័ត៌មានmini bar
class _Main_State extends State<Main_> {
  dynamic tmp;
  bool is_loading = true;

  String? name;
  double? price;
  double? stock;
  String? note;

  // * ផ្ទុកព័ត៌មានmini barតាម id
  void init() async {
    // * អានទិន្នន័យmini barតាម id
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.MINI_BAR_READ_ID, data: {Mini_Bar.ID: widget.id});
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: "Error: ${endpoint.MINI_BAR_READ_ID}", cl: Colors.red);
    if (tmp.data.isEmpty) return snackbar(ct: context, ms: "No data found.", cl: Colors.red);

    final mini_bar = Mini_Bar.fromJson(tmp.data[0]);
    name = mini_bar.name;
    price = mini_bar.price;
    stock = mini_bar.stock?.toDouble();
    note = mini_bar.note;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // * បង្ហាញ loading ពេលកំពុងផ្ទុក
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      // * បង្ហាញName
      Show_Text(
        prefixIcon: Icons.text_fields,
        lead: "Name:", //
        value: name,
      ),

      // * បង្ហាញPrice
      Show_Number(
        prefixIcon: Icons.numbers,
        leading: "Price:", //
        value: price,
      ),

      // * បង្ហាញStock
      Show_Number(
        prefixIcon: Icons.numbers,
        leading: "Stock:", //
        value: stock,
      ),

      // * បង្ហាញកំណត់ចំណាំ
      Show_Text(
        prefixIcon: Icons.note_alt_outlined,
        lead: "Note:", //
        value: note,
        maxLines: 4,
      ),

      // * ប៊ូតុងបិទ
      OutlinedButton.icon(
        icon: Icon(Icons.check), //
        label: Text("Close"),
        onPressed: () => Navigator.pop(context),
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

// * ថ្នាក់ Main_ ជាទំព័រអានព័ត៌មានmini bar
class Main_ extends StatefulWidget {
  const Main_({
    super.key, //
    required this.id,
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
