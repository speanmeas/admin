# Code Review: Spean Meas Admin (Flutter Web)

**Date:** 2026-07-31  
**Project:** Spean Meas Admin - Hotel Management System (Flutter Web)  
**Platform:** Flutter Web → Cloudflare Pages  

---

## Architecture & Structure

Flutter web admin panel for a hotel management system. Uses a custom CRUD-generator pattern with PlutoGrid for data tables and Provider (`ChangeNotifier`) for state management. Deploys to Cloudflare Pages via Wrangler.

### Directory Layout

```
lib/
  __config__.dart          - Global config (API hosts, app title)
  __variable__.dart        - Global mutable singleton state
  main.dart                - Entry point
  setting.dart             - Placeholder setting class
  template.dart            - Dev template widget
  theme/theme_data.dart    - Material 3 theme
  i18n/                    - Empty locale JSON files
  utility/                 - Dio client, secure storage
  widget/                  - Shared widgets (datetime picker, snackbar, show_data)
  layout/                  - Main layout (sidebar, topbar, body, notification)
  page/
    auth/                  - Sign-in, loading, profile, profile forms
    dashboard/front_desk/  - Main operational dashboard
    front_desk/            - CRUD for front desk records
    guest/                 - CRUD for guests
    nationality/           - CRUD for nationalities
    room/                  - CRUD for rooms
    user/                  - CRUD for users
    report/                - Daily, Weekly, Monthly, Yearly (all stubs)
    setting/               - Placeholder
    .demo_1/               - Dead code (old CRUD pattern)
    .demo_1a/              - Dead code
    .demo_1b/              - Dead code
    .demo_old/             - Dead code
test/
  cli/                     - Dio, SSE experiments; not real tests
  gui/                     - PlutoGrid widget experiments
  widget/                  - One widget test
```

---

## Strengths

- Clean separation of layout, pages, widgets, and utilities
- Consistent CRUD page pattern (`main.dart` / `__config__.dart` / `schema.g.dart` / `form/`) makes adding new entities predictable
- Role-based UI gating (admin/manager/receptionist) in place
- Dark/light theme ready with Material 3
- Mobile-responsive layout (sidebar collapses to Drawer at 1000px)

---

## Critical Issues

### 1. Massive Schema Code Duplication

The `front_desk` schema (450+ lines, 45+ fields) is duplicated verbatim in two locations:
- `lib/page/dashboard/front_desk/schema.g.dart`
- `lib/page/front_desk/schema.g.dart`

**Fix:** Extract to a shared location (e.g., `lib/schema/front_desk.dart`).

### 2. API Hosts Hardcoded in Source

`lib/__config__.dart` hardcodes IP addresses, debug flags, and domain names:

```dart
if (bool.fromEnvironment('dart.vm.product')) {
  // ... environment checks
  api_host = "muysengly.1riel.com";
  api_host = "api.speanmeas.com";
}
```

**Fix:** Use environment variables or a `.env` file (with `flutter_dotenv`).

### 3. No Input Validation / Sanitization

All CRUD forms send raw user input to the API with minimal validation. Only password confirmation is checked (`form/password.dart:121`). All other fields pass directly through.

**Fix:** Add field-level validation (required fields, format checks, length limits).

### 4. 30+ Lint Rules Disabled

`analysis_options.yaml` disables nearly every useful Dart lint:
- `unused_import`, `unused_local_variable`, `dead_code` — hides dead code
- `must_be_immutable`, `prefer_final_fields` — allows mutable state in widgets
- `use_build_context_synchronously` — allows async context use after `await`
- `non_constant_identifier_names`, `file_names` — inconsistent naming

**Fix:** Re-enable these lints incrementally and fix violations.

### 5. Auth Token Has No Refresh / Expiry Handling

- Token is stored in `FlutterSecureStorage` and validated once on load (`auth/loading.dart`)
- No interceptor on Dio to detect 401 responses and redirect to login
- No refresh token mechanism

**Fix:** Add a Dio interceptor to catch 401 responses and trigger re-authentication.

---

## Medium Issues

| Issue | Location | Recommendation |
|---|---|---|
| Global mutable singleton (`Global`) | `__variable__.dart` | Replace with proper state management; at minimum make fields `private` with getters |
| i18n JSON files empty | `lib/i18n/` | Either implement i18n or remove the files |
| Dead demo directories | `lib/page/.demo_*` | Delete unused code |
| 15+ TODO comments in committed code | Across codebase | Address or track in issue tracker |
| No type safety — all schemas are `List<Map<String, dynamic>>` | All `schema.g.dart` files | Uncomment `json_serializable` + `build_runner` for type-safe models |
| No global error boundary | `main.dart` | Add `FlutterError.onError` / `runZonedGuarded` |
| Reports & Settings are stubs (5 pages) | `lib/page/report/`, `lib/page/setting/` | Implement or remove |
| Tests are experiments, not real tests | `test/` | Write unit tests for services and widget tests for forms |
| `publish_to: "Local"` | `pubspec.yaml:5` | Won't break anything but misleading |
| NotoSansKhmer font referenced but not declared as asset | `theme/theme_data.dart:12` | Add to `pubspec.yaml` or remove reference |

---

## Minor / Style Issues

| Issue | Location |
|---|---|
| Inconsistent import casing (`dio.dart` vs `Environment.dart`) | New code vs old demo code |
| `.g.dart` naming for non-generated files (implies code generation) | All `schema.g.dart` files |
| No `const` constructors for stateless widgets | Many widget files |
| Magic strings for page routing (`global.body = "Front Desk"`) | `layout/panel_body.dart` |
| 1000-row limit hardcoded per page config | Each page's `__config__.dart` |

---

## Security Observations

- Passwords are masked in PlutoGrid as `"**********"` but sent in plaintext via Dio form-data POST requests
- No CSRF protection visible
- No rate limiting on auth endpoints (client-side)
- No HTTPS enforcement (though Cloudflare handles this)
- No input sanitization before API calls

---

## TODO Summary (Committed)

| File | Type | Description |
|---|---|---|
| `lib/__config__.dart:16,30,36,41` | `todo` | Router configuration |
| `lib/layout/notification.dart:2` | `TODO` | Develop notification page |
| `lib/page/dashboard/front_desk/main.dart:108-360` | `TODO` | 10+ menu items "Under Development" |
| `lib/page/auth/form/username.dart:103` | `todo` | Validation |
| All create/update forms | `todo` | "clear date-time?" |

---

## Action Items (Priority Order)

1. **Extract shared schema** — deduplicate `front_desk` schema
2. **Re-enable lints** — at minimum `unused_import`, `dead_code`, `prefer_final_fields`
3. **Clean dead code** — remove `.demo_*` directories
4. **Add token refresh** — Dio interceptor for 401 handling
5. **Fix font asset** — declare NotoSansKhmer or remove reference
6. **Use environment variables** — move API hosts out of source
7. **Add form validation** — required fields, format checks
8. **Remove or implement i18n** — empty JSON files are dead weight
9. **Consider json_serializable** — for type-safe model classes
10. **Add global error handling** — `FlutterError.onError`
