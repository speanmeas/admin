// * នាំចូល Flutter material និង intl សម្រាប់ទម្រង់កាលបរិច្ឆេទ
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:intl/intl.dart";

import "package:speanmeas/core/utility/all.dart";

// * ថ្នាក់ state របស់ Show_Datetime គ្រប់គ្រងការបង្ហាញកាលបរិច្ឆេទ
class _Show_DatetimeState extends State<Show_Datetime> {
  @override
  Widget build(BuildContext context) {
    // * ធ្វើទ្រង់ទ្រាយកាលបរិច្ឆេទ
    String value = "";
    if (widget.value != null) {
      value = DateFormat(DEFAULT_DATE_FORMAT).format(widget.value!.toLocal());
    }

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
          widget.leading ?? "", //
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // * តម្លៃកាលបរិច្ឆេទដែលបានបង្ហាញ
        Expanded(
          child: Text(
            value, //
            style: TextStyle(color: Colors.blue),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// * ថ្នាក់ Show_Datetime ជា widget សម្រាប់បង្ហាញកាលបរិច្ឆេទ
class Show_Datetime extends StatefulWidget {
  const Show_Datetime({
    super.key, //
    required this.leading,
    required this.value,
    this.prefixIcon,
    this.prefixText,
  });

  final String? leading;
  final DateTime? value;
  final IconData? prefixIcon;
  final String? prefixText;

  @override
  State<Show_Datetime> createState() => _Show_DatetimeState();
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
            children: [Show_Datetime(leading: "Text Value:", value: DateTime.now())],
          ),
        ),
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
