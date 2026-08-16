// * នាំចូល Flutter material និង services សម្រាប់ dialog
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

// * ថ្នាក់ state របស់ Dialog_ គ្រប់គ្រង dialog កែលេខទូរស័ព្ទ
class _Dialog_State extends State<Dialog_> {
  dynamic tmp;

  String phone_number = "";

  void init() async {
    phone_number = widget.input?.toString() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    // * បង្កើត AlertDialog សម្រាប់បញ្ចូលលេខទូរស័ព្ទ
    return AlertDialog(
      titlePadding: EdgeInsets.all(8),
      contentPadding: EdgeInsets.all(4),
      actionsPadding: EdgeInsets.all(4),
      alignment: AlignmentGeometry.topCenter, //
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Update Phone Number", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), //
        ],
      ),

      content: Column(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          // * ប្រអប់បញ្ចូលលេខទូរស័ព្ទ
          TextField(
            autofocus: true,

            keyboardType: TextInputType.numberWithOptions(decimal: false),
            // * អនុញ្ញាតតែលេខ និងសញ្ញាបូក
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9+]"))],
            decoration: InputDecoration(
              labelText: "Phone Number:", //
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              // * ប៊ូតុងសម្អាតតម្លៃ
              suffixIcon: ExcludeFocus(
                child: Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: IconButton(
                    icon: Icon(Icons.clear, color: Colors.red),
                    onPressed: () {
                      phone_number = "";
                      setState(() {});
                    },
                  ), //
                ),
              ),
            ),
            onChanged: (v) {
              phone_number = v;
              setState(() {});
            },
            onSubmitted: (v) => on_okay(),
          ),
        ],
      ),
      actions: [
        // * ប៊ូតុងបោះបង់
        OutlinedButton(
          style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
          onPressed: () {
            Navigator.pop(context); //
          },
          child: Text("Cancel"), //
        ),
        // * ប៊ូតុងយល់ព្រម
        OutlinedButton(
          onPressed: on_okay, //
          child: Text("Okay"), //
        ),
      ],
    );
  }

  // * រក្សាទុកលេខទូរស័ព្ទថ្មី
  void on_okay() async {
    // * ផ្ញើសំណើធ្វើបច្ចុប្បន្នភាពលេខទូរស័ព្ទ
    tmp = await dio.post(
      endpoint.USER_CRUD_UPDATE, //
      data: {
        User.ID: await secure.read(key: "_id"), //
        User.PHONE_NUMBER: phone_number, //
      },
    );
    if (tmp == null) return snackbar(ct: context, ms: "Error: ${endpoint.USER_CRUD_UPDATE}", cl: Colors.red);

    snackbar(ct: context, ms: "Success", cl: Colors.green);
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    phone_number = widget.input?.toString() ?? "";
    init();
  }
}

// * ថ្នាក់ Dialog_ ជា dialog កែលេខទូរស័ព្ទ
class Dialog_ extends StatefulWidget {
  const Dialog_({
    super.key, //
    this.input,
  });

  final dynamic input;

  @override
  State<Dialog_> createState() => _Dialog_State();
}

// * បង្ហាញ dialog កែលេខទូរស័ព្ទ
Future<dynamic> view({
  required BuildContext context, //
  dynamic input, //
}) {
  return showDialog<dynamic>(
    context: context,
    builder: (context) {
      return Dialog_(input: input); //
    },
  );
}

class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          onPressed: () async {
            final v = await view(
              context: context, //
              input: "0123456789", //
            );
            print("value: $v");
          },
          child: const Text("Show Dialog"),
        ),
      ),
    );
  }
}

class Main_ extends StatefulWidget {
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
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
        home: Main_(), //
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
