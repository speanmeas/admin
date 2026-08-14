// * នាំចូល Flutter material និង Provider សម្រាប់ state management
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

// * ថ្នាក់ state របស់ Layout គ្រប់គ្រងប្លង់ទូទៅរបស់កម្មវិធី
class _LayoutState extends State<Layout> {
  //
  dynamic tmp;

  // * កំណត់ថាតើជាឧបករណ៍ចល័តឬអត់
  bool is_mobile = false;

  @override
  Widget build(BuildContext context) {
    // * ពិនិត្យទទឹងអេក្រង់ដើម្បីកំណត់របៀបបង្ហាញ
    is_mobile = MediaQuery.of(context).size.width < MOBILE_SCREEN_WIDTH;
    return Scaffold(
      // * បន្ទះខាងលើ
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
                // * បន្ទះខាងឆ្វេង (menu)
                if (!is_mobile)
                  Container(
                    width: 250,
                    decoration: BoxDecoration(border: Border(right: BorderSide())), //
                    child: left.Panel_Left(), //
                  ),

                // * បន្ទះខ្លឹមសារ
                Expanded(
                  child: body.Panel_Body(), //
                ),
              ],
            ),
          ),
        ],
      ),

      // * drawer សម្រាប់ឧបករណ៍ចល័ត
      drawer: is_mobile ? Drawer(child: left.Panel_Left()) : null,
    );
  }
}

// * ថ្នាក់ Layout ជា widget ចម្បងរបស់កម្មវិធី
class Layout extends StatefulWidget {
  const Layout({super.key});
  @override
  State<Layout> createState() => _LayoutState();
}

// * ចំណុចចាប់ផ្តើមសម្រាប់ការអភិវឌ្ឍន៍
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
