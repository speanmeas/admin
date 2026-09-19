import "package:pluto_grid/pluto_grid.dart";
import "package:speanmeas/core/utility/all.dart";

/// Converts a guest value (Guest_Show, Map, or String) to a display label.
String format_guest_label(dynamic g) {
  if (g == null) return "";
  if (g is Guest_Show) {
    return "${g.full_name ?? "N/A"} (${g.phone_number ?? "N/A"})";
  }
  if (g is Map) {
    return "${g[Guest.FULL_NAME] ?? "N/A"} (${g[Guest.PHONE_NUMBER] ?? "N/A"})";
  }
  return format_string(g);
}

/// Converts a user value (User_Show or String) to a display name.
String format_user_label(dynamic u) {
  if (u == null) return "";
  if (u is User_Show) return u.full_name ?? "";
  if (u is Map) return (u[User.FULL_NAME] ?? "").toString();
  return format_string(u);
}

/// Converts a Front_Desk entity to a PlutoRow for grid display.
PlutoRow build_front_desk_row(Front_Desk d, int index, List<PlutoColumn> columns) {
  return PlutoRow(
    cells: {
      for (var c in columns)
        c.field: (() {
          switch (c.field) {
            case "index":
              return PlutoCell(value: index);
            case Front_Desk.ID:
              return PlutoCell(value: d.id ?? "");
            case Front_Desk.ROOM_NUMBER:
              return PlutoCell(value: d.room_number ?? "");
            case Front_Desk.CHECK_IN_AT:
              return PlutoCell(value: format_datetime(d.check_in_at));
            case Front_Desk.CHECK_OUT_AT:
              return PlutoCell(value: format_datetime(d.check_out_at));
            case Front_Desk.GUEST_ID:
              return PlutoCell(value: format_guest_label(d.guest_id));
            case Front_Desk.NUMBER_OF_GUEST:
              return PlutoCell(value: d.number_of_guest ?? 0);
            case Front_Desk.ROOM_PRICE:
              return PlutoCell(value: d.room_price ?? 0.0);
            case Front_Desk.MINI_BAR_PRICE:
              return PlutoCell(value: d.mini_bar_price ?? 0.0);
            case Front_Desk.PENALTY_PRICE:
              return PlutoCell(value: d.penalty_price ?? 0.0);
            case Front_Desk.PAY_CASH:
              return PlutoCell(value: d.pay_cash ?? 0.0);
            case Front_Desk.PAY_BANK:
              return PlutoCell(value: d.pay_bank ?? 0.0);
            case Front_Desk.PAY_BALANCE:
              return PlutoCell(value: d.pay_balance ?? 0.0);
            case Front_Desk.PAY_NOTE:
              return PlutoCell(value: d.pay_note ?? "");
            case Front_Desk.CHECK_IN_BY:
              return PlutoCell(value: format_user_label(d.check_in_by));
            case Front_Desk.CHECK_OUT_BY:
              return PlutoCell(value: format_user_label(d.check_out_by));
            case Front_Desk.SHIFT_DATE:
              return PlutoCell(value: format_datetime(d.shift_date));
            default:
              return PlutoCell(value: "");
          }
        })(),
    },
  );
}
