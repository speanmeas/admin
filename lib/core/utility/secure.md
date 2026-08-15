# Secure Storage Utility — Usage Guide

A safe wrapper around [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) for storing sensitive data (tokens, passwords, etc.).

**File:** `lib/core/utility/secure.dart`

---

## 1. Two ways to use it

The file exposes **two** objects:

| Object | Type | Purpose |
| ------ | ---- | ------- |
| `secure` | `FlutterSecureStorage` | Raw API (existing code) |
| `secureUtil` | `SecureUtil` | **Safe wrapper** — recommended |

> **Use `secureUtil`** for new code. It catches `PlatformException` errors so the app never crashes.

---

## 2. Basic read / write

```dart
import "package:speanmeas/core/utility/secure.dart";

// Write
await secureUtil.write("access_token", "abc123");

// Read (null if missing or error)
final token = await secureUtil.read("access_token");

// Read with a default
final name = await secureUtil.readOrDefault("name", "Guest");

// Check if a key exists
final hasToken = await secureUtil.contains("access_token");
```

---

## 3. Typed values (bool / int / double)

```dart
// Boolean
await secureUtil.writeBool("is_admin", true);
final isAdmin = await secureUtil.readBool("is_admin");            // true
final isAdmin2 = await secureUtil.readBool("missing", defaultValue: true); // true

// Integer
await secureUtil.writeInt("attempts", 3);
final attempts = await secureUtil.readInt("attempts");            // 3
final attempts2 = await secureUtil.readInt("missing", defaultValue: 10); // 10

// Double
await secureUtil.writeDouble("rate", 4000.5);
final rate = await secureUtil.readDouble("rate");                 // 4000.5
```

> Typed reads use `tryParse`, so invalid stored data falls back to the default instead of throwing.

---

## 4. JSON (Map / List)

```dart
// Store a Map
await secureUtil.writeJson("user", {"name": "Sok", "role": "admin"});

// Store a List
await secureUtil.writeJson("tags", ["hotel", "front-desk"]);

// Read as dynamic
final data = await secureUtil.readJson("user");

// Read as a typed Map
final user = await secureUtil.readJsonMap("user");
final name = user?["name"]; // 'Sok'

// Read as a typed List
final tags = await secureUtil.readJsonList("tags");
```

---

## 5. Delete

```dart
// Delete one key
await secureUtil.delete("access_token");

// Delete many keys
await secureUtil.deleteAll(["access_token", "_id", "refresh_token"]);
```

---

## 6. Full example (login flow)

```dart
import "package:speanmeas/core/utility/secure.dart";

Future<void> saveLogin(Map<String, dynamic> data) async {
  await secureUtil.write("_id", data["_id"]);
  await secureUtil.write("access_token", data["access_token"]);
  await secureUtil.writeBool("logged_in", true);
  await secureUtil.writeJson("user", data);
}

Future<bool> isLoggedIn() async {
  return await secureUtil.readBool("logged_in");
}

Future<String?> getToken() async {
  return await secureUtil.read("access_token");
}

Future<void> logout() async {
  await secureUtil.deleteAll(["_id", "access_token", "user"]);
  await secureUtil.writeBool("logged_in", false);
}
```

---

## 7. Using the raw `secure` object (existing code)

The raw API is still available and unchanged:

```dart
await secure.write(key: "access_token", value: "abc123");
final token = await secure.read(key: "access_token");
await secure.delete(key: "access_token");
```

> ⚠️ The raw API **can throw** `PlatformException` (e.g. on unsupported platforms). Prefer `secureUtil` to avoid crashes.

---

## API Reference

### `SecureUtil secureUtil`

| Method | Description |
| ------ | ----------- |
| `Future<void> write(key, value)` | Save a value (null deletes the key). |
| `Future<String?> read(key)` | Read a value (null if missing/error). |
| `Future<String> readOrDefault(key, def)` | Read with a fallback. |
| `Future<bool> contains(key)` | Check if a key exists. |
| `Future<void> delete(key)` | Delete a key. |
| `Future<void> deleteAll(keys)` | Delete many keys. |
| `Future<void> writeBool(key, value)` | Save a boolean. |
| `Future<bool> readBool(key, {defaultValue})` | Read a boolean. |
| `Future<void> writeInt(key, value)` | Save an integer. |
| `Future<int> readInt(key, {defaultValue})` | Read an integer. |
| `Future<void> writeDouble(key, value)` | Save a double. |
| `Future<double> readDouble(key, {defaultValue})` | Read a double. |
| `Future<void> writeJson(key, value)` | Save a Map/List as JSON. |
| `Future<dynamic> readJson(key)` | Read JSON as dynamic. |
| `Future<Map<String, dynamic>?> readJsonMap(key)` | Read JSON as a Map. |
| `Future<List<dynamic>?> readJsonList(key)` | Read JSON as a List. |
