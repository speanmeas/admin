// នាំចូល Flutter material សម្រាប់ UI components
import "package:flutter/material.dart";
import "dart:math" as math; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import

// បង្ហាញ snackbar ជូនដំណឹងដល់អ្នកប្រើប្រាស់
void snackbar({
  required BuildContext ct, //
  required String ms, //
  required Color cl, //
}) {
  final screenWidth = MediaQuery.sizeOf(ct).width;
  final screenHeight = MediaQuery.sizeOf(ct).height;
  const snackbarWidth = 400.0;
  const topMargin = 4.0;
  const snackbarHeight = 36.0;
  final horizontalMargin = math.max(0.0, (screenWidth - snackbarWidth) / 2);
  final bottomMargin = math.max(0.0, screenHeight - topMargin - snackbarHeight);

  ScaffoldMessenger.of(ct)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(left: horizontalMargin, right: horizontalMargin, bottom: bottomMargin),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        duration: const Duration(seconds: 5),
        content: Row(
          children: [
            // រូបតំណាងព័ត៌មាន
            const Icon(Icons.info_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            // អត្ថបទសារ
            Expanded(
              child: Text(
                ms, //
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14, //
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        // backgroundColor: Colors.transparent,
        backgroundColor: cl,

        elevation: 2, //

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: BorderSide(color: cl),
        ),

        behavior: SnackBarBehavior.floating,
      ),
      snackBarAnimationStyle: const AnimationStyle(duration: Duration(milliseconds: 150), reverseDuration: Duration(milliseconds: 80)),
    );
}

// Widget សម្រាប់សាកល្បង snackbar
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

// ចំណុចចូលកម្មវិធីសម្រាប់សាកល្បង snackbar
void main() {
  runApp(const MaterialApp(home: SnackbarTester(), debugShowCheckedModeBanner: false));
}
