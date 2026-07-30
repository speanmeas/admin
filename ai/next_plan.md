# Next Plan — Spean Meas Admin

## Priority 1: Critical Bugs

- [ ] **Deduplicate front_desk schema** — Extract shared schema from `page/dashboard/front_desk/` and `page/front_desk/` into `lib/schema/`
- [ ] **Add Dio 401 interceptor** — Redirect to login when token expires instead of silent failure
- [ ] **Add NotoSansKhmer font asset** — Declare in `pubspec.yaml` or remove reference from theme
- [ ] **Validate API hosts** — Move hardcoded IPs/domains out of `__config__.dart` into env variables

## Priority 2: Quality & Maintainability

- [ ] **Remove dead code** — Delete `.demo_1`, `.demo_1a`, `.demo_1b`, `.demo_old` directories
- [ ] **Add form validation** — Required fields, phone format, email format, min/max lengths
- [ ] **Replace raw Map schemas** — Uncomment `json_serializable` + `build_runner` for type-safe models
- [ ] **Add global error boundary** — `FlutterError.onError` + `runZonedGuarded` in `main.dart`

## Priority 3: Features to Complete

- [ ] **Implement i18n** — Wire up Khmer (`kh_KH.json`) and English (`en_EN.json`) translations
- [ ] **Build report pages** — Daily, Weekly, Monthly, Yearly (currently stubs)
- [ ] **Build settings page** — Currently a placeholder
- [ ] **Build notification page** — Currently a placeholder

## Priority 4: Testing

- [ ] **Write API service unit tests** — Test Dio calls with mock responses
- [ ] **Write widget tests** — CRUD forms, login flow, navigation
- [ ] **Clean up test experiments** — Remove SSE, PlutoGrid playground files; keep only real tests

## Priority 5: Polish

- [ ] **Resolve all `// todo:` comments** — Router config, date-time clearing, validation
- [ ] **Consistent import casing** — Ensure all imports use lowercase filenames
- [ ] **Address remaining lint infos** — `use_build_context_synchronously` across async gaps
