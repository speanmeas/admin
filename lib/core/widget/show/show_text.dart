// * នាំចូល Flutter material និង intl សម្រាប់ទម្រង់កាលបរិច្ឆេទ
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";
import "package:intl/intl.dart";
import "package:speanmeas/core/config.dart";

import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import

// * ថ្នាក់ state របស់ Show_Text គ្រប់គ្រងការបង្ហាញអត្ថបទ
class _Show_TextState extends State<Show_Text> {
  // * តម្លៃដែលបានធ្វើទ្រង់ទ្រាយ
  String value = "";

  @override
  void initState() {
    super.initState();
    value = _format(widget.value);
  }

  @override
  void didUpdateWidget(covariant Show_Text oldWidget) {
    super.didUpdateWidget(oldWidget);
    // * ធ្វើបច្ចុប្បន្នភាពតម្លៃនៅពេល widget ផ្លាស់ប្តូរ
    if (oldWidget.value != widget.value) value = _format(widget.value);
  }

  // * ធ្វើទ្រង់ទ្រាយតម្លៃទៅជាអត្ថបទ
  String _format(dynamic v) {
    if (v == null) return "";
    if (v is String) return v;
    if (v is int) return v.toString();
    if (v is double) return v.toString();
    if (v is bool) return v ? "Yes" : "No";
    if (v is DateTime) return DateFormat(DEFAULT_DATE_FORMAT).format(v);
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children: [
        // * រូបតំណាងមុន
        if (widget.prefixIcon != null) Icon(widget.prefixIcon!, color: Colors.blue),
        // * អត្ថបទមុន
        if (widget.prefixText != null)
          Text(
            widget.prefixText ?? "", //
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        // * អត្ថបទដឹកនាំ
        Text(
          widget.lead ?? "", //
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // * តម្លៃដែលបានបង្ហាញ
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Colors.blue),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: widget.maxLines ?? 1,
          ),
        ),
      ],
    );
  }
}

// * ថ្នាក់ Show_Text ជា widget សម្រាប់បង្ហាញអត្ថបទ
class Show_Text extends StatefulWidget {
  const Show_Text({
    super.key, //
    required this.lead,
    required this.value,
    this.prefixIcon,
    this.prefixText,
    this.maxLines,
  });

  final String? lead;
  final dynamic value;
  final IconData? prefixIcon;
  final String? prefixText;
  final int? maxLines;

  @override
  State<Show_Text> createState() => _Show_TextState();
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
      child: MaterialApp(
        home: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Show_Text(lead: "Text Value:", value: "Hello")],
          ),
        ),
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
