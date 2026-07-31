# AGENTS.md

Flutter web admin panel ("Spean Meas Admin") for a hotel management system. Package name `speanmeas`, Dart SDK `^3.11.4`. Backend API is a separate repo/service.

## Commands

- `flutter pub get` after any pubspec change
- `flutter analyze` — lint/typecheck (the only static check; analyzer config deliberately ignores many lints)
- `flutter test` — near-useless: `test/` contains experiments (dio/SSE/PlutoGrid playgrounds), not real tests
- Build for Cloudflare: `flutter build web --release --base-href / --output=build/cloudflare`
- Build for GitHub Pages: `flutter build web --release --base-href /admin/ --output=build/github`
- Formatting: `dart format` (trailing commas are used intentionally to control it)

## Architecture

- Entrypoint `lib/main.dart` → `Main_` → `page/auth/loading.dart`. State via singleton `global` (`lib/__variable__.dart`, `ChangeNotifier`) injected with `ChangeNotifierProvider`; read with `context.watch<Global>()`.
- Routing is string-based, not named routes: `global.body` is matched in `lib/layout/panel_body.dart` with `IndexedStack`. App shell in `lib/layout/layout.dart` (sidebar, panel_top, panel_body).
- CRUD entities live in `lib/page/{entity}/` with a fixed layout: `__config__.dart` (HEADER, PATH, DATE_FORMAT, LIMIT, KEY, ORDER), `schema.g.dart`, `main.dart` (PlutoGrid grid + pagination), `form/{create,read,update,delete}.dart`, `widget/{entity}_search.dart`. Copy the structure from an existing entity (e.g. `guest/`) when adding one.
- `schema.g.dart` is hand-written `Map<String, Map<String, dynamic>>` with field types `id`, `string`, `number`, `date-time`, `boolean`. No codegen (build_runner/json_serializable are commented out in pubspec).
- All API calls are `dio.post(...)` with `FormData.fromMap({...})` against the shared instance in `lib/utility/dio.dart`. Endpoints per entity: `$PATH/read`, `read_count`, `read_id`, `create`, `update`, `update_field`, `delete`; auth: `/auth/sign_in`, `/auth/access_token`.
- Errors handled per-call with try/catch + `snackbar_show(context:..., message:..., color:...)` from `lib/widget/snackbar_show.dart`.

## Conventions (differ from Flutter defaults — follow them)

- Double quotes only, never single quotes.
- Widget class names end with `_`: `Main_`, `Datetime_Picker_`; state classes `_Main_State`. `StatefulWidget` is the default.
- Constants (incl. schema field keys) are `SCREAMING_SNAKE_CASE`; vars/functions `snake_case`; config/global files named `__name__.dart`.
- Every widget file includes its own `main()` for standalone dev.
- Khmer/English mixed UI and `// * ...` comments; use `//` blank separators between logic blocks; append `, //` after last argument to keep trailing commas.
- UI: square corners (borderRadius 0), blue seed color, Material 3. Theme in `lib/theme/theme_data.dart` references font "NotoSansKhmer" which is NOT bundled in pubspec — known issue.

## API host & deploy gotchas

- `lib/__config__.dart` picks `API_HOST`: `kDebugMode` → localhost; `is_local` → LAN IP; `is_github` → `https://muysengly.1riel.com`; else `https://api.speanmeas.com`. Same pattern for MINIO_PUBLIC.
- `update_cloudflare.py` and `update_github.py` handle the real deploy: bump build number in pubspec.yaml, build web, `git add . && git commit -m "update" && git push`. `update_github.py` flips `is_github = true` before build and reverts after. Commit style is just "update".
- `build/cloudflare` and `build/github` are git-tracked (see `.gitignore` exceptions). `wrangler.jsonc` serves `build/cloudflare`.
- CI: `.github/workflows/static.yml` deploys `./build/github/` to GitHub Pages on push to `main`.

## Known dead/placeholder code

- `lib/page/.demo_1`, `.demo_1a`, `.demo_1b`, `.demo_old`, and `lib/page/demo_1`, `demo_2` are demo/experiment code, not production.
- `lib/i18n/*.json` are empty stubs; `lib/page/report/*`, `lib/page/setting/`, `lib/layout/notification.dart` are placeholders.
- Passwords are masked in the grid as `"**********"`; auth token lives in `flutter_secure_storage` keyed `"access_token"` (no refresh/Dio 401 interceptor yet).
