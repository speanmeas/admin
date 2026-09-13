import "package:flutter/material.dart";
import "package:flutter/services.dart";

Future<int?> dialog_select_page(
  BuildContext context, {
  required int page, //
  required int total_row,
  required int limit,
}) async {
  final ITEM_HEIGHT = 32.0;
  final total_pages = total_row == 0 ? 1 : (total_row + limit - 1) ~/ limit;
  final controller = ScrollController(initialScrollOffset: ((page - 1) * ITEM_HEIGHT).clamp(0.0, double.infinity));
  final input_controller = TextEditingController();

  final result = await showDialog<int>(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        alignment: Alignment.topCenter,
        titlePadding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
        contentPadding: const EdgeInsets.all(4),
        actionsPadding: const EdgeInsets.all(4),
        actionsAlignment: MainAxisAlignment.center,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$total_pages Pages ($total_row Rows)", //
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SizedBox(
          width: 400,
          height: 600,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
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
                            isDense: true,
                            hintText: "Select Page",
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
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
                    final end_item = p * limit > total_row ? total_row : p * limit;

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
                            const SizedBox(width: 8),
                            Text(
                              "Page $p",
                              style: TextStyle(fontSize: 13, fontWeight: is_current ? FontWeight.bold : FontWeight.normal, color: is_current ? Colors.blue : Colors.black87),
                            ),
                            const SizedBox(width: 8),
                            Text("(#$start_item - #$end_item)", style: TextStyle(fontSize: 11, color: is_current ? Colors.blue.shade700 : Colors.grey.shade600)),
                            const Spacer(),
                            if (is_current) const Icon(Icons.check, size: 20, color: Colors.blue),
                            const SizedBox(width: 8),
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