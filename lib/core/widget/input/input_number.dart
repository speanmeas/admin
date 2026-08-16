// * នាំចូល Flutter material និង services សម្រាប់បញ្ចូលលេខ
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

// * ថ្នាក់ state របស់ Input_Number គ្រប់គ្រងការបញ្ចូលលេខ
class _Input_NumberState extends State<Input_Number> {
  //
  final controller = TextEditingController();
  final focusNode = FocusNode();

  // * កំណត់ថាតើតម្លៃមិនត្រឹមត្រូវឬអត់
  bool is_error = false;

  // * ចាប់ផ្តើមតម្លៃដំបូង
  void init() {
    if (widget.init != null) {
      controller.text = widget.init!.toStringAsFixed(2);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // * បង្កើត TextField សម្រាប់បញ្ចូលលេខ
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      // * អនុញ្ញាតតែលេខ និងចំណុចទសភាគ
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]"))],
      decoration: InputDecoration(
        labelText: widget.lead,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        errorText: is_error ? "Invalid number" : null,
        prefixIcon: Icon(widget.prefixIcon ?? Icons.onetwothree), //
        // * ប៊ូតុងសម្អាតតម្លៃ
        suffixIcon: ExcludeFocus(
          child: Padding(
            padding: EdgeInsets.only(right: 4),
            child: IconButton(
              icon: Icon(Icons.clear, color: Colors.red),
              onPressed: () async {
                controller.clear();
                widget.onChanged?.call(null);
                is_error = false;
                focusNode.requestFocus();
                setState(() {});
              },
            ),
          ),
        ),
      ),

      onChanged: (v) {
        // * បំប្លែងអត្ថបទទៅជាលេខ និងពិនិត្យកំហុស
        final double? value = double.tryParse(v);
        is_error = value == null;
        widget.onChanged?.call(value);
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }
}

// * ថ្នាក់ Input_Number ជា widget សម្រាប់បញ្ចូលលេខ
class Input_Number extends StatefulWidget {
  const Input_Number({
    super.key, //
    this.init,
    this.lead,
    this.onChanged,
    this.prefixIcon,
  });

  final double? init;
  final String? lead;
  final Function(double?)? onChanged;
  final IconData? prefixIcon;

  @override
  State<Input_Number> createState() => _Input_NumberState();
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
              Input_Number(
                lead: "Number Value:",
                init: 5.0,
                onChanged: (v) {
                  print("Changed: $v");
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
