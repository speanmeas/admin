import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";

import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/select/select_dynamic.dart";
import "package:speanmeas/core/widget/search/search_nationality.dart";
import "package:speanmeas/core/schema/guest.g.dart";
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Create", //
        style: TextStyle(
          fontSize: 20, //
          fontWeight: FontWeight.bold,
        ),
      ),

      centerTitle: false,
      toolbarHeight: 40,
      titleSpacing: 0,

      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1), //
        child: Divider(height: 1, color: Colors.black),
      ),
    ),
    body: SingleChildScrollView(
      child: Center(
        child: Container(
          width: 600,
          padding: EdgeInsets.all(8),
          child: Column(
            spacing: 8,
            children: children, //
          ),
        ),
      ),
    ),
  );
}

class _Main_State extends State<Main_> {
  dynamic tmp;

  String? full_name;
  String? phone_number;
  String? gender;
  String? nationality_id;
  String? id_number;
  String? passport_number;
  String? note;

  void init() async {
    //
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return _layout([
      Input_Text(
        init: full_name, //
        lead: "Full Name:", //
        onChanged: (v) => full_name = v,
      ),

      Input_Text(
        init: phone_number, //
        lead: "Phone Number:", //
        onChanged: (v) => phone_number = v,
      ),

      Select_Dynamic(
        prefixIcon: Icons.wc,
        options: ["Male", "Female", "Other"], //
        onChanged: (v) => gender = v,
      ),

      Search_Nationality(
        init: "Cambodian", //
        onChanged: (v) => nationality_id = v,
      ),

      Input_Text(
        init: id_number, //
        lead: "National ID Number:", //
        onChanged: (v) => id_number = v,
      ),

      Input_Text(
        init: passport_number, //
        lead: "Passport Number:", //
        onChanged: (v) => passport_number = v,
      ),

      Input_Text(
        init: note, //
        lead: "Note:", //
        maxLines: 4, //
        onChanged: (v) => note = v ?? "",
      ),

      OutlinedButton.icon(
        icon: Icon(Icons.check),
        label: Text("Create"),
        style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
        onPressed: on_create,
      ),

      SizedBox(height: height - 100),
    ]);
  }

  void on_create() async {
    try {
      tmp = await dio.post(
        endpoint.GUEST_CRUD_CREATE, //
        data: {
          sm_guest.FULL_NAME: full_name,
          sm_guest.PHONE_NUMBER: phone_number,
          sm_guest.GENDER: gender,
          sm_guest.NATIONALITY_ID: nationality_id,
          sm_guest.ID_NUMBER: id_number,
          sm_guest.PASSPORT_NUMBER: passport_number,
          sm_guest.NOTE: note, //
        },
      );

      Navigator.pop(context, tmp.data[0]);

      snackbar(ct: context, ms: "Success", cl: Colors.green);
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  @override
  void initState() {
    super.initState();
    init();
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
      child: Main_(),
    ),
  );
}
