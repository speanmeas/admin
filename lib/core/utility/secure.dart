// * នាំចូល flutter_secure_storage សម្រាប់ផ្ទុកទិន្នន័យសម្ងាត់
import "dart:convert";
import "package:flutter/foundation.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

// * instance សកលសម្រាប់ផ្ទុកទិន្នន័យសម្ងាត់ (token, password...)
final FlutterSecureStorage secure = FlutterSecureStorage();

// * ថ្នាក់ SecureUtil គ្រប់គ្រង secure storage ដោយសុវត្ថិភាព
// * ចាប់កំហុស PlatformException ដើម្បីកុំឲ្យកម្មវិធី crash
class SecureUtil {
  // * singleton instance
  static final SecureUtil instance = SecureUtil._();
  SecureUtil._();

  // * storage instance ខាងក្រោម
  final FlutterSecureStorage _storage = secure;

  // * រក្សាទុក value (null នឹងលុប key)
  Future<void> write(String key, String? value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      debugPrint("Secure write '$key' failed: $e");
    }
  }

  // * ទទួលបាន value (null បើមិនមាន ឬមានកំហុស)
  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      debugPrint("Secure read '$key' failed: $e");
      return null;
    }
  }

  // * ទទួលបាន value ជាមួយ default value
  Future<String> readOrDefault(String key, String defaultValue) async {
    return await read(key) ?? defaultValue;
  }

  // * ពិនិត្យថាមាន key ឬអត់
  Future<bool> contains(String key) async {
    try {
      return await _storage.containsKey(key: key);
    } catch (e) {
      debugPrint("Secure contains '$key' failed: $e");
      return false;
    }
  }

  // * លុប key
  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      debugPrint("Secure delete '$key' failed: $e");
    }
  }

  // * លុប keys ច្រើនក្នុងពេលតែមួយ
  Future<void> deleteAll(Iterable<String> keys) async {
    for (final key in keys) {
      await delete(key);
    }
  }

  // * រក្សាទុក bool
  Future<void> writeBool(String key, bool value) => write(key, value.toString());

  // * ទទួលបាន bool (default false)
  Future<bool> readBool(String key, {bool defaultValue = false}) async {
    final v = await read(key);
    if (v == null) return defaultValue;
    return v == "true";
  }

  // * រក្សាទុក int
  Future<void> writeInt(String key, int value) => write(key, value.toString());

  // * ទទួលបាន int (default 0)
  Future<int> readInt(String key, {int defaultValue = 0}) async {
    final v = await read(key);
    return int.tryParse(v ?? "") ?? defaultValue;
  }

  // * រក្សាទុក double
  Future<void> writeDouble(String key, double value) => write(key, value.toString());

  // * ទទួលបាន double (default 0.0)
  Future<double> readDouble(String key, {double defaultValue = 0.0}) async {
    final v = await read(key);
    return double.tryParse(v ?? "") ?? defaultValue;
  }

  // * រក្សាទុក JSON (Map/List) ជា string
  Future<void> writeJson(String key, dynamic value) async {
    try {
      await write(key, jsonEncode(value));
    } catch (e) {
      debugPrint("Secure writeJson '$key' failed: $e");
    }
  }

  // * ទទួលបាន JSON (Map/List) ពី string
  Future<dynamic> readJson(String key) async {
    final v = await read(key);
    if (v == null) return null;
    try {
      return jsonDecode(v);
    } catch (e) {
      debugPrint("Secure readJson '$key' failed: $e");
      return null;
    }
  }

  // * ទទួលបាន JSON ជា Map
  Future<Map<String, dynamic>?> readJsonMap(String key) async {
    final v = await readJson(key);
    return v is Map<String, dynamic> ? v : null;
  }

  // * ទទួលបាន JSON ជា List
  Future<List<dynamic>?> readJsonList(String key) async {
    final v = await readJson(key);
    return v is List ? v : null;
  }
}

// * instance សកលរបស់ SecureUtil
SecureUtil secureUtil = SecureUtil.instance;
