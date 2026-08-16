// * នាំចូល Flutter material និង Provider សម្រាប់ state management
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

// * ថ្នាក់ state របស់ Show_Boolean គ្រប់គ្រងការបង្ហាញតម្លៃ boolean
class _Show_BooleanState extends State<Show_Boolean> {
  @override
  Widget build(BuildContext context) {
    // * កំណត់អត្ថបទពីតម្លៃ boolean
    String value = "";
    if (widget.value == true) value = "Yes";
    if (widget.value == false) value = "No";

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
        // * តម្លៃ boolean ដែលបានបង្ហាញ
        Expanded(
          child: Text(
            '$value ${widget.suffixText ?? ""}',
            style: TextStyle(color: Colors.blue),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ),
      ],
    );
  }
}

// * ថ្នាក់ Show_Boolean ជា widget សម្រាប់បង្ហាញតម្លៃ boolean
class Show_Boolean extends StatefulWidget {
  const Show_Boolean({
    super.key, //
    required this.leading,
    required this.value,
    this.prefixIcon,
    this.prefixText,
    this.suffixText,
  });

  final String? leading;
  final bool? value;
  final IconData? prefixIcon;
  final String? prefixText;
  final String? suffixText;

  @override
  State<Show_Boolean> createState() => _Show_BooleanState();
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
            children: [Show_Boolean(leading: "Text Value:", value: true)],
          ),
        ),
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
