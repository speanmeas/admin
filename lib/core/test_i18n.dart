import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/i18n.dart";
import "package:speanmeas/core/theme/theme_data.dart" as theme;

/// Usage:
///   import "..." as form;
///   form.Main_(context);

class _Main_State extends State<Main_> {
  @override
  Widget build(BuildContext context) {
    final I18N i18n = context.watch<I18N>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Title"), //
        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1), //
          child: Divider(height: 1, color: Colors.black), //
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 600,
            margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Column(
              children: [
                Text("This is a simple form."), //

                OutlinedButton.icon(
                  icon: Icon(Icons.check), //
                  label: Text(i18n.tr("Hello")), //
                  onPressed: () {
                    //
                  }, //
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Main_ extends StatefulWidget {
  Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

void main() async {
  // await i18n.set_locale("en_EN");
  await i18n.set_locale("km_KH");
  runApp(
    ChangeNotifierProvider(
      create: (_) => i18n, //
      child: MaterialApp(
        title: "Development", //
        theme: theme.data(), //
        debugShowCheckedModeBanner: false,
        home: Main_(),
      ),
    ),
  );
}
