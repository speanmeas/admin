// ឧបករណ៍បម្លែងតម្លៃដោយសុវត្ថិភាព (safe parse) សម្រាប់គ្រប់ប្រភេទទិន្នន័យ
// ប្រើសម្រាប់អានតម្លៃពី Map/dynamic ដោយមិនបាក់កម្មវិធី
// រាល់ function ត្រឡប់ null ពេលតម្លៃមិនអាចបម្លែងបាន ឬអវត្តមាន

// បម្លែងទៅជា String (null-safe)
import 'package:intl/intl.dart';
import 'package:speanmeas/core/config.dart';

String? parse_string(dynamic v) {
  if (v == null) return null;
  return v.toString();
}

String format_string(dynamic v, {String fallback = ""}) {
  if (v == null) return fallback;
  final s = parse_string(v);
  if (s == null) return fallback;
  return s;
}

int? parse_int(dynamic v, {int fallback = 0}) {
  if (v == null) return fallback;
  if (v is int) return v;
  if (v is num) return v.toInt();
  try {
    return int.tryParse(v?.toString() ?? "");
  } catch (_) {
    return null;
  }
}

String format_int(dynamic v, {String fallback = "0"}) {
  if (v == null) return fallback;
  final i = parse_int(v);
  if (i == null) return fallback;
  return i.toString();
}

double? parse_double(dynamic v) {
  if (v == null) return null;
  if (v is double) return v;
  if (v is num) return v.toDouble();
  try {
    return double.tryParse(v?.toString() ?? "");
  } catch (_) {
    return null;
  }
}

String format_double(dynamic v, {String fallback = "0.00", int digits = 2}) {
  if (v == null) return fallback;
  final d = parse_double(v);
  if (d == null) return fallback;
  return d.toStringAsFixed(digits);
}

num? parse_num(dynamic v) {
  if (v == null) return null;
  if (v is num) return v;
  try {
    return num.tryParse(v?.toString() ?? "");
  } catch (_) {
    return null;
  }
}

String format_bool(dynamic v, {String fallback = "0", String true_val = "1", String false_val = "0"}) {
  if (v == null) return fallback;
  final b = parse_bool(v);
  return b ? true_val : false_val;
}

bool parse_bool(dynamic v, {bool fallback = false}) {
  if (v == null) return fallback;
  if (v is bool) return v;
  if (v is num) return v != 0;
  final s = v?.toString().trim().toLowerCase() ?? "";
  if (s == "true" || s == "1" || s == "yes") return true;
  if (s == "false" || s == "0" || s == "no") return false;
  return fallback;
}

DateTime? parse_datetime(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  try {
    return DateTime.tryParse(v?.toString() ?? "");
  } catch (_) {
    return null;
  }
}

String format_datetime(dynamic v, {String fallback = "", String format = DEFAULT_DATE_FORMAT}) {
  if (v == null) return fallback;
  final dt = parse_datetime(v);
  if (dt == null) return fallback;
  return DateFormat(format).format(dt.toLocal());
}

// // បម្លែងទៅជា List<dynamic> (null-safe)
// List<dynamic>? parse_list(dynamic v) {
//   if (v == null) return null;
//   if (v is List) return v;
//   return null;
// }

// // បម្លែងទៅជា Map<String, dynamic> (null-safe)
// Map<String, dynamic>? parse_map(dynamic v) {
//   if (v == null) return null;
//   if (v is Map) return Map<String, dynamic>.from(v);
//   return null;
// }

// // អានតម្លៃ nested ពី Map ដោយសុវត្ថិភាព (guard គ្រប់កម្រិត)
// // ឧទាហរណ៍: parse_nested(m, ["guest", "name"]) ?? ""
// dynamic parse_nested(dynamic root, List<String> keys) {
//   dynamic cur = root;
//   for (final k in keys) {
//     if (cur is! Map) return null;
//     cur = cur[k];
//   }
//   return cur;
// }
