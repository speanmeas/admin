// * នាំចូល Flutter material និងធនធានចាំបាច់សម្រាប់ទំព័រប្រវត្តិរូប
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/secure.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/schema/user.g.dart";
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "dialog/dialog_full_name.dart" as dialog_fn;
import "dialog/dialog_phone_number.dart" as dialog_pn;
import "dialog/dialog_username.dart" as dialog_un;
import "dialog/dialog_password.dart" as dialog_pw;

import "sign_in.dart" as sign_in;
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

// * បង្កើត layout មូលដ្ឋានសម្រាប់ទំព័រប្រវត្តិរូប
Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "User Profile", //
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
          margin: EdgeInsets.all(4),
          child: Column(children: children),
        ),
      ),
    ),
  );
}

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទំព័រប្រវត្តិរូបអ្នកប្រើ
class _Main_State extends State<Main_> {
  //
  dynamic tmp;
  dynamic map_data;

  // * ព័ត៌មានអ្នកប្រើ
  String? full_name;
  String? phone_number;
  String? username;
  String? password;

  // * តួនាទីរបស់អ្នកប្រើ
  bool? is_admin;
  bool? is_manager;
  bool? is_receptionist;
  bool? is_housekeeper;

  // * ចាប់ផ្តើមទាញយកព័ត៌មានអ្នកប្រើ
  void init() async {
    try {
      //
      // * ផ្ទៀងផ្ទាត់ access token
      tmp = await dio.post(
        endpoint.AUTH_ACCESS_TOKEN, //
        data: {"access_token": await secure.read(key: "access_token")},
      );
      if (tmp == null) throw Exception("Invalid Access Token");
      map_data = tmp.data[0];

      // * កំណត់ព័ត៌មានអ្នកប្រើ
      full_name = map_data?[sm_user.FULL_NAME]?.toString();
      phone_number = map_data?[sm_user.PHONE_NUMBER]?.toString();
      username = map_data?[sm_user.USERNAME]?.toString();
      password = map_data?[sm_user.PASSWORD]?.toString();

      is_admin = map_data?[sm_user.IS_ADMIN] == true;
      is_manager = map_data?[sm_user.IS_MANAGER] == true;
      is_receptionist = map_data?[sm_user.IS_RECEPTIONIST] == true;
      is_housekeeper = map_data?[sm_user.IS_HOUSEKEEPER] == true;

      setState(() {});
    } catch (e, st) {
      // * បង្ហាញកំហុស និងត្រឡប់ទៅទំព័រចូលប្រព័ន្ធ
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => sign_in.Main_()));
    }

    //
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return _layout([
      // * បង្ហាញតួនាទីរបស់អ្នកប្រើ
      (() {
        String value = "N/A";
        if (is_admin == true) value = "Administrator";
        if (is_manager == true) value = "Manager";
        if (is_receptionist == true) value = "Receptionist";
        if (is_housekeeper == true) value = "Housekeeper";
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ],
        );
      })(),

      SizedBox(height: 4),

      // * បង្ហាញឈ្មោះពេញ និងប៊ូតុងកែសម្រួល
      (() {
        String value = "N/A";
        if (full_name != null) //
          value = full_name!;
        return Row(
          spacing: 4,
          children: [
            Icon(Icons.person_pin_outlined),
            Text("Full Name: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(fontSize: 16, color: Colors.blue)),
            InkWell(
              child: Icon(Icons.edit_outlined, color: Colors.blue),
              onTap: () async {
                tmp = await dialog_fn.view(context: context, input: value);
                if (tmp != null) init();
              },
            ),
          ],
        );
      })(),

      // * បង្ហាញលេខទូរស័ព្ទ និងប៊ូតុងកែសម្រួល
      (() {
        String value = "N/A";
        if (phone_number != null) //
          value = phone_number!;
        return Row(
          spacing: 4,
          children: [
            Icon(Icons.phone_outlined),
            Text("Phone Number: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(fontSize: 16, color: Colors.blue)),
            InkWell(
              child: Icon(Icons.edit_outlined, color: Colors.blue),
              onTap: () async {
                tmp = await dialog_pn.view(context: context, input: value);
                if (tmp != null) init();
              },
            ),
          ],
        );
      })(),

      // * បង្ហាញឈ្មោះអ្នកប្រើ និងប៊ូតុងកែសម្រួល
      (() {
        String value = "N/A";
        if (username != null) //
          value = username!;
        return Row(
          spacing: 4,
          children: [
            Icon(Icons.person_outline),
            Text("Username: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(fontSize: 16, color: Colors.blue)),
            InkWell(
              child: Icon(Icons.edit_outlined, color: Colors.blue),
              onTap: () async {
                tmp = await dialog_un.view(context: context, input: value);
                if (tmp != null) init();
              },
            ),
          ],
        );
      })(),

      // * បង្ហាញពាក្យសម្ងាត់ និងប៊ូតុងកែសម្រួល
      (() {
        String value = "**********";
        return Row(
          spacing: 4,
          children: [
            Icon(Icons.lock_outline),
            Text("Password: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(fontSize: 16, color: Colors.blue)),
            InkWell(
              child: Icon(Icons.edit_outlined, color: Colors.blue),
              onTap: () async {
                tmp = await dialog_pw.view(context: context);
                if (tmp != null) init();
              },
            ),
          ],
        );
      })(),

      SizedBox(height: 8),

      // * ប៊ូតុងចាកចេញពីប្រព័ន្ធ
      OutlinedButton.icon(
        icon: Icon(Icons.logout), //
        label: Text("Sign Out"),
        style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
        onPressed: on_sign_out,
      ),

      SizedBox(height: height - 100),
    ]);
  }

  // * ដំណើរការចាកចេញពីប្រព័ន្ធ
  void on_sign_out() async {
    try {
      //
      // * លុប token និងព័ត៌មានចូលប្រព័ន្ធ
      // await dio.options.headers.remove("Authorization");
      dio.clear_token();
      await secure.delete(key: "access_token");
      await secure.delete(key: "_id");

      // * ត្រឡប់ទៅទំព័រចូលប្រព័ន្ធ
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => sign_in.Main_()));

      //
      snackbar(ct: context, ms: "Success", cl: Colors.green);
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  //
  @override
  void initState() {
    super.initState();
    init();
  }
}

// * ថ្នាក់ Main_ ជាទំព័រប្រវត្តិរូបអ្នកប្រើ
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
        home: const Main_(), //
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
