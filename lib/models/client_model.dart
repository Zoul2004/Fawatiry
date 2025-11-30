class Product {
  final String id;
  String name; // اسم المنتج
  double price; // سعر المنتج (وحدة واحدة)

  Product({
    required this.id,
    required this.name,
    required this.price,
  });

  // دالة تحويل الخريطة
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}
