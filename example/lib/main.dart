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

enum InterfaceBrightness {
  light,
  dark,
  auto,
}

extension InterfaceBrightnessExtension on InterfaceBrightness {
  bool getIsDark(BuildContext? context) {
    if (this == InterfaceBrightness.light) return false;
    if (this == InterfaceBrightness.auto) {
      if (context == null) return true;
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    
    return true;
  }
  
  Color getForegroundColor(BuildContext? context) {
    return getIsDark(context) ? Colors.white : Colors.black;
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
  InterfaceBrightness brightness = Platform.isMacOS ? InterfaceBrightness.auto : InterfaceBrightness.dark;

  @override
  void initState() {
    super.initState();
    this.setWindowEffect(this.effect);
  }

  void setWindowEffect(WindowEffect? value) {
    Window.setEffect(
      effect: value!,
      color: this.color,
      dark: brightness == InterfaceBrightness.dark,
    );
    if (brightness != InterfaceBrightness.auto) {
      Window.overrideMacOSBrightness(dark: brightness == InterfaceBrightness.dark);
    }
    this.setState(() => this.effect = value);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
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
                        color: brightness.getForegroundColor(context)
                      ),
                    ),
                    Text(
                      'github.com/alexmercerind/flutter_acrylic',
                      style: TextStyle(
                        color: brightness.getForegroundColor(context)
                      )
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Theme(
                    data: brightness.getIsDark(context) ? ThemeData.dark() : ThemeData.light(),
                    child: Column(
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
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: brightness.getForegroundColor(context),
                                    )
                                  ),
                              value: effect,
                              groupValue: this.effect,
                              onChanged: this.setWindowEffect,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              ButtonBar(
                alignment: MainAxisAlignment.start,
                children: [
                  MaterialButton(
                    onPressed: () => setState(() {
                      brightness = brightness == InterfaceBrightness.dark ? InterfaceBrightness.light : InterfaceBrightness.dark;
                      this.setWindowEffect(this.effect);
                    }),
                    child: Container(
                      alignment: Alignment.center,
                      height: 28.0,
                      width: 140.0,
                      child: Text('Dark: ${(() {
                        switch (brightness) {
                          case InterfaceBrightness.light: return 'light';
                          case InterfaceBrightness.dark: return 'dark';
                          default: return 'auto';
                        }
                      })()}',
                      style: TextStyle(
                        color: brightness.getForegroundColor(context)
                      ),),
                    ),
                  ),
                  MaterialButton(
                    onPressed: Window.hideWindowControls,
                    child: Container(
                      alignment: Alignment.center,
                      height: 28.0,
                      width: 140.0,
                      child: Text(
                        'Hide controls',
                        style: TextStyle(
                          color: brightness.getForegroundColor(context)
                        ),
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: Window.showWindowControls,
                    child: Container(
                      alignment: Alignment.center,
                      height: 28.0,
                      width: 140.0,
                      child: Text(
                        'Show controls',
                        style: TextStyle(
                          color: brightness.getForegroundColor(context)
                        ),
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: Window.enterFullscreen,
                    child: Container(
                      alignment: Alignment.center,
                      height: 28.0,
                      width: 140.0,
                      child: Text(
                        'Enter fullscreen',
                        style: TextStyle(
                          color: brightness.getForegroundColor(context)
                        ),
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: Window.exitFullscreen,
                    child: Container(
                      alignment: Alignment.center,
                      height: 28.0,
                      width: 140.0,
                      child: Text(
                        'Exit fullscreen',
                        style: TextStyle(
                          color: brightness.getForegroundColor(context)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
