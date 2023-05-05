import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mdev_carpool/DisplayTheme/display_theme.dart';
import 'package:mdev_carpool/SplashScreen/splash_screen.dart';
import 'package:mdev_carpool/screens/destination_screen.dart';
import 'package:mdev_carpool/screens/login_screen.dart';
import 'package:mdev_carpool/screens/main_page.dart';
import 'package:mdev_carpool/screens/register_screen.dart';
import 'package:provider/provider.dart';

import 'InfoHandler/app_info.dart';

Future<void> main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AppInfo(),
        child: MaterialApp(
          title: 'Flutter Demo',
          themeMode: ThemeMode.system,
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        ),
    );
  }
}

