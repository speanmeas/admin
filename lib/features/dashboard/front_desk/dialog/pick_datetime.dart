import "package:flutter/material.dart";
import "package:pluto_grid/pluto_grid.dart";
import "package:speanmeas/core/utility/all.dart";
import "package:speanmeas/core/widget/dialog/dialog_datetime.dart";

// * បង្ហាញ dialog ជ្រើសរើសពេលចូល/ចេញ ហើយអាប់ដេត row stay តាម endpoint
Future<bool?> dialog_pick_datetime({
  required BuildContext context, //
  required PlutoColumnRendererContext rc, //
  required bool is_check_in, //
}) async {
  final String? fd_id = rc.row.cells["_id"]?.value;
  if (fd_id == null) return false;

  DateTime? current = parse_datetime(rc.cell.value) ?? DateTime.now();

  final DateTime? picked_datetime = await dialog_datetime(context, initial: current);
  if (picked_datetime == null || !context.mounted) return false;

  String key = is_check_in ? Front_Desk.CHECK_IN_AT : Front_Desk.CHECK_OUT_AT;
  dynamic tmp = await dio.post(
    endpoint.FRONT_DESK_UPDATE,
    data: {
      Front_Desk.ID: fd_id, //
      key: format_datetime(picked_datetime), //
    },
  );
  if (tmp == null) {
    snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    return false;
  }

  snackbar(ct: context, ms: "Updated", cl: Colors.green);
  return true;
}
