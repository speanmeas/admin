import "package:flutter/material.dart";

void snackbar_show({
  required BuildContext context, //
  required String message, //
  required Color color, //
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
        duration: const Duration(seconds: 5),
        content: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
}
