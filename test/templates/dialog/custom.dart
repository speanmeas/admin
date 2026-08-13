import "package:flutter/material.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme/theme_data.dart"; // ignore: unused_import

//
// Custom dialog — put any widget inside, pop with a result.
//
// Usage:
//   final p = await custom<int>(context, title: "Pick", content: myWidget);
//   if (p == null) return;
//

Future<T?> custom<T>(BuildContext context, {String title = "", required Widget content, double width = 360, double height = 400}) async {
  return showDialog<T>(
    context: context,
    builder: (context) => AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      title: title.isEmpty
          ? null
          : Row(
              children: [
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
      content: SizedBox(width: width, height: height, child: content),
    ),
  );
}