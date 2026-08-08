import "package:flutter/material.dart";
import "package:flutter/services.dart";

//
import "package:speanmeas/core/theme/theme_data.dart";

Future<int?> show(
  BuildContext context, {
  required int page, //
  required int row_total,
  required int limit,
}) async {
  final ITEM_HEIGHT = 38.0;
  final total_pages = row_total == 0 ? 1 : (row_total + limit - 1) ~/ limit;
  final controller = ScrollController(initialScrollOffset: ((page - 1) * ITEM_HEIGHT).clamp(0.0, double.infinity));
  final input_controller = TextEditingController();

  final result = await showDialog<int>(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        titlePadding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        contentPadding: EdgeInsets.zero,
        title: Row(
          children: [
            const Text(
              "Select Page", //
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Text(
                "$total_pages Pages ($row_total rows)", //
                style: const TextStyle(
                  fontSize: 12, //
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.close, size: 24, color: Colors.red),
              padding: EdgeInsets.all(4),
              constraints: const BoxConstraints(),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        content: SizedBox(
          width: 360,
          height: 520,
          child: Column(
            children: [
              // Quick jump input
              Container(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 34,
                        child: TextField(
                          controller: input_controller,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            hintText: "Enter page...",
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
                            isDense: true,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.arrow_forward, color: Colors.blue),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              tooltip: "Go",
                              onPressed: () {
                                final p = int.tryParse(input_controller.text);
                                if (p != null && p >= 1 && p <= total_pages) {
                                  Navigator.pop(context, p);
                                }
                              },
                            ),
                          ),
                          onSubmitted: (v) {
                            final p = int.tryParse(v);
                            if (p != null && p >= 1 && p <= total_pages) {
                              Navigator.pop(context, p);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Page list
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemExtent: ITEM_HEIGHT,
                  itemCount: total_pages,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final p = index + 1;
                    final is_current = p == page;
                    final start_item = (p - 1) * limit + 1;
                    final end_item = p * limit > row_total ? row_total : p * limit;

                    return InkWell(
                      hoverColor: Colors.blue.withValues(alpha: 0.05),
                      onTap: () => Navigator.pop(context, p),
                      child: Container(
                        height: ITEM_HEIGHT,
                        decoration: BoxDecoration(
                          border: Border(
                            top: const BorderSide(color: Colors.grey),
                            left: is_current ? const BorderSide(color: Colors.blue, width: 3) : BorderSide.none,
                          ),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            Text(
                              "Page $p",
                              style: TextStyle(fontSize: 13, fontWeight: is_current ? FontWeight.bold : FontWeight.normal, color: is_current ? Colors.blue : Colors.black87),
                            ),
                            const SizedBox(width: 8),
                            Text("(#$start_item - #$end_item)", style: TextStyle(fontSize: 11, color: is_current ? Colors.blue.shade700 : Colors.grey.shade600)),
                            const Spacer(),
                            if (is_current) const Icon(Icons.check, size: 18, color: Colors.blue),
                            const SizedBox(width: 12),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
  return result;
}

class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  int page = 1;
  int row_total = 2500;
  int limit = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Current Page: $page of ${row_total == 0 ? 1 : (row_total + limit - 1) ~/ limit}", //
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            //
            OutlinedButton(
              style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
              onPressed: () async {
                final v = await show(context, page: page, row_total: row_total, limit: limit);
                if (v == null) return;
                page = v;
                setState(() {});
              },
              child: const Text("Select Page"),
            ),
          ],
        ),
      ),
    );
  }
}

class Main_ extends StatefulWidget {
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme_data, //
      home: const Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
