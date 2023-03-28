import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_acrylic/widgets/visual_effect_subview_container/visual_effect_subview_container.dart';
import 'package:flutter_acrylic_example/widgets/macos_action_menu/macos_action_menu.dart';
import 'package:flutter_acrylic_example/widgets/sidebar_frame/sidebar_frame.dart';

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
  MacOSBlurViewState macOSBlurViewState =
      MacOSBlurViewState.followsWindowActiveState;

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
          dark: brightness == InterfaceBrightness.dark,
        );
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

  /// Lets the madness begin! (macOS only.)
  ///
  /// This method plays a silly little effect that is achieved using visual
  /// effect subviews. It is designed to showcase a low-level approach to using
  /// visual effect subviews without relying on the
  /// [VisualEffectSubviewContainer] widget.
  ///
  /// In most cases, using the container widget is preferable, though, due to
  /// its ease of use.
  void letTheMadnessBegin() async {
    final random = Random();
    final windowWidth = MediaQuery.of(context).size.width;
    final windowHeight = MediaQuery.of(context).size.height;
    for (var i = 0; i < 10; i += 1) {
      // Create some random visual effect view.
      final size = random.nextDouble() * 64.0 + 32.0;
      final speed = random.nextDouble() * 2.0 + 2.0;
      var frameX = -size - random.nextDouble() * 32.0;
      final frameY = random.nextDouble() * windowHeight;

      // Remember to store its ID.
      final subviewId =
          await Window.addVisualEffectSubview(VisualEffectSubviewProperties(
        effect: WindowEffect.hudWindow,
        alphaValue: random.nextDouble(),
        cornerRadius: random.nextDouble() * 48.0,
        cornerMask: random.nextInt(16),
        frameX: frameX,
        frameY: frameY,
        frameWidth: size,
        frameHeight: size,
      ));

      Timer.periodic(const Duration(milliseconds: 8), (timer) {
        // Now, let's periodically update its position:
        frameX += speed;
        Window.updateVisualEffectSubviewProperties(
          subviewId,
          VisualEffectSubviewProperties(
            frameX: frameX,
            frameY: frameY + sin(frameX * 0.01) * 32.0,
          ),
        );

        if (frameX > windowWidth) {
          // Remember to remove the visual effect subview when you no longer
          // need it.
          Window.removeVisualEffectSubview(subviewId);
          timer.cancel();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // The [TitlebarSafeArea] widget is required when running on macOS and
    // enabling the full-size content view using
    // [Window.setFullSizeContentView]. It ensures that its child is not covered
    // by the macOS title bar.
    return TitlebarSafeArea(
      child: SidebarFrame(
        macOSBlurViewState: macOSBlurViewState,
        sidebar: SizedBox.expand(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'Sidebar',
                      style: TextStyle(
                        color: brightness.getForegroundColor(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12.0,
                    ),
                    child: Text(
                      'This is an example of a sidebar that has been '
                      'implemented using the TransparentMacOSSidebar widget.',
                      style: TextStyle(
                        color: brightness.getForegroundColor(context),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 12.0,
                    ),
                    child: Text(
                      'Check out the sidebar_frame.dart file to see how it '
                      'has been implemented!',
                      style: TextStyle(
                        color: brightness.getForegroundColor(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 12.0,
                    ),
                    child: Text(
                      'Press the following button if you would like to see '
                      'some visual effect subview madness:',
                      style: TextStyle(
                        color: brightness.getForegroundColor(context),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 12.0,
                    ),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: letTheMadnessBegin,
                        child: Text('Let the madness begin!'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
                            color: brightness.getForegroundColor(context),
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'github.com/alexmercerind/flutter_acrylic',
                          style: TextStyle(
                            color: brightness.getForegroundColor(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: buildEffectMenu(context),
                  ),
                  Divider(
                    height: 1.0,
                    color: brightness == InterfaceBrightness.dark
                        ? Colors.white12
                        : Colors.black12,
                  ),
                  buildActionButtonBar(context),
                  buildMacOSActionMenuOpener(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ButtonBar buildActionButtonBar(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.start,
      overflowButtonSpacing: 4.0,
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

  Widget buildMacOSActionMenuOpener(BuildContext context) {
    if (!Platform.isMacOS) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 12.0, left: 12.0),
      child: Row(
        children: [
          Text(
            'macOS actions:',
            style: TextStyle(
              fontSize: 16.0,
              color: brightness.getForegroundColor(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16.0),
          OutlinedButton(
            child: Text('show all actions'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return Theme(
                    data: brightness.getIsDark(context)
                        ? ThemeData.dark()
                        : ThemeData.light(),
                    child: LayoutBuilder(builder: (_, constraints) {
                      return Center(
                        child: SizedBox(
                          width: min(512.0, constraints.maxWidth - 32.0),
                          height: constraints.maxHeight - 32.0,
                          child: MacOSActionMenu(
                            items: [
                              MacOSActionMenuItem(
                                name: 'Set Document Edited',
                                function: () => Window.setDocumentEdited(),
                                description:
                                    'This will change the appearance of the '
                                    'close button on the titlebar.',
                              ),
                              MacOSActionMenuItem(
                                name: 'Set Document Unedited',
                                function: () => Window.setDocumentUnedited(),
                              ),
                              MacOSActionMenuItem(
                                name: 'Set Represented Filename',
                                function: () =>
                                    Window.setRepresentedFilename('filename'),
                              ),
                              MacOSActionMenuItem(
                                name: 'Set Represented URL',
                                function: () => Window.setRepresentedUrl('url'),
                              ),
                              MacOSActionMenuItem(
                                name: 'Hide Title',
                                function: () => Window.hideTitle(),
                              ),
                              MacOSActionMenuItem(
                                name: 'Show Title',
                                function: () => Window.showTitle(),
                              ),
                              MacOSActionMenuItem(
                                name: 'Make Titlebar Transparent',
                                function: () =>
                                    Window.makeTitlebarTransparent(),
                              ),
                              MacOSActionMenuItem(
                                name: 'Make Titlebar Opaque',
                                function: () => Window.makeTitlebarOpaque(),
                              ),
                              MacOSActionMenuItem(
                                name: 'Enable Full Size Content View',
                                function: () =>
                                    Window.enableFullSizeContentView(),
                                description:
                                    'This expands the area that Flutter '
                                    'can draw to to fill the entire '
                                    'window. It is recommended to enable '
                                    'the full-size content view when '
                                    'making the titlebar transparent.',
                              ),
                              MacOSActionMenuItem(
                                name: 'Disable Full Size Content View',
                                function: () =>
                                    Window.disableFullSizeContentView(),
                              ),
                              MacOSActionMenuItem(
                                name: 'Zoom Window',
                                function: () => Window.zoomWindow(),
                              ),
                              MacOSActionMenuItem(
                                name: 'Unzoom Window',
                                function: () => Window.unzoomWindow(),
                              ),
                              MacOSActionMenuItem(
                                name: 'Hide Zoom Button',
                                function: () => Window.hideZoomButton(),
                              ),
                              MacOSActionMenuItem(
                                name: 'Show Zoom Button',
                                function: () => Window.showZoomButton(),
                              ),
                              MacOSActionMenuItem(
                                name: 'Hide Miniaturize Button',
                                function: () => Window.hideMiniaturizeButton(),
                              ),
                              MacOSActionMenuItem(
                                name: 'Show Miniaturize Button',
                                function: () => Window.showMiniaturizeButton(),
                              ),
                              MacOSActionMenuItem(
                                name: 'Hide Close Button',
                                function: () => Window.hideCloseButton(),
                              ),
                              MacOSActionMenuItem(
                                name: 'Show Close Button',
                                function: () => Window.showCloseButton(),
                              ),
                              MacOSActionMenuItem(
                                name: 'Enable Zoom Button',
                                function: () => Window.enableZoomButton(),
                              ),
                              MacOSActionMenuItem(
                                name: 'Disable Zoom Button',
                                function: () => Window.disableZoomButton(),
                              ),
                              MacOSActionMenuItem(
                                name: 'Enable Miniaturize Button',
                                function: () =>
                                    Window.enableMiniaturizeButton(),
                              ),
                              MacOSActionMenuItem(
                                name: 'Disable Miniaturize Button',
                                function: () =>
                                    Window.disableMiniaturizeButton(),
                              ),
                              MacOSActionMenuItem(
                                name: 'Enable Close Button',
                                function: () => Window.enableCloseButton(),
                              ),
                              MacOSActionMenuItem(
                                name: 'Disable Close Button',
                                function: () => Window.disableCloseButton(),
                              ),
                              MacOSActionMenuItem(
                                name: 'Set Window Alpha Value to 0.5',
                                function: () => Window.setWindowAlphaValue(0.5),
                              ),
                              MacOSActionMenuItem(
                                name: 'Set Window Alpha Value to 0.75',
                                function: () =>
                                    Window.setWindowAlphaValue(0.75),
                              ),
                              MacOSActionMenuItem(
                                name: 'Set Window Alpha Value to 1.0',
                                function: () => Window.setWindowAlphaValue(1.0),
                              ),
                              MacOSActionMenuItem(
                                name: 'Set Window Background Color to Default '
                                    'Color',
                                function: () => Window
                                    .setWindowBackgroundColorToDefaultColor(),
                                description:
                                    'Sets the window background color to '
                                    'the default (opaque) window color.',
                              ),
                              MacOSActionMenuItem(
                                name: 'Set Window Background Color to Clear',
                                function: () =>
                                    Window.setWindowBackgroundColorToClear(),
                              ),
                              MacOSActionMenuItem(
                                name: 'Set Blur View State to Active',
                                function: () {
                                  setState(() {
                                    macOSBlurViewState =
                                        MacOSBlurViewState.active;
                                  });
                                  Window.setBlurViewState(
                                    MacOSBlurViewState.active,
                                  );
                                },
                              ),
                              MacOSActionMenuItem(
                                name: 'Set Blur View State to Inactive',
                                function: () {
                                  setState(
                                    () {
                                      macOSBlurViewState =
                                          MacOSBlurViewState.inactive;
                                    },
                                  );
                                  Window.setBlurViewState(
                                    MacOSBlurViewState.inactive,
                                  );
                                },
                              ),
                              MacOSActionMenuItem(
                                name: 'Set Blur View State to Follows '
                                    'Window Active State',
                                function: () {
                                  setState(
                                    () {
                                      macOSBlurViewState = MacOSBlurViewState
                                          .followsWindowActiveState;
                                    },
                                  );
                                  Window.setBlurViewState(MacOSBlurViewState
                                      .followsWindowActiveState);
                                },
                              ),
                              MacOSActionMenuItem(
                                name: 'Add Toolbar',
                                function: () => Window.addToolbar(),
                              ),
                              MacOSActionMenuItem(
                                name: 'Remove Toolbar',
                                function: () => Window.removeToolbar(),
                              ),
                              MacOSActionMenuItem(
                                name: 'Set Toolbar Style to Automatic',
                                function: () => Window.setToolbarStyle(
                                  toolbarStyle: MacOSToolbarStyle.automatic,
                                ),
                                description:
                                    'For this method to have an effect, the '
                                    'window needs to have had a toolbar '
                                    'added beforehand. This can be achieved '
                                    'using the “Add Toolbar” action.',
                              ),
                              MacOSActionMenuItem(
                                name: 'Set Toolbar Style to Expanded',
                                function: () => Window.setToolbarStyle(
                                  toolbarStyle: MacOSToolbarStyle.expanded,
                                ),
                                description:
                                    'For this method to have an effect, '
                                    'the window needs to have had a toolbar '
                                    'added beforehand. This can be achieved '
                                    'using the “Add Toolbar” action.',
                              ),
                              MacOSActionMenuItem(
                                name: 'Set Toolbar Style to Preference',
                                function: () => Window.setToolbarStyle(
                                  toolbarStyle: MacOSToolbarStyle.preference,
                                ),
                                description:
                                    'For this method to have an effect, the '
                                    'window needs to have had a toolbar '
                                    'added beforehand. This can be achieved '
                                    'using the “Add Toolbar” action.',
                              ),
                              MacOSActionMenuItem(
                                name: 'Set Toolbar Style to Unified',
                                function: () => Window.setToolbarStyle(
                                  toolbarStyle: MacOSToolbarStyle.unified,
                                ),
                                description:
                                    'For this method to have an effect, the '
                                    'window needs to have had a toolbar '
                                    'added beforehand. This can be achieved '
                                    'using the “Add Toolbar” action.',
                              ),
                              MacOSActionMenuItem(
                                name: 'Set Toolbar Style to Unified Compact',
                                function: () => Window.setToolbarStyle(
                                  toolbarStyle:
                                      MacOSToolbarStyle.unifiedCompact,
                                ),
                                description:
                                    'For this method to have an effect, the '
                                    'window needs to have had a toolbar '
                                    'added beforehand. This can be achieved '
                                    'using the “Add Toolbar” action.',
                              ),
                              MacOSActionMenuItem(
                                name: 'Enable Shadow',
                                function: () => Window.enableShadow(),
                              ),
                              MacOSActionMenuItem(
                                name: 'Disable Shadow',
                                function: () => Window.disableShadow(),
                              ),
                              MacOSActionMenuItem(
                                name: 'Invalidate Shadows',
                                function: () => Window.invalidateShadows(),
                                description:
                                    'This is a fairly technical action and '
                                    'is included here for completeness\' '
                                    'sake. Normally, it should not be '
                                    'necessary to use it.',
                              ),
                              MacOSActionMenuItem(
                                name: 'Add Empty Mask Image',
                                function: () => Window.addEmptyMaskImage(),
                                description:
                                    'This will effectively disable the '
                                    '`NSVisualEffectView`\'s effect.\n\n'
                                    '**Warning:** It is recommended to '
                                    'disable the window\'s shadow using '
                                    '`Window.disableShadow()` when using '
                                    'this method. Keeping the shadow '
                                    'enabled when using an empty mask image '
                                    'can cause visual artifacts and '
                                    'performance issues.',
                              ),
                              MacOSActionMenuItem(
                                name: 'Remove Mask Image',
                                function: () => Window.removeMaskImage(),
                              ),
                              MacOSActionMenuItem(
                                name: 'Make Window Fully Transparent',
                                function: () =>
                                    Window.makeWindowFullyTransparent(),
                                description: 'Makes a window fully transparent '
                                    '(with no blur effect). This is a '
                                    'convenience function which executes:\n'
                                    '```dart\n'
                                    'setWindowBackgroundColorToClear();\n'
                                    'makeTitlebarTransparent();\n'
                                    'addEmptyMaskImage();\n'
                                    'disableShadow();\n```\n**Warning:** '
                                    'When the window is fully transparent, '
                                    'its highlight effect (the thin white '
                                    'line at the top of the window) is '
                                    'still visible. This is considered a '
                                    'bug and may change in a future version.',
                              ),
                              MacOSActionMenuItem(
                                name: 'Ignore Mouse Events',
                                function: () {
                                  Window.ignoreMouseEvents();
                                  Timer(
                                    const Duration(seconds: 5),
                                    () => Window.acknowledgeMouseEvents(),
                                  );
                                },
                                description:
                                    'This action can be used to make parts '
                                    'of the window click-through, which may '
                                    'be desirable when used in conjunction '
                                    'with '
                                    '`Window.makeWindowFullyTransparent()`.'
                                    '\n\n**Note:** Executing this action '
                                    'will make this widow click-through, '
                                    'thus making it impossible to perform '
                                    'the “Acknowledge Mouse Events” again. '
                                    'For this reason, the example app '
                                    'automatically starts acknowledging '
                                    'mouse events again after five seconds.',
                              ),
                              MacOSActionMenuItem(
                                name: 'Acknowledge Mouse Events',
                                function: () => Window.acknowledgeMouseEvents(),
                                description: 'This action is included here for '
                                    'completeness\' sake, however it is '
                                    'technically impossible to run it after '
                                    'performing the “Ignore Mouse Events” '
                                    'action, since the “show all actions” '
                                    'button can then no longer be clicked.',
                              ),
                              MacOSActionMenuItem(
                                name: 'Set Subtitle',
                                function: () => Window.setSubtitle('subtitle'),
                              ),
                              MacOSActionMenuItem(
                                name: 'Remove Subtitle',
                                function: () => Window.setSubtitle(''),
                                description: 'The action works by setting the '
                                    'subtitle to an empty string using '
                                    '`Window.setSubtitle(\'\')`. There is no '
                                    'method called `Window.removeSubtitle()`.',
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  SingleChildScrollView buildEffectMenu(BuildContext context) {
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
                  title: Text(
                    effect.toString(),
                    style: TextStyle(
                      fontSize: 14.0,
                      color: brightness.getForegroundColor(context),
                    ),
                  ),
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
                  const Spacer(),
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
