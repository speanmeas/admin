import "dart:async";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n.dart";

import "package:speanmeas/core/config.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart";
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/utility/pprint.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/theme.dart"; // ignore: unused_import

import "package:speanmeas/core/schema/room.g.dart";
import "package:speanmeas/core/schema/front_desk.g.dart";
import "package:speanmeas/core/schema/guest.g.dart";
import "package:speanmeas/core/schema/mini_bar.g.dart";

import "form/charge.dart" as charge;

class _Main_State extends State<Main_> {
  //
  dynamic tmp;
  Timer? _debounce; // * ពន្យាពេល rebuild ពេលវាយស្វែងរក
  final c_search = TextEditingController();

  List<Map<String, dynamic>> list_r = [];
  Map<String, dynamic> map_fd = {};
  List<Map<String, dynamic>> list_mb = [];

  // * mock persistence: room_id → [{name, price, qty, total}]
  // * (frontend only សម្រាប់ពេលនេះ រក្សាទុកក្នុងអង្គចងចាំ បាត់ពេល reload)
  Map<String, List<Map<String, dynamic>>> map_charge = {};

  // * walk-in charges: [{name, price, qty, total}]
  // * (អតិថិជនដើរចូលទិញ មិនស្នាក់នៅបន្ទប់)
  List<Map<String, dynamic>> list_walkin = [];

  void init() async {
    try {
      // * ទាញយកទិន្នន័យបន្ទប់ទាំងអស់ពី Server
      tmp = await dio.post(
        endpoint.ROOM_CRUD_READ, //
        data: {
          "key": sm_room.NUMBER, //
          "order": 1, //
        },
      );
      list_r = List<Map<String, dynamic>>.from(tmp.data);

      // * ទាញយកទិន្នន័យ front desk ដែលទាក់ទងនឹងបន្ទប់
      // * (ផ្ញើរួមគ្នាប៉ារ៉ាឡែល មិនរង់ចាំមួយៗ ដើម្បីកុំឲ្យយឺត)
      final ids = <dynamic>[];
      for (var r in list_r) {
        final fd_id = r[sm_room.FRONT_DESK_ID];
        if (fd_id != null && !ids.contains(fd_id)) ids.add(fd_id);
      }

      // * ទាញយក front desk នីមួយៗដោយ id របស់វា
      final futures = [
        for (var fd_id in ids)
          dio.post(
            endpoint.FRONT_DESK_READ_ID, //
            data: {
              sm_front_desk.ID: fd_id, //
            },
          ),
      ];
      final results = await Future.wait(futures);
      for (var i = 0; i < ids.length; i++) {
        final fd = results[i].data[0];
        if (fd != null) map_fd[ids[i]] = fd;
      }

      // * ទាញយកបញ្ជីទំនិញ mini bar (catalog) ពី Server
      tmp = await dio.post(
        endpoint.MINI_BAR_CRUD_READ, //
        data: {
          "key": DEFAULT_KEY, //
          "order": DEFAULT_ORDER, //
          "offset": 0, //
          "limit": DEFAULT_LIMIT_ROW,
        },
      );
      list_mb = List<Map<String, dynamic>>.from(tmp.data);

      setState(() {});
      //
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  //
  Widget _layout(List<Widget> children) {
    return Scaffold(
      body: Column(
        children: [
          // * បង្ហាញប៊ូតុង refresh
          Row(
            children: [
              // * ប៊ូតុង Walk-in (អតិថិជនដើរចូលទិញ មិនស្នាក់នៅបន្ទប់)
              OutlinedButton.icon(
                onPressed: list_mb.isEmpty ? null : on_walkin, //
                icon: Icon(Icons.person_add_outlined),
                label: Text("Walk-in"),
                style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(Colors.purple),
                ),
              ), //

              Spacer(),

              Container(
                width: 200,
                height: 40,
                padding: EdgeInsets.only(top: 8), //
                child: TextField(
                  controller: c_search,
                  decoration: InputDecoration(
                    isDense: true, //
                    labelText: "ស្វែងរក", //
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                    prefixIcon: Icon(Icons.search, size: 20), //
                  ),
                  onChanged: (v) {
                    // * រង់ចាំអ្នកប្រើឈប់វាយ 500ms ទើប rebuild
                    _debounce?.cancel();
                    _debounce = Timer(const Duration(milliseconds: 500), () {
                      setState(() {});
                    });
                  },
                ),
              ),

              Spacer(),

              Tooltip(
                message: "Refresh",
                child: InkWell(
                  onTap: init,
                  child: Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    child: Icon(Icons.refresh, size: 30, color: Colors.blue), //
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Wrap(
                  children: children, //
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _layout([
      // * សង្ខេប Walk-in (អតិថិជនមិនស្នាក់នៅបន្ទប់)
      if (list_walkin.isNotEmpty)
        Container(
          width: 500,
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.purple, width: 1),
          ),
          child: Row(
            children: [
              // info
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // header row
                    Row(
                      spacing: 4,
                      children: [
                        Icon(
                          Icons.person_add_outlined,
                          size: 24,
                          color: Colors.purple,
                        ), //
                        Text(
                          "Walk-in Mini Bar:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ), //
                        //
                        SizedBox(width: 4), //
                        Icon(Icons.circle, size: 6), //
                        Text(
                          "$_walkin_total \$",
                          style: TextStyle(color: Colors.purple),
                        ), //
                      ],
                    ),

                    // items
                    for (var line in list_walkin)
                      Row(
                        spacing: 4,
                        children: [
                          Text(
                            "${line[sm_mini_bar.NAME]}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ), //
                          Text(
                            "x${line["qty"]}",
                            style: TextStyle(color: Colors.grey),
                          ), //
                          Text(
                            "${line["total"]} \$",
                            style: TextStyle(color: Colors.blue),
                          ), //
                        ],
                      ),
                  ],
                ),
              ),

              // clear
              OutlinedButton.icon(
                onPressed: on_clear_walkin, //
                icon: Icon(Icons.delete_outline),
                label: Text("Clear"),
                style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(Colors.red),
                ),
              ),
            ],
          ),
        ),

      // * បង្ហាញបញ្ជីបន្ទប់ទាំងអស់ (ត្រងតាមការស្វែងរក)
      for (var r in _list_show)
        Container(
          width: 500,
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
          ),
          child: Row(
            children: [
              // info.
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // * លេខបន្ទប់ (កណ្តាល) + ស្ថានភាព (ស្តាំ)
                    Stack(
                      children: [
                        // * លេខបន្ទប់នៅកណ្តាលជានិច្ច
                        Row(
                          spacing: 4,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "បន្ទប់ ${r[sm_room.NUMBER]}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),

                        // * ស្ថានភាពបន្ទប់នៅខាងស្តាំ
                        (() {
                          var color = Colors.black; // Default color
                          if (["Available"].contains(r[sm_room.STATUS]))
                            color = Colors.green;
                          if (["Pending Pay"].contains(r[sm_room.STATUS]))
                            color = Colors.orange;
                          if (["Pending Leave"].contains(r[sm_room.STATUS]))
                            color = Colors.blue;
                          if (["Pending Clean"].contains(r[sm_room.STATUS]))
                            color = Colors.grey;
                          if (["Pending Fix"].contains(r[sm_room.STATUS]))
                            color = Colors.red;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.circle, size: 10, color: color),
                              SizedBox(width: 4),
                              Text(
                                "${r[sm_room.STATUS]}",
                                style: TextStyle(fontSize: 14, color: color),
                              ),
                            ],
                          );
                        })(),
                      ],
                    ),

                    // * room info
                    Row(
                      spacing: 4,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${r[sm_room.KIND]}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("-"), //
                        Text(
                          "${r[sm_room.USD_PER_3H]} \$ / 3 ម៉ោង",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ), //
                        Text("-"), //
                        Text(
                          "${r[sm_room.USD_PER_DAY]} \$ / 1 ថ្ងៃ",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    //
                    if (r[sm_room.FRONT_DESK_ID] != null) ...[
                      // guest info
                      if (!"${r[sm_room.STATUS]}".contains("Pending Fix"))
                        (() {
                          final guest =
                              _fd(r)[sm_front_desk.GUEST_ID]
                                  as Map<String, dynamic>? ??
                              {};
                          final guest_name = guest[sm_guest.FULL_NAME] ?? "N/A";
                          final guest_phone =
                              guest[sm_guest.PHONE_NUMBER] ?? "N/A";
                          return Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.person, size: 24), //
                              Text(
                                "អតិថិជន:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              //
                              SizedBox(width: 2), //
                              Icon(Icons.circle, size: 6), //
                              Text(
                                guest_name,
                                style: TextStyle(color: Colors.blue),
                              ), //
                              //
                              SizedBox(width: 2), //
                              Icon(Icons.circle, size: 6), //
                              Text(
                                guest_phone,
                                style: TextStyle(color: Colors.blue),
                              ), //
                            ],
                          );
                        })(),
                    ],

                    // * mini bar charge info
                    (() {
                      final room_id = "${r[sm_room.ID]}";
                      final lines = map_charge[room_id] ?? [];
                      final total = _charge_total(room_id);
                      return Row(
                        spacing: 4,
                        children: [
                          Icon(Icons.local_bar_outlined, size: 24), //
                          Text(
                            "Mini Bar:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ), //
                          //
                          SizedBox(width: 4), //
                          Icon(Icons.circle, size: 6), //
                          Text(
                            "$total \$",
                            style: TextStyle(color: Colors.blue),
                          ), //
                          //
                          SizedBox(width: 4), //
                          Icon(Icons.circle, size: 6), //
                          Text(
                            "${lines.length} Items",
                            style: TextStyle(color: Colors.blue),
                          ), //
                        ],
                      );
                    })(),

                    // buttons
                    Row(
                      spacing: 4,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if ([
                          "Pending Pay",
                          "Pending Leave",
                        ].contains(r[sm_room.STATUS])) //
                          OutlinedButton.icon(
                            onPressed: list_mb.isEmpty
                                ? null
                                : () => on_charge(r), //
                            icon: Icon(Icons.local_bar_outlined),
                            label: Text("Charge"),
                            style: ButtonStyle(
                              foregroundColor: WidgetStatePropertyAll(
                                Colors.blue,
                              ),
                            ),
                          ), //

                        if ((map_charge["${r[sm_room.ID]}"] ?? [])
                            .isNotEmpty) //
                          OutlinedButton.icon(
                            onPressed: () => on_clear(r), //
                            icon: Icon(Icons.delete_outline),
                            label: Text("Clear"),
                            style: ButtonStyle(
                              foregroundColor: WidgetStatePropertyAll(
                                Colors.red,
                              ),
                            ),
                          ), //
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    ]);
  }

  //
  // * បញ្ជីបន្ទប់ដែលត្រងតាមការស្វែងរក (លេខបន្ទប់ + ស្ថានភាព)
  List<Map<String, dynamic>> get _list_show {
    final q = c_search.text.trim().toLowerCase();
    if (q.isEmpty) return list_r;
    return list_r.where((r) {
      final room_number = "${r[sm_room.NUMBER]}".toLowerCase();
      final room_status = "${r[sm_room.STATUS]}".toLowerCase();
      final room_kind = "${r[sm_room.KIND]}".toLowerCase();
      return room_number.contains(q) ||
          room_status.contains(q) ||
          room_kind.contains(q);
    }).toList();
  }

  //
  // * បន្ថែមទំនិញ mini bar ទៅបន្ទប់
  void on_charge(dynamic r) async {
    try {
      // * គណនាចំនួនដែលបានគិតប្រាក់រួចហើយរបស់បន្ទប់នេះ
      final sold = <dynamic, int>{};
      for (var line in map_charge["${r[sm_room.ID]}"] ?? []) {
        final id = line[sm_mini_bar.ID];
        if (id != null) sold[id] = (sold[id] ?? 0) + (line["qty"] as int);
      }

      //
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => charge.Charge_(
            room: r, //
            catalog: list_mb, //
            sold: sold, //
          ), //
        ),
      );

      //
      if (tmp != null) {
        map_charge["${r[sm_room.ID]}"] = List<Map<String, dynamic>>.from(tmp);
        setState(() {});
      }

      //
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  //
  // * សម្អាតទំនិញ mini bar របស់បន្ទប់
  void on_clear(dynamic r) {
    map_charge.remove("${r[sm_room.ID]}");
    setState(() {});
  }

  //
  // * បន្ថែមទំនិញ mini bar សម្រាប់អតិថិជនដើរចូលទិញ (Walk-in)
  void on_walkin() async {
    try {
      // * គណនាចំនួនដែលបានលក់រួចហើយ (walk-in)
      final sold = <dynamic, int>{};
      for (var line in list_walkin) {
        final id = line[sm_mini_bar.ID];
        if (id != null) sold[id] = (sold[id] ?? 0) + (line["qty"] as int);
      }

      //
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => charge.Charge_(
            room: null, //
            catalog: list_mb, //
            sold: sold, //
          ), //
        ),
      );

      //
      if (tmp != null) {
        list_walkin.addAll(List<Map<String, dynamic>>.from(tmp));
        setState(() {});
      }

      //
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  //
  // * សម្អាតទំនិញ walk-in ទាំងអស់
  void on_clear_walkin() {
    list_walkin.clear();
    setState(() {});
  }

  //
  // * សរុបតម្លៃ walk-in
  double get _walkin_total {
    var total = 0.0;
    for (var line in list_walkin) {
      total += (line["total"] as num).toDouble();
    }
    return total;
  }

  //
  // * សរុបតម្លៃ mini bar របស់បន្ទប់
  double _charge_total(String room_id) {
    var total = 0.0;
    for (var line in map_charge[room_id] ?? []) {
      total += (line["total"] as num).toDouble();
    }
    return total;
  }

  //
  // * ស្វែងរក front desk របស់បន្ទប់ដោយសុវត្ថិភាព (បើគ្មាន ត្រឡប់ {})
  Map<String, dynamic> _fd(dynamic r) =>
      map_fd[r[sm_room.FRONT_DESK_ID]] as Map<String, dynamic>? ?? {};

  //
  @override
  void initState() {
    super.initState();
    init();
  }

  //
  @override
  void dispose() {
    _debounce?.cancel();
    c_search.dispose();
    super.dispose();
  }

  //
}

//
class Main_ extends StatefulWidget {
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

//
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
