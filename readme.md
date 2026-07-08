# Spean Meas Hotel System

## Project Structure Review

This project is a Flutter admin web app for hotel management.

### Top-level directories

- `lib/`: Main application source code
- `asset/`: Static assets
- `web/`: Flutter web host files
- `test/`: Flutter test files
- `tool/`: Local helper tools

### `lib/` structure

- `Main.dart`: App entry point
- `Environment.dart`: Environment constants and endpoint host selection
- `Global.dart`: Shared app state (`ChangeNotifier`)
- `layout/`: Main dashboard shell (top, left, body panels)
- `page/`: Feature modules (front desk, guest, room, user, reports, etc.)
- `theme/`: Theme configuration
- `utility/`: Shared utilities (Dio client, secure storage)
- `widget/`: Reusable widgets
- `i18n/`: Localization files (`en_EN`, `kh_KH`, `cn_CN`)

### Feature module pattern

Most CRUD modules under `lib/page/*` follow a consistent layout:

- `Main.dart`
- `Setup.dart`
- `Schema.g.dart`
- `Filter_*.dart`
- `Form_Create.dart`
- `Form_Read.dart`
- `Form_Update.dart`
- `Form_Delete.dart`

This consistent pattern makes feature maintenance and extension straightforward.
