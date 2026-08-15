# Dio Utility — Usage Guide

A safe wrapper around [Dio](https://pub.dev/packages/dio) for HTTP requests.

**File:** `lib/core/utility/dio.dart`

---

## 1. Two ways to use it

The file exposes **two** objects:

| Object    | Type      | Purpose                        |
| --------- | --------- | ------------------------------ |
| `dio`     | `Dio`     | Raw API (existing code)        |
| `dioUtil` | `DioUtil` | **Safe wrapper** — recommended |

> **Use `dioUtil`** for new code. It catches `DioException` errors so the app never crashes.

---

## 2. Basic requests

```dart
import "package:speanmeas/core/utility/dio.dart";

// POST (returns null on error)
final res = await dioUtil.post(endpoint.AUTH_SIGN_IN, data: {
  "username": "admin",
  "password": "1234",
});
if (res == null) {
  // handle error
  return;
}
final token = res.data["access_token"];

// GET
final res2 = await dioUtil.get("/some/path", query: {"page": 1});

// PUT
await dioUtil.put("/some/path", data: {"name": "New"});

// DELETE
await dioUtil.delete("/some/path", data: {"id": "123"});

// PATCH
await dioUtil.patch("/some/path", data: {"note": "updated"});
```

---

## 3. Getting data directly

Instead of handling `Response`, use the typed helpers:

```dart
// Get raw data (null on failure)
final data = await dioUtil.getData(endpoint.BANK_CRUD_READ, data: {...});

// Get data as a List
final rows = await dioUtil.getList(endpoint.BANK_CRUD_READ, data: {...});
if (rows != null) {
  for (final row in rows) {
    print(row);
  }
}

// Get data as a Map
final user = await dioUtil.getMap(endpoint.USER_CRUD_READ_ID, data: {"id": "1"});
final name = user?["name"];
```

> `getList` returns `null` if the response isn't a `List`. `getMap` returns `null` if it isn't a `Map`.

---

## 4. Token management

```dart
// Set the Authorization header
dioUtil.setToken("abc123"); // -> "Bearer abc123"

// Clear it (logout)
dioUtil.clearToken();
```

---

## 5. Full example (login flow)

```dart
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/utility/secure.dart";

Future<bool> signIn(String username, String password) async {
  final res = await dioUtil.post(endpoint.AUTH_SIGN_IN, data: {
    "username": username,
    "password": password,
  });

  // Request failed
  if (res == null) return false;

  // Save token securely and set it on Dio
  await secureUtil.write("access_token", res.data["access_token"]);
  await secureUtil.write("_id", res.data["_id"]);
  dioUtil.setToken(res.data["access_token"]);

  return true;
}

Future<void> logout() async {
  await secureUtil.deleteAll(["access_token", "_id"]);
  dioUtil.clearToken();
}
```

---

## 6. Using the raw `dio` object (existing code)

The raw API is still available and unchanged:

```dart
final tmp = await dio.post(endpoint.AUTH_SIGN_IN, data: {
  "username": username,
  "password": password,
});
final token = tmp.data["access_token"];
dio.options.headers["Authorization"] = "Bearer $token";
```

> ⚠️ The raw API **can throw** `DioException` (network, timeout, 4xx/5xx). Prefer `dioUtil` to avoid crashes.

---

## API Reference

### `DioUtil dioUtil`

| Method                                                   | Description                                |
| -------------------------------------------------------- | ------------------------------------------ |
| `Dio get client`                                         | The underlying Dio instance.               |
| `void setToken(String? token)`                           | Set the Authorization header.              |
| `void clearToken()`                                      | Clear the Authorization header.            |
| `Future<Response?> get(path, {query, options})`          | Safe GET request.                          |
| `Future<Response?> post(path, {data, query, options})`   | Safe POST request.                         |
| `Future<Response?> put(path, {data, query, options})`    | Safe PUT request.                          |
| `Future<Response?> delete(path, {data, query, options})` | Safe DELETE request.                       |
| `Future<Response?> patch(path, {data, query, options})`  | Safe PATCH request.                        |
| `Future<dynamic> getData(path, {data, query, options})`  | Returns `response.data` (null on failure). |
| `Future<List?> getList(path, {data, query, options})`    | Returns data as a `List`.                  |
| `Future<Map?> getMap(path, {data, query, options})`      | Returns data as a `Map`.                   |
