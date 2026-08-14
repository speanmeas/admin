// * វីជេតជ្រើសរើសស្ថានភាពបន្ទប់ (Room Status) ដោយប្រើ TypeAheadField

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងការជ្រើសរើសស្ថានភាពបន្ទប់
class _Main_State extends State<Main_> {
  //
  final controller = TextEditingController();

  // * ផ្ទុកតម្លៃដំបូងទៅក្នុង controller
  void init() {
    if (widget.initial != null) {
      controller.text = widget.initial!;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // * បង្កើត TypeAheadField សម្រាប់ជ្រើសរើសស្ថានភាពបន្ទប់
    return TypeAheadField<String>(
      controller: controller,
      // * បញ្ជីសំណូមពរស្ថានភាពបន្ទប់
      suggestionsCallback: (query) => ["Available", "Pending Pay", "Pending Leave", "Pending Clean", "Pending Fix"],
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: "Select Status:", //
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: Icon(Icons.verified_outlined, color: Colors.blue),
            // * ប៊ូតុងសម្អាតតម្លៃ
            suffixIcon: ExcludeFocus(
              child: Padding(
                padding: EdgeInsets.only(right: 4),
                child: IconButton(
                  icon: Icon(Icons.clear, color: Colors.red),
                  onPressed: () {
                    controller.clear();
                    widget.onChanged?.call(null);
                    setState(() {});
                  },
                ), //
              ),
            ),
          ),
        );
      },
      itemBuilder: (context, item) => ListTile(title: Text(item)),
      // * ពេលជ្រើសរើសតម្លៃ
      onSelected: (v) {
        controller.text = v;
        widget.onChanged?.call(v);
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

// * ថ្នាក់ Main_ ជាវីជេតជ្រើសរើសស្ថានភាពបន្ទប់
class Main_ extends StatefulWidget {
  const Main_({
    super.key, //
    this.initial,
    this.onChanged,
  });

  final String? initial;
  final ValueChanged<String?>? onChanged;

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
        home: Scaffold(
          body: Center(
            child: Main_(
              initial: "Available",
              onChanged: (v) {
                print("Changed: $v");
              },
            ),
          ),
        ),
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
