import "package:flutter/material.dart";

import "package:speanmeas/core/utility/all.dart";

// * ថ្នាក់ទិន្នន័យការបញ្ជាទំនិញ penalty (ប្រើក្នុង UI មុនពេលរក្សាទុក)
class Order_Penalty {
  final String? id; // * id នៃ Penalty_Item ដែលរក្សាទុករួច (null = ថ្មី)
  final Penalty_Show_2? penalty_id;
  int quantity;
  Order_Penalty({this.id, this.penalty_id, this.quantity = 1});

  // * តម្លៃសរុប = price × quantity
  double get total => (penalty_id?.price ?? 0) * quantity;

  factory Order_Penalty.fromJson(Map<String, dynamic> m) => Order_Penalty(id: parse_string(m["_id"]), penalty_id: m["penalty_id"] == null ? null : Penalty_Show_2.fromJson(m["penalty_id"]), quantity: parse_int(m["quantity"]) ?? 1);
}

// * dialog ជ្រើសរើសទំនិញ penalty ជាមួយ stepper +/- ក្នុងមួយទំនិញ
Future<bool?> dialog_select_penalty({
  required BuildContext context, //
  required List<Order_Penalty> list_order_penalty,
  required String? front_desk_id, //
}) async {
  List<Penalty> list_penalty = [];
  List<Order_Penalty> orders = [...list_order_penalty];
  String search = "";
  bool is_loading = false;

  // * ទាញយកបញ្ជីទំនិញ penalty ពី server
  Future<void> load() async {
    final tmp = await dio.post(endpoint.PENALTY_READ, data: {});
    if (tmp == null) {
      snackbar(ct: context, ms: "Error: Read Penalty", cl: Colors.red);
      return;
    }
    list_penalty = (tmp.data as List<dynamic>? ?? []).map((e) => Penalty.fromJson(e)).toList();
  }

  // * ពិនិត្យថាទំនិញបានជ្រើសរើសហើយឬនៅ (មាន order ដែល quantity > 0)
  bool is_selected(Penalty item) => orders.any((o) => o.penalty_id?.id == item.id);

  // * ស្វែងរក order របស់ទំនិញ
  Order_Penalty? order_of(Penalty item) {
    for (var o in orders) {
      if (o.penalty_id?.id == item.id) return o;
    }
    return null;
  }

  // * ជ្រើស/មិនជ្រើសទំនិញមួយម្តងៗ
  void toggle(Penalty item, bool selected) {
    if (selected) {
      orders.removeWhere((o) => o.penalty_id?.id == item.id);
    } else {
      orders.add(
        Order_Penalty(
          penalty_id: Penalty_Show_2(id: item.id, name: item.name, price: item.price),
          quantity: 1,
        ),
      );
    }
  }

  // * បង្កើនចំនួន
  void increase(Penalty item) {
    var o = order_of(item);
    if (o == null) return;
    o.quantity++;
  }

  // * បន្ថយចំនួន (ដល់ 0 ដកចេញពីបញ្ជី)
  void decrease(Penalty item) {
    var o = order_of(item);
    if (o == null) return;
    o.quantity--;
    if (o.quantity <= 0) {
      orders.removeWhere((x) => x.penalty_id?.id == item.id);
    }
  }

  // * តម្រងបញ្ជីទំនិញតាមឈ្មោះដែលស្វែងរក
  List<Penalty> list_show() {
    final q = search.trim().toLowerCase();
    if (q.isEmpty) return list_penalty;
    return list_penalty.where((item) => (item.name ?? "").toLowerCase().contains(q)).toList();
  }

  // * រក្សាទុកទំនិញ: ថ្មី → create, មានរួច → update quantity, រួចភ្ជាប់ទៅ stay
  Future<bool?> on_confirm() async {
    is_loading = true;

    List<String> ids = [];
    for (var o in orders) {
      if (o.id != null) {
        final tmp_up = await dio.post(
          endpoint.PENALTY_ITEM_UPDATE,
          data: {
            Penalty_Item.ID: o.id, //
            Penalty_Item.QUANTITY: o.quantity, //
          },
        );
        if (tmp_up == null) return null;
        ids.add(o.id!);
        continue;
      }
      final tmp_item = await dio.post(
        endpoint.PENALTY_ITEM_CREATE,
        data: {
          Penalty_Item.PENALTY_ID: o.penalty_id?.id, //
          Penalty_Item.QUANTITY: o.quantity, //
        },
      );
      if (tmp_item == null) return null;
      ids.add(tmp_item.data[0][Penalty_Item.ID]);
    }

    final tmp_fd = await dio.post(
      endpoint.FRONT_DESK_UPDATE_PENALTY_ITEM,
      data: {
        Front_Desk.ID: front_desk_id, //
        Front_Desk.PENALTY_ITEM_ID: ids, //
      },
    );
    if (tmp_fd == null) return null;

    snackbar(ct: context, ms: "Penalty Updated", cl: Colors.green);
    return true;
  }

  await load();

  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            titlePadding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            contentPadding: EdgeInsets.zero,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Select Item", //
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: SizedBox(
              width: 420,
              height: 480,
              child: Column(
                children: [
                  // * ប្រអប់ស្វែងរកទំនិញតាមឈ្មោះ
                  Container(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                    child: TextField(
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: "Search",
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
                        prefixIcon: const Icon(Icons.search, size: 20, color: Colors.blue),
                      ),
                      onChanged: (v) {
                        search = v;
                        setState(() {});
                      },
                    ),
                  ),

                  const Divider(height: 1),

                  // * បញ្ជីទំនិញដែលបានត្រង
                  Expanded(
                    child: list_penalty.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : list_show().isEmpty
                        ? const Center(
                            child: Text("No item found", style: TextStyle(color: Colors.grey)),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                            itemCount: list_show().length,
                            separatorBuilder: (_, _) => const Divider(height: 1, color: Colors.grey),
                            itemBuilder: (context, index) {
                              final item = list_show()[index];
                              final selected = is_selected(item);
                              final order = order_of(item);
                              final price = item.price ?? 0;
                              final qty = order?.quantity ?? 0;
                              return InkWell(
                                hoverColor: Colors.blue.withValues(alpha: 0.05),
                                onTap: () {
                                  toggle(item, selected);
                                  setState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(
                                    border: Border(left: selected ? const BorderSide(color: Colors.blue, width: 3) : BorderSide.none),
                                  ),
                                  child: Row(
                                    children: [
                                      // * សញ្ញាធីកបង្ហាញថាបានជ្រើសរើស
                                      Icon(selected ? Icons.check_circle : Icons.radio_button_unchecked, color: selected ? Colors.blue : Colors.grey),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.name ?? "", //
                                              style: TextStyle(
                                                fontSize: 16, //
                                                fontWeight: FontWeight.bold,
                                                color: selected ? Colors.blue : Colors.black87,
                                              ),
                                            ),
                                            Text(
                                              "$price \$ / item", //
                                              style: const TextStyle(color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // * stepper +/-
                                      if (selected) ...[
                                        IconButton(
                                          tooltip: "Decrease", //
                                          icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          onPressed: () {
                                            decrease(item);
                                            setState(() {});
                                          }, //
                                        ),
                                        SizedBox(
                                          width: 32,
                                          child: Text(
                                            "$qty", //
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        IconButton(
                                          tooltip: "Increase", //
                                          icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          onPressed: () {
                                            increase(item);
                                            setState(() {});
                                          }, //
                                        ),
                                      ],
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
            actionsPadding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              // * ប៊ូតុងបញ្ជាក់ការជ្រើសរើស និងរក្សាទុកទំនិញ
              OutlinedButton.icon(
                icon: is_loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.check), //
                label: const Text("Confirm"), //
                onPressed: is_loading
                    ? null
                    : () async {
                        final r = await on_confirm();
                        if (r == null) {
                          if (context.mounted) snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
                          return;
                        }
                        if (context.mounted) Navigator.pop(context, r);
                      },
              ),
            ],
          );
        },
      );
    },
  );
  return result;
}

class _Main_State extends State<Main_> {
  bool? tmp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
          onPressed: () async {
            final v = await dialog_select_penalty(
              context: context, //
              list_order_penalty: [], //
              front_desk_id: "test", //
            );
            if (v == null) return;
            tmp = v;
            setState(() {});
          },
          child: const Text("Show"),
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
      home: const Main_(), //
      theme: theme_data, //
      title: "Development", //
      debugShowCheckedModeBanner: false, //
    ),
  );
}

