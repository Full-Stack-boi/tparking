import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:get/get_navigation/get_navigation.dart';
import 'package:tparking/firebase_options.dart';
import 'package:tparking/src/features/core/controllers/car_register_list.dart';
//import 'package:tparking/src/features/authentication/screens/splash_screen/welcome/welcome_screen.dart';
//import 'package:tparking/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:tparking/src/repository/authentication_repository/authentication_repository.dart';
import 'package:tparking/src/utils/theme/theme.dart';

import 'src/features/controllers/notification_api.dart';
import 'src/features/controllers/notification_local.dart';
//import 'src/features/core/screens/car_registion.dart';
import 'package:timezone/data/latest_all.dart' as tz;

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationLocal().initNotification();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthenticationRepository()));
  FirebaseApi().initNotifications();
  tz.initializeTimeZones();
  await SharedPreference.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tpraking',
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      // This is the theme of your application.
      //
      // TRY THIS: Try running your application with "flutter run". You'll see
      // the application has a blue toolbar. Then, without quitting the app,
      // try changing the seedColor in the colorScheme below to Colors.green
      // and then invoke "hot reload" (save your changes or press the "hot
      // reload" button in a Flutter-supported IDE, or press "r" if you used
      // the command line to start the app).
      //
      // Notice that the counter didn't reset back to zero; the application
      // state is not lost during the reload. To reset the state, use hot
      // restart instead.
      //
      // This works for code too, not just values: Most code changes can be
      // tested with just a hot reload.
      debugShowCheckedModeBanner: false,
      // home:  const WelcomeScreen(),
      home: const Center(child: CircularProgressIndicator()),

      // navigatorKey: navigatorKey,
      // routes: {
      //   '/notification_screen':(context) =>  const CarRegistion(),
      // },
    );
  }
}
