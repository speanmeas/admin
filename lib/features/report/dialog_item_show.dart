import "package:flutter/material.dart";
import "package:speanmeas/core/utility/all.dart";

// * បង្ហាញ dialog អានតែមួយគត់ (read-only) សម្រាប់បញ្ជីទំនិញ mini bar និង penalty
Future<void> dialog_item_show({
  required BuildContext context, //
  required String title, //
  required List<dynamic> list, //
  required bool is_mini_bar, //
}) {
  // * គណនាទំនិញនីមួយៗ
  List<(String, double?, int, double)> items = [
    for (var it in list)
      if (_parse(it, is_mini_bar) case (final String name, final double? price, final int qty)) (name, price, qty, (price ?? 0) * qty),
  ];
  double total = items.fold(0, (s, i) => s + i.$4);

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        alignment: Alignment.topCenter,
        titlePadding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
        contentPadding: EdgeInsets.zero,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(is_mini_bar ? Icons.local_bar_outlined : Icons.gavel_outlined, color: Colors.blue), //
            // const SizedBox(width: 8),
            Text(
              title, //
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            // IconButton(
            //   icon: const Icon(Icons.close, size: 24, color: Colors.red),
            //   padding: EdgeInsets.all(4),
            //   constraints: const BoxConstraints(),
            //   onPressed: () => Navigator.pop(context),
            // ),
          ],
        ),
        content: SizedBox(
          width: 420,
          height: 320,
          child: Column(
            children: [
              // * ជួរឈរ (header)
              Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                color: Colors.blue.withValues(alpha: 0.06),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text("ទំនិញ", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(width: 8),
                    SizedBox(
                      width: 70,
                      child: Text("តម្លៃ/ឯកតា", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(width: 8),
                    SizedBox(
                      width: 40,
                      child: Text("ចំនួន", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(width: 8),
                    SizedBox(
                      width: 80,
                      child: Text(
                        "សរុប",
                        textAlign: TextAlign.right,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              // * បញ្ជីទំនិញ
              Expanded(
                child: list.isEmpty
                    ? const Center(
                        child: Text("No item", style: TextStyle(color: Colors.grey)),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const Divider(height: 1, color: Colors.grey),
                        itemBuilder: (context, index) {
                          final (name, price, qty, t) = items[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            child: Row(
                              children: [
                                Expanded(flex: 3, child: Text(name, overflow: TextOverflow.ellipsis)),
                                SizedBox(width: 8),
                                SizedBox(width: 70, child: Text(format_double(price, digits: 2), textAlign: TextAlign.right)),
                                SizedBox(width: 8),
                                SizedBox(width: 40, child: Text("$qty", textAlign: TextAlign.center)),
                                SizedBox(width: 8),
                                SizedBox(
                                  width: 80,
                                  child: Text(
                                    "$t \$", //
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),

              // * ជួរសរុប
              Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                color: Colors.blue.withValues(alpha: 0.06),
                child: Row(
                  children: [
                    const Spacer(),
                    const Text("សរុប: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      "$total \$", //
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // actionsPadding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
        // actionsAlignment: MainAxisAlignment.center,
        // actions: [
        //   OutlinedButton.icon(
        //     style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
        //     icon: const Icon(Icons.check), //
        //     label: const Text("Done"), //
        //     onPressed: () => Navigator.pop(context), //
        //   ),
        // ],
      );
    },
  );
}

// * ទាញយក (name, price, qty) ពីទំនិញអាស្រ័យប្រភេទ
(Object?, double?, int?) _parse(dynamic it, bool is_mini_bar) {
  if (is_mini_bar) {
    if (it is Mini_Bar_Item) {
      final show = it.mini_bar_id is Mini_Bar_Show_2 ? it.mini_bar_id as Mini_Bar_Show_2 : null;
      return (show?.name, show?.price, it.quantity);
    }
  } else {
    if (it is Penalty_Item) {
      final show = it.penalty_id is Penalty_Show_2 ? it.penalty_id as Penalty_Show_2 : null;
      return (show?.name, show?.price, it.quantity);
    }
  }
  return (null, null, null);
}
