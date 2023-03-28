import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

/// A widget that displays an action menu item's description at the bottom of
/// the action menu.
class DescriptionDisplay extends StatelessWidget {
  static const maxHeight = 150.0;

  const DescriptionDisplay({Key? key, this.description}) : super(key: key);

  final String? description;

  @override
  Widget build(BuildContext context) {
    if (description == null) {
      return const SizedBox();
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(5.0),
          ),
          boxShadow: [
            // This shadows serves as a top-border.
            BoxShadow(
              color: Theme.of(context).canvasColor,
              offset: const Offset(0.0, -0.5),
            ),
          ],
        ),
        child: Markdown(
          data: description!,
          shrinkWrap: true,
          padding: EdgeInsets.all(8.0),
        ),
      ),
    );
  }
}
