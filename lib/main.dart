import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
      options: const FirebaseOptions(
       // databaseURL: "https://efda-d66cd-default-rtdb.asia-southeast1.firebasedatabase.app",
          apiKey: 'AIzaSyDru13lcR1nIAOEX_PXHtaWnonODB1cxck',
          appId: '1:797469394513:android:4648c68dc508e8d5e09a70',
          messagingSenderId: '797469394513',
          projectId: 'efda-d66cd'));
  setupServices();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}
