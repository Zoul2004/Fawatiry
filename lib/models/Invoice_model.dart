// lib/models/invoice_model.dart

// نموذج يمثل منتجاً واحداً داخل قائمة منتجات الفاتورة
class InvoiceItemModel {
  final String productId; // معرف المنتج (لربطه بـ ProductModel)
  final String productName; // اسم المنتج (للعرض)
  final double unitPrice; // سعر الوحدة
  final int quantity; // الكمية المطلوبة
  final double subtotal; // الإجمالي الجزئي (السعر * الكمية)

  InvoiceItemModel({
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
  }) : subtotal = unitPrice * quantity; // يتم حساب الإجمالي الجزئي تلقائياً

  // دالة لتحويل الكائن إلى خريطة (Map) لحفظه
  Map<String, dynamic> toJson() => {
    'productId': productId,
    'productName': productName,
    'unitPrice': unitPrice,
    'quantity': quantity,
    'subtotal': subtotal,
  };
}
