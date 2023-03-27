import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_acrylic/widgets/transparent_macos_sidebar.dart';

import 'top_bar.dart';

class SidebarFrame extends StatefulWidget {
  final Widget child;
  final Widget sidebar;
  final MacOSBlurViewState macOSBlurViewState;

  const SidebarFrame({
    Key? key,
    required this.sidebar,
    required this.child,
    required this.macOSBlurViewState,
  }) : super(key: key);

  @override
  State<SidebarFrame> createState() => _SidebarFrameState();
}

class _SidebarFrameState extends State<SidebarFrame> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    if (!Platform.isMacOS) {
      return widget.child;
    }

    const sidebarWidth = 250.0;

    return Stack(
      children: [
        Row(
          children: [
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1200),
              curve: Curves.fastLinearToSlowEaseIn,
              tween: Tween<double>(
                begin: _isOpen ? sidebarWidth : 0.0,
                end: _isOpen ? sidebarWidth : 0.0,
              ),
              builder: (BuildContext context, double value, Widget? child) {
                // The TransparentMacOSSidebar needs to be built inside the
                // TweenAnimationBuilder's `build` method because it needs to be
                // rebuilt whenever its size changes so that the visual effect
                // subview gets updated. If you ever find yourself in a
                // situation where a rebuild cannot be guaranteed, check out the
                // VisualEffectSubviewContainerResizeEventRelay class, which
                // lets you control the sidebar's update behavior manually.
                return TransparentMacOSSidebar(
                  state: widget.macOSBlurViewState,
                  child: Container(
                    width: value,
                    padding: const EdgeInsets.only(top: 40.0),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(),
                    child: OverflowBox(
                      minWidth: sidebarWidth,
                      maxWidth: sidebarWidth,
                      child: child,
                    ),
                  ),
                );
              },
              child: widget.sidebar,
            ),
            Container(
              width: 1.0,
              color: Colors.black.withOpacity(0.2),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: widget.child,
              ),
            ),
          ],
        ),
        TopBar(
          onSidebarToggleButtonPressed: () {
            setState(() {
              _isOpen = !_isOpen;
            });
          },
        ),
      ],
    );
  }
}
