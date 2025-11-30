// تعريف حالة الفاتورة لتسهيل تطبيق الألوان
enum InvoiceStatus {
  paid, // مسدد (أخضر)
  due, // آجل (أصفر)
  overdue, // متأخر (أحمر)
}

// دالة مساعدة لتحويل حالة الفاتورة إلى لون
Color getStatusColor(InvoiceStatus status) {
  switch (status) {
    case InvoiceStatus.paid:
      return Colors.green; // أخضر للمسدد
    case InvoiceStatus.due:
      return Colors.yellow.shade800; // أصفر للآجل
    case InvoiceStatus.overdue:
      return Colors.red; // أحمر للمتأخر
  }
}

// نموذج المنتج داخل الفاتورة
class InvoiceItem {
  final String productName;
  final double unitPrice;
  final int quantity;
  final String productId; // معرف المنتج في قائمة المنتجات

  InvoiceItem({
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    required this.productId,
  });

  double get subtotal => unitPrice * quantity;
}

// نموذج الفاتورة الرئيسية
class Invoice {
  final String id; // رقم الفاتورة (معرف فريد)
  final String clientId; // معرف العميل
  final String clientName;
  final DateTime issueDate; // تاريخ التحرير
  final DateTime? dueDate; // تاريخ السداد (إذا كانت آجل)
  final String paymentMethod; // طريقة السداد
  final List<InvoiceItem> items;
  final String? comment; // تعليق اختياري
  InvoiceStatus status; // حالة الفاتورة (مسدد/آجل/متأخر)

  Invoice({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.issueDate,
    this.dueDate,
    required this.paymentMethod,
    required this.items,
    this.comment,
    this.status = InvoiceStatus.due, // الافتراضي آجل
  });

  // حساب إجمالي المبلغ
  double get totalAmount => items.fold(0.0, (sum, item) => sum + item.subtotal);

  // تحديث حالة الفاتورة بناءً على التاريخ الحالي (لتطبيق إشعار المتأخر)
  void updateStatus() {
    if (status == InvoiceStatus.paid) return; // لا نغير حالة المسدد

    if (dueDate != null && DateTime.now().isAfter(dueDate!)) {
      status = InvoiceStatus.overdue;
    } else if (dueDate != null && DateTime.now().isBefore(dueDate!)) {
      status = InvoiceStatus.due;
    }
  }
}
