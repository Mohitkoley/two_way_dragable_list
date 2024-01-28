extension ListExt on List {
  List<E> mergeto<E>(List<E> list) {
    List<E> result = [];
    for (int i = 0; i < length; i++) {
      result.add(this[i] as E);
    }
    for (int i = 0; i < list.length; i++) {
      result.add(list[i]);
    }
    return result;
  }

  void reorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final dynamic item = removeAt(oldIndex);
    insert(newIndex, item);
  }
}
