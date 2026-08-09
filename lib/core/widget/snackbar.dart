import "package:flutter/material.dart";

void snackbar({
  required BuildContext ct, //
  required String ms, //
  required Color cl, //
}) {
  ScaffoldMessenger.of(ct)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
        duration: Duration(seconds: 5),
        content: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                ms, //
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18, //
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: cl,
        behavior: SnackBarBehavior.floating,
      ),
    );
}
