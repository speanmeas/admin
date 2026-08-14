import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";
import "package:speanmeas/core/config.dart";
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "panel_body.dart" as body;
import "panel_left.dart" as left;
import "panel_top.dart" as top;
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import

class _LayoutState extends State<Layout> {
  //
  dynamic tmp;

  bool is_mobile = false;

  @override
  Widget build(BuildContext context) {
    is_mobile = MediaQuery.of(context).size.width < MOBILE_SCREEN_WIDTH;
    return Scaffold(
      appBar: AppBar(
        title: top.Panel_Top(), //
        titleSpacing: 0,
        toolbarHeight: 48,
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1), //
          child: Divider(height: 1, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                // panel left
                if (!is_mobile)
                  Container(
                    width: 250,
                    decoration: BoxDecoration(border: Border(right: BorderSide())), //
                    child: left.Panel_Left(), //
                  ),

                // panel body
                Expanded(
                  child: body.Panel_Body(), //
                ),
              ],
            ),
          ),
        ],
      ),

      // drawer
      drawer: is_mobile ? Drawer(child: left.Panel_Left()) : null,
    );
  }
}

class Layout extends StatefulWidget {
  const Layout({super.key});
  @override
  State<Layout> createState() => _LayoutState();
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
        home: Layout(), //
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
