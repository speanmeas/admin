// * នាំចូល Flutter material សម្រាប់ UI components
import "package:flutter/material.dart";
import "dart:math" as math; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import

// * បង្ហាញ snackbar ជូនដំណឹងដល់អ្នកប្រើប្រាស់
void snackbar({
  required BuildContext ct, //
  required String ms, //
  required Color cl, //
}) {
  ScaffoldMessenger.of(ct)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(left: math.max(8, MediaQuery.sizeOf(ct).width - 500 - 8), top: 0, right: 8, bottom: 8),
        duration: Duration(seconds: 5),

        content: Row(
          children: [
            // * រូបតំណាងព័ត៌មាន
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 8),
            // * អត្ថបទសារ
            Expanded(
              child: Text(
                ms, //
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16, //
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        // backgroundColor: Colors.transparent,
        backgroundColor: cl,

        elevation: 0, //

        shape: RoundedRectangleBorder(
          //
          side: BorderSide(color: cl),
        ),

        behavior: SnackBarBehavior.floating,
      ),
    );
}

// * Widget សម្រាប់សាកល្បង snackbar
class SnackbarTester extends StatefulWidget {
  const SnackbarTester({super.key});

  @override
  State<SnackbarTester> createState() => _SnackbarTesterState();
}

class _SnackbarTesterState extends State<SnackbarTester> {
  static const _colors = [Colors.green, Colors.orange, Colors.red, Colors.blue];
  int _index = 0;

  void _show() {
    snackbar(ct: context, ms: "ដំណឹងជោគជ័យ! ព័ត៌មានត្រូវបានរក្សាទុក។", cl: _colors[_index % _colors.length]);
  }

  void _cycle() {
    setState(() => _index++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(onPressed: _show, child: const Text("បង្ហាញ Snackbar")),
            const SizedBox(height: 12),
            TextButton.icon(onPressed: _cycle, icon: const Icon(Icons.palette_outlined), label: const Text("ប្ដូរពណ៌")),
          ],
        ),
      ),
    );
  }
}

// * ចំណុចចូលកម្មវិធីសម្រាប់សាកល្បង snackbar
void main() {
  runApp(const MaterialApp(home: SnackbarTester(), debugShowCheckedModeBanner: false));
}
