// * នាំចូល Hive សម្រាប់ local storage និង Flutter foundation
import "package:flutter/foundation.dart";
import "package:hive/hive.dart";
import "package:path_provider/path_provider.dart";
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

// * ថ្នាក់ HiveBox គ្រប់គ្រង Hive box ដើម្បីងាយស្រួលប្រើប្រាស់
class HiveBox {
  // * ឈ្មោះ box និង instance របស់ box
  final String name;
  Box? _box;

  // * បង្កើត HiveBox ជាមួយឈ្មោះ box
  HiveBox(this.name);

  // * បើក box (ហៅម្ដងប៉ុណ្ណោះ)
  Future<void> open() async {
    _box ??= await Hive.openBox(name);
  }

  // * បិទ box
  Future<void> close() async {
    await _box?.close();
    _box = null;
  }

  // * ទទួលបាន box instance (ត្រូវប្រាកដថាបាន open រួច)
  Box get box {
    final b = _box;
    if (b == null) {
      throw StateError("HiveBox '$name' is not open. Call open() first.");
    }
    return b;
  }

  // * ពិនិត្យថា box បានបើកឬអត់
  bool get isOpen => _box != null;

  // * ចំនួនទិន្នន័យក្នុង box
  int get length => box.length;

  // * បញ្ជី keys ទាំងអស់ក្នុង box
  Iterable<dynamic> get keys => box.keys;

  // * ពិនិត្យថាមាន key ឬអត់
  bool containsKey(dynamic key) => box.containsKey(key);

  // * ទទួលបាន value តាម key (null បើមិនមាន)
  dynamic get(dynamic key) => box.get(key);

  // * ទទួលបាន value តាម key ជាមួយ default value
  dynamic getOrDefault(dynamic key, dynamic defaultValue) => box.get(key, defaultValue: defaultValue);

  // * ទទួលបាន value តាម key ជាមួយ type ជាក់លាក់
  T? getAs<T>(dynamic key) {
    final v = box.get(key);
    return v is T ? v : null;
  }

  // * ទទួលបាន value តាម key ជាមួយ type និង default value
  T getAsOrDefault<T>(dynamic key, T defaultValue) {
    final v = box.get(key);
    return v is T ? v : defaultValue;
  }

  // * រក្សាទុក value តាម key
  Future<void> put(dynamic key, dynamic value) => box.put(key, value);

  // * រក្សាទុក value ច្រើនក្នុងពេលតែមួយ
  Future<void> putAll(Map<dynamic, dynamic> entries) => box.putAll(entries);

  // * លុប value តាម key
  Future<void> delete(dynamic key) => box.delete(key);

  // * លុប value ច្រើនតាម keys
  Future<void> deleteAll(Iterable<dynamic> keys) => box.deleteAll(keys);

  // * លុបទិន្នន័យទាំងអស់ក្នុង box
  Future<void> clear() => box.clear();

  // * ស្ដាប់ការផ្លាស់ប្ដូរក្នុង box
  Stream<BoxEvent> watch() => box.watch();

  // * ស្ដាប់ការផ្លាស់ប្ដូរតាម key ជាក់លាក់
  Stream<BoxEvent> watchKey(dynamic key) => box.watch(key: key);

  // * បោះពុម្ពទិន្នន័យទាំងអស់ក្នុង box
  void dump({String? label}) {
    pprint(box.toMap(), label: label ?? "HiveBox '$name'");
  }
}

// * ថ្នាក់ HiveUtil គ្រប់គ្រង Hive ទាំងមូល
class HiveUtil {
  // * singleton instance
  static final HiveUtil instance = HiveUtil._();
  HiveUtil._();

  // * បញ្ជី boxes ដែលបានបើក
  final Map<String, HiveBox> _boxes = {};

  // * ចាប់ផ្តើម Hive
  Future<void> init() async {
    // * ទទួលបាន directory សម្រាប់ផ្ទុកទិន្នន័យរបស់កម្មវិធី
    final dir = await getApplicationDocumentsDirectory();
    // * ចាប់ផ្តើម Hive ជាមួយ directory នោះ
    Hive.init(dir.path);
    debugPrint("Hive initialized at ${dir.path}.");
  }

  // * ទទួលបាន HiveBox តាមឈ្មោះ (បើកដោយស្វ័យប្រវត្តិ)
  Future<HiveBox> box(String name) async {
    final b = _boxes[name] ??= HiveBox(name);
    if (!b.isOpen) await b.open();
    return b;
  }

  // * ទទួលបាន HiveBox ដោយមិនបើក (ត្រូវបើកដោយខ្លួនឯង)
  HiveBox boxSync(String name) => _boxes[name] ??= HiveBox(name);

  // * បិទ box តាមឈ្មោះ
  Future<void> close(String name) async {
    final b = _boxes.remove(name);
    if (b != null) await b.close();
  }

  // * បិទ boxes ទាំងអស់
  Future<void> closeAll() async {
    for (final b in _boxes.values) {
      await b.close();
    }
    _boxes.clear();
  }

  // * លុប box ទាំងស្រុងពី disk
  Future<void> deleteBox(String name) async {
    await close(name);
    await Hive.deleteBoxFromDisk(name);
  }

  // * លុប boxes ទាំងអស់ពី disk
  Future<void> deleteAllBoxes() async {
    await closeAll();
    await Hive.deleteFromDisk();
  }
}

// * instance សកលរបស់ HiveUtil
HiveUtil hive = HiveUtil.instance;
