// * នាំចូលឧបករណ៍ដែលត្រូវការ
import "package:speanmeas/core/endpoint.g.dart";
import "package:speanmeas/core/schema.g.dart";
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/utility/secure.dart";
import "package:speanmeas/core/utility/pprint.dart";

// * AuthService — ទាញយកអ្នកប្រើបច្ចុប្បន្នតែម្តង ហើយផ្ទុក cache
// * (panel_top / panel_left / profile លែង POST AUTH_ACCESS_TOKEN ដដែលៗរាល់ shell load)
class AuthService {
  // * singleton instance
  static final AuthService instance = AuthService._();
  AuthService._();

  // * អ្នកប្រើបច្ចុប្បន្ន (cache)
  User? current_user;

  // * សំណើដែលកំពុងរង់ចាំ (ការពារការហៅ API ដដែលៗពេលហៅដំណាលគ្នា)
  Future<User?>? _pending;

  // * ទាញយកអ្នកប្រើបច្ចុប្បន្ន (ប្រើ cache បើមានហើយ)
  Future<User?> fetch() {
    if (current_user != null) return Future.value(current_user);
    return _pending ??= _load().then((u) {
      _pending = null;
      current_user = u;
      return u;
    });
  }

  // * ទាញយកថ្មីជានិច្ច (ក្រោយកែប្រែ profile ឬចុះឈ្មោះចូលថ្មី)
  Future<User?> refresh() {
    current_user = null;
    _pending = null;
    return fetch();
  }

  // * ជម្រះ cache (ពេលចាកចេញ ឬ token មិនត្រឹមត្រូវ ឬចុះឈ្មោះចូលគណនីថ្មី)
  void clear() {
    current_user = null;
    _pending = null;
  }

  // * ផ្ញើសំណើទៅ server
  Future<User?> _load() async {
    try {
      final token = await secure.read(key: "access_token");
      if (token == null || token.isEmpty) return null;

      final tmp = await dio.post(endpoint.AUTH_ACCESS_TOKEN, data: {"access_token": token});
      if (tmp == null || tmp.data == null) return null;

      // * server ត្រឡប់ list នៃ user ដែលបានពង្រីកវាលភ្ជាប់រួច
      final data_list = tmp.data as List?;
      if (data_list == null || data_list.isEmpty) return null;

      final json = data_list.first;
      if (json is! Map<String, dynamic>) return null;
      return User.fromJson(json);
    } catch (e, st) {
      // * ការពារការ crash ពេលរូបរាងទិន្នន័យមិនស្របនឹង schema (អ្នកប្រើថ្មី/raw doc)
      pprint(st);
      return null;
    }
  }
}

// * instance សកល
AuthService auth = AuthService.instance;
