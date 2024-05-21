class ItemRepository {
  static final ItemRepository _singleton = ItemRepository._internal();

  factory ItemRepository() {
    return _singleton;
  }

  ItemRepository._internal();

  final List<Map<String, dynamic>> items = [];

  List<Map<String, dynamic>> getItems() {
    return items;
  }

  void addItem(Map<String, dynamic> item) {
    items.add(item);
  }
}
