import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_acrylic_example/widgets/macos_action_menu/description_display.dart';

import 'action_list/action_list.dart';

class MacOSActionMenu extends StatefulWidget {
  final List<MacOSActionMenuItem> items;

  const MacOSActionMenu({Key? key, required this.items}) : super(key: key);

  @override
  State<MacOSActionMenu> createState() => _MacOSActionMenuState();
}

class _MacOSActionMenuState extends State<MacOSActionMenu> {
  String _searchString = '';
  int _selectedIndex = 0;
  late List<MacOSActionMenuItem> _filteredItems;

  int get _legalSelectedIndex =>
      max(0, min(_filteredItems.length - 1, _selectedIndex));

  void _updateFilteredItems() {
    _filteredItems = widget.items.where((element) {
      return element.name
          .toLowerCase()
          .replaceAll(' ', '')
          .contains(_searchString.toLowerCase().replaceAll(' ', ''));
    }).toList();
  }

  @override
  void initState() {
    super.initState();

    _updateFilteredItems();
  }

  @override
  Widget build(BuildContext context) {
    return TitlebarSafeArea(
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        child: Focus(
          onKeyEvent: (focusNode, event) {
            if (event is KeyDownEvent || event is KeyRepeatEvent) {
              if (event.physicalKey == PhysicalKeyboardKey.arrowDown) {
                setState(() {
                  _selectedIndex = _legalSelectedIndex + 1;
                });

                return KeyEventResult.handled;
              }

              if (event.physicalKey == PhysicalKeyboardKey.arrowUp) {
                setState(() {
                  _selectedIndex = _legalSelectedIndex - 1;
                });

                return KeyEventResult.handled;
              }

              if (event.physicalKey == PhysicalKeyboardKey.enter) {
                _filteredItems[_legalSelectedIndex].function();
                Navigator.of(context).maybePop();

                return KeyEventResult.handled;
              }
            }

            return KeyEventResult.ignored;
          },
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'Search for a macOS action to perform:',
                      ),
                      onChanged: ((value) => setState(() {
                            _searchString = value;
                            _updateFilteredItems();
                            _selectedIndex = 0;
                          })),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ActionList(
                        selectedIndex: _legalSelectedIndex,
                        items: _filteredItems,
                        selectItem: (newIndex) => setState(() {
                          _selectedIndex = newIndex;
                        }),
                        performItemAction: (item) {
                          item.function();
                          Navigator.of(context).maybePop();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              DescriptionDisplay(
                description: _filteredItems.isEmpty
                    ? null
                    : _filteredItems[_legalSelectedIndex].description,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MacOSActionMenuItem {
  final String name;
  final void Function() function;
  final String? description;

  MacOSActionMenuItem({
    required this.name,
    required this.function,
    this.description,
  });
}
