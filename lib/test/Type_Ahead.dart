import 'package:flutter/material.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';

void main() {
  runApp(MaterialApp(home: const FruitPageWrapper()));
}

class FruitPageWrapper extends StatelessWidget {
  const FruitPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const FruitPage();
  }
}

class FruitPage extends StatefulWidget {
  const FruitPage({super.key});

  @override
  State<FruitPage> createState() => _FruitPageState();
}

class _FruitPageState extends State<FruitPage> {
  TextEditingController controller_search = TextEditingController();
  List<String> options = ['Apple', 'Banana', 'Cherry', 'Date', 'Elderberry', 'Fig', 'Grape', 'Honeydew', 'Kiwi', 'Mango', 'Orange', 'Pineapple'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TypeAhead Example')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TypeAheadField<String>(
              controller: controller_search,
              suggestionsCallback: (query) {
                return options.where((e) => e.toLowerCase().contains(query.toLowerCase())).toList();
              },
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: "Fruit:", //
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: IconButton(
                        icon: Icon(Icons.clear, size: 24, color: Colors.red), //
                        onPressed: controller.clear,
                      ),
                    ),
                  ),
                );
              },
              itemBuilder: (context, item) {
                return ListTile(title: Text(item));
              },
              onSelected: (fruit) {
                setState(() {
                  controller_search.text = fruit;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
