import "package:flutter/material.dart";
import "package:speanmeas/core/utility/all.dart";
import "confirm_dialog.dart";

Future<bool?> dialog_add_mini_bar({
  required BuildContext context,
}) async {
  return dialog_confirm(
    context: context,
    title: "Add Mini Bar",
    message: "Please confirm to add walk-in mini bar.",
    confirm_color: Colors.green,
    on_confirm: () async {
      final res = await dio.post(endpoint.FRONT_DESK_WALK_IN);
      if (res == null) {
        snackbar(ct: context, ms: dio.error_msg ?? "Failed to add walk-in mini bar", cl: Colors.red);
        return false;
      }
      snackbar(ct: context, ms: "Mini Bar Added", cl: Colors.green);
      return true;
    },
  );
}