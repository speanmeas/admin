import "package:flutter/material.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import

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
                  fontSize: 16, //
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
