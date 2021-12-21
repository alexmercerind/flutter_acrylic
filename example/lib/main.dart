import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  if (Platform.isWindows) {
    await Window.hideWindowControls();
  }
  runApp(MyApp());
  if (Platform.isWindows) {
    doWhenWindowReady(() {
      appWindow
        ..minSize = Size(640, 360)
        ..size = Size(720, 540)
        ..alignment = Alignment.center
        ..show();
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
  Color color = Platform.isWindows ? Color(0xCC222222) : Colors.transparent;
  InterfaceBrightness brightness =
      Platform.isMacOS ? InterfaceBrightness.auto : InterfaceBrightness.dark;

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
    if (Platform.isMacOS) {
      if (brightness != InterfaceBrightness.auto) {
        Window.overrideMacOSBrightness(
            dark: brightness == InterfaceBrightness.dark);
      }
    }
    this.setState(() => this.effect = value);
  }

  void setBrightness(InterfaceBrightness brightness) {
    this.brightness = brightness;
    if (this.brightness == InterfaceBrightness.dark) {
      color = Platform.isWindows ? Color(0xCC222222) : Colors.transparent;
    } else {
      color = Platform.isWindows ? Color(0x22DDDDDD) : Colors.transparent;
    }
    this.setWindowEffect(this.effect);
  }

  @override
  Widget build(BuildContext context) {
    // The [TitlebarSafeArea] widget is required when running on macOS and enabling
    // the full-size content view using [Window.setFullSizeContentView]. It ensures
    // that its child is not covered by the macOS title bar.
    return TitlebarSafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WindowTitleBar(
                  brightness: brightness,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    bottom: 20.0,
                    top: 12.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Flutter Acrylic',
                        style: TextStyle(
                            fontSize: 32.0,
                            color: brightness.getForegroundColor(context)),
                      ),
                      SizedBox(height: 4.0),
                      Text('github.com/alexmercerind/flutter_acrylic',
                          style: TextStyle(
                              color: brightness.getForegroundColor(context))),
                    ],
                  ),
                ),
                Expanded(
                  child: generateEffectMenu(context),
                ),
                Divider(
                  height: 1.0,
                  color: brightness == InterfaceBrightness.dark
                      ? Colors.white12
                      : Colors.black12,
                ),
                generateActionButtonBar(context),
                generateMacOSActionButtonBar(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ButtonBar generateActionButtonBar(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () => setState(() {
            setBrightness(
              brightness == InterfaceBrightness.dark
                  ? InterfaceBrightness.light
                  : InterfaceBrightness.dark,
            );
          }),
          child: Text(
            'Dark: ${(() {
              switch (brightness) {
                case InterfaceBrightness.light:
                  return 'light';
                case InterfaceBrightness.dark:
                  return 'dark';
                default:
                  return 'auto';
              }
            })()}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: Window.hideWindowControls,
          child: Text(
            'Hide controls',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: Window.showWindowControls,
          child: Text(
            'Show controls',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: Window.enterFullscreen,
          child: Text(
            'Enter fullscreen',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: Window.exitFullscreen,
          child: Text(
            'Exit fullscreen',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget generateMacOSActionButtonBar(BuildContext context) {
    if (!Platform.isMacOS) return const SizedBox();

    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 4.0, top: 12.0),
        child: Text('macOS actions:',
            style: TextStyle(
              fontSize: 16.0,
              color: brightness.getForegroundColor(context),
              fontWeight: FontWeight.bold,
            )),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ['Set Document Edited', () => Window.setDocumentEdited()],
              ['Set Document Unedited', () => Window.setDocumentUnedited()],
              [
                'Set Represented Filename',
                () => Window.setRepresentedFilename('filename')
              ],
              ['Set Represented Url', () => Window.setRepresentedUrl('url')],
              ['Hide Title', () => Window.hideTitle()],
              ['Show Title', () => Window.showTitle()],
              [
                'Make Titlebar Transparent',
                () => Window.makeTitlebarTransparent()
              ],
              ['Make Titlebar Opaque', () => Window.makeTitlebarOpaque()],
              [
                'Enable Full Size Content View',
                () => Window.enableFullSizeContentView()
              ],
              [
                'Disable Full Size Content View',
                () => Window.disableFullSizeContentView()
              ],
              ['Zoom Window', () => Window.zoomWindow()],
              ['Unzoom Window', () => Window.unzoomWindow()],
              ['Hide Zoom Button', () => Window.hideZoomButton()],
              ['Show Zoom Button', () => Window.showZoomButton()],
              ['Hide Miniaturize Button', () => Window.hideMiniaturizeButton()],
              ['Show Miniaturize Button', () => Window.showMiniaturizeButton()],
              ['Hide Close Button', () => Window.hideCloseButton()],
              ['Show Close Button', () => Window.showCloseButton()],
              ['Enable Zoom Button', () => Window.enableZoomButton()],
              ['Disable Zoom Button', () => Window.disableZoomButton()],
              [
                'Enable Miniaturize Button',
                () => Window.enableMiniaturizeButton()
              ],
              [
                'Disable Miniaturize Button',
                () => Window.disableMiniaturizeButton()
              ],
              ['Enable Close Button', () => Window.enableCloseButton()],
              ['Disable Close Button', () => Window.disableCloseButton()],
              [
                'Set Window Alpha Value to 0.5',
                () => Window.setWindowAlphaValue(0.5)
              ],
              [
                'Set Window Alpha Value to 0.75',
                () => Window.setWindowAlphaValue(0.75)
              ],
              [
                'Set Window Alpha Value to 1.0',
                () => Window.setWindowAlphaValue(1.0)
              ],
              [
                'Set Window Background Color to Default Color',
                () => Window.setWindowBackgroundColorToDefaultColor()
              ],
              [
                'Set Window Background Color to Clear',
                () => Window.setWindowBackgroundColorToClear()
              ],
              [
                'Set Blur View State to Active',
                () => Window.setBlurViewState(MacOSBlurViewState.active)
              ],
              [
                'Set Blur View State to Inactive',
                () => Window.setBlurViewState(MacOSBlurViewState.inactive)
              ],
              [
                'Set Blur View State to Follows Window Active State',
                () => Window.setBlurViewState(
                    MacOSBlurViewState.followsWindowActiveState)
              ],
            ]
                .map((e) => MaterialButton(
                      child: Text(
                        e[0] as String,
                        style: TextStyle(
                            color: brightness.getForegroundColor(context)),
                      ),
                      onPressed: e[1] as void Function(),
                    ))
                .toList(),
          ),
        ),
      ),
    ]);
  }

  SingleChildScrollView generateEffectMenu(BuildContext context) {
    return SingleChildScrollView(
      child: Theme(
        data: brightness.getIsDark(context)
            ? ThemeData.dark()
            : ThemeData.light(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: (Platform.isWindows
                  ? WindowEffect.values.take(7)
                  : WindowEffect.values)
              .map(
                (effect) => RadioListTile<WindowEffect>(
                  title: Text(effect.toString(),
                      style: TextStyle(
                        fontSize: 14.0,
                        color: brightness.getForegroundColor(context),
                      )),
                  value: effect,
                  groupValue: this.effect,
                  onChanged: this.setWindowEffect,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class WindowTitleBar extends StatelessWidget {
  final InterfaceBrightness brightness;
  const WindowTitleBar({Key? key, required this.brightness}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isWindows
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: 32.0,
            color: Colors.transparent,
            child: MoveWindow(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  MinimizeWindowButton(
                    colors: WindowButtonColors(
                      iconNormal: brightness == InterfaceBrightness.light
                          ? Colors.black
                          : Colors.white,
                      iconMouseDown: brightness == InterfaceBrightness.light
                          ? Colors.black
                          : Colors.white,
                      iconMouseOver: brightness == InterfaceBrightness.light
                          ? Colors.black
                          : Colors.white,
                      normal: Colors.transparent,
                      mouseOver: brightness == InterfaceBrightness.light
                          ? Colors.black.withOpacity(0.04)
                          : Colors.white.withOpacity(0.04),
                      mouseDown: brightness == InterfaceBrightness.light
                          ? Colors.black.withOpacity(0.08)
                          : Colors.white.withOpacity(0.08),
                    ),
                  ),
                  MaximizeWindowButton(
                    colors: WindowButtonColors(
                      iconNormal: brightness == InterfaceBrightness.light
                          ? Colors.black
                          : Colors.white,
                      iconMouseDown: brightness == InterfaceBrightness.light
                          ? Colors.black
                          : Colors.white,
                      iconMouseOver: brightness == InterfaceBrightness.light
                          ? Colors.black
                          : Colors.white,
                      normal: Colors.transparent,
                      mouseOver: brightness == InterfaceBrightness.light
                          ? Colors.black.withOpacity(0.04)
                          : Colors.white.withOpacity(0.04),
                      mouseDown: brightness == InterfaceBrightness.light
                          ? Colors.black.withOpacity(0.08)
                          : Colors.white.withOpacity(0.08),
                    ),
                  ),
                  CloseWindowButton(
                    onPressed: () {
                      appWindow.close();
                    },
                    colors: WindowButtonColors(
                      iconNormal: brightness == InterfaceBrightness.light
                          ? Colors.black
                          : Colors.white,
                      iconMouseDown: brightness == InterfaceBrightness.light
                          ? Colors.black
                          : Colors.white,
                      iconMouseOver: brightness == InterfaceBrightness.light
                          ? Colors.black
                          : Colors.white,
                      normal: Colors.transparent,
                      mouseOver: brightness == InterfaceBrightness.light
                          ? Colors.black.withOpacity(0.04)
                          : Colors.white.withOpacity(0.04),
                      mouseDown: brightness == InterfaceBrightness.light
                          ? Colors.black.withOpacity(0.08)
                          : Colors.white.withOpacity(0.08),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }
}
