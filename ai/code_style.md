# Spean Meas Admin — Flutter Code Style Guide

## 1. Project Overview

- **Package name:** `speanmeas`
- **Description:** Hotel Management System
- **State management:** `provider` (ChangeNotifier singleton pattern)
- **HTTP client:** `dio` (POST-only API)
- **Data grid:** `pluto_grid`
- **Secure storage:** `flutter_secure_storage`
- **Schema:** Hand-written `Map<String, Map<String, dynamic>>` (no code generation)
- **Target:** Web/Desktop-first, mobile responsive at 1000px breakpoint

---

## 2. Naming Conventions

| Element                    | Style                                | Examples                                                       |
| -------------------------- | ------------------------------------ | -------------------------------------------------------------- |
| Source files               | `snake_case`                         | `__config__.dart`, `snackbar_show.dart`, `panel_top.dart`      |
| Config/variable files      | `__name__.dart` (double underscores) | `__config__.dart`, `__variable__.dart`                         |
| Classes                    | `PascalCase`                         | `Main`, `Global`, `Setting`, `_Main_State`                     |
| Widget classes             | `PascalCase` + trailing `_`          | `Main_`, `Datetime_Picker_`                                    |
| Private state classes      | `_$PascalCase`                       | `_Main_State`, `_Datetime_Picker_State`                        |
| Variables & functions      | `snake_case`                         | `row_total`, `is_loading`, `on_create()`, `load_page()`        |
| Constants (module-level)   | `SCREAMING_SNAKE_CASE`               | `TITLE`, `API_HOST`, `HEADER`, `PATH`, `LIMIT`, `KEY`, `ORDER` |
| Schema field key constants | `SCREAMING_SNAKE_CASE`               | `ID`, `FULL_NAME`, `PHONE_NUMBER`, `IS_ADMIN`                  |
| Parameters                 | `snake_case`                         | `initial_datetime`, `max_lines`                                |

---

## 3. String Quotes

Double quotes `"` are used **exclusively**. No single quotes anywhere in the project.

```dart
String TITLE = "Spean Meas";
return Text("Hello");
```

---

## 4. Import Ordering

Four groups, separated by blank lines:

```dart
import "package:flutter/material.dart";               // Group 1: Flutter/Dart SDK
import "package:dio/dio.dart";                         // Group 2: Third-party packages
import "package:speanmeas/utility/dio.dart";           // Group 3: Project imports
import "__config__.dart";                              // Group 4: Local relative imports
```

Within groups, loosely alphabetical. Dart SDK `dart:` imports come first. Relative imports use `../` or `../../` as needed. Use `as` aliases for disambiguation:

```dart
import "schema.g.dart" as schema;
import "form/create.dart" as create;
```

---

## 5. Trailing Commas

Use trailing commas extensively to trigger Dart auto-formatting. Append `//` after the last argument when the formatter might otherwise remove the trailing comma:

```dart
return Container(
  width: 600,
  margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
  child: TextField(
    decoration: InputDecoration(
      labelText: e.value["title"], //
    ),
  ),
);
```

---

## 6. Comment Style

- **`//` line separators** — blank `//` lines between logical blocks inside methods
- **`//` trailing-comma-forcers** — `, //` after last argument to keep trailing comma
- **`// *` bullet markers** — for section descriptions in Khmer: `// * លុប sort + filter`
- **`// todo:`** — for incomplete features
- **Khmer language** — comments for field types: `// * អក្សរ` (text), `// * លេខ` (number)

---

## 7. Widget Structure

### Page pattern (in every file)

```dart
class _Main_State extends State<Main_> {
  @override
  void initState() { super.initState(); init(); }

  void init() async {
    // initialization
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Title", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,
      ),
      body: ...,
    );
  }
}

class Main_ extends StatefulWidget {
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}
```

**Rule:** Every exported widget class is named `Main_` (trailing underscore). `StatefulWidget` is the default; `StatelessWidget` is rare.

---

## 8. State Management

### Singleton + ChangeNotifier + Provider

```dart
class Global extends ChangeNotifier {
  static final Global instance = Global._();
  Global._();

  String body = "Front Desk";

  void clear() {
    body = "Database - Nationality";
    notifyListeners();
  }
}

Global global = Global.instance;
```

Injection in `main.dart`:

```dart
runApp(ChangeNotifierProvider(create: (_) => global, child: const Main()));
```

Read state: `context.watch<Global>()`. Local UI state: `setState(() {});`

---

## 9. Schema Pattern

File: `schema.g.dart`

```dart
Map<String, Map<String, dynamic>> data = {
  "_id":     {"type": "id",        "title": "ID",   "hide": true,  "lock": false, "value": null},
  "name":    {"type": "string",    "title": "Name",  "hide": false, "lock": false, "value": null},
  "price":   {"type": "number",    "title": "Price", "hide": false, "lock": false, "value": null},
  // ...
};

final ID = "_id";
final NAME = "name";

void clear() { for (var k in data.keys) data[k]!["value"] = null; }
```

**Field types:** `"id"`, `"string"`, `"number"`, `"date-time"`, `"boolean"`

---

## 10. CRUD Page Structure

```
page/{entity}/
  __config__.dart        — Config: HEADER, PATH, DATE_FORMAT, LIMIT, KEY, ORDER
  schema.g.dart          — Schema definition
  main.dart              — PlutoGrid data grid + pagination + CRUD buttons
  form/
    create.dart          — Dynamic form from schema
    read.dart            — Read-only display
    update.dart          — Pre-populated form
    delete.dart          — Confirmation screen
  widget/
    {entity}_search.dart — Search widget for FK lookups
```

### `__config__.dart` format:

```dart
String HEADER = "Guest";
String get PATH => "/${HEADER.toLowerCase().replaceAll(" ", "_")}";
String DATE_FORMAT = "yyyy-MM-dd HH:mm";
int LIMIT = 1000;
String KEY = "created_at";
int ORDER = -1;
```

---

## 11. API Call Pattern

### Shared Dio instance

```dart
// lib/utility/dio.dart
Dio dio = Dio(BaseOptions(baseUrl: API_HOST));
```

### Request format

All calls use `dio.post()` with `FormData.fromMap()`:

```dart
final r = await dio.post("$PATH/read", data: FormData.fromMap({
  "key": KEY, "order": ORDER, "offset": (p - 1) * LIMIT, "limit": LIMIT,
}));
```

### Endpoints

```
$PATH/read         — List with pagination
$PATH/read_count   — Total rows
$PATH/read_id      — By ID
$PATH/create       — Create
$PATH/update       — Update
$PATH/update_field — Single field update
$PATH/delete       — Delete
/auth/sign_in      — Login
/auth/access_token — Token validation
```

---

## 12. Error Handling

```dart
void on_create() async {
  try {
    //
    // ... logic ...
    //
    Navigator.pop(context, r.data);
    snackbar_show(context: context, message: "Success", color: Colors.green);
    //
  } catch (e) {
    snackbar_show(context: context, message: e.toString(), color: Colors.red);
  }
}
```

---

## 13. Form Handling

- Dynamic field rendering by iterating `schema.data.entries`
- Fields rendered by type: string (TextField), number (TextField + numeric filter), date-time (read-only + picker), boolean (TypeAhead Yes/No)
- IIFE pattern `(() { return Container(...); })()` inside Column children
- TextFields use `onSubmitted` to trigger primary action
- Strings stored as `" "` (space) when empty after `v.trim()`
- `FilteringTextInputFormatter.allow(RegExp("[0-9.]"))` for numbers

---

## 14. Reusable Widgets

| File                              | Purpose                                                            |
| --------------------------------- | ------------------------------------------------------------------ |
| `lib/widget/snackbar_show.dart`   | Global snackbar: `snackbar_show(context:, message:, color:)`       |
| `lib/widget/datetime_picker.dart` | Date + Time picker: `datetime_picker(context:, initial_datetime:)` |
| `lib/widget/show_data.dart`       | Label-value display: `show_data.Main_(title:, value:, max_lines:)` |

---

## 15. Per-file `main()`

Every widget file includes a standalone `main()` for isolated development:

```dart
void main() {
  runApp(MaterialApp(
    title: HEADER,
    theme: Theme_Data(),
    home: const Main_(),
    debugShowCheckedModeBanner: false,
  ));
}
```

---

## 16. Layout Architecture

- `layout.dart` — App shell: AppBar, sidebar (250px), body, mobile Drawer
- `panel_top.dart` — Top bar: logo, page title + version, notification badge, user avatar
- `panel_left.dart` — Navigation sidebar with `ExpansionTile` groups + `list_tile_l1`/`list_tile_l2` helpers
- `panel_body.dart` — Body router via string-matching `global.body` + `IndexedStack`
- `notification.dart` — Placeholder

---

## 17. Theme

```dart
ThemeData Theme_Data() {
  return ThemeData(
    fontFamily: "NotoSansKhmer",
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
    // ...
  );
}
```

**Key choices:** Square corners (borderRadius: 0), bold 20px AppBar titles, Material 3, blue seed color.

---

## 18. Security

- Token stored in `FlutterSecureStorage` keyed by `"access_token"`
- Passwords masked in data grid as `"**********"`
- No encryption/CSRF beyond HTTPS (handled by Cloudflare)

---

## 19. Linting

`analysis_options.yaml` intentionally ignores:

- `avoid_print`, `camel_case_types`, `constant_identifier_names`
- `curly_braces_in_flow_control_structures`, `non_constant_identifier_names`
- `prefer_const_constructors_in_immutables`, `sort_child_properties_last`
- `sized_box_for_whitespace`, `unused_element`

This is deliberate to support the project's naming conventions (snake*case constants, `Main*` widget names).

---

## Summary of Distinctive Conventions

| Convention        | Choice                                                              |
| ----------------- | ------------------------------------------------------------------- |
| Quotes            | Double `"` only                                                     |
| Widget class name | `Main_` (trailing `_`)                                              |
| State management  | Singleton + ChangeNotifier + Provider                               |
| API method        | POST only                                                           |
| API payload       | `FormData.fromMap()`                                                |
| Schema            | Hand-written `Map<String, Map<String, dynamic>>` in `schema.g.dart` |
| Routing           | String-based with `IndexedStack`                                    |
| Forms             | Dynamic iteration over schema entries                               |
| Pagination        | Custom with page selector dialog                                    |
| Error handling    | try/catch + snackbar                                                |
| Comments          | `//` line separators, `//` trailing-comma-forcers                   |
| Linting           | Selective ignores for naming flexibility                            |
| Borders           | Square (radius: 0)                                                  |
| Language          | UI/comments in Khmer and English                                    |
| Per-file main()   | Every widget runnable standalone                                    |
