import "dart:async";
import "dart:js_interop";
import "dart:typed_data";

import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:intl/intl.dart";
import "package:speanmeas/core/utility/all.dart";
import "package:web/web.dart" as web;

class _Main_State extends State<Main_> {
  // ########## BLOCK ATTRIBUTE ##########
  int reload = 0;

  bool downloading = false;
  DateTime date = DateTime.now();
  bool loading = false;
  Map<String, dynamic> summary = {};
  List<Front_Desk> rows = [];
  // ########## BLOCK ATTRIBUTE END ##########

  // ########## BLOCK DESIGN ##########
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        spacing: 1,
        children: [
          Container(
            height: 34,
            padding: const EdgeInsets.all(1),
            child: Row(
              spacing: 1,
              children: [
                IconButton(
                  tooltip: "Previous",
                  icon: const Icon(Icons.navigate_before, size: 30),
                  padding: const EdgeInsets.all(0),
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    date = date.subtract(const Duration(days: 1));
                    on_load_page();
                  },
                ),

                TextButton(
                  onPressed: pick_date,
                  child: Text(
                    DateFormat("yyyy-MM-dd").format(date),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                IconButton(
                  tooltip: "Next",
                  icon: const Icon(Icons.navigate_next, size: 30),
                  padding: const EdgeInsets.all(0),
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    date = date.add(const Duration(days: 1));
                    on_load_page();
                  },
                ),

                const Spacer(),

                IconButton(
                  tooltip: "Download Excel",
                  icon: downloading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : SvgPicture.asset("assets/icon/excel.svg", width: 30, height: 30),
                  padding: const EdgeInsets.all(0),
                  constraints: const BoxConstraints(),
                  onPressed: on_download,
                ),

                IconButton(
                  tooltip: "Print",
                  icon: const Icon(Icons.print_outlined, size: 30),
                  padding: const EdgeInsets.all(0),
                  constraints: const BoxConstraints(),
                  onPressed: on_print,
                ),

                IconButton(
                  tooltip: "Reload",
                  icon: const Icon(Icons.refresh, size: 30),
                  padding: const EdgeInsets.all(0),
                  constraints: const BoxConstraints(),
                  onPressed: on_reload,
                ),
              ],
            ),
          ),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Center(child: _preview()),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _preview() {
    return Container(
      width: 720,
      decoration: BoxDecoration(
        color: Colors.white, //
        border: Border.all(color: Colors.black45),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "SPEAN MEAS",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
          const Text(
            "Hotel Management System",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          const Divider(thickness: 2, color: Colors.black87),
          const SizedBox(height: 8),
          const Text(
            "DAILY SUMMARY REPORT",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat("EEEE, dd MMMM yyyy").format(date),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 24),

          _section_title("ចំណូល (Revenue)"),
          _table(rows: [
            ("ចំណូលបន្ទប់ (Room Revenue)", room_revenue),
            ("ចំណូលមីនីបារ (Mini Bar Revenue)", mini_bar_revenue),
            ("ចំណូលពិន័យ (Penalty Revenue)", penalty_revenue),
          ], total_label: "ចំណូលសរុប (Total Revenue)", total: total_revenue),

          const SizedBox(height: 20),

          _section_title("ការបង់ប្រាក់ (Collection)"),
          _table(rows: [
            ("លុយ (Cash)", pay_cash),
            ("ធនាគារ (Bank)", pay_bank),
          ], total_label: "ប្រមូលបាន (Total Collected)", total: total_collected),

          const SizedBox(height: 20),

          _section_title("គណនីត្រូវទារ (Account Receivable)"),
          _highlight_row(
            "គណនីត្រូវទារ (Account Receivable)",
            account_receivable,
            account_receivable > 0 ? Colors.red : Colors.green,
          ),

          if (mini_bar_items.isNotEmpty) ...[
            const SizedBox(height: 20),
            _section_title("មីនីបារ (Mini Bar Detail)"),
            _mini_bar_table(),
          ],

          if (bank_breakdown.isNotEmpty) ...[
            const SizedBox(height: 20),
            _section_title("ធនាគារ (Bank Breakdown)"),
            _table(
              rows: [for (final b in bank_breakdown) (b.$1, b.$2)],
              total_label: "សរុប (Total Bank)",
              total: bank_total,
            ),
          ],

          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(child: _signature("Prepared by")),
              Expanded(child: _signature("Checked by")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _section_title(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  Widget _table({
    required List<(String, double)> rows,
    required String total_label,
    required double total,
  }) {
    return Table(
      border: TableBorder.all(color: Colors.black54),
      columnWidths: const {0: FlexColumnWidth(3), 1: FlexColumnWidth(2)},
      children: [
        for (final (label, value) in rows)
          TableRow(
            children: [
              _cell(label),
              _cell(format_double(value, digits: 2) + " \$", align: TextAlign.right),
            ],
          ),
        TableRow(
          decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.08)),
          children: [
            _cell(total_label, bold: true),
            _cell(format_double(total, digits: 2) + " \$", align: TextAlign.right, bold: true),
          ],
        ),
      ],
    );
  }

  Widget _highlight_row(String label, double value, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08), //
        border: Border.all(color: Colors.black54),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
          Text(
            format_double(value, digits: 2) + " \$", //
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _mini_bar_table() {
    return Table(
      border: TableBorder.all(color: Colors.black54),
      columnWidths: const {
        0: FlexColumnWidth(4),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(1.5),
        3: FlexColumnWidth(2),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.12)),
          children: [
            _cell("ទំនិញ (Item)", bold: true),
            _cell("តម្លៃ (Price)", align: TextAlign.right, bold: true),
            _cell("ចំនួន (Qty)", align: TextAlign.center, bold: true),
            _cell("ទឹកប្រាក់ (Amount)", align: TextAlign.right, bold: true),
          ],
        ),
        for (final item in mini_bar_items)
          TableRow(
            children: [
              _cell(item.$1),
              _cell(format_double(item.$2, digits: 2) + " \$", align: TextAlign.right),
              _cell("${item.$3}", align: TextAlign.center),
              _cell(format_double(item.$4, digits: 2) + " \$", align: TextAlign.right),
            ],
          ),
        TableRow(
          decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.08)),
          children: [
            _cell("សរុប (Total)", bold: true),
            _cell("", align: TextAlign.right),
            _cell("$mini_bar_qty", align: TextAlign.center, bold: true),
            _cell(format_double(mini_bar_items_total, digits: 2) + " \$", align: TextAlign.right, bold: true),
          ],
        ),
      ],
    );
  }

  Widget _cell(String text, {TextAlign align = TextAlign.left, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(fontSize: 13, fontWeight: bold ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }

  Widget _signature(String label) {
    return Column(
      children: [
        const SizedBox(height: 48),
        Container(width: 160, decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.black54)))),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
  // ########## BLOCK DESIGN END ##########

  // ########## BLOCK METHODS ##########
  @override
  void initState() {
    super.initState();
    on_load_page();
  }

  @override
  void reassemble() {
    super.reassemble();
    reload++;
  }

  Future<void> on_load_page() async {
    setState(() => loading = true);
    final String formatted_date = DateFormat("yyyy-MM-dd").format(date);
    dynamic tmp = await dio.post(endpoint.FRONT_DESK_REPORT_DAILY, data: {"date": formatted_date});
    if (tmp == null) {
      setState(() => loading = false);
      return snackbar(ct: context, ms: dio.error_msg ?? "Failed to load report", cl: Colors.red);
    }

    summary = tmp.data?["summary"] ?? {};
    rows = (tmp.data?["rows"] as List<dynamic>? ?? []).map((e) => Front_Desk.fromJson(e)).toList();
    setState(() => loading = false);
  }

  Future<void> on_reload() async {
    reload++;
    await on_load_page();
    snackbar(ct: context, ms: "Reloaded", cl: Colors.green);
  }

  Future<void> on_download() async {
    if (downloading) return;
    setState(() => downloading = true);
    try {
      final String formatted_date = DateFormat("yyyy-MM-dd").format(date);
      dynamic tmp = await dio.download(endpoint.FRONT_DESK_REPORT_DAILY_SUMMARY_EXCEL, data: {"date": formatted_date});
      if (tmp == null) {
        snackbar(ct: context, ms: dio.error_msg ?? "Error: ${endpoint.FRONT_DESK_REPORT_DAILY_SUMMARY_EXCEL}", cl: Colors.red);
        return;
      }

      final bytes = Uint8List.fromList(tmp.data as List<int>);
      final blob = web.Blob([bytes.toJS].toJS, web.BlobPropertyBag(type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));
      final url = web.URL.createObjectURL(blob);
      final anchor = web.HTMLAnchorElement()
        ..href = url
        ..download = "report_daily_summary_$formatted_date.xlsx";
      web.document.body?.appendChild(anchor);
      anchor.click();
      anchor.remove();
      web.URL.revokeObjectURL(url);
      snackbar(ct: context, ms: "Downloaded: report_daily_summary_$formatted_date.xlsx", cl: Colors.green);
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: "Error: $e", cl: Colors.red);
    } finally {
      if (mounted) setState(() => downloading = false);
    }
  }

  Future<void> pick_date() async {
    final DateTime? picked = await showDatePicker(
      context: context, //
      initialDate: date, //
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    date = picked;
    on_load_page();
  }

  void on_print() {
    final content = _build_print_html();
    final frame = web.HTMLIFrameElement()
      ..setAttribute("style", "position:fixed;right:0;bottom:0;width:0;height:0;border:0;");

    final loaded = Completer<void>();
    frame.onload = ((web.Event _) {
      if (!loaded.isCompleted) loaded.complete();
    }).toJS;

    frame.srcdoc = content.toJS;
    web.document.body?.appendChild(frame);

    loaded.future.then((_) async {
      await Future.delayed(const Duration(milliseconds: 300));
      final win = frame.contentWindow;
      win?.focus();
      win?.print();
      await Future.delayed(const Duration(seconds: 2));
      frame.remove();
    });
  }

  String _build_print_html() {
    String money(double v) => format_double(v, digits: 2) + " \$";
    final shift = DateFormat("yyyy-MM-dd").format(date);
    final day = DateFormat("EEEE, dd MMMM yyyy").format(date);
    final generated = DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());

    final items = mini_bar_items;
    final banks = bank_breakdown;

    final mini_bar_rows = StringBuffer();
    for (final item in items) {
      final name = item.$1;
      final price = item.$2;
      final qty = item.$3;
      final amount = item.$4;
      mini_bar_rows.write(
        '<tr><td>$name</td><td class="num">${money(price)}</td><td class="num">$qty</td><td class="num">${money(amount)}</td></tr>',
      );
    }

    final bank_rows = StringBuffer();
    for (final bank in banks) {
      final name = bank.$1;
      final amount = bank.$2;
      bank_rows.write('<tr><td>$name</td><td class="num">${money(amount)}</td></tr>');
    }

    final mini_bar_table = items.isEmpty
        ? ""
        : """
  <table>
    <caption>មីនីបារ (Mini Bar Detail)</caption>
    <thead><tr><th>ទំនិញ (Item)</th><th class="num">តម្លៃ (Price)</th><th class="num">ចំនួន (Qty)</th><th class="num">ទឹកប្រាក់ (Amount)</th></tr></thead>
    <tbody>$mini_bar_rows</tbody>
    <tfoot><tr class="total"><td>សរុប (Total)</td><td></td><td class="num">$mini_bar_qty</td><td class="num">${money(mini_bar_items_total)}</td></tr></tfoot>
  </table>
""";

    final bank_table = banks.isEmpty
        ? ""
        : """
  <table>
    <caption>ធនាគារ (Bank Breakdown)</caption>
    <thead><tr><th>ធនាគារ (Bank)</th><th class="num">ទឹកប្រាក់ (Amount)</th></tr></thead>
    <tbody>$bank_rows</tbody>
    <tfoot><tr class="total"><td>សរុប (Total Bank)</td><td class="num">${money(bank_total)}</td></tr></tfoot>
  </table>
""";

    return """
<!DOCTYPE html>
<html lang="km">
<head>
<meta charset="utf-8"/>
<title>Daily Summary Report - $shift</title>
<style>
  @page { size: A4 portrait; margin: 14mm; }
  @font-face { font-family: 'Nokora'; src: url('assets/assets/font/Nokora.ttf') format('truetype'); font-weight: normal; }
  * { box-sizing: border-box; }
  html, body { margin: 0; padding: 0; }
  body { font-family: 'Nokora', 'Khmer OS', 'Khmer OS Battambang', Arial, sans-serif; color: #111; font-size: 12pt; }
  .header { text-align: center; padding-bottom: 10px; border-bottom: 2px solid #111; margin-bottom: 14px; }
  .header .hotel { font-size: 20pt; font-weight: 700; letter-spacing: 1px; }
  .header .sub { font-size: 11pt; color: #555; margin-top: 2px; }
  .header .title { font-size: 15pt; font-weight: 700; margin-top: 10px; }
  .header .date { font-size: 12pt; margin-top: 4px; }
  .meta { display: flex; justify-content: space-between; font-size: 9pt; color: #555; margin-bottom: 16px; }
  table { width: 100%; border-collapse: collapse; margin-bottom: 18px; }
  caption { text-align: left; font-weight: 700; font-size: 12pt; padding-bottom: 6px; }
  th, td { border: 1px solid #333; padding: 7px 10px; }
  th { background: #f1f3f5; text-align: left; }
  th.num, td.num { text-align: right; font-variant-numeric: tabular-nums; }
  tr.total td { background: #e8f1fb; font-weight: 700; font-size: 13pt; }
  .sign { display: flex; justify-content: space-between; margin-top: 60px; font-size: 11pt; }
  .sign div { width: 40%; text-align: center; }
  .sign .line { margin-top: 48px; border-top: 1px solid #333; padding-top: 6px; }
  .footer { margin-top: 24px; text-align: center; font-size: 8pt; color: #999; }
</style>
</head>
<body>
  <div class="header">
    <div class="hotel">SPEAN MEAS</div>
    <div class="sub">Hotel Management System</div>
    <div class="title">DAILY SUMMARY REPORT</div>
    <div class="date">$day</div>
  </div>

  <div class="meta">
    <span>Shift: $shift</span>
    <span>Generated: $generated</span>
  </div>

  <table>
    <caption>ចំណូល (Revenue)</caption>
    <thead><tr><th>ប្រភេទ</th><th class="num">ទឹកប្រាក់</th></tr></thead>
    <tbody>
      <tr><td>ចំណូលបន្ទប់ (Room Revenue)</td><td class="num">${money(room_revenue)}</td></tr>
      <tr><td>ចំណូលមីនីបារ (Mini Bar Revenue)</td><td class="num">${money(mini_bar_revenue)}</td></tr>
      <tr><td>ចំណូលពិន័យ (Penalty Revenue)</td><td class="num">${money(penalty_revenue)}</td></tr>
    </tbody>
    <tfoot><tr class="total"><td>ចំណូលសរុប (Total Revenue)</td><td class="num">${money(total_revenue)}</td></tr></tfoot>
  </table>

  <table>
    <caption>ការបង់ប្រាក់ (Collection)</caption>
    <thead><tr><th>ប្រភេទ</th><th class="num">ទឹកប្រាក់</th></tr></thead>
    <tbody>
      <tr><td>លុយ (Cash)</td><td class="num">${money(pay_cash)}</td></tr>
      <tr><td>ធនាគារ (Bank)</td><td class="num">${money(pay_bank)}</td></tr>
    </tbody>
    <tfoot><tr class="total"><td>ប្រមូលបាន (Total Collected)</td><td class="num">${money(total_collected)}</td></tr></tfoot>
  </table>

  <table>
    <tr class="total"><td>គណនីត្រូវទារ (Account Receivable)</td><td class="num">${money(account_receivable)}</td></tr>
  </table>
$mini_bar_table$bank_table
  <div class="sign">
    <div><div class="line">Prepared by</div></div>
    <div><div class="line">Checked by</div></div>
  </div>

  <div class="footer">$TITLE &middot; Daily Summary Report &middot; $shift</div>
</body>
</html>
""";
  }
  // ########## BLOCK METHODS END ##########

  // ########## BLOCK SUMMARY VALUES ##########
  double _value(List<String> path) {
    dynamic cur = summary;
    for (final key in path) {
      if (cur is Map) {
        cur = cur[key];
      } else {
        return 0;
      }
    }
    return parse_double(cur) ?? 0.0;
  }

  double get room_revenue => _value(["room", "price"]);
  double get mini_bar_revenue => _value(["mini_bar", "price"]);
  double get penalty_revenue => _value(["penalty", "price"]);
  double get total_revenue => room_revenue + mini_bar_revenue + penalty_revenue;
  double get pay_cash => _value(["pay", "cash"]);
  double get pay_bank => _value(["pay", "bank"]);
  double get total_collected => pay_cash + pay_bank;
  double get account_receivable => total_revenue - total_collected;

  List<(String, double, int, double)> get mini_bar_items {
    final map = <String, (String, double, int, double)>{};
    for (final fd in rows) {
      for (final raw in fd.mini_bar_item_id ?? []) {
        if (raw is! Mini_Bar_Item) continue;
        final mb = raw.mini_bar_id;
        final name = (mb is Mini_Bar_Show_2 && (mb.name ?? "").trim().isNotEmpty) ? mb.name!.trim() : "Unknown Item";
        final price = mb is Mini_Bar_Show_2 ? (mb.price ?? 0) : 0.0;
        final id = mb is Mini_Bar_Show_2 ? (mb.id ?? "") : "";
        final key = id.isNotEmpty ? id : name;
        final qty = raw.quantity ?? 0;
        final amount = price * qty;
        final existing = map[key];
        map[key] = existing == null
            ? (name, price, qty, amount) //
            : (name, price, existing.$3 + qty, existing.$4 + amount);
      }
    }
    return map.values.toList()..sort((a, b) => a.$1.toLowerCase().compareTo(b.$1.toLowerCase()));
  }

  int get mini_bar_qty => mini_bar_items.fold(0, (sum, item) => sum + item.$3);

  double get mini_bar_items_total => mini_bar_items.fold(0.0, (sum, item) => sum + item.$4);

  List<(String, double)> get bank_breakdown {
    final map = <String, double>{};
    for (final fd in rows) {
      final amount = fd.pay_bank ?? 0;
      if (amount == 0) continue;
      final name = (fd.pay_bank_name ?? "").trim();
      final key = name.isEmpty ? "Unknown Bank" : name;
      map[key] = (map[key] ?? 0) + amount;
    }
    return map.entries.map((e) => (e.key, e.value)).toList()..sort((a, b) => a.$1.toLowerCase().compareTo(b.$1.toLowerCase()));
  }

  double get bank_total => bank_breakdown.fold(0.0, (sum, bank) => sum + bank.$2);
  // ########## BLOCK SUMMARY VALUES END ##########
}

// ########## BLOCK ARGUMENTS OF MAIN ##########
class Main_ extends StatefulWidget {
  const Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}
// ########## BLOCK ARGUMENTS OF MAIN END ##########

void main() {
  runApp(
    MaterialApp(
      home: const Main_(), //
      theme: theme_data, //
      title: "Development", //
      debugShowCheckedModeBanner: false, //
    ),
  );
}
