import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/db/db_helper.dart';
import 'package:todo/services/NotificationServices.dart';
import 'package:todo/services/ThemeServices.dart';
import 'package:todo/ui/HomePage.dart';
import 'package:todo/ui/Themes.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  NotificationServices.initialiszeNotification();
  NotificationServices.requestNotificationPermission();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      home: const HomePage(),
    );
  }
}


