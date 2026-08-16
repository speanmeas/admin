// * នាំចូល Flutter material សម្រាប់បង្កើត UI
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

// * ថ្នាក់ state របស់ Menu_Button_Text គ្រប់គ្រងប៊ូតុងអត្ថបទ
class _Menu_Button_TextState extends State<Menu_Button_Text> {
  @override
  Widget build(BuildContext context) {
    // * បង្កើតប៊ូតុងអត្ថបទជាមួយ tooltip
    return Tooltip(
      message: widget.tip,
      child: InkWell(
        onTap: widget.onPressed,
        child: Container(
          height: 38,
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          alignment: Alignment.center,
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 18, //
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ), //
        ),
      ),
    );
  }
}

// * ថ្នាក់ Menu_Button_Text ជា widget ប៊ូតុងអត្ថបទ
class Menu_Button_Text extends StatefulWidget {
  const Menu_Button_Text({
    super.key, //
    required this.tip,
    required this.text,
    this.onPressed,
    this.color,
  });

  final String? tip;
  final String text;
  final Function()? onPressed;
  final Color? color;

  @override
  State<Menu_Button_Text> createState() => _Menu_Button_TextState();
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
              Menu_Button_Text(
                tip: "Create New",
                text: "Create New",
                onPressed: () {
                  print("Pressed");
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
