import "package:flutter/material.dart";
import "package:speanmeas/core/utility/all.dart";
import "confirm_dialog.dart";

Future<bool?> dialog_carry_over({
  required BuildContext context, //
  required String lead,
  required String front_desk_id,
}) async {
  return dialog_confirm(
    context: context, //
    title: lead,
    message: "Please confirm the carry over.",
    confirm_color: Colors.green,
    on_confirm: () async {
      final res = await dio.post(
        endpoint.FRONT_DESK_CARRY_OVER_ONE,
        data: {Front_Desk.ID: front_desk_id},
      );
      if (res == null) {
        snackbar(ct: context, ms: dio.error_msg ?? "Carry over failed", cl: Colors.red);
        return false;
      }
      snackbar(ct: context, ms: "Carried Over", cl: Colors.green);
      return true;
    },
  );
}

