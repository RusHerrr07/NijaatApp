import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nijaat_app/firebase_option.dart';
import 'package:nijaat_app/routes/get_route.dart';
import 'package:nijaat_app/routes/routes.dart';
import 'package:nijaat_app/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  String getInitialRoute() => AppRoutes.splash;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: messengerKey,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: "Nasha Mukt Bharat",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 160, 214, 97),
        ),
        primaryColor: const Color.fromARGB(255, 160, 214, 97),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: getInitialRoute(),
      onGenerateRoute: (settings) => getRoute(settings),
    );
  }
}