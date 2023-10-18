class HiveBoxes {
  static const String tokenBox = 'tokenBox';
  static final  history = HistoryQueue(10);
}

class HistoryQueue<T> {
  final int maxSize;
  final List _items = [];

  HistoryQueue(this.maxSize);

  // Add an item to the history
  void add(T item) {
    _items.add(item);

    // Ensure that the history contains at most maxSize items
    while (_items.length > maxSize) {
      _items.removeAt(0); // Remove the oldest item
    }
  }

  // Get the items in the history
  List<T> get items => List.from(_items);

  // Clear the history
  void clear() {
    _items.clear();
  }
}