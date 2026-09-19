import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:pluto_grid/pluto_grid.dart";
import "package:speanmeas/core/utility/all.dart";

/// Generates PlutoColumn definitions for Front Desk grid.
List<PlutoColumn> build_front_desk_columns({
  required BuildContext context,
  required bool Function(PlutoRow row) is_walk_in_row,
  required void Function(PlutoColumnRendererContext rc) on_update_room,
  required void Function(PlutoColumnRendererContext rc) on_search_guest,
  required void Function(PlutoColumnRendererContext rc) on_add_guest,
  required void Function(PlutoColumnRendererContext rc) on_update_guest,
  required void Function(PlutoColumnRendererContext rc, double value) on_update_number_of_guest,
  required void Function(PlutoColumnRendererContext rc) on_update_check_in_at,
  required void Function(PlutoColumnRendererContext rc) on_update_check_out_at,
  required void Function(PlutoColumnRendererContext rc) on_update_carry_over,
  required void Function(PlutoColumnRendererContext rc) on_mini_bar_item,
  required void Function(PlutoColumnRendererContext rc) on_penalty_item,
  required void Function(PlutoColumnRendererContext rc) on_update_shift_date,
  required void Function(PlutoColumnRendererContext rc) on_print_receipt,
}) {
  bool is_row_mini_bar(PlutoColumnRendererContext rc) => is_walk_in_row(rc.row);

  Widget money_cell(PlutoColumnRendererContext rc) {
    if (is_row_mini_bar(rc)) {
      return const Align(
        alignment: Alignment.center,
        child: Text("-", style: TextStyle(color: Colors.grey)),
      );
    }
    return Align(
      alignment: Alignment.center,
      child: Text(
        "${format_double(parse_double(rc.cell.value) ?? 0, digits: 2)} \$",
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget cash_bank_cell(PlutoColumnRendererContext rc) {
    double v = parse_double(rc.cell.value) ?? 0;
    return Align(
      alignment: Alignment.center,
      child: Text(
        "${format_double(v, digits: 2)} \$",
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: v >= 0 ? Colors.black : Colors.red),
      ),
    );
  }

  Widget balance_cell(PlutoColumnRendererContext rc) {
    double v = parse_double(rc.cell.value) ?? 0;
    return Align(
      alignment: Alignment.center,
      child: Text(
        "${format_double(v, digits: 2)} \$",
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: v == 0 ? Colors.black : (v > 0 ? Colors.green : Colors.red)),
      ),
    );
  }

  Widget sum_footer(PlutoColumnFooterRendererContext rc) {
    return PlutoAggregateColumnFooter(
      rendererContext: rc,
      format: "#,##0.00",
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      type: PlutoAggregateColumnType.sum,
      titleSpanBuilder: (value) => [
        WidgetSpan(
          child: Text(
            "$value \$",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
    );
  }

  return [
    PlutoColumn(
      field: Front_Desk.ID,
      title: "ID",
      type: PlutoColumnType.text(),
      enableEditingMode: false,
      width: 0,
    ),

    PlutoColumn(
      field: "index",
      title: "ល.រ.",
      type: PlutoColumnType.number(),
      enableEditingMode: false,
      enableRowDrag: true,
      width: 60,
      renderer: (rc) => Align(
        alignment: Alignment.center,
        child: Text(format_string(rc.cell.value), overflow: TextOverflow.ellipsis),
      ),
      footerRenderer: (rc) => PlutoAggregateColumnFooter(
        rendererContext: rc,
        format: "#,##0.00",
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        type: PlutoAggregateColumnType.count,
        titleSpanBuilder: (value) => [
          const WidgetSpan(
            child: Text("Sum: ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),
          ),
        ],
      ),
    ),

    PlutoColumn(
      field: Front_Desk.ROOM_NUMBER,
      title: "បន្ទប់",
      type: PlutoColumnType.text(),
      width: 80,
      renderer: (rc) {
        final is_walk_in = is_row_mini_bar(rc);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(format_string(rc.cell.value), overflow: TextOverflow.ellipsis),
              ),
            ),
            if (!is_walk_in)
              IconButton(
                tooltip: "ផ្លាស់ប្តូរបន្ទប់",
                icon: const Icon(Icons.swap_horiz_outlined),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => on_update_room(rc),
              ),
          ],
        );
      },
    ),

    PlutoColumn(
      field: Front_Desk.GUEST_ID,
      title: "ឈ្មោះ (លេខទូរស័ព្ទ)",
      type: PlutoColumnType.text(),
      enableEditingMode: false,
      width: 200,
      renderer: (rc) {
        final val = rc.cell.value;
        final has_guest = val != null && (val is! String || val.isNotEmpty);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              tooltip: "Search Guest",
              icon: const Icon(Icons.search_outlined),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => on_search_guest(rc),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(format_string(rc.cell.value), overflow: TextOverflow.ellipsis),
              ),
            ),
            if (!has_guest)
              IconButton(
                tooltip: "Add Guest",
                icon: const Icon(Icons.person_add_outlined),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => on_add_guest(rc),
              ),
            if (has_guest)
              IconButton(
                tooltip: "Update Guest",
                icon: const Icon(Icons.edit_outlined),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => on_update_guest(rc),
              ),
          ],
        );
      },
    ),

    PlutoColumn(
      field: Front_Desk.NUMBER_OF_GUEST,
      title: "ចំនួន",
      type: PlutoColumnType.number(),
      width: 70,
      renderer: (rc) {
        if (is_row_mini_bar(rc)) return const SizedBox();
        double value = parse_double(rc.cell.value) ?? 0.0;
        return Row(
          children: [
            Expanded(
              child: Text(
                value == 0 ? "" : "${value.toInt()} នាក់",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            PopupMenuButton<double>(
              menuPadding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              itemBuilder: (context) => [
                for (double o in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]) ...[
                  PopupMenuItem(value: o, child: Text("${o.toInt()} នាក់", style: const TextStyle(fontSize: 14))),
                  const PopupMenuDivider(height: 0),
                ],
              ],
              onSelected: (v) => on_update_number_of_guest(rc, v),
              child: const Icon(Icons.arrow_drop_down, color: Colors.blue),
            ),
          ],
        );
      },
    ),

    PlutoColumn(
      field: Front_Desk.CHECK_IN_AT,
      title: "ពេលចូល",
      type: PlutoColumnType.text(),
      width: 160,
      renderer: (rc) {
        final is_walk_in = is_row_mini_bar(rc);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!is_walk_in)
              IconButton(
                tooltip: "កែពេលចូល",
                icon: const Icon(Icons.calendar_month_outlined),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => on_update_check_in_at(rc),
              ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(format_datetime(rc.cell.value), overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        );
      },
    ),

    PlutoColumn(
      field: Front_Desk.CHECK_OUT_AT,
      title: "ពេលចេញ",
      type: PlutoColumnType.text(),
      width: 160,
      renderer: (rc) {
        if (is_row_mini_bar(rc)) return const SizedBox();
        final has_checkout = rc.cell.value != null && rc.cell.value != "";
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              tooltip: "កែពេលចេញ",
              icon: const Icon(Icons.calendar_month_outlined),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => on_update_check_out_at(rc),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(format_datetime(rc.cell.value), overflow: TextOverflow.ellipsis),
              ),
            ),
            if (!has_checkout)
              IconButton(
                tooltip: "ស្នាក់នៅបន្ត",
                icon: const Icon(Icons.navigate_next_outlined),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => on_update_carry_over(rc),
              ),
          ],
        );
      },
    ),

    PlutoColumn(
      field: Front_Desk.ROOM_PRICE,
      title: "ថ្លៃបន្ទប់",
      type: PlutoColumnType.number(negative: false, format: "#,##0.00"),
      enableEditingMode: true,
      checkReadOnly: (row, cell) => is_walk_in_row(row),
      width: 90,
      renderer: money_cell,
      footerRenderer: sum_footer,
    ),

    PlutoColumn(
      field: Front_Desk.MINI_BAR_PRICE,
      title: "ថ្លៃមីនីបារ",
      type: PlutoColumnType.number(negative: false, format: "#,##0.00"),
      enableEditingMode: false,
      width: 90,
      renderer: (rc) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            tooltip: "Mini Bar Items",
            icon: const Icon(Icons.local_bar_outlined),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => on_mini_bar_item(rc),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "${format_double(parse_double(rc.cell.value) ?? 0, digits: 2)} \$",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
      footerRenderer: sum_footer,
    ),

    PlutoColumn(
      field: Front_Desk.PENALTY_PRICE,
      title: "ថ្លៃពិន័យ",
      type: PlutoColumnType.number(negative: false, format: "#,##0.00"),
      enableEditingMode: false,
      width: 90,
      renderer: (rc) {
        if (is_row_mini_bar(rc)) {
          return const Align(alignment: Alignment.center, child: Text("-", style: TextStyle(color: Colors.grey)));
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              tooltip: "Penalty Items",
              icon: const Icon(Icons.gavel_outlined),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => on_penalty_item(rc),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "${format_double(parse_double(rc.cell.value) ?? 0, digits: 2)} \$",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        );
      },
      footerRenderer: sum_footer,
    ),

    PlutoColumn(
      field: Front_Desk.PAY_CASH,
      title: "លុយ",
      type: PlutoColumnType.number(negative: true, format: "#,##0.00"),
      enableEditingMode: true,
      width: 90,
      renderer: cash_bank_cell,
      footerRenderer: sum_footer,
    ),

    PlutoColumn(
      field: Front_Desk.PAY_BANK,
      title: "ធនាគារ",
      type: PlutoColumnType.number(negative: true, format: "#,##0.00"),
      enableEditingMode: true,
      width: 90,
      renderer: cash_bank_cell,
      footerRenderer: sum_footer,
    ),

    PlutoColumn(
      field: Front_Desk.PAY_BALANCE,
      title: "សមតុល្យ",
      type: PlutoColumnType.number(negative: true, format: "#,##0.00"),
      enableEditingMode: true,
      checkReadOnly: (row, cell) => is_walk_in_row(row),
      width: 90,
      renderer: balance_cell,
      footerRenderer: sum_footer,
    ),

    PlutoColumn(
      field: Front_Desk.PAY_NOTE,
      title: "ចំណាំ",
      type: PlutoColumnType.text(),
      enableEditingMode: true,
      width: 120,
      renderer: (rc) => Align(
        alignment: Alignment.center,
        child: Text(format_string(rc.cell.value), overflow: TextOverflow.ellipsis),
      ),
    ),

    if (kDebugMode)
      PlutoColumn(
        field: Front_Desk.SHIFT_DATE,
        title: "របាយការណ៍ថ្ងៃ",
        type: PlutoColumnType.text(),
        enableEditingMode: false,
        width: 120,
        renderer: (rc) {
          final is_walk_in = is_row_mini_bar(rc);
          final v = parse_datetime(rc.cell.value);
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!is_walk_in)
                IconButton(
                  tooltip: "កែថ្ងៃ",
                  icon: const Icon(Icons.calendar_month_outlined),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => on_update_shift_date(rc),
                ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    v == null ? "" : DateFormat("yyyy-MM-dd").format(v),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          );
        },
      ),

    PlutoColumn(
      field: "other",
      title: "ផ្សេងៗ",
      type: PlutoColumnType.text(),
      enableEditingMode: false,
      enableColumnDrag: false,
      enableContextMenu: false,
      enableDropToResize: false,
      enableFilterMenuItem: false,
      enableSorting: false,
      width: 40,
      cellPadding: EdgeInsets.zero,
      renderer: (rc) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            tooltip: "Print Receipt",
            icon: const Icon(Icons.print_outlined),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => on_print_receipt(rc),
          ),
        ],
      ),
    ),
  ];
}
