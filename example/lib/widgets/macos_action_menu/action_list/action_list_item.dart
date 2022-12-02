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
  bool _isBeingHoveredOver = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                .backgroundColor
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
