import 'package:flutter/material.dart';

import 'package:flutter_acrylic/flutter_acrylic.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterAcrylic.create();
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}


class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FlutterAcrylic.set(
      effect: BlurEffect.acrylic,
      gradientColor: Colors.white.withOpacity(0.2)
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Flutter Acrylic'),
        ),
        body: Center(),
      ),
    );
  }
}
