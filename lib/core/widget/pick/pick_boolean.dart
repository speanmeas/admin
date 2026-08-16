// * នាំចូល Flutter material និង flutter_typeahead សម្រាប់ autocomplete
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/utility/all.dart";

// * ថ្នាក់ state របស់ Picker_Boolean គ្រប់គ្រងការជ្រើសរើសតម្លៃ boolean
class _Picker_BooleanState extends State<Picker_Boolean> {
  //
  // * controller សម្រាប់អត្ថបទ
  final controller = TextEditingController();

  // * ចាប់ផ្តើមតម្លៃដំបូង
  void init() {
    if (widget.initial != null) {
      if (widget.initial == true) controller.text = "Yes";
      if (widget.initial == false) controller.text = "No";
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // * បង្កើត TypeAheadField សម្រាប់ជ្រើសរើស Yes/No
    return TypeAheadField<String>(
      controller: controller,
      suggestionsCallback: (query) => ["Yes", "No"],
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: widget.title ?? "Logic 1:", //
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            // * រូបតំណាង toggle អាស្រ័យលើតម្លៃ
            prefixIcon: Icon(controller.text == "Yes" ? Icons.toggle_on : Icons.toggle_off_outlined),
            // * ប៊ូតុងសម្អាតតម្លៃ
            suffixIcon: ExcludeFocus(
              child: Padding(
                padding: EdgeInsets.only(right: 4),
                child: IconButton(
                  icon: Icon(Icons.clear, color: Colors.red),
                  onPressed: () async {
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
      onSelected: (v) {
        // * កំណត់តម្លៃដែលបានជ្រើសរើស
        controller.text = v;
        if (v == "Yes") widget.onChanged?.call(true);
        if (v == "No") widget.onChanged?.call(false);
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

// * ថ្នាក់ Picker_Boolean ជា widget សម្រាប់ជ្រើសរើសតម្លៃ boolean
class Picker_Boolean extends StatefulWidget {
  const Picker_Boolean({
    super.key, //
    this.initial,
    this.title, //
    this.onChanged,
  });

  final bool? initial;
  final String? title;
  final Function(bool?)? onChanged;

  @override
  State<Picker_Boolean> createState() => _Picker_BooleanState();
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
            children: [
              Picker_Boolean(
                title: "Boolean Value:",
                initial: true,
                onChanged: (v) {
                  print("Selected: $v");
                },
              ),
            ],
          ),
        ),
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
