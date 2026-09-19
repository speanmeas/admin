import "package:flutter/material.dart";
import "package:flutter/services.dart";

/// Reusable confirmation dialog for front desk actions (Check-in, Check-out, Clean, Mini Bar, etc.)
Future<bool?> dialog_confirm({
  required BuildContext context,
  required String title,
  required String message,
  required Future<bool> Function() on_confirm,
  String confirm_text = "OK",
  String cancel_text = "Cancel",
  Color confirm_color = Colors.blue,
}) async {
  bool is_loading = false;

  return await showDialog<bool>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> submit() async {
            setState(() => is_loading = true);
            try {
              final ok = await on_confirm();
              if (ok && context.mounted) {
                Navigator.pop(context, true);
              }
            } finally {
              if (context.mounted) {
                setState(() => is_loading = false);
              }
            }
          }

          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            alignment: Alignment.topCenter,
            titlePadding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
            contentPadding: const EdgeInsets.all(4),
            actionsPadding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
            actionsAlignment: MainAxisAlignment.end,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            content: Focus(
              autofocus: true,
              onKeyEvent: (node, event) {
                if (is_loading) return KeyEventResult.ignored;
                if (event is KeyDownEvent &&
                    (event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.numpadEnter)) {
                  submit();
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: SizedBox(
                width: 400,
                child: Column(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(height: 1, color: Colors.grey),
                    Text(message, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            actions: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onPressed: is_loading ? null : () => Navigator.pop(context, false),
                child: Text(cancel_text),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: confirm_color,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onPressed: is_loading ? null : submit,
                child: is_loading
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(confirm_text),
              ),
            ],
          );
        },
      );
    },
  );
}
