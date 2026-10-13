// ជំនួយការទាញយកឯកសារពី backend នៅលើ web (bytes -> Blob -> download)
import "dart:js_interop";
import "dart:typed_data";

import "package:intl/intl.dart";
import "package:web/web.dart" as web;

// MIME សម្រាប់ឯកសារ Excel
const XLSX_MIME = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

// បង្កើតឈ្មោះឯកសារតាមទម្រង់ NAME_yyyymmddhhmmss.EXTENSION
String download_name(String name, String extension, {DateTime? at}) {
  final stamp = DateFormat("yyyyMMddHHmmss").format(at ?? DateTime.now());
  return "${name}_$stamp.$extension";
}

// អានឈ្មោះពី Content-Disposition (បើមាន) បើអត់ប្រើ fallback
String download_filename(String? content_disposition, String fallback) {
  final match = RegExp(r'filename="?([^";]+)"?').firstMatch(content_disposition ?? "");
  return match?.group(1) ?? fallback;
}

// រក្សាទុក bytes ជាឯកសារ (បង្កើត Blob រួច click ទាញយក)
void download_bytes({
  required List<int> bytes, //
  required String filename,
  required String mime,
}) {
  final data = Uint8List.fromList(bytes);
  final blob = web.Blob([data.toJS].toJS, web.BlobPropertyBag(type: mime));
  final url = web.URL.createObjectURL(blob);
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = filename;
  web.document.body?.appendChild(anchor);
  anchor.click();
  anchor.remove();
  web.URL.revokeObjectURL(url);
}
