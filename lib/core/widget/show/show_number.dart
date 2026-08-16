// * នាំចូល Flutter material និង Provider សម្រាប់ state management
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

// * ថ្នាក់ state របស់ Show_Number គ្រប់គ្រងការបង្ហាញលេខ
class _Show_NumberState extends State<Show_Number> {
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
          widget.leading ?? "", //
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // * តម្លៃលេខដែលបានបង្ហាញ
        Expanded(
          child: Text(
            '${widget.value?.toStringAsFixed(2) ?? ""} ${widget.suffixText ?? ""}',
            style: TextStyle(color: Colors.blue),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ),
      ],
    );
  }
}

// * ថ្នាក់ Show_Number ជា widget សម្រាប់បង្ហាញលេខ
class Show_Number extends StatefulWidget {
  const Show_Number({
    super.key, //
    required this.leading,
    required this.value,
    this.prefixIcon,
    this.prefixText,
    this.suffixText,
  });

  final String? leading;
  final double? value;
  final IconData? prefixIcon;
  final String? prefixText;
  final String? suffixText;

  @override
  State<Show_Number> createState() => _Show_NumberState();
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
            children: [Show_Number(leading: "Text Value:", value: 10)],
          ),
        ),
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
