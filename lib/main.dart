import 'package:flutter/material.dart';
import 'package:guesttellio/providers/UserData.dart';
import 'package:guesttellio/screens/LandingPage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await EasyLocalization.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserData()),
    ],
    child: const MyApp(),
    // child: EasyLocalization(
    //     supportedLocales: const [Locale('en'), Locale('ar')],
    //     path:
    //     'assets/translations', // <-- change the path of the translation files
    //     fallbackLocale: Locale('en'),
    //     // assetLoader: CodegenLoader(),
    //     child: const MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
      return MaterialApp(
          builder: EasyLoading.init(),
          // localizationsDelegates: context.localizationDelegates,
          // supportedLocales: context.supportedLocales,
          // locale: context.locale,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.green,
            fontFamily: 'Lato',
          ),
          home: LandingPage());
  }
}
