// lib/models/product_model.dart

class ProductModel {
  final String productId; // معرف فريد للمنتج
  final String name; // اسم المنتج (إلزامي)
  final double price; // سعر المنتج (إلزامي)

  ProductModel({
    required this.productId,
    required this.name,
    required this.price,
  });

  // دوال لإنشاء كائن من الخريطة (مثال للبيانات القادمة من قاعدة البيانات)
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['productId'],
      name: json['name'],
      price: json['price'].toDouble(), // التأكد من تحويل الرقم إلى صيغة عشرية
    );
  }
}
