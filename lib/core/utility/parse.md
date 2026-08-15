# Safe Parse Utility — `parse.dart`

Utility for safely converting values read from `Map`/`dynamic` (e.g. API responses) into typed values, without crashing the app.

**File:** `lib/core/utility/parse.dart`

## Design Principles

- **Null-safe** — every function handles `null` input without throwing.
- **Web-safe** — numeric and date parsers wrap `tryParse` in `try/catch`, protecting against the DDC `FormatException` crash on Flutter web.
- **Nullable returns** — every parser returns `null` when the value is missing or cannot be converted. Callers decide the fallback at the call site (`?? ""`, `?? 0`, `?? false`).
- **Type-aware fast paths** — `if (v is int) return v;` avoids unnecessary string round-trips and preserves precision.

## Import

```dart
import "package:speanmeas/core/utility/parse.dart";
```

## Functions

### `String? parse_string(dynamic v)`

Converts any value to its string representation.

| Input   | Result   |
| ------- | -------- |
| `null`  | `null`   |
| `"abc"` | `"abc"`  |
| `123`   | `"123"`  |
| `true`  | `"true"` |

```dart
final name = parse_string(m["name"]) ?? "";
```

### `int? parse_int(dynamic v)`

Converts to an integer.

| Input       | Result          |
| ----------- | --------------- |
| `null`      | `null`          |
| `5` (int)   | `5`             |
| `5.9` (num) | `5` (truncated) |
| `"42"`      | `42`            |
| `"abc"`     | `null`          |

```dart
final count = parse_int(m["count"]) ?? 0;
```

### `double? parse_double(dynamic v)`

Converts to a double.

| Input           | Result |
| --------------- | ------ |
| `null`          | `null` |
| `3.14` (double) | `3.14` |
| `2` (int)       | `2.0`  |
| `"9.99"`        | `9.99` |
| `"abc"`         | `null` |

```dart
final price = parse_double(m["price"]) ?? 0;
```

### `num? parse_num(dynamic v)`

Converts to a `num` (int or double).

| Input   | Result |
| ------- | ------ |
| `null`  | `null` |
| `7`     | `7`    |
| `7.5`   | `7.5`  |
| `"7.5"` | `7.5`  |
| `"abc"` | `null` |

```dart
final amount = parse_num(m["amount"]) ?? 0;
```

### `bool? parse_bool(dynamic v)`

Converts to a boolean. Accepts `bool`, numbers, and common string forms. Returns `null` for unknown values (distinguishes "unknown" from `false`).

| Input                | Result           |
| -------------------- | ---------------- |
| `null`               | `null`           |
| `true` / `false`     | `true` / `false` |
| `1` / `0`            | `true` / `false` |
| `"true"` / `"false"` | `true` / `false` |
| `"1"` / `"0"`        | `true` / `false` |
| `"yes"` / `"no"`     | `true` / `false` |
| `"maybe"`            | `null`           |

```dart
final flag = parse_bool(m["flag"]) ?? false;
```

### `DateTime? parse_datetime(dynamic v)`

Converts to a `DateTime`. Web-safe (wraps `tryParse` in `try/catch`).

| Input                   | Result            |
| ----------------------- | ----------------- |
| `null`                  | `null`            |
| `DateTime`              | same instance     |
| `"2026-08-15T10:00:00"` | parsed `DateTime` |
| invalid string          | `null`            |

```dart
final dt = parse_datetime(m["created_at"]);
if (dt != null) {
  final date = DateFormat("yyyy-MM-dd").format(dt.toLocal());
}
```

### `List<dynamic>? parse_list(dynamic v)`

Returns the value as a `List`, or `null` if it is not a list.

```dart
for (var item in (parse_list(m["items"]) ?? const [])) {
  // ...
}
```

### `Map<String, dynamic>? parse_map(dynamic v)`

Returns the value as a `Map<String, dynamic>`, or `null` if it is not a map.

```dart
final guest = parse_map(m["guest"]);
final name = guest?["name"] ?? "";
```

### `dynamic parse_nested(dynamic root, List<String> keys)`

Safely reads a nested value from a map, guarding each level. Returns `null` if any intermediate level is missing or not a map.

```dart
final name = parse_string(parse_nested(m, ["guest", "name"])) ?? "";
```

## Usage Patterns

### Reading from an API row

```dart
final name = parse_string(row[sm_demo_1.TEXT_1]) ?? "";
final price = parse_double(row[sm_demo_1.NUMBER_1]) ?? 0;
final flag = parse_bool(row[sm_demo_1.LOGIC_1]) ?? false;
final dt = parse_datetime(row[sm_demo_1.DATETIME_1]);
```

### Iterating a nullable sub-list

```dart
for (var l in (parse_list(x["pay_room"]) ?? const [])) {
  // ...
}
```

### Nested map access

```dart
final guestName = parse_string(parse_nested(m, ["guest", "name"])) ?? "";
```

## Notes

- `parse_string` on a `Map`/`List` returns Dart's debug representation (e.g. `{a: 1}`), not JSON. Use `jsonEncode` if JSON is needed.
- `parse_bool` returns `null` (not `false`) for unrecognized values — intentional, to distinguish "unknown" from "false".
- `parse_map`/`parse_list` return `null` (not `{}`/`[]`) — always combine with `?? const {}` / `?? const []` before use.
