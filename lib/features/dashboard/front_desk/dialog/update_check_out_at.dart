import "package:flutter/material.dart";
import "package:speanmeas/core/utility/all.dart";
import "package:speanmeas/core/widget/dialog/dialog_datetime.dart";

// * បង្ហាញ dialog ជ្រើសរើសពេលចេញ ហើយអាប់ដេត row stay តាម endpoint
Future<bool?> dialog_update_check_out_at({
  required BuildContext context, //
  required String fd_id, //
}) async {
  final DateTime? picked_datetime = await dialog_datetime(context);
  if (picked_datetime == null || !context.mounted) return false;

  dynamic tmp = await dio.post(
    endpoint.FRONT_DESK_UPDATE,
    data: {
      Front_Desk.ID: fd_id, //
      Front_Desk.CHECK_OUT_AT: format_datetime(picked_datetime),
    },
  );
  if (tmp == null) {
    snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    return false;
  }

  snackbar(ct: context, ms: "Updated", cl: Colors.green);
  return true;
}