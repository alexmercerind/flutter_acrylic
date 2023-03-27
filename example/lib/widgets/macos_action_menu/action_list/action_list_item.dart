import 'dart:async';

import 'package:flutter/material.dart';

/// An item to be displayed in the action list.
class ActionListItem extends StatefulWidget {
  const ActionListItem({
    Key? key,
    required this.name,
    required this.function,
    required this.isSelected,
    required this.select,
    required this.perform,
  }) : super(key: key);

  final String name;
  final void Function() function;
  final bool isSelected;
  final void Function() select;
  final void Function() perform;

  @override
  State<ActionListItem> createState() => _ActionListItemState();
}

class _ActionListItemState extends State<ActionListItem> {
  final _globalKey = GlobalKey();
  bool _isBeingHoveredOver = false;

  void _ensureVisible() {
    if (_globalKey.currentContext == null) {
      return;
    }

    Scrollable.ensureVisible(
      _globalKey.currentContext!,
      alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
    );
    Scrollable.ensureVisible(
      _globalKey.currentContext!,
      alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
    );
  }

  @override
  void initState() {
    // Run `_ensureVisible` through a timer to ensure that it runs after the
    // `build` method has already run.
    if (widget.isSelected) {
      Timer(const Duration(), _ensureVisible);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSelected) {
      _ensureVisible();
    }

    return GestureDetector(
      key: _globalKey,
      onTap: widget.isSelected ? widget.perform : widget.select,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) => setState(() {
          _isBeingHoveredOver = true;
        }),
        onExit: (event) => setState(() {
          _isBeingHoveredOver = false;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 50),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .background
                .withOpacity(_getBackgroundOpacity()),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 100),
                opacity: widget.isSelected ? 1.0 : 0.5,
                child: Text(
                  widget.name,
                  style: TextStyle(
                    fontWeight:
                        widget.isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _getBackgroundOpacity() {
    if (widget.isSelected) {
      return 1.0;
    }

    return _isBeingHoveredOver ? 0.5 : 0.0;
  }
}
