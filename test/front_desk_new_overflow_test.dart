import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:speanmeas/features/dashboard/front_desk_new/main.dart";

void main() {
  testWidgets("no bottom overflow at small sizes", (tester) async {
    final errors = <FlutterErrorDetails>[];
    final old = FlutterError.onError;
    FlutterError.onError = (details) {
      errors.add(details);
      old?.call(details);
    };

    await tester.binding.setSurfaceSize(const Size(300, 200));
    await tester.pumpWidget(MaterialApp(home: const Main_()));
    await tester.pumpAndSettle();

    final overflow = errors.where((e) => e.exception.toString().contains("overflowed")).toList();
    expect(overflow, isEmpty, reason: overflow.map((e) => e.exception.toString()).join("\n"));

    await tester.binding.setSurfaceSize(const Size(2000, 600));
    await tester.pumpAndSettle();
    final overflow2 = errors.where((e) => e.exception.toString().contains("overflowed")).toList();
    expect(overflow2, isEmpty, reason: overflow2.map((e) => e.exception.toString()).join("\n"));

    await tester.binding.setSurfaceSize(null);
  });
}
