import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

class _Item_PickerState extends State<Item_Picker_> {

  dynamic tmp;

  List<Mini_Bar> list_mini_bar = [];

  String _search = "";

  List<String> items = []; // id of items that have been picked (selected) in the dialog
  List<String> pick_items = []; // id of items that have been picked (selected) in the dialog

  // * ទាញយកបញ្ជីទំនិញ mini bar ពី server
  void init() async {
    list_mini_bar = widget.list_mini_bar;
    items = list_mini_bar.map((item) => item.id.toString()).toList();
    pick_items = [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      titlePadding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          const Text(
            "Select Item", //
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          // * ប៊ូតុងបិទ dialog
          IconButton(
            icon: const Icon(Icons.close, size: 24, color: Colors.red),
            padding: EdgeInsets.all(4),
            constraints: const BoxConstraints(),
            onPressed: () => Navigator.pop(context),
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
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search",
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
                          isDense: true,
                          prefixIcon: const Icon(Icons.search, size: 20, color: Colors.blue),
                        ),
                        onChanged: (v) {
                          _search = v;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // * បញ្ជីទំនិញដែលបានត្រង
            Expanded(
              child: list_mini_bar.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _list_show.isEmpty
                  ? const Center(
                      child: Text("No item found", style: TextStyle(color: Colors.grey)),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      itemCount: _list_show.length,
                      separatorBuilder: (_, _) => const Divider(height: 1, color: Colors.grey),
                      itemBuilder: (context, index) {
                        final item = _list_show[index];
                        final id = item.id;
                        final selected = pick_items.contains(id);
                        final price = item.price ?? 0;
                        return InkWell(
                          hoverColor: Colors.blue.withValues(alpha: 0.05),
                          onTap: () => _toggle(id, selected),
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
      actions: [
        // * ប៊ូតុងបញ្ជាក់ការជ្រើសរើស
        OutlinedButton.icon(
          icon: const Icon(Icons.check), //
          label: const Text("Done"), //
          onPressed: () {
            pprint(pick_items);
            // Navigator.pop(context, pick_items), //
          },
        ),
      ],
    );
  }

  // * ជ្រើស/មិនជ្រើសទំនិញមួយម្តងៗ
  void _toggle(dynamic id, bool selected) {
    if (selected) {
      pick_items.remove(id);
    } else {
      pick_items.add(id);
    }
    setState(() {});
  }

  // * តម្រងបញ្ជីទំនិញតាមឈ្មោះដែលស្វែងរក
  List<Mini_Bar> get _list_show {
    final q = _search.trim().toLowerCase();
    if (q.isEmpty) return list_mini_bar;
    return list_mini_bar.where((item) => (item.name ?? "").toLowerCase().contains(q)).toList();
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

// * dialog ជ្រើសរើសទំនិញ mini bar ជាមួយ stepper +/- ក្នុងមួយទំនិញ
class Item_Picker_ extends StatefulWidget {
  const Item_Picker_({super.key, required this.list_mini_bar});

  final List<Mini_Bar> list_mini_bar; // * បញ្ជីទំនិញ mini bar

  @override
  State<Item_Picker_> createState() => _Item_PickerState();
}

// * ចំណុចចាប់ផ្តើមកម្មវិធី
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
        home: Scaffold(
          body: Center(
            child: Builder(
              builder: (context) => OutlinedButton(
                onPressed: () => showDialog<Map<dynamic, int>>(
                  context: context,
                  builder: (context) => Item_Picker_(
                    list_mini_bar: [], //
                    // stock: (item) => 0, //
                  ),
                ),
                child: const Text("Open Item Picker"), //
              ),
            ),
          ),
        ),
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
