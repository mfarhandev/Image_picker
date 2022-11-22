import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:imagepicker_app/upload_multiple.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UploadMultipleImages(),
    );
  }
}

