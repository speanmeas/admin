import "package:flutter/material.dart";
import "package:speanmeas/core/utility/all.dart";
import "confirm_dialog.dart";

Future<bool?> dialog_check_out({
  required BuildContext context,
  required String lead,
  required String room_number,
}) async {
  return dialog_confirm(
    context: context,
    title: lead,
    message: "Please confirm the check-out.",
    confirm_color: Colors.red,
    on_confirm: () async {
      final res = await dio.post(
        endpoint.FRONT_DESK_CHECK_OUT,
        data: {Front_Desk.ROOM_NUMBER: room_number},
      );
      if (res == null) {
        snackbar(ct: context, ms: dio.error_msg ?? "Check-out failed", cl: Colors.red);
        return false;
      }
      snackbar(ct: context, ms: "Success", cl: Colors.green);
      return true;
    },
  );
}