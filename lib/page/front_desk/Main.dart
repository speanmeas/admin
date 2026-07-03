import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/layout/Layout.dart';
import 'package:speanmeas/page/main/User.g.dart';
import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

import 'Filter_String.dart' as filter_string;
import 'Filter_Number.dart' as filter_number;
import 'Filter_Boolean.dart' as filter_boolean;
import 'Filter_Datetime.dart' as filter_datetime;

import '__Setup__.dart';
import 'Schema.g.dart';

import 'Form_Create.dart';
import 'Form_Read.dart';
import 'Form_Update.dart';
import 'Form_Delete.dart';

import 'form_check_in/Step_1_Room_Info.dart' as check_in;
import 'form_payment/Step_1_Payment_Info.dart' as payment;
import 'form_check_out/Step_1_Note.dart' as check_out;
import 'form_clean/Step_1_Note.dart' as clean;

import 'form_update_guest/Step_1_Guest_Info.dart' as update_guest;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global.variable, //
      child: const Main(),
    ),
  );
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: const Main_(),
    );
  }
}

class Main_ extends StatefulWidget {
  const Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

class _Main_State extends State<Main_> {
  //

  bool is_loading = false;
  bool has_more = true;
  int total_row = 0;

  //
  String? key;
  bool? has;
  String? query;
  double? min;
  double? max;
  DateTime? start;
  DateTime? end;
  int? order;

  PlutoGridStateManager? state_manager;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await dio
        .post(
          '$PATH/data_read',
          data: FormData.fromMap({
            "key": key, //
            "has": has, //
            "query": query, //
            "min": min, //
            "max": max, //
            "start": start, //
            "end": end, //
            "order": order, //
          }),
        ) //
        .then((r) {
          final data = List<Map<String, dynamic>>.from(r.data);

          if (r.data.length == 10000) has_more = true;
          if (r.data.length != 10000) has_more = false;

          state_manager?.removeAllRows();

          state_manager?.appendRows([
            for (var d in data)
              PlutoRow(
                cells: {
                  for (var s in schema)
                    // exclude password field
                    if (s['key'] == "password")
                      s['key']!: PlutoCell(value: "**********")
                    //
                    else if (s['type'] == 'date-time') //
                      s['key']!: PlutoCell(
                        value: (() {
                          //
                          if (d[s['key']] == null) return '';

                          //
                          final dt = DateTime.tryParse(d[s['key']].toString());
                          if (dt == null) return '';

                          // default
                          return DateFormat('yyyy-MM-dd HH:mm:ss').format(dt.toLocal());
                        })(),
                      )
                    //
                    else if (s['type'] == 'boolean') //
                      s['key']!: PlutoCell(
                        value: (() {
                          //
                          if (d[s['key']] == null) return '';
                          if (d[s['key']] == true) return 'Yes';

                          // default
                          return "No";
                        })(),
                      )
                    //
                    else
                      s['key']!: PlutoCell(
                        value: (() {
                          //
                          if (d[s['key']] == null) return '';

                          // default
                          return d[s['key']].toString();
                        })(),
                      ),
                },
              ),
          ]);

          setState(() {});
        })
        .catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    final is_mobile = MediaQuery.of(context).size.width < MOBILE_SCREEN_WIDTH;
    final screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          // menu
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Wrap(
                  children: [
                    // check in
                    if (user["is_admin"] == true || user["is_manager"] == true || user["is_receptionist"] == true)
                      Container(
                        height: 32,
                        margin: EdgeInsets.fromLTRB(2, 2, 0, 2),
                        child: OutlinedButton.icon(
                          icon: Icon(Icons.login), //
                          label: Text("Check In"),
                          onPressed: on_check_in,
                        ),
                      ),

                    // payment
                    if (user["is_admin"] == true || user["is_manager"] == true || user["is_receptionist"] == true)
                      Container(
                        height: 32,
                        margin: EdgeInsets.fromLTRB(2, 2, 0, 2),
                        child: OutlinedButton.icon(
                          icon: Icon(Icons.payment), //
                          label: Text("Payment"),
                          onPressed: on_payment,
                        ),
                      ),

                    // check out
                    if (user["is_admin"] == true || user["is_manager"] == true || user["is_receptionist"] == true)
                      Container(
                        height: 32,
                        margin: EdgeInsets.fromLTRB(2, 2, 0, 2),
                        child: OutlinedButton.icon(
                          icon: Icon(Icons.logout), //
                          label: Text("Check Out"),
                          onPressed: on_check_out,
                        ),
                      ),

                    // clean
                    Container(
                      height: 32,
                      margin: EdgeInsets.fromLTRB(2, 2, 0, 2),
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.cleaning_services), //
                        label: Text("Clean"),
                        onPressed: on_clean,
                      ),
                    ),

                    // change room
                    Container(
                      height: 32,
                      margin: EdgeInsets.fromLTRB(2, 2, 0, 2),
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.swap_horiz), //
                        label: Text("Change Room"),
                        onPressed: () {},
                      ),
                    ),

                    // cancel
                    Container(
                      height: 32,
                      margin: EdgeInsets.fromLTRB(2, 2, 0, 2),
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.cancel_outlined), //
                        label: Text("Cancel"),
                        onPressed: () {},
                      ),
                    ),

                    // update guest info
                    if (user["is_admin"] == true || user["is_manager"] == true || user["is_receptionist"] == true)
                      Container(
                        height: 32,
                        margin: EdgeInsets.fromLTRB(2, 2, 0, 2),
                        child: OutlinedButton.icon(
                          icon: Icon(Icons.edit_outlined), //
                          label: Text("Edit Guest"),
                          onPressed: on_update_guest,
                        ),
                      ),

                    // read
                    Container(
                      height: 32,
                      margin: EdgeInsets.fromLTRB(2, 2, 0, 2),
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.visibility_outlined), //
                        label: Text("Read"),
                        onPressed: on_read,
                      ),
                    ),

                    // update
                    if (user["is_admin"] == true || user["is_manager"] == true)
                      Container(
                        height: 32,
                        margin: EdgeInsets.fromLTRB(2, 2, 0, 2),
                        child: OutlinedButton.icon(
                          icon: Icon(Icons.edit_outlined), //
                          label: Text("Update"),
                          onPressed: on_update,
                        ),
                      ),

                    // delete
                    if (user["is_admin"] == true || user["is_manager"] == true)
                      Container(
                        height: 32,
                        margin: EdgeInsets.fromLTRB(2, 2, 0, 2),
                        child: OutlinedButton.icon(
                          icon: Icon(Icons.delete_outline, color: Colors.red), //
                          label: Text("Delete", style: TextStyle(color: Colors.red)),
                          onPressed: on_delete,
                        ),
                      ),
                  ],
                ),
              ),

              // refresh
              Container(
                height: 32,
                margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: InkWell(
                  child: Icon(
                    Icons.refresh, //
                    size: 28,
                    color: Colors.blue,
                  ), //
                  onTap: on_refresh,
                ),
              ),
            ],
          ),
          // filter
          Expanded(
            child: PlutoGrid(
              //
              rows: [],
              //
              columns: [
                ...schema.map((s) {
                  return build_plutocolumn(
                    field: s['key']!, //
                    title: s['title']!,
                    type: s['type']!,
                    on_filter: () => on_filter(s),
                  );
                }),
              ], //
              //
              configuration: PlutoGridConfiguration(
                scrollbar: PlutoGridScrollbarConfig(
                  scrollbarThickness: 12, //
                  scrollbarThicknessWhileDragging: 12,
                  isAlwaysShown: true,
                ),
                style: PlutoGridStyleConfig(
                  rowHeight: 28, //
                  columnHeight: 32,
                ),
              ),
              onLoaded: (event) {
                state_manager = event.stateManager;

                state_manager?.scroll.bodyRowsVertical!.addListener(() {
                  final position = state_manager?.scroll.bodyRowsVertical!.position;

                  if (!is_loading) {
                    if (position!.pixels >= position.maxScrollExtent) {
                      // print('Reached bottom');
                      if (has_more) {
                        is_loading = true;
                        on_load_more();
                      }
                      setState(() {});
                    }
                  }
                });
              },
            ),
          ),

          if (is_loading)
            Container(
              height: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20, //
                    height: 20,
                    child: CircularProgressIndicator(),
                  ),
                  SizedBox(width: 12),
                  Text('Loading more...'),
                ],
              ),
            ),

          if (!is_loading)
            (() {
              if (state_manager == null) return SizedBox();
              total_row = state_manager!.rows.length;
              return Container(
                height: 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Loaded: $total_row items'), //
                  ],
                ),
              );
            })(),
        ],
      ),
    );
  }

  void on_filter(s) {
    //
    // init
    key = s['key'];
    order = 1;

    // clear sort
    final sorted_column = state_manager?.getSortedColumn;
    if (sorted_column != null) {
      state_manager?.sortBySortIdx(sorted_column);
    }

    if (s['type'] == 'string') {
      Navigator.push(
        context, //
        MaterialPageRoute(builder: (context) => filter_string.Main_()),
      ).then((v) {
        //
        if (v == null) return;

        query = v;
        init();

        // scroll to top
        state_manager?.scroll.vertical?.jumpTo(0);
      });
    }
    //
    else if (s['type'] == 'number') {
      Navigator.push(
        context, //
        MaterialPageRoute(builder: (context) => filter_number.Main_()),
      ).then((v) {
        //
        if (v == null) return;

        min = v["min"];
        max = v["max"];

        init();

        // scroll to top
        state_manager?.scroll.vertical?.jumpTo(0);
      });
    }
    //
    else if (s['type'] == 'date-time') {
      Navigator.push(
        context, //
        MaterialPageRoute(builder: (context) => filter_datetime.Main_()),
      ).then((v) {
        //
        if (v == null) return;

        start = v["start"];
        end = v["end"];

        init();

        // scroll to top
        state_manager?.scroll.vertical?.jumpTo(0);
      });
    }
    //
    else if (s['type'] == 'boolean') {
      Navigator.push(
        context, //
        MaterialPageRoute(builder: (context) => filter_boolean.Main_()),
      ).then((v) {
        //
        if (v == null) return;

        has = v;
        init();

        // scroll to top
        state_manager?.scroll.vertical?.jumpTo(0);
      });
    }
  }

  void on_check_in() {
    //
    Navigator.push(
      context, //
      MaterialPageRoute(builder: (context) => check_in.Main_()),
    ).then((v) {
      //
      if (v == null) {
        // clear schema values
        for (var s in schema) s["value"] = null;
        return;
      }

      state_manager?.prependRows([
        PlutoRow(
          cells: {
            'id': PlutoCell(value: v['id'].toString()),
            for (var s in schema)
              if (s['type'] == 'date-time') //
                s['key']!: PlutoCell(
                  value: (() {
                    if (v[s['key']] == null) return '';

                    final dt = DateTime.tryParse(v[s['key']].toString());
                    if (dt == null) return '';

                    // default
                    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dt.toLocal());
                  })(),
                )
              else if (s['type'] == 'boolean') //
                s['key']!: PlutoCell(
                  value: (() {
                    if (v[s['key']] == null) return '';
                    if (v[s['key']] == true) return 'Yes';

                    // default
                    return 'No';
                  })(),
                )
              else
                s['key']!: PlutoCell(
                  value: (() {
                    if (v[s['key']] == null) return '';

                    // default
                    return v[s['key']].toString();
                  })(),
                ),
          },
        ),
      ]);

      // refresh total row count
      total_row = state_manager!.rows.length;
      setState(() {});

      // scroll to top
      state_manager?.scroll.vertical?.jumpTo(0);

      // clear schema values
      for (var s in schema) s["value"] = null;
    });
  }

  void on_payment() {
    if (state_manager?.currentRow == null) {
      snackbar_show(context: context, message: "Please select a row.", color: Colors.red);
      return;
    }

    // pass current row data to schema values
    state_manager?.currentRow!.cells.forEach((k, c) {
      // print("on_payment $k ${c.value}");
      for (var s in schema) {
        // skip password
        if (s['key'] == "password") continue;

        if (s['key'] == k) {
          // skip null
          if (c.value == null) {
            s['value'] = null;
            continue;
          }

          // id
          if (s['type'] == 'id') {
            s['value'] = c.value;
            continue;
          }

          // string
          if (s['type'] == 'string') {
            s['value'] = c.value;
            continue;
          }

          // number
          if (s['type'] == 'number') {
            double? tmp = double.tryParse(c.value.toString());
            s['value'] = tmp;
            continue;
          }

          // date-time
          if (s['type'] == 'date-time') {
            final tmp = DateTime.tryParse(c.value.toString());
            s['value'] = tmp == null ? null : DateFormat('yyyy-MM-dd HH:mm:ss').format(tmp);
            continue;
          }

          // boolean
          if (s['type'] == 'boolean') {
            if (c.value == "Yes") s['value'] = true;
            if (c.value == "No") s['value'] = false;
            continue;
          }
        }
      }
    });

    // check if clean is already done
    for (var s in schema) {
      if (s['key'] == "clean_by") {
        // print(s['value']);
        if (s['value'] != "") {
          snackbar_show(context: context, message: "Clean already done by ${s['value']}", color: Colors.blue);
          return;
        }
      }
    }

    // check if payment is already done
    for (var s in schema) {
      if (s['key'] == "payment_by") {
        // print(s['value']);
        if (s['value'] != "") {
          snackbar_show(context: context, message: "Payment already done by ${s['value']}", color: Colors.blue);
          return;
        }
      }
    }

    Navigator.push(
      context, //
      MaterialPageRoute(builder: (context) => payment.Main_()),
    ).then((v) {
      //
      if (v == null) {
        // clear schema values
        for (var s in schema) s["value"] = null;
        return;
      }

      final row = state_manager?.currentRow;
      for (var s in schema) {
        final key = s['key'];
        if (key == null) continue;

        if (s['type'] == 'date-time') {
          row?.cells[key]?.value = (() {
            if (v[key] == null) return '';

            final dt = DateTime.tryParse(v[key].toString());
            if (dt == null) return '';

            // default
            return DateFormat('yyyy-MM-dd HH:mm:ss').format(dt.toLocal());
          })();
        } else if (s['type'] == 'boolean') {
          row?.cells[key]?.value = (() {
            if (v[key] == null) return '';
            if (v[key] == true) return 'Yes';

            // default
            return 'No';
          })();
        } else {
          row?.cells[key]?.value = (() {
            if (v[key] == null) return '';

            // default
            return v[key].toString();
          })();
        }
      }

      state_manager?.notifyListeners();

      // clear schema values
      for (var s in schema) s["value"] = null;
    });
  }

  void on_check_out() {
    if (state_manager?.currentRow == null) {
      snackbar_show(context: context, message: "Please select a row.", color: Colors.red);
      return;
    }

    //
    state_manager?.currentRow!.cells.forEach((k, c) {
      for (var s in schema) {
        // skip password
        if (s['key'] == "password") continue;

        if (s['key'] == k) {
          // skip null
          if (c.value == null) {
            s['value'] = null;
            continue;
          }

          // id
          if (s['type'] == 'id') {
            s['value'] = c.value;
            continue;
          }

          // string
          if (s['type'] == 'string') {
            s['value'] = c.value;
            continue;
          }

          // number
          if (s['type'] == 'number') {
            double? tmp = double.tryParse(c.value.toString());
            s['value'] = tmp;
            continue;
          }

          // date-time
          if (s['type'] == 'date-time') {
            DateTime? tmp = DateTime.tryParse(c.value.toString());
            s['value'] = tmp == null ? null : DateFormat('yyyy-MM-dd HH:mm:ss').format(tmp);
            continue;
          }

          // boolean
          if (s['type'] == 'boolean') {
            if (c.value == "Yes") s['value'] = true;
            if (c.value == "No") s['value'] = false;
            continue;
          }
        }
      }
    });

    // check if clean is already done
    for (var s in schema) {
      if (s['key'] == "clean_by") {
        // print(s['value']);
        if (s['value'] != "") {
          snackbar_show(context: context, message: "Clean already done by ${s['value']}", color: Colors.blue);
          return;
        }
      }
    }

    // check if payment is already done
    for (var s in schema) {
      if (s['key'] == "payment_by") {
        // print(s['value']);
        if (s['value'] == "") {
          snackbar_show(context: context, message: "Please complete payment first.", color: Colors.red);
          return;
        }
      }
    }

    // check if check out is already done
    for (var s in schema) {
      if (s['key'] == "check_out_by") {
        // print(s['value']);
        if (s['value'] != "") {
          snackbar_show(context: context, message: "Check out already done by ${s['value']}", color: Colors.blue);
          return;
        }
      }
    }

    Navigator.push(
      context, //
      MaterialPageRoute(builder: (context) => check_out.Main_()),
    ).then((v) {
      //
      if (v == null) {
        // clear schema values
        for (var s in schema) s["value"] = null;
        return;
      }

      final row = state_manager?.currentRow;
      for (var s in schema) {
        final key = s['key'];
        if (key == null) continue;

        if (s['type'] == 'date-time') {
          row?.cells[key]?.value = (() {
            if (v[key] == null) return '';

            final dt = DateTime.tryParse(v[key].toString());
            if (dt == null) return '';

            // default
            return DateFormat('yyyy-MM-dd HH:mm:ss').format(dt.toLocal());
          })();
        } else if (s['type'] == 'boolean') {
          row?.cells[key]?.value = (() {
            if (v[key] == null) return '';
            if (v[key] == true) return 'Yes';

            // default
            return 'No';
          })();
        } else {
          row?.cells[key]?.value = (() {
            if (v[key] == null) return '';

            // default
            return v[key].toString();
          })();
        }
      }

      state_manager?.notifyListeners();

      // clear schema values
      for (var s in schema) s["value"] = null;
    });
  }

  void on_clean() {
    // TODO: check if check out is already done, if yes, show snackbar "Check out already done", else go to clean page

    // is selected?
    if (state_manager?.currentRow == null) {
      snackbar_show(context: context, message: "Please select a row.", color: Colors.red);
      return;
    }

    //
    state_manager?.currentRow!.cells.forEach((k, c) {
      for (var s in schema) {
        // skip password
        if (s['key'] == "password") continue;

        if (s['key'] == k) {
          // skip null
          if (c.value == null) {
            s['value'] = null;
            continue;
          }

          // id
          if (s['type'] == 'id') {
            s['value'] = c.value;
            continue;
          }

          // string
          if (s['type'] == 'string') {
            s['value'] = c.value;
            continue;
          }

          // number
          if (s['type'] == 'number') {
            double? tmp = double.tryParse(c.value.toString());
            s['value'] = tmp;
            continue;
          }

          // date-time
          if (s['type'] == 'date-time') {
            DateTime? tmp = DateTime.tryParse(c.value.toString());
            s['value'] = tmp == null ? null : DateFormat('yyyy-MM-dd HH:mm:ss').format(tmp);
            continue;
          }

          // boolean
          if (s['type'] == 'boolean') {
            if (c.value == "Yes") s['value'] = true;
            if (c.value == "No") s['value'] = false;
            continue;
          }
        }
      }
    });

    // check if payment is already done
    for (var s in schema) {
      if (s['key'] == "payment_by") {
        // print(s['value']);
        if (s['value'] == "") {
          snackbar_show(context: context, message: "Please complete payment first.", color: Colors.red);
          return;
        }
      }
    }

    // check if check out is already done
    for (var s in schema) {
      if (s['key'] == "check_out_by") {
        // print(s['value']);
        if (s['value'] == "") {
          snackbar_show(context: context, message: "Please complete check out first.", color: Colors.red);
          return;
        }
      }
    }

    // check if clean is already done
    for (var s in schema) {
      if (s['key'] == "clean_by") {
        // print(s['value']);
        if (s['value'] != "") {
          snackbar_show(context: context, message: "Clean already done by ${s['value']}", color: Colors.blue);
          return;
        }
      }
    }

    Navigator.push(
      context, //
      MaterialPageRoute(builder: (context) => clean.Main_()),
    ).then((v) {
      //
      if (v == null) {
        // clear schema values
        for (var s in schema) s["value"] = null;
        return;
      }

      final row = state_manager?.currentRow;
      for (var s in schema) {
        final key = s['key'];
        if (key == null) continue;

        if (s['type'] == 'date-time') {
          row?.cells[key]?.value = (() {
            if (v[key] == null) return '';

            final dt = DateTime.tryParse(v[key].toString());
            if (dt == null) return '';

            // default
            return DateFormat('yyyy-MM-dd HH:mm:ss').format(dt.toLocal());
          })();
        } else if (s['type'] == 'boolean') {
          row?.cells[key]?.value = (() {
            if (v[key] == null) return '';
            if (v[key] == true) return 'Yes';

            // default
            return 'No';
          })();
        } else {
          row?.cells[key]?.value = (() {
            if (v[key] == null) return '';

            // default
            return v[key].toString();
          })();
        }
      }

      state_manager?.notifyListeners();

      // clear schema values
      for (var s in schema) s["value"] = null;
    });
  }

  void on_update_guest() {
    if (state_manager?.currentRow == null) {
      snackbar_show(context: context, message: "Please select a row.", color: Colors.red);
      return;
    }

    //
    state_manager?.currentRow!.cells.forEach((k, c) {
      for (var s in schema) {
        // skip password
        if (s['key'] == "password") continue;

        if (s['key'] == k) {
          // skip null
          if (c.value == null) {
            s['value'] = null;
            continue;
          }

          // id
          if (s['type'] == 'id') {
            s['value'] = c.value;
            continue;
          }

          // string
          if (s['type'] == 'string') {
            s['value'] = c.value;
            continue;
          }

          // number
          if (s['type'] == 'number') {
            double? tmp = double.tryParse(c.value.toString());
            s['value'] = tmp;
            continue;
          }

          // date-time
          if (s['type'] == 'date-time') {
            DateTime? tmp = DateTime.tryParse(c.value.toString());
            s['value'] = tmp == null ? null : DateFormat('yyyy-MM-dd HH:mm:ss').format(tmp);
            continue;
          }

          // boolean
          if (s['type'] == 'boolean') {
            if (c.value == "Yes") s['value'] = true;
            if (c.value == "No") s['value'] = false;
            continue;
          }
        }
      }
    });

    Navigator.push(
      context, //
      MaterialPageRoute(builder: (context) => update_guest.Main_()),
    ).then((v) {
      //
      if (v == null) {
        // clear schema values
        for (var s in schema) s["value"] = null;
        return;
      }

      final row = state_manager?.currentRow;
      for (var s in schema) {
        final key = s['key'];
        if (key == null) continue;

        if (s['type'] == 'date-time') {
          row?.cells[key]?.value = (() {
            if (v[key] == null) return '';

            final dt = DateTime.tryParse(v[key].toString());
            if (dt == null) return '';

            // default
            return DateFormat('yyyy-MM-dd HH:mm:ss').format(dt.toLocal());
          })();
        } else if (s['type'] == 'boolean') {
          row?.cells[key]?.value = (() {
            if (v[key] == null) return '';
            if (v[key] == true) return 'Yes';

            // default
            return 'No';
          })();
        } else {
          row?.cells[key]?.value = (() {
            if (v[key] == null) return '';

            // default
            return v[key].toString();
          })();
        }
      }

      state_manager?.notifyListeners();

      // clear schema values
      for (var s in schema) s["value"] = null;
    });
  }

  void on_read() {
    //
    if (state_manager?.currentRow == null) {
      snackbar_show(context: context, message: "Please select a row.", color: Colors.red);
      return;
    }

    //
    Map<String, dynamic> data = {};
    state_manager?.currentRow!.cells.forEach((key, cell) {
      data[key] = cell.value;
    });
    // print("Read row $data");

    Navigator.push(
      context, //
      MaterialPageRoute(builder: (context) => Form_Read_(input: data)),
    );
  }

  void on_update() {
    //

    if (state_manager?.currentRow == null) {
      snackbar_show(context: context, message: "Please select a row.", color: Colors.red);
      return;
    }

    Map<String, dynamic> data = {};
    state_manager?.currentRow!.cells.forEach((k, c) {
      data[k] = (() {
        if (c.value == null) return null;

        // default
        return c.value.toString();
      })();
    });

    Navigator.push(
      context, //
      MaterialPageRoute(builder: (context) => Form_Update_(input: data)),
    ).then((v) {
      //
      if (v == null) return;

      final row = state_manager?.currentRow;
      for (var s in schema) {
        final key = s['key'];
        if (key == null) continue;

        if (s['type'] == 'date-time') {
          row?.cells[key]?.value = (() {
            if (v[key] == null) return '';

            final dt = DateTime.tryParse(v[key].toString());
            if (dt == null) return '';

            // default
            return DateFormat('yyyy-MM-dd HH:mm:ss').format(dt.toLocal());
          })();
        } else if (s['type'] == 'boolean') {
          row?.cells[key]?.value = (() {
            if (v[key] == null) return '';
            if (v[key] == true) return 'Yes';

            // default
            return 'No';
          })();
        } else {
          row?.cells[key]?.value = (() {
            if (v[key] == null) return '';

            // default
            return v[key].toString();
          })();
        }
      }

      state_manager?.notifyListeners();
    });
  }

  void on_delete() {
    if (state_manager?.currentRow == null) {
      snackbar_show(context: context, message: "Please select a row.", color: Colors.red);
      return;
    }

    //
    String id = state_manager?.currentRow!.cells['id']!.value;

    //
    Navigator.push(
      context, //
      MaterialPageRoute(builder: (context) => Form_Delete_(id: id)),
    ).then((v) {
      if (v == null) return;
      state_manager?.removeCurrentRow();

      // refresh total row count
      total_row = state_manager!.rows.length;
      setState(() {});
    });
  }

  void on_refresh() {
    //
    key = null;
    has = null;
    query = null;
    min = null;
    max = null;
    start = null;
    end = null;
    order = null;

    // clear sort
    final sorted_column = state_manager?.getSortedColumn;
    if (sorted_column != null) {
      state_manager?.sortBySortIdx(sorted_column);
    }

    init();

    // scroll to top
    state_manager?.scroll.vertical?.jumpTo(0);

    // Navigator.pop(context);
  }

  void on_load_more() async {
    // clear sort
    final sorted_column = state_manager?.getSortedColumn;
    if (sorted_column != null) {
      state_manager?.sortBySortIdx(sorted_column);
    }

    await dio
        .post(
          '$PATH/data_read',
          data: FormData.fromMap({
            "key": key, //
            "has": has, //
            "query": query, //
            "min": min, //
            "max": max, //
            "start": start, //
            "end": end, //
            "order": order, //
            "offset": state_manager?.rows.length, //
          }),
        ) //
        .then((r) {
          final data = List<Map<String, dynamic>>.from(r.data);

          state_manager?.appendRows([
            for (var d in data)
              PlutoRow(
                cells: {
                  for (var s in schema)
                    //
                    if (s['key'] == "password") //
                      s['key']!: PlutoCell(value: "**********")
                    //
                    else if (s['type'] == 'date-time') //
                      s['key']!: PlutoCell(
                        value: (() {
                          //
                          if (d[s['key']] == null) return '';

                          //
                          final dt = DateTime.tryParse(d[s['key']].toString());
                          if (dt == null) return '';

                          // default
                          return DateFormat('yyyy-MM-dd HH:mm:ss').format(dt.toLocal());
                        })(),
                      )
                    //
                    else if (s['type'] == 'boolean') //
                      s['key']!: PlutoCell(
                        value: (() {
                          //
                          if (d[s['key']] == null) return '';
                          if (d[s['key']] == true) return 'Yes';

                          // default
                          return "No";
                        })(),
                      )
                    //
                    else
                      s['key']!: PlutoCell(
                        value: (() {
                          //
                          if (d[s['key']] == null) return '';

                          // default
                          return d[s['key']].toString();
                        })(),
                      ),
                },
              ),
          ]);
          is_loading = false;
          setState(() {});
        })
        .catchError((e) {});
  }

  build_plutocolumn({
    required String title, //
    required String field,
    required String type,
    required VoidCallback on_filter,
  }) {
    //
    PlutoColumnType column_type = PlutoColumnType.text();

    // make number sort correctly
    if (type == 'number') {
      column_type = PlutoColumnType.number();
    }

    //
    return PlutoColumn(
      title: title,
      field: field,
      type: column_type,
      width: 160,
      minWidth: 100,
      readOnly: true,
      enableFilterMenuItem: false,
      hide: type == "id" ? true : false,

      titleSpan: WidgetSpan(
        child: Row(
          children: [
            if (type == "number")
              InkWell(
                onTap: on_filter,
                child: Icon(Icons.tune, size: 20, color: Colors.blue),
              )
            else if (type == "boolean")
              InkWell(
                onTap: on_filter,
                child: Icon(Icons.toggle_on_outlined, size: 20, color: Colors.blue),
              )
            else if (type == "date-time")
              InkWell(
                onTap: on_filter,
                child: Icon(Icons.date_range, size: 20, color: Colors.blue),
              )
            else
              InkWell(
                onTap: on_filter,
                child: Icon(Icons.filter_alt_outlined, size: 20, color: Colors.blue),
              ),

            SizedBox(width: 4),

            Expanded(
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
