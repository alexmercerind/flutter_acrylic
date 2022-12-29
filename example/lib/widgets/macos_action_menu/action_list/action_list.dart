import 'package:flutter/material.dart';
import 'package:flutter_acrylic_example/widgets/macos_action_menu/description_display.dart';

import '../macos_action_menu.dart';
import 'action_list_item.dart';

/// A list containing macOS action items.
class ActionList extends StatelessWidget {
  const ActionList({
    Key? key,
    required this.items,
    required this.selectedIndex,
    required this.selectItem,
    required this.performItemAction,
  }) : super(key: key);

  final List<MacOSActionMenuItem> items;
  final int selectedIndex;
  final void Function(int) selectItem;
  final void Function(MacOSActionMenuItem) performItemAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...items
            .asMap()
            .map(((key, value) {
              final item = ActionListItem(
                name: value.name,
                function: value.function,
                isSelected: key == selectedIndex,
                select: () => selectItem(key),
                perform: () => performItemAction(value),
              );

              return MapEntry(key, item);
            }))
            .values
            .toList(),
        // This SizedBox allows for a “scroll past end” effect and is necessary
        // to prevent the DescriptionDisplay from covering the ActionList.
        const SizedBox(height: DescriptionDisplay.maxHeight),
      ],
    );
  }
}
