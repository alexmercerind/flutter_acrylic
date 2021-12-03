import 'dart:io';

import 'package:flutter/widgets.dart';

import 'package:flutter_acrylic/flutter_acrylic.dart';

class _MacOSTitlebarSafeArea extends StatefulWidget {
  final Widget child;

  const _MacOSTitlebarSafeArea({Key? key, required this.child})
      : super(key: key);

  @override
  State<_MacOSTitlebarSafeArea> createState() => _MacOSTitlebarSafeAreaState();
}

class _MacOSTitlebarSafeAreaState extends State<_MacOSTitlebarSafeArea> {
  double titlebarHeight = 0.0;

  Future<void> calculateTitlebarHeight() async {
    titlebarHeight = await Window.getTitlebarHeight();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    calculateTitlebarHeight();

    return Padding(
      padding: EdgeInsets.only(top: titlebarHeight),
      child: widget.child,
    );
  }
}

class TitlebarSafeArea extends StatelessWidget {
  final Widget child;

  /// A widget that provides a safe area for its child.
  /// The safe area is the area on the top of the window that is not covered by the title bar.
  /// This widget has no effect when the full-size content view is disabled or when the app is
  /// running on a platform other than macOS.
  /// Example:
  /// ```dart
  /// TitlebarSafeArea(
  ///  child: Text('Hello World'),
  /// )
  /// ```
  const TitlebarSafeArea({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Platform.isMacOS) return child;

    return _MacOSTitlebarSafeArea(child: child);
  }
}
