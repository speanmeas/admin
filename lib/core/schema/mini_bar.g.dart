class Mini_bar {
  static final Mini_bar instance = Mini_bar._();
  Mini_bar._();

  final ID = "_id";
  final NAME = "name";
  final PRICE = "price";
  final STOCK = "stock";
  final NOTE = "note";
  final CREATED_AT = "created_at";
  final CREATED_BY = "created_by";
  final UPDATED_AT = "updated_at";
  final UPDATED_BY = "updated_by";
  final DELETED_AT = "deleted_at";
  final DELETED_BY = "deleted_by";
}

Mini_bar sm_mini_bar = Mini_bar.instance;
