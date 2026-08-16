// * នាំចូល Flutter material សម្រាប់បង្កើត UI
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

// * ថ្នាក់ state របស់ Menu_Button_Icon គ្រប់គ្រងប៊ូតុងរូបតំណាង
class _Menu_Button_IconState extends State<Menu_Button_Icon> {
  @override
  Widget build(BuildContext context) {
    // * បង្កើតប៊ូតុងរូបតំណាងជាមួយ tooltip
    return Tooltip(
      message: widget.tip,
      child: InkWell(
        onTap: widget.onPressed,
        child: Container(
          height: 38,
          width: 38,
          alignment: Alignment.center,
          child: Icon(widget.icon, size: 30, color: widget.color ?? Colors.blue), //
        ),
      ),
    );
  }
}

// * ថ្នាក់ Menu_Button_Icon ជា widget ប៊ូតុងរូបតំណាង
class Menu_Button_Icon extends StatefulWidget {
  const Menu_Button_Icon({
    super.key, //
    required this.tip,
    required this.icon,
    this.onPressed,
    this.color,
  });

  final String? tip;
  final IconData icon;
  final Function()? onPressed;
  final Color? color;

  @override
  State<Menu_Button_Icon> createState() => _Menu_Button_IconState();
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
              Menu_Button_Icon(
                tip: "Create New",
                icon: Icons.add,
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
