// * ទំព័រលុបសញ្ជាតិ

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";

import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

// * បង្កើត layout មេរបស់ទំព័រលុបសញ្ជាតិ
Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Delete", //
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return _layout([
      // * សារបញ្ជាក់ការលុប
      Text(
        "Confirm to delete?", //
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),

      // * ប៊ូតុងលុប
      OutlinedButton.icon(
        autofocus: true,
        icon: Icon(Icons.delete_outlined),
        label: Text("Delete"),
        style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
        onPressed: on_delete,
      ),

      SizedBox(height: height - 100),
    ]);
  }

  // * អនុវត្តការលុបសញ្ជាតិ
  void on_delete() async {
    try {
      // * ផ្ញើសំណើលុបសញ្ជាតិ
      tmp = await dio.post(
        endpoint.NATIONALITY_CRUD_DELETE, //
        data: {"_id": widget.id},
      );

      //
      snackbar(ct: context, ms: "Success", cl: Colors.green);

      //
      Navigator.pop(context, tmp.data);

      //
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }
}

// * ថ្នាក់ Main_ ជាទំព័រលុបសញ្ជាតិ
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
