import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  }) : super();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NativeDrag(),
    );
  }
}

class NativeDrag extends StatefulWidget {
  const NativeDrag({
    super.key,
  }) : super();

  @override
  State<NativeDrag> createState() => _NativeDragState();
}

class _NativeDragState extends State<NativeDrag> {
  List<String> list1 = ['Item 1', 'Item 2', 'Item 3'];
  List<String> list2 = ['Item 4', 'Item 5', 'Item 6'];

  ScrollController list1Controller = ScrollController();
  ScrollController list2Controller = ScrollController();

  @override
  void dispose() {
    super.dispose();
    list1Controller.dispose();
    list2Controller.dispose();
  }

  insertAtDrop(String data, int index) {
    if (list1.contains(data)) {
      list1.remove(data);
    }
    if (list2.contains(data)) {
      list2.remove(data);
    }
    list2.insert(index, data.toString());

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Drag and Drop"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DragList(
                dragableList: list1,
                onReorder: (oldIndex, newIndex) {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final item = list1.removeAt(oldIndex);
                  list1.insert(newIndex, item);
                  setState(() {});
                },
                onAccept: (details) {
                  String data = details.data as String;
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  Offset offset = renderBox.localToGlobal(Offset.zero);
                  int index = (details.offset.dx - offset.dx) ~/ 100;

                  insertAtDrop(data, index);
                }),
            const SizedBox(
              height: 20,
            ),
            DragList(
                dragableList: list2,
                onReorder: (oldIndex, newIndex) {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final item = list2.removeAt(oldIndex);
                  list2.insert(newIndex, item);
                  setState(() {});
                },
                onAccept: (details) {
                  String data = details.data as String;
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  Offset offset = renderBox.localToGlobal(Offset.zero);
                  int index = (details.offset.dx - offset.dx) ~/ 50;

                  insertAtDrop(data, index);
                }),
          ],
        ),
      ),
    );
  }
}

class DragList extends StatelessWidget {
  const DragList(
      {super.key,
      required this.dragableList,
      required this.onReorder,
      required this.onAccept});
  final List dragableList;
  final void Function(int, int) onReorder;
  final void Function(DragTargetDetails<Object>) onAccept;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 300,
      child: DragTarget(
          onWillAccept: (data) => true,
          onAcceptWithDetails: onAccept,
          builder: (context, candidateData, rejectedData) {
            return ReorderableListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  String title = dragableList[index];
                  return ListItemWidget(
                      title: title, index: index, key: ValueKey(index));
                },
                itemCount: dragableList.length,
                onReorder: onReorder);
          }),
    );
  }
}

class ListItemWidget extends StatelessWidget {
  const ListItemWidget({
    super.key,
    required this.title,
    required this.index,
  }) : super();

  final String title;
  final int index;

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<String>(
      data: title,
      feedback: Material(color: Colors.transparent, child: Text(title)),
      childWhenDragging: const SizedBox(),
      child: SizedBox(height: 50, width: 50, child: Text(title)),
    );
  }
}
