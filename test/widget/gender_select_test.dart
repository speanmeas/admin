import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speanmeas/features/database/guest/widget/gender_select.dart';

void main() {
  testWidgets('gender selector can initialize without calling onChanged during build', (tester) async {
    final controller = TextEditingController(text: 'Male');
    String? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Main_(
            controller: controller,
            onChanged: (value) {
              selected = value;
            },
            onCleared: () {},
          ),
        ),
      ),
    );

    expect(selected, isNull);
    expect(find.text('Male'), findsOneWidget);
  });
}
