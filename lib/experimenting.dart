import 'dart:developer';

import 'package:flutter/material.dart';

class Experimenting extends StatefulWidget {
  const Experimenting({
    super.key,
  }) : super();

  @override
  State<Experimenting> createState() => _ExperimentingState();
}

class _ExperimentingState extends State<Experimenting> {
  List<String> items = ["Item 1", "Item 2", "Item 3", "Item 4"];
  int hoveringIndex = -1; // Index of the item being hovered over

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Drag and Drop Example"),
      ),
      body: DragTarget<String>(
        builder: (context, candidateData, rejectedData) {
          return ReorderableListView.builder(
            onReorder: (oldInddex, newIndex) {
              if (oldInddex < newIndex) {
                newIndex -= 1;
              }
              final item = items.removeAt(oldInddex);
              items.insert(newIndex, item);
            },
            itemCount: items.length,
            itemBuilder: (context, index) {
              // return Container(
              //   color: index == hoveringIndex
              //       ? Colors.blue.withOpacity(0.5)
              //       : null,
              //   child: ListTile(
              //     title: Text(items[index]),
              //   ),
              // );

              return LongPressDraggable<String>(
                key: ValueKey(items[index]),
                data: items[index],
                feedback: SizedBox(
                  width: 50,
                  height: 50,
                  child: Material(
                    child: Container(
                      color: Colors.transparent,
                      child: Text(items[index]),
                    ),
                  ),
                ),
                childWhenDragging: Container(),
                child: Container(
                  color: index == hoveringIndex
                      ? Colors.blue.withOpacity(0.5)
                      : null,
                  child: AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: SizedBox(
                          height: index == hoveringIndex ? 20 : 50,
                          child: Text(items[index]))),
                ),
              );
            },
          );
        },
        onLeave: (data) {
          // Perform the action when an item is dragged away from the target
          setState(() {
            hoveringIndex = -1;
          });
        },
        onWillAccept: (details) {
          // Perform the action when an item is dragged over the target
          return true;
        },
        onAcceptWithDetails: (details) {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final localPosition = renderBox.globalToLocal(details.offset);
          final index = (localPosition.dy / 50).floor();

          if (index >= 0 && index < items.length) {
            setState(() {
              hoveringIndex = index;
            });
            if (details.data != items[hoveringIndex]) {
              final item = items.removeAt(items.indexOf(details.data));
              items.insert(hoveringIndex, item);
            }
          } else {
            setState(() {
              hoveringIndex = -1;
            });
          }
        },
        onMove: (details) {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final localPosition = renderBox.globalToLocal(details.offset);
          final index = (localPosition.dy / kMinInteractiveDimension).floor();

          if (index >= 0 && index < items.length) {
            setState(() {
              hoveringIndex = index;
            });
          } else {
            setState(() {
              hoveringIndex = -1;
            });
          }
        },
        onAccept: (data) {
          // Perform the action when an item is dropped on the target
          setState(() {
            hoveringIndex = -1;
          });
        },
      ),
    );
  }
}
