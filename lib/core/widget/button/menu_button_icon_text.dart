// * នាំចូល Flutter material សម្រាប់បង្កើត UI
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

// * ថ្នាក់ state របស់ Menu_Button_Icon គ្រប់គ្រងប៊ូតុងរូបតំណាង
class _Menu_Button_Icon_TextState extends State<Menu_Button_Icon_Text> {
  @override
  Widget build(BuildContext context) {
    // * បង្កើតប៊ូតុងរូបតំណាងជាមួយ tooltip និងអត្ថបទ
    return Tooltip(
      message: widget.tip,
      child: InkWell(
        onTap: widget.onPressed,
        child: Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 30, color: widget.color ?? Colors.blue), //
              const SizedBox(width: 4), //
              Text(
                widget.text,
                style: TextStyle(
                  fontSize: 16, //
                  color: widget.color ?? Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// * ថ្នាក់ Menu_Button_Icon ជា widget ប៊ូតុងរូបតំណាង
class Menu_Button_Icon_Text extends StatefulWidget {
  const Menu_Button_Icon_Text({
    super.key, //
    required this.tip,
    required this.icon,
    required this.text,
    this.onPressed,
    this.color,
  });

  final String? tip;
  final IconData icon;
  final String text;
  final Function()? onPressed;
  final Color? color;

  @override
  State<Menu_Button_Icon_Text> createState() => _Menu_Button_Icon_TextState();
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
              Menu_Button_Icon_Text(
                tip: "Create New",
                icon: Icons.add,
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
