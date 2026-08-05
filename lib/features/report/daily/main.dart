import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:pluto_grid/pluto_grid.dart";

import "package:speanmeas/core/endpoint.g.dart" as ep; // ignore: unused_import
import "package:speanmeas/core/theme/theme_light.dart" as theme;
import "package:speanmeas/core/widget/snackbar.dart" as snackbar;

import "config.dart";
import "schema.g.dart" as schema;

class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  //
  DateTime selected_date = DateTime.now();

  bool is_loading = false;
  PlutoGridStateManager? state_manager;

  String search_text = "";
  String selected_category = "All";
  String selected_payment = "All";

  // * Summary metrics — mapped 1-to-1 from FastAPI /report/daily response
  // summary
  int check_ins = 0;
  int check_outs = 0;
  int total_guests_today = 0;
  int active_stays = 0;
  // room_revenue
  double room_paid_total = 0.0;
  double room_bank_usd = 0.0;
  double room_cash_usd = 0.0;
  double room_balance = 0.0;
  // revenue (service)
  double revenue_paid_total = 0.0;
  double revenue_bank_usd = 0.0;
  double revenue_cash_usd = 0.0;
  double revenue_balance = 0.0;
  // combined
  double total_revenue = 0.0;
  double aba_bank_total = 0.0;
  double cash_total = 0.0;
  // room_status
  int total_rooms = 0;
  int occupied_rooms = 0;
  int available_rooms = 0;
  int pending_pay = 0;
  int pending_leave = 0;
  int pending_clean = 0;

  List<Map<String, dynamic>> raw_transactions = [];

  //
  @override
  void initState() {
    super.initState();
    load_report_data();
  }

  //
  Future<void> load_report_data() async {
    try {
      // is_loading = true;
      // setState(() {});

      // final date_str = DateFormat(DATE_FORMAT).format(selected_date);

      // try {
      //   final r = await dio.post(
      //     PATH, //
      //     data: {
      //       "date": date_str, //
      //     },
      //   );

      //   if (r.data != null && r.data is Map<String, dynamic>) {
      //     _parse(Map<String, dynamic>.from(r.data), date_str);
      //   } else {
      //     _fallback(date_str);
      //   }
      // } catch (e, st) {
      //   print(st);
      //   snackbar.view(context: context, message: "Failed", color: Colors.red);
      //   _fallback(date_str);
      // }

      // populate_grid();
      // is_loading = false;
      // setState(() {});
    } catch (e, st) {
      print(st);
      snackbar.view(context: context, message: "Failed", color: Colors.red);
      is_loading = false;
      setState(() {});
    }
  }

  //
  void populate_grid() {
    if (state_manager == null) return;

    final filtered = raw_transactions.where((tx) {
      final q = search_text.toLowerCase();
      final match_search =
          q.isEmpty ||
          tx[schema.GUEST_NAME].toString().toLowerCase().contains(q) ||
          tx[schema.ROOM_NUMBER].toString().toLowerCase().contains(q) ||
          tx[schema.REFERENCE_NO].toString().toLowerCase().contains(q);
      final match_cat = selected_category == "All" || tx[schema.CATEGORY] == selected_category;
      final match_pay = selected_payment == "All" || tx[schema.PAYMENT_METHOD] == selected_payment;
      return match_search && match_cat && match_pay;
    }).toList();

    state_manager!.removeAllRows();
    state_manager!.appendRows([
      for (final d in filtered)
        PlutoRow(
          cells: {
            for (final e in schema.data.entries)
              e.key: PlutoCell(
                // * amount field arrives as a double from Python — keep it numeric
                value: e.value["type"] == "number" ? ((d[e.key] as num?)?.toDouble() ?? 0.0) : (d[e.key]?.toString() ?? ""),
              ),
          },
        ),
    ]);
  }

  //
  void change_date(int days) {
    selected_date = selected_date.add(Duration(days: days));
    load_report_data();
  }

  //
  Future<void> pick_date() async {
    final picked = await showDatePicker(context: context, initialDate: selected_date, firstDate: DateTime(2020), lastDate: DateTime(2100));
    if (picked != null && picked != selected_date) {
      selected_date = picked;
      load_report_data();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // * [A] Top bar
          _top_bar(),

          // * Loading strip
          if (is_loading) const LinearProgressIndicator(minHeight: 2),

          // * [B] Metrics row
          if (!is_loading) _metrics_row(),

          // * [C] Filter / search row
          _filter_row(),

          // * [D] Grid
          Expanded(child: _grid()),
        ],
      ),
    );
  }

  // * ─── top bar ─────────────────────────────────────────────────────────────
  Widget _top_bar() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Text(HEADER, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

          const SizedBox(width: 8),

          // chevron left
          _icon_btn(Icons.chevron_left, () => change_date(-1)),

          // date button
          InkWell(
            onTap: pick_date,
            child: Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 6),
                  Text(DateFormat("dd MMM yyyy").format(selected_date), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),

          // chevron right
          _icon_btn(Icons.chevron_right, () => change_date(1)),

          const Spacer(),

          // today
          _text_btn("Today", () {
            selected_date = DateTime.now();
            load_report_data();
          }),

          const SizedBox(width: 4),

          _text_btn("Refresh", load_report_data),

          const SizedBox(width: 4),

          _text_btn("Print", () {
            snackbar.view(context: context, message: "Printing...", color: Colors.blue);
          }),
        ],
      ),
    );
  }

  Widget _icon_btn(IconData icon, VoidCallback on_pressed) => SizedBox(
    width: 32,
    height: 32,
    child: InkWell(
      onTap: on_pressed,
      child: Icon(icon, size: 20, color: Colors.grey.shade700),
    ),
  );

  Widget _text_btn(String label, VoidCallback on_pressed) => OutlinedButton(
    style: OutlinedButton.styleFrom(minimumSize: const Size(0, 32), padding: const EdgeInsets.symmetric(horizontal: 12), textStyle: const TextStyle(fontSize: 13)),
    onPressed: on_pressed,
    child: Text(label),
  );

  // * ─── metrics row ─────────────────────────────────────────────────────────
  Widget _metrics_row() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          // * room_revenue.paid_total_usd + revenue.paid_total_usd
          _metric_tile("Total Revenue", "\$${total_revenue.toStringAsFixed(2)}", Icons.monetization_on_outlined, Colors.blue),
          _divider(),
          // * summary.total_check_ins / total_check_outs
          _metric_tile("Check-in / Out", "$check_ins / $check_outs", Icons.swap_horiz, Colors.orange),
          _divider(),
          // * summary.active_stays
          _metric_tile("Active Stays", "$active_stays rooms", Icons.hotel_outlined, Colors.green),
          _divider(),
          // * room_status.available / pending_pay
          _metric_tile("Avail / Pending", "$available_rooms / $pending_pay", Icons.meeting_room_outlined, Colors.purple),
          _divider(),
          // * ABA Pay: paid_bank_usd combined
          _metric_tile("Bank / Cash", "\$${aba_bank_total.toStringAsFixed(0)} / \$${cash_total.toStringAsFixed(0)}", Icons.payments_outlined, Colors.teal),
        ],
      ),
    );
  }

  Widget _metric_tile(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(width: 1, height: 32, margin: const EdgeInsets.symmetric(horizontal: 12), color: Colors.grey.shade300);

  // * ─── filter row ──────────────────────────────────────────────────────────
  Widget _filter_row() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          // search
          SizedBox(
            width: 220,
            child: TextField(
              onChanged: (val) {
                search_text = val;
                populate_grid();
              },
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: "Search name / room / ref...",
                hintStyle: const TextStyle(fontSize: 13),
                prefixIcon: const Icon(Icons.search, size: 18),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // category
          _filter_dropdown<String>(
            value: selected_category,
            // * Only categories the backend actually emits in transactions[]
            items: const ["All", "Room Charge", "Service / Minibar"],
            on_changed: (val) {
              if (val == null) return;
              selected_category = val;
              populate_grid();
            },
          ),

          const SizedBox(width: 8),

          // payment
          _filter_dropdown<String>(
            value: selected_payment,
            items: const ["All", "Cash", "ABA Pay", "Credit Card"],
            on_changed: (val) {
              if (val == null) return;
              selected_payment = val;
              populate_grid();
            },
          ),

          const SizedBox(width: 8),

          // reset
          if (search_text.isNotEmpty || selected_category != "All" || selected_payment != "All")
            InkWell(
              onTap: () {
                search_text = "";
                selected_category = "All";
                selected_payment = "All";
                populate_grid();
                setState(() {});
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Icon(Icons.close, size: 16, color: Colors.red),
                    SizedBox(width: 4),
                    Text("Reset", style: TextStyle(fontSize: 12, color: Colors.red)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _filter_dropdown<T>({required T value, required List<T> items, required ValueChanged<T?> on_changed}) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isDense: true,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          items: items.map((v) => DropdownMenuItem<T>(value: v, child: Text(v.toString()))).toList(),
          onChanged: on_changed,
        ),
      ),
    );
  }

  // * ─── grid ────────────────────────────────────────────────────────────────
  Widget _grid() {
    return PlutoGrid(
      columns: [
        for (final e in schema.data.entries)
          PlutoColumn(
            field: e.key,
            title: e.value["title"]!,
            type: e.value["type"] == "number" ? PlutoColumnType.number(format: "\$#,##0.00") : PlutoColumnType.text(),
            hide: e.value["hide"]!,
            width: e.key == schema.GUEST_NAME
                ? 180
                : e.key == schema.REFERENCE_NO
                ? 140
                : e.key == schema.AMOUNT
                ? 130
                : 120,
            enableEditingMode: false,
          ),
      ],
      rows: const [],
      configuration: const PlutoGridConfiguration(scrollbar: PlutoGridScrollbarConfig(isAlwaysShown: true, scrollbarThickness: 8), style: PlutoGridStyleConfig(rowHeight: 32, columnHeight: 36)),
      onLoaded: (event) {
        state_manager = event.stateManager;
        populate_grid();
      },
    );
  }
}

class Main_ extends StatefulWidget {
  const Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(MaterialApp(title: HEADER, theme: theme.data(), home: const Main_(), debugShowCheckedModeBanner: false));
}
