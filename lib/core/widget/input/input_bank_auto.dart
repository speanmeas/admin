// * នាំចូល Flutter material និង flutter_typeahead សម្រាប់ autocomplete
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/utility/all.dart";

// * ថ្នាក់ state របស់ Input_Bank_Auto គ្រប់គ្រងការបញ្ចូលធនាគារដោយស្វ័យប្រវត្តិ
class _Input_Bank_AutoState extends State<Input_Bank_Auto> {
  dynamic tmp;
  dynamic data;

  // * បញ្ជីជម្រើស និងធនាគាររបស់យើង
  List<String> options = [];
  List<String> our_banks = ["ABA Bank", "ACLEDA Bank"];

  final controller = TextEditingController();

  // * ចាប់ផ្តើមទាញយកបញ្ជីធនាគារ
  void init() async {
    try {
      // * ទាញយកបញ្ជីធនាគារពី server
      tmp = await dio.post(endpoint.BANK_CRUD_READ);
      data = tmp.data as List<dynamic>;

      // * បង្កើតជម្រើស "ពីធនាគារ ទៅធនាគាររបស់យើង"
      for (var to in our_banks)
        for (var from in data.map((e) => e["name"])) //
          if (from.isNotEmpty) options.add("$from to $to");
    } catch (e, st) {
      pprint(st);
    }

    // * កំណត់តម្លៃដំបូង
    if (widget.init != null) controller.text = widget.init!;
  }

  @override
  Widget build(BuildContext context) {
    // * បង្កើត TypeAheadField សម្រាប់បញ្ចូលធនាគារដោយស្វ័យប្រវត្តិ
    return TypeAheadField<dynamic>(
      controller: controller,
      itemBuilder: (context, item) => ListTile(title: Text(item)),
      // * ត្រងជម្រើសតាមអត្ថបទដែលបានបញ្ចូល
      suggestionsCallback: (q) {
        List<dynamic> opts = [];
        for (var e in options) {
          tmp = e.split(" to ")[0];
          if (tmp.toLowerCase().contains(q.toLowerCase())) //
            opts.add(e);
        }
        return opts;
      },
      builder: (context, controller, focusNode) {
        return TextField(
          maxLines: widget.maxLines ?? 4,
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: "Note:", //
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: Icon(widget.prefixIcon ?? Icons.note_alt_outlined, color: Colors.blue),
            // * ប៊ូតុងសម្អាតតម្លៃ
            suffixIcon: ExcludeFocus(
              child: Padding(
                padding: EdgeInsets.only(right: 4),
                child: IconButton(
                  icon: Icon(Icons.clear, color: Colors.red),
                  onPressed: () async {
                    controller.clear();
                    widget.onChanged?.call(null);
                    focusNode.requestFocus();
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
          onChanged: (v) {
            widget.onChanged?.call(v);
          },
        );
      },
      onSelected: (v) {
        // * កំណត់តម្លៃដែលបានជ្រើសរើស
        controller.text = v.toString();
        widget.onChanged?.call(v);
      },
    );
  }

  @override
  initState() {
    super.initState();
    init();
  }
}

// * ថ្នាក់ Input_Bank_Auto ជា widget សម្រាប់បញ្ចូលធនាគារដោយស្វ័យប្រវត្តិ
class Input_Bank_Auto extends StatefulWidget {
  const Input_Bank_Auto({
    super.key, //
    this.init,
    this.prefixIcon,
    this.maxLines,
    required this.onChanged,
  });

  final String? init;
  final IconData? prefixIcon;
  final int? maxLines;
  final Function(String?)? onChanged;

  @override
  State<Input_Bank_Auto> createState() => _Input_Bank_AutoState();
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
            child: Input_Bank_Auto(
              onChanged: (data) {
                print("Selected Data: $data");
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
