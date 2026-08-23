// * ទំព័រលុបឧទាហរណ៍

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

// * បង្កើត layout មេរបស់ទំព័រលុបឧទាហរណ៍
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងការលុបឧទាហរណ៍
class _Main_State extends State<Main_> {
  dynamic tmp;
  bool is_loading = true;

  void init() async {
    setState(() => is_loading = false);
  }

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
        onPressed: is_loading ? null : on_delete,
      ),

      SizedBox(height: height - 100),
    ]);
  }

  // * អនុវត្តការលុបឧទាហរណ៍
  void on_delete() async {
    // * ផ្ញើសំណើលុបឧទាហរណ៍
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.DEMO_2_DELETE, data: {"_id": widget.id});
    setState(() => is_loading = false);
    if (tmp == null) return snackbar(ct: context, ms: "Error: ${endpoint.DEMO_2_DELETE}", cl: Colors.red);

    snackbar(ct: context, ms: "Success", cl: Colors.green);
    Navigator.pop(context, tmp.data);
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

// * ថ្នាក់ Main_ ជាទំព័រលុបឧទាហរណ៍
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
