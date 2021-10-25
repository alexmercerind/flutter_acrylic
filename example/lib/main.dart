import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_acrylic/flutter_acrylic.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        splashFactory: InkRipple.splashFactory,
      ),
      darkTheme: ThemeData.dark().copyWith(
        splashFactory: InkRipple.splashFactory,
      ),
      themeMode: ThemeMode.dark,
      home: MyAppBody(),
    );
  }
}

class MyAppBody extends StatefulWidget {
  MyAppBody({Key? key}) : super(key: key);

  @override
  MyAppBodyState createState() => MyAppBodyState();
}

class MyAppBodyState extends State<MyAppBody> {
  WindowEffect effect = WindowEffect.transparent;
  Color color = Platform.isWindows ? Color(0x00222222) : Colors.transparent;

  @override
  void initState() {
    super.initState();
    this.setWindowEffect(this.effect);
  }

  void setWindowEffect(WindowEffect? value) {
    Window.setEffect(
      effect: value!,
      color: this.color,
      dark: true,
    );
    this.setState(() => this.effect = value);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0, bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Flutter Acrylic',
                        style: TextStyle(
                          fontSize: 32.0,
                        ),
                      ),
                      Text('github.com/alexmercerind/flutter_acrylic'),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: WindowEffect.values
                      .map(
                        (effect) => RadioListTile<WindowEffect>(
                          title: Text(
                              effect
                                      .toString()
                                      .split('.')
                                      .last[0]
                                      .toUpperCase() +
                                  effect
                                      .toString()
                                      .split('.')
                                      .last
                                      .substring(1),
                              style: TextStyle(fontSize: 14.0)),
                          value: effect,
                          groupValue: this.effect,
                          onChanged: this.setWindowEffect,
                        ),
                      )
                      .toList(),
                ),
                SizedBox(
                  height: 48.0,
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.start,
                  children: [
                    MaterialButton(
                      onPressed: Window.hideWindowControls,
                      child: Container(
                        alignment: Alignment.center,
                        height: 28.0,
                        width: 140.0,
                        child: Text('Hide controls'),
                      ),
                    ),
                    MaterialButton(
                      onPressed: Window.showWindowControls,
                      child: Container(
                        alignment: Alignment.center,
                        height: 28.0,
                        width: 140.0,
                        child: Text('Show controls'),
                      ),
                    ),
                    MaterialButton(
                      onPressed: Window.enterFullscreen,
                      child: Container(
                        alignment: Alignment.center,
                        height: 28.0,
                        width: 140.0,
                        child: Text('Enter fullscreen'),
                      ),
                    ),
                    MaterialButton(
                      onPressed: Window.exitFullscreen,
                      child: Container(
                        alignment: Alignment.center,
                        height: 28.0,
                        width: 140.0,
                        child: Text('Exit fullscreen'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
