import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Acrylic.initialize();
  runApp(const MyApp());
  if (Platform.isWindows) {
    doWhenWindowReady(() {
      Size initialSize = const Size(960, 720);
      appWindow.minSize = const Size(720, 480);
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.show();
    });
  }
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
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const MyAppBody(),
    );
  }
}

class MyAppBody extends StatefulWidget {
  const MyAppBody({Key? key}) : super(key: key);

  @override
  MyAppBodyState createState() => MyAppBodyState();
}

class MyAppBodyState extends State<MyAppBody> {
  AcrylicEffect effect = AcrylicEffect.transparent;
  Color color =
      Platform.isWindows ? const Color(0x00222222) : Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Flutter Acrylic'),
          ),
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 4.0,
                  color: Colors.black,
                  child: SizedBox(
                    height: 5 * 48.0,
                    width: 240.0,
                    child: Column(
                      children: AcrylicEffect.values
                          .map(
                            (effect) => RadioListTile<AcrylicEffect>(
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
                                style: const TextStyle(fontSize: 14.0),
                              ),
                              value: effect,
                              groupValue: this.effect,
                              onChanged: setWindowEffect,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32.0,
                ),
                ElevatedButton(
                  onPressed: Window.enterFullscreen,
                  child: Container(
                    alignment: Alignment.center,
                    height: 28.0,
                    width: 140.0,
                    child: const Text('Enter Fullscreen'),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                ElevatedButton(
                  onPressed: Window.exitFullscreen,
                  child: Container(
                    alignment: Alignment.center,
                    height: 28.0,
                    width: 140.0,
                    child: const Text('Exit Fullscreen'),
                  ),
                ),
                const SizedBox(
                  height: 32.0,
                ),
                const Text(
                  'More features coming soon!',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Platform.isWindows
            ? WindowTitleBarBox(
                child: MoveWindow(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 56.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MinimizeWindowButton(
                          colors: WindowButtonColors(
                              iconNormal: Colors.white,
                              mouseOver: Colors.white.withOpacity(0.1),
                              mouseDown: Colors.white.withOpacity(0.2),
                              iconMouseOver: Colors.white,
                              iconMouseDown: Colors.white),
                        ),
                        MaximizeWindowButton(
                          colors: WindowButtonColors(
                              iconNormal: Colors.white,
                              mouseOver: Colors.white.withOpacity(0.1),
                              mouseDown: Colors.white.withOpacity(0.2),
                              iconMouseOver: Colors.white,
                              iconMouseDown: Colors.white),
                        ),
                        CloseWindowButton(
                          colors: WindowButtonColors(
                            mouseOver: const Color(0xFFD32F2F),
                            mouseDown: const Color(0xFFB71C1C),
                            iconNormal: Colors.white,
                            iconMouseOver: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    setWindowEffect(effect);
  }

  void setWindowEffect(AcrylicEffect? value) {
    Acrylic.setEffect(effect: value!, gradientColor: color);
    setState(() => effect = value);
  }
}
