// * ទំព័រកែប្រែ mini bar

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";

import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/input/input_number.dart";
import "package:speanmeas/core/schema/mini_bar.g.dart";
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

// * បង្កើត layout មេរបស់ទំព័រកែប្រែ mini bar
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទម្រង់កែប្រែ mini bar
class _Main_State extends State<Main_> {
  //
  dynamic tmp; // ignore: unused
  bool is_loading = true;

  String? name;
  double? price;
  double? stock;
  String? note;

  // * ផ្ទុកព័ត៌មាន mini bar តាម id សម្រាប់កែប្រែ
  void init() async {
    //
    try {
      // * អានព័ត៌មាន mini bar តាម id
      tmp = await dio.post(
        endpoint.MINI_BAR_CRUD_READ_ID, //
        data: {sm_mini_bar.ID: widget.id},
      );

      final data = tmp.data;
      // * បើគ្មានទិន្នន័យ បង្ហាញសារព្រមាន
      if (data == null || data.isEmpty) {
        snackbar(ct: context, ms: "No data found.", cl: Colors.red);
        setState(() => is_loading = false);
        return;
      }
      final row = data[0];

      // * ផ្ទុកតម្លៃទៅក្នុងអថេរ
      name = row[sm_mini_bar.NAME]?.toString();
      price = double.tryParse(row[sm_mini_bar.PRICE]?.toString() ?? "");
      stock = double.tryParse(row[sm_mini_bar.STOCK]?.toString() ?? "");
      note = row[sm_mini_bar.NOTE]?.toString();

      setState(() => is_loading = false);
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
      // * កែប្រែឈ្មោះ
      Input_Text(
        init: name, //
        lead: "Name:", //
        onChanged: (v) {
          name = v;
          setState(() {});
        },
      ),

      // * កែប្រែតម្លៃ
      Input_Number(
        init: price, //
        lead: "Price:", //
        onChanged: (v) {
          price = v;
          setState(() {});
        },
      ),

      // * កែប្រែចំនួនស្តុក
      Input_Number(
        init: stock, //
        lead: "Stock:", //
        onChanged: (v) {
          stock = v;
          setState(() {});
        },
      ),

      // * កែប្រែកំណត់ចំណាំ
      Input_Text(
        init: null, //
        lead: "Note:", //
        maxLines: 4, //
        onChanged: (v) {
          note = v ?? "";
          setState(() {});
        },
      ),

      // * ប៊ូតុងកែប្រែ
      OutlinedButton.icon(
        icon: Icon(Icons.check),
        label: Text("Update"),
        style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
        onPressed: on_update,
      ),
      SizedBox(height: height - 100),
    ]);
  }

  // * អនុវត្តការកែប្រែ mini bar
  void on_update() async {
    try {
      // * ផ្ញើសំណើកែប្រែ mini bar
      tmp = await dio.post(
        endpoint.MINI_BAR_CRUD_UPDATE, //
        data: {
          sm_mini_bar.ID: widget.id,
          sm_mini_bar.NAME: name,
          sm_mini_bar.PRICE: price,
          sm_mini_bar.STOCK: stock,
          sm_mini_bar.NOTE: note, //
        },
      );

      //
      Navigator.pop(context, tmp.data[0]);

      //
      snackbar(ct: context, ms: "Success", cl: Colors.green);

      //
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  //
}

// * ថ្នាក់ Main_ ជាទំព័រកែប្រែ mini bar
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
  //
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
