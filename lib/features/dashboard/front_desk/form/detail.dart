import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "package:speanmeas/core/config.dart";
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/endpoint.g.dart";
import "package:speanmeas/core/widget/show/show_text.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/schema/front_desk.g.dart";
import "package:speanmeas/core/schema/room.g.dart";

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Detail", //
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
          padding: EdgeInsets.fromLTRB(8, 8, 16, 8),
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
  bool is_loading = true;

  // room
  String? room_number;
  String? room_status;
  String? room_kind;

  // front desk
  String? guest_id;
  int? check_in_number;
  int? check_in_day;
  int? check_in_hour;
  String? check_in_note;
  String? check_in_at;
  String? check_in_by;

  double? pay_room;
  double? pay_mini_bar;
  double? pay_other;

  String? check_out_note;
  String? check_out_at;
  String? check_out_by;

  String? clean_note;
  String? clean_at;
  String? clean_by;

  String? broke_note;
  String? broke_at;
  String? broke_by;

  String? fix_note;
  String? fix_at;
  String? fix_by;

  String? cancel_note;
  String? cancel_at;
  String? cancel_by;

  String? change_note;
  String? change_at;
  String? change_by;

  String? created_at;
  String? created_by;
  String? updated_at;
  String? updated_by;

  void init() async {
    try {
      tmp = await dio.post(
        endpoint.ROOM_CRUD_READ_ID, //
        data: {sm_room.ID: widget.room_id},
      );

      room_number = tmp.data[0][sm_room.NUMBER]?.toString();
      room_status = tmp.data[0][sm_room.STATUS]?.toString();
      room_kind = tmp.data[0][sm_room.KIND]?.toString();

      String? front_desk_id = tmp.data[0][sm_room.FRONT_DESK_ID];

      if (front_desk_id != null) {
        tmp = await dio.post(
          endpoint.FRONT_DESK_READ_ID, //
          data: {sm_front_desk.ID: front_desk_id},
        );

        guest_id = tmp.data[0][sm_front_desk.GUEST_ID]?.toString();
        check_in_number = tmp.data[0][sm_front_desk.CHECK_IN_NUMBER];
        check_in_day = tmp.data[0][sm_front_desk.CHECK_IN_DAY];
        check_in_hour = tmp.data[0][sm_front_desk.CHECK_IN_HOUR];
        check_in_note = tmp.data[0][sm_front_desk.CHECK_IN_NOTE]?.toString();
        check_in_at = tmp.data[0][sm_front_desk.CHECK_IN_AT]?.toString();
        check_in_by = tmp.data[0][sm_front_desk.CHECK_IN_BY]?.toString();

        pay_room = (tmp.data[0][sm_front_desk.PAY_ROOM] as num?)?.toDouble();
        pay_mini_bar = (tmp.data[0][sm_front_desk.PAY_MINI_BAR] as num?)?.toDouble();
        pay_other = (tmp.data[0][sm_front_desk.PAY_OTHER] as num?)?.toDouble();

        check_out_note = tmp.data[0][sm_front_desk.CHECK_OUT_NOTE]?.toString();
        check_out_at = tmp.data[0][sm_front_desk.CHECK_OUT_AT]?.toString();
        check_out_by = tmp.data[0][sm_front_desk.CHECK_OUT_BY]?.toString();

        clean_note = tmp.data[0][sm_front_desk.CLEAN_NOTE]?.toString();
        clean_at = tmp.data[0][sm_front_desk.CLEAN_AT]?.toString();
        clean_by = tmp.data[0][sm_front_desk.CLEAN_BY]?.toString();

        broke_note = tmp.data[0][sm_front_desk.BROKE_NOTE]?.toString();
        broke_at = tmp.data[0][sm_front_desk.BROKE_AT]?.toString();
        broke_by = tmp.data[0][sm_front_desk.BROKE_BY]?.toString();

        fix_note = tmp.data[0][sm_front_desk.FIX_NOTE]?.toString();
        fix_at = tmp.data[0][sm_front_desk.FIX_AT]?.toString();
        fix_by = tmp.data[0][sm_front_desk.FIX_BY]?.toString();

        cancel_note = tmp.data[0][sm_front_desk.CANCEL_NOTE]?.toString();
        cancel_at = tmp.data[0][sm_front_desk.CANCEL_AT]?.toString();
        cancel_by = tmp.data[0][sm_front_desk.CANCEL_BY]?.toString();

        change_note = tmp.data[0][sm_front_desk.CHANGE_NOTE]?.toString();
        change_at = tmp.data[0][sm_front_desk.CHANGE_AT]?.toString();
        change_by = tmp.data[0][sm_front_desk.CHANGE_BY]?.toString();

        created_at = tmp.data[0][sm_front_desk.CREATED_AT]?.toString();
        created_by = tmp.data[0][sm_front_desk.CREATED_BY]?.toString();
        updated_at = tmp.data[0][sm_front_desk.UPDATED_AT]?.toString();
        updated_by = tmp.data[0][sm_front_desk.UPDATED_BY]?.toString();
      }

      is_loading = false;
      setState(() {});
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  String _formatDate(String? iso) {
    if (iso == null) return "";
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    return DateFormat(DEFAULT_DATE_FORMAT).format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      // Room Info
      Show_Text(leading: "Room:", value: room_number ?? ""),
      Show_Text(leading: "Status:", value: room_status ?? ""),
      Show_Text(leading: "Kind:", value: room_kind ?? ""),

      if (guest_id != null) ...[Divider(height: 1, color: Colors.black), Show_Text(leading: "Guest ID:", value: guest_id ?? ""), Show_Text(leading: "Number of Guests:", value: check_in_number?.toString() ?? ""), Show_Text(leading: "Stay Days:", value: check_in_day?.toString() ?? ""), Show_Text(leading: "Stay Hours:", value: check_in_hour?.toString() ?? ""), if (check_in_note != null) Show_Text(leading: "Check-in Note:", value: check_in_note!, maxLines: 3), Show_Text(leading: "Check-in At:", value: _formatDate(check_in_at)), Show_Text(leading: "Check-in By:", value: check_in_by ?? "")],

      if (pay_room != null || pay_mini_bar != null || pay_other != null) ...[Divider(height: 1, color: Colors.black), Show_Text(leading: "Pay Room:", value: pay_room?.toStringAsFixed(2) ?? "0.00"), Show_Text(leading: "Pay Mini Bar:", value: pay_mini_bar?.toStringAsFixed(2) ?? "0.00"), Show_Text(leading: "Pay Other:", value: pay_other?.toStringAsFixed(2) ?? "0.00")],

      if (check_out_at != null) ...[Divider(height: 1, color: Colors.black), if (check_out_note != null) Show_Text(leading: "Check-out Note:", value: check_out_note!, maxLines: 3), Show_Text(leading: "Check-out At:", value: _formatDate(check_out_at)), Show_Text(leading: "Check-out By:", value: check_out_by ?? "")],

      if (clean_at != null) ...[Divider(height: 1, color: Colors.black), if (clean_note != null) Show_Text(leading: "Clean Note:", value: clean_note!, maxLines: 3), Show_Text(leading: "Clean At:", value: _formatDate(clean_at)), Show_Text(leading: "Clean By:", value: clean_by ?? "")],

      if (broke_at != null) ...[Divider(height: 1, color: Colors.black), if (broke_note != null) Show_Text(leading: "Broke Note:", value: broke_note!, maxLines: 3), Show_Text(leading: "Broke At:", value: _formatDate(broke_at)), Show_Text(leading: "Broke By:", value: broke_by ?? "")],

      if (fix_at != null) ...[Divider(height: 1, color: Colors.black), if (fix_note != null) Show_Text(leading: "Fix Note:", value: fix_note!, maxLines: 3), Show_Text(leading: "Fix At:", value: _formatDate(fix_at)), Show_Text(leading: "Fix By:", value: fix_by ?? "")],

      if (cancel_at != null) ...[Divider(height: 1, color: Colors.black), if (cancel_note != null) Show_Text(leading: "Cancel Note:", value: cancel_note!, maxLines: 3), Show_Text(leading: "Cancel At:", value: _formatDate(cancel_at)), Show_Text(leading: "Cancel By:", value: cancel_by ?? "")],

      if (change_at != null) ...[Divider(height: 1, color: Colors.black), if (change_note != null) Show_Text(leading: "Change Note:", value: change_note!, maxLines: 3), Show_Text(leading: "Change At:", value: _formatDate(change_at)), Show_Text(leading: "Change By:", value: change_by ?? "")],

      Divider(height: 1, color: Colors.black),
      Show_Text(leading: "Created At:", value: _formatDate(created_at)),
      Show_Text(leading: "Created By:", value: created_by ?? ""),
      Show_Text(leading: "Updated At:", value: _formatDate(updated_at)),
      Show_Text(leading: "Updated By:", value: updated_by ?? ""),

      OutlinedButton.icon(
        autofocus: true,
        label: Text("OK"),
        icon: Icon(Icons.check), //
        onPressed: () => Navigator.pop(context), //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  //
}

class Main_ extends StatefulWidget {
  const Main_({
    super.key, //
    this.room_id,
  });

  final String? room_id;

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme_data, //
      home: Main_(
        room_id: "6a71dc186c013023294f6742", //
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
