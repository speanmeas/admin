// * នាំចូល Flutter material និង flutter_typeahead សម្រាប់ autocomplete
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/utility/all.dart";

// * ថ្នាក់ state របស់ Select_Dynamic គ្រប់គ្រងការជ្រើសរើសតម្លៃ
class _Select_DynamicState extends State<Select_Dynamic> {
  // * controller សម្រាប់អត្ថបទ
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // * កំណត់តម្លៃដំបូង
    if (widget.init != null) {
      controller.text = widget.init.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    // * បង្កើត TypeAheadField សម្រាប់ជ្រើសរើស
    return TypeAheadField<dynamic>(
      controller: controller,
      itemBuilder: (context, i) => ListTile(title: Text(i.toString())),
      suggestionsCallback: (q) => widget.options?.toList() ?? <dynamic>[],
      builder: (context, controller, focusNode) {
        return TextField(
          readOnly: true,
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: widget.lead,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: Icon(widget.prefixIcon),
            // * ប៊ូតុងសម្អាតតម្លៃ
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 4),
              child: IconButton(
                icon: Icon(Icons.clear, color: Colors.red),
                onPressed: () {
                  controller.clear();
                  widget.onChanged?.call(null);
                },
              ), //
            ),
          ),
        );
      },
      onSelected: (value) {
        // * កំណត់តម្លៃដែលបានជ្រើសរើស
        controller.text = value.toString();
        widget.onChanged?.call(value);
      },
    );
  }
}

// * ថ្នាក់ Select_Dynamic ជា widget សម្រាប់ជ្រើសរើសតម្លៃថាមវន្ត
class Select_Dynamic extends StatefulWidget {
  const Select_Dynamic({
    super.key, //
    required this.options,
    required this.onChanged,
    this.lead,
    this.init,
    this.prefixIcon,
  });

  final String? lead;
  final dynamic init;
  final List<dynamic>? options;
  final Function(dynamic)? onChanged;
  final IconData? prefixIcon;

  @override
  State<Select_Dynamic> createState() => _Select_DynamicState();
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
          body: Center(
            child: Select_Dynamic(
              lead: "Number of Guests:",
              init: 5,
              options: List.generate(100, (index) => index),
              prefixIcon: Icons.people_alt_outlined, //
              onChanged: (value) {
                print("Selected value: $value");
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
