// * នាំចូលបណ្ណាល័យ Flutter សម្រាប់ UI និង Provider សម្រាប់ state management
import "package:flutter/material.dart";
import "package:provider/provider.dart";

// * នាំចូលឯកសារកំណត់រចនាសម្ព័ន្ធ និងធនធានរបស់កម្មវិធី
import "package:speanmeas/core/utility/all.dart";

import "features/auth/load.dart" as loading;

// * ចំណុចចាប់ផ្តើមសំខាន់របស់កម្មវិធី
void main() async {
  // * ធានាថា Flutter binding ត្រូវបានចាប់ផ្តើមមុនពេលប្រើប្រាស់
  WidgetsFlutterBinding.ensureInitialized();
  // * ចាប់ផ្តើម global state និង language
  glob.init();
  lang.init();

  // * បញ្ជូនទៅ sign in ពេល token ផុតកំណត់ (401) — ជម្រះផ្ទុកសុវត្ថិភាព រួចត្រឡប់ទៅ splash
  dio.on_unauthenticated = () async {
    await secureUtil.deleteAll(["access_token", "_id"]);
    navigatorKey.currentState?.pushAndRemoveUntil(MaterialPageRoute(builder: (_) => loading.Load()), (route) => false);
  };
  //
  // * បង្កើត root widget ជាមួយ MultiProvider សម្រាប់ផ្តល់ state ដល់កម្មវិធី
  runApp(
    MultiProvider(
      providers: [
        // * ផ្តល់ global state និង language state
        ChangeNotifierProvider.value(value: glob),
        ChangeNotifierProvider.value(value: lang),
      ],
      child: Main(),
    ),
  );
}

// * ថ្នាក់ Main ជា root widget របស់កម្មវិធី
class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    // * បង្កើត MaterialApp ជាមួយ theme និង home page
    return MaterialApp(
      title: "$TITLE Admin", //
      theme: theme_data, //
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: loading.Load(),
    );
  }
}
