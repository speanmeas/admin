# Hive Utility — Usage Guide

A lightweight wrapper around [Hive](https://pub.dev/packages/hive) for easy local key-value storage.

**File:** `lib/core/utility/hive.dart`

---

## 1. Setup (one time)

Call `hive.init()` **once** in `main()` before `runApp()`.

```dart
import "package:speanmeas/core/utility/hive.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await hive.init(); // <-- required once
  runApp(const MyApp());
}
```

> `hive.init()` stores Hive data in the app's **documents directory** (via `path_provider`).

---

## 2. Getting a box

```dart
// Opens the box automatically (reuses it if already open)
final box = await hive.box('settings');
```

You can also get a box without opening it (you must open it yourself):

```dart
final box = hive.boxSync('settings');
await box.open();
```

---

## 3. Read / Write

```dart
final box = await hive.box('settings');

// Write
await box.put('theme', 'dark');
await box.put('userId', 42);
await box.putAll({'lang': 'km', 'rate': 4000});

// Read
final theme = box.get('theme');                       // dynamic -> 'dark'
final lang  = box.getOrDefault('lang', 'en');         // 'km' (or 'en' if missing)
final rate  = box.getAs<int>('rate');                 // 4000 (null if wrong type)
final theme2 = box.getAsOrDefault<String>('theme', 'light'); // 'dark'

// Check
final hasTheme = box.containsKey('theme');            // true
final count    = box.length;                          // number of entries
final allKeys  = box.keys;                            // Iterable of keys
```

---

## 4. Delete

```dart
final box = await hive.box('settings');

await box.delete('theme');            // delete one key
await box.deleteAll(['lang', 'rate']); // delete many keys
await box.clear();                    // delete everything in the box
```

---

## 5. Reactive (watch changes)

```dart
final box = await hive.box('settings');

// Watch all changes in the box
box.watch().listen((event) {
  print('${event.key} changed to ${event.value}');
});

// Watch a specific key
box.watchKey('theme').listen((event) {
  print('theme is now ${event.value}');
});
```

---

## 6. Debug / Inspect

```dart
final box = await hive.box('settings');
box.dump();                    // prints all data as pretty JSON
box.dump(label: 'My Settings'); // with a custom label
```

---

## 7. Closing & Cleanup

```dart
// Close one box
await hive.close('settings');

// Close all open boxes
await hive.closeAll();

// Delete a box from disk (closes it first)
await hive.deleteBox('settings');

// Delete ALL boxes from disk
await hive.deleteAllBoxes();
```

---

## 8. Storing complex data

Hive can store primitives, `List`, `Map`, `DateTime`, `Uint8List`, and any object with a registered `TypeAdapter`.

```dart
final box = await hive.box('app');

// Store a Map
await box.put('user', {'name': 'Sok', 'role': 'admin'});
final user = box.get('user'); // Map

// Store a List
await box.put('tags', ['hotel', 'front-desk']);
final tags = box.getAs<List>('tags');
```

> For custom model classes, register a `TypeAdapter` with `Hive.registerAdapter(...)` before opening the box.

---

## 9. Full example

```dart
import "package:flutter/material.dart";
import "package:speanmeas/core/utility/hive.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await hive.init();

  // Open a box
  final box = await hive.box('session');

  // Save login state
  await box.put('loggedIn', true);
  await box.put('token', 'abc123');

  // Read it back
  final loggedIn = box.getAsOrDefault<bool>('loggedIn', false);
  final token    = box.getAs<String>('token');

  debugPrint('loggedIn=$loggedIn, token=$token');

  // Inspect everything
  box.dump();

  runApp(const MyApp());
}
```

---

## API Reference

### `HiveUtil hive` (global singleton)

| Method                                | Description                  |
| ------------------------------------- | ---------------------------- |
| `Future<void> init()`                 | Initialize Hive (call once). |
| `Future<HiveBox> box(String name)`    | Get a box, auto-opens it.    |
| `HiveBox boxSync(String name)`        | Get a box without opening.   |
| `Future<void> close(String name)`     | Close one box.               |
| `Future<void> closeAll()`             | Close all boxes.             |
| `Future<void> deleteBox(String name)` | Delete a box from disk.      |
| `Future<void> deleteAllBoxes()`       | Delete all boxes from disk.  |

### `HiveBox`

| Method                           | Description                         |
| -------------------------------- | ----------------------------------- |
| `Future<void> open()`            | Open the box.                       |
| `Future<void> close()`           | Close the box.                      |
| `Box get box`                    | Raw Hive box (throws if not open).  |
| `bool get isOpen`                | Whether the box is open.            |
| `int get length`                 | Number of entries.                  |
| `Iterable<dynamic> get keys`     | All keys.                           |
| `bool containsKey(key)`          | Check if a key exists.              |
| `dynamic get(key)`               | Get a value (null if missing).      |
| `dynamic getOrDefault(key, def)` | Get a value or default.             |
| `T? getAs<T>(key)`               | Get a value as type `T`.            |
| `T getAsOrDefault<T>(key, def)`  | Get a value as type `T` or default. |
| `Future<void> put(key, value)`   | Write a value.                      |
| `Future<void> putAll(map)`       | Write many values.                  |
| `Future<void> delete(key)`       | Delete a key.                       |
| `Future<void> deleteAll(keys)`   | Delete many keys.                   |
| `Future<void> clear()`           | Clear the box.                      |
| `Stream<BoxEvent> watch()`       | Watch all changes.                  |
| `Stream<BoxEvent> watchKey(key)` | Watch a specific key.               |
| `void dump({String? label})`     | Print all data as JSON.             |
