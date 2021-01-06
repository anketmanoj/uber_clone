import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/data_provider/app_data.dart';
import 'package:rider_app/screens/login_page.dart';
import 'package:rider_app/screens/mainpage.dart';
import 'package:rider_app/screens/registration_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    name: 'db2',
    options: Platform.isIOS || Platform.isMacOS
        ? FirebaseOptions(
            appId: '1:881002486271:ios:8b7f5c01087a9fe86c6fca',
            apiKey: 'AIzaSyAJ2EeV9V_J1DiiKvfS_ezNgCHE7f0-78U',
            projectId: 'flutter-firebase-plugins',
            messagingSenderId: '881002486271',
            databaseURL:
                'https://transdelivery-a097f-default-rtdb.firebaseio.com',
          )
        : FirebaseOptions(
            appId: '1:881002486271:android:9c5e1429a05eaa326c6fca',
            apiKey: 'AIzaSyALciJRxGgFoCw2-jxjdlwxj8k74p-kyuM',
            messagingSenderId: '297855924061',
            projectId: 'flutter-firebase-plugins',
            databaseURL:
                'https://transdelivery-a097f-default-rtdb.firebaseio.com',
          ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'Brand-Regular'),
        initialRoute: MainPage.id,
        routes: {
          RegistrationPage.id: (context) => RegistrationPage(),
          LoginPage.id: (context) => LoginPage(),
          MainPage.id: (context) => MainPage(),
        },
      ),
    );
  }
}
